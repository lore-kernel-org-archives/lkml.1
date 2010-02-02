Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab0BBRuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 12:50:40 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:58337 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab0BBRui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 12:50:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=KnvDGRfbjPAK4jBVkVWLrc88nC9gytRUVpxyLXs1uiU/AQ+oTmpfWp7HrG2pV0SVb6
         5K8X2XJjd8cRa9yp7LC7Zitva6G3+g0eUkOMRFg/56FJc5tUraqJuolp4Fu9XitA9kUN
         NCB2yucVWYqK9TLcrRa/zUA0deUMAP/ZR3QDM=
MIME-Version: 1.0
Date: Wed, 3 Feb 2010 01:50:37 +0800
Message-ID: <10d816431002020950w65fb9955t4355a8415e4f3953@mail.gmail.com>
Subject: [RFC][PATCH] 8250: race condition in SMP
From: Lin Mac <mkl0301@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I'm sorry that I have sent this mail in linux-serial, but not reply
there, so I resent it again here.

I had had an issue with serial console in SMP mode.

http://lists.infradead.org/pipermail/linux-arm-kernel/2009-December/006650.html

I'm using ARM11 MPCore with 2 CPU, Linux-2.6.31.1, SMP enabled, L1 enabled,
L2 disabled

Under SMP environment, I have observed following issues:

   1. Sometimes, console became extremely slow, print 1 character for 1-2
seconds
      RVDS say that both CPU are idling. kernel seems find because messages
response to inserting USB flash is quick and correct.

   2. Sometimes, the Linux console halt and canot accept any input.
      RVDS say that both CPU are idling. kernel seems find because messages
response to inserting USB flash is quick and correct.

In both cases kernel message seems fine, but user messages is broken.

http://lists.infradead.org/pipermail/linux-arm-kernel/2010-January/007052.html

Thanks for Russell's advice, after some tracing, I found that my IER
(Interrupt Enable Register) of the serial port is 0 under case 1!!

Case 2 is actually the same with case 1. Case 1 would come first, if I don't
keep input things and let it finish its slow printing, it would then become
case 2.

UART_BUG_THRE are detected and enabled on my platform, causing
serial8250_backup_timeout to be used.

There are many places that do ( get IER, clear IER, restore IER ), like
serial8250_console_write called by printk, and serial8250_backup_timeout.
serial8250_backup_timeout is not protected by spinlock, causing the race
condition, and result in wrong IER value.

Following patch fix this issue.

    diff --git a/kernels/linux-2.6.31.1-X/drivers/serial/8250.c
b/kernels/linux-2.6.31.1-X/drivers/serial/8250.c
    index 288a0e4..55602c3 100644
    --- a/kernels/linux-2.6.31.1-cavm1/drivers/serial/8250.c
    +++ b/kernels/linux-2.6.31.1-cavm1/drivers/serial/8250.c
    @@ -1752,6 +1758,8 @@ static void serial8250_backup_timeout(unsigned
long data)
      unsigned int iir, ier = 0, lsr;
      unsigned long flags;

    +
    + spin_lock_irqsave(&up->port.lock, flags);
      /*
       * Must disable interrupts or else we risk racing with the interrupt
       * based handler.
    @@ -1769,10 +1777,8 @@ static void serial8250_backup_timeout(unsigned
long data)
       * the "Diva" UART used on the management processor on many HP
       * ia64 and parisc boxes.
       */
    - spin_lock_irqsave(&up->port.lock, flags);
      lsr = serial_in(up, UART_LSR);
      up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
    - spin_unlock_irqrestore(&up->port.lock, flags);
      if ((iir & UART_IIR_NO_INT) && (up->ier & UART_IER_THRI) &&
          (!uart_circ_empty(&up->port.info->xmit) || up->port.x_char) &&
          (lsr & UART_LSR_THRE)) {
    @@ -1780,12 +1786,14 @@ static void serial8250_backup_timeout(unsigned
long data)
       iir |= UART_IIR_THRI;
      }

    - if (!(iir & UART_IIR_NO_INT))
    -  serial8250_handle_port(up);
    -
      if (is_real_interrupt(up->port.irq))
       serial_out(up, UART_IER, ier);

    + spin_unlock_irqrestore(&up->port.lock, flags);
    +
    + if (!(iir & UART_IIR_NO_INT))
    +  serial8250_handle_port(up);
    +
      /* Standard timer interval plus 0.2s to keep the port running */
      mod_timer(&up->timer,
       jiffies + poll_timeout(up->port.timeout) + HZ / 5);

Is there any concern of above patch?

On the other hand, is it normal to have UART_BUG_THRE enabled? My console
work almost the same as the without this workaround (force
UART_BUG_THRE disabled, only
test once though, but it doesn't have issues above). Almost, but the
first login prompt is not shown, after typing anything, the first
prompt and the thing typed shown. All the same there after. If it
shouldn't be, I doubt that somehow the interrupt is serviced, such
that the detection of
UART_BUG_THRE failed.

But while I'm tracing, I cannot find where the driver clear the interrupt.
If the driver didn't clear the interrupt, how does the hardware knows that
it is serviced?

Any advice appreciated.

Best Regards,
Mac Lin
