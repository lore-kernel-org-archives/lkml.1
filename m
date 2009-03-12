Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbZCLKHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbZCLKHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbZCLKHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:07:43 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:47006 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbZCLKHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:07:43 -0400
Date: Thu, 12 Mar 2009 11:07:35 +0100 (CET)
From: yann.poupet@free.fr
To: linux-kernel@vger.kernel.org
Message-ID: <30164110.1844321236852455770.JavaMail.root@spooler2-g27.priv.proxad.net>
Subject: PROBLEM: ppp over serial gets stuck in drivers/char/tty_ioctl.c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.243.41]
X-Mailer: Zimbra 5.0.11_GA_2627.UBUNTU8 (zclient/5.0.11_GA_2627.UBUNTU8)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm working on ARM with kernel 2.6.18.2, and maybe I found a problem in
drivers/char/tty_ioctl.c, function tty_wait_until_sent().


void tty_wait_until_sent(struct tty_struct * tty, long timeout)
{
    DECLARE_WAITQUEUE(wait, current);

#ifdef TTY_DEBUG_WAIT_UNTIL_SENT
    char buf[64];

    printk(KERN_DEBUG "%s wait until sent...\n", tty_name(tty, buf));
#endif
    if (!tty->driver->chars_in_buffer)
        return;
    add_wait_queue(&tty->write_wait, &wait);
    
[snip...]

While trying to get PPP to work over serial line, I found ppp getting stuck in
this function, because if tty buffer is empty when getting here, it might wait
forever IIRC (I found the problem a few month ago and can't remember the
details of my investigations).
This is why I added a test to see whether the buffer is not already empty:

[snip...]
    if (!tty->driver->chars_in_buffer)
        return;
    /* if buffer is empty, return */
    if (!tty->driver->chars_in_buffer(tty))
        return;
    add_wait_queue(&tty->write_wait, &wait);
[snip...]

After this modification, ppp over serial line worked fine.

Is it on purpose one tests whether tty->driver->chars_in_buffer is != 0 ?
I felt like this should be if (!tty->driver->chars_in_buffer(tty)), but in
doubts I left both tests.

I saw tty_wait_until_sent() has been modified between 2.6.25 and 2.6.26,
so probably this problem is gone in newer kernels.
However, if a kernel version up to 2.6.25 is still maintained, or if someone
gets the same problem for kernel up to 2.6.25, this might be usefull.

Since this is only related to older kernel, maybe I shouldn't post to this
ML, but I haven't found where I should send my message.


Regards,

Yann Poupet.
