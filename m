Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbYGXGxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbYGXGxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 02:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbYGXGxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 02:53:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:20593 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbYGXGxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 02:53:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent:from;
        b=iPQdzx23MoKKWXgZz+CgBdsLC2wUmkRbyfGe7ybM97DmosL0DV4+4znByMsYBgNfzx
         eB34w3COssAwDukbQK5aeRzgWPoiMWASU7FoughmhFae5r+fGq3tXHG0dh3D9RErHMKU
         tcIKlNytoOWdfxWJMCA9DxJVHgB9z0xdhFSG8=
Date: Thu, 24 Jul 2008 08:53:29 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [lockdep warning] INFO: inconsistent lock state,
	serial8250_interrupt(), &port_lock_key
Message-ID: <20080724065329.GE17724@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Ingo Molnar <mingo@elte.hu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20080723093332.GA22109@elte.hu> <20080723093604.GA29817@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080723093604.GA29817@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 11:36:04AM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > =================================
> > [ INFO: inconsistent lock state ]
> > 2.6.26-tip-06509-gb4ebc67-dirty #13600
> > ---------------------------------
> 
> the upstream component of that is: v2.6.26-6077-gc010b2f
> 
> i.e. my suspicion is that this got introduced via the recent tty 
> changes.

Hi,

i hit the same warning here. How about the following fix (this is at least what
i think happens):
--

serial8250_startup() might unconditionally enable irqs after releasing
&up->port.lock while we're still servicing an interrupt.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

--
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 27f34a9..55eca08 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1874,7 +1874,7 @@ static int serial8250_startup(struct uart_port *port)
 		 * the interrupt is enabled.  Delays are necessary to
 		 * allow register changes to become visible.
 		 */
-		spin_lock(&up->port.lock);
+		spin_lock_irqsave(&up->port.lock, flags);
 		if (up->port.flags & UPF_SHARE_IRQ)
 			disable_irq_nosync(up->port.irq);
 
@@ -1890,7 +1890,7 @@ static int serial8250_startup(struct uart_port *port)
 
 		if (up->port.flags & UPF_SHARE_IRQ)
 			enable_irq(up->port.irq);
-		spin_unlock(&up->port.lock);
+		spin_unlock_irqrestore(&up->port.lock, flags);
 
 		/*
 		 * If the interrupt is not reasserted, setup a timer to

-- 
Regards/Gruﬂ,
    Boris.
