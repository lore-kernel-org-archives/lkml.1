Return-Path: <linux-kernel-owner+w=401wt.eu-S1423254AbXBUWyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423254AbXBUWyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423257AbXBUWyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:54:23 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:14833 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423254AbXBUWyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:54:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=jsQN2cyPt7yJx5qj1BRTKaNKuHigx6ssxS9E7HgRofXs4nRB8rAg6A/62auKJ+iXNvIXo1doVt+ct3ICyWklYDj3bLMQaExU2JH6OolI0LEj5bIxLSvCVrj2MxhJny1C44aCPESGrQ6QwjAIih1c6VLt3Ec+mVHyhIsjr8YsrtQ=
Date: Wed, 21 Feb 2007 22:53:08 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: Jose Goncalves <jose.goncalves@inov.pt>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
Message-ID: <20070221225308.GA4113@slug>
References: <20070219134539.GA27370@flint.arm.linux.org.uk> <20070220142442.GF566@slug> <20070219143520.GB27370@flint.arm.linux.org.uk> <20070220144814.GJ566@slug> <20070219150508.GD27370@flint.arm.linux.org.uk> <45D9D073.7020701@inov.pt> <20070219164200.GF27370@flint.arm.linux.org.uk> <45D9E46C.4030408@inov.pt> <20070219212347.GA4258@flint.arm.linux.org.uk> <45DC537B.6020108@inov.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DC537B.6020108@inov.pt>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 02:13:15PM +0000, Jose Goncalves wrote:
> New devolpments.
> I have upgraded to 2.6.16.41, applied a patch sent by Frederik that
> removed the changed made in http://lkml.org/lkml/2005/6/23/266 and
> activated some more kernel debug, i.e., CONFIG_KALLSYMS_ALL,
> CONFIG_DEBUG_KERNEL, CONFIG_DETECT_SOFTLOCKUP, CONFIG_DEBUG_SLAB,
> CONFIG_DEBUG_MUTEXES, CONFIG_FRAME_POINTER and CONFIG_FORCED_INLINING
> (thanks to vda for pointing me to the right doc.).
> At first it seemed to work fine, but after some days of continuous
> running I've got another kernel Oops!
> I attach the dmesg output and the assembly dump of serial8250_startup()
> and serial8250_shutdown().
> 
As suspected by Russell, the badness seems to happen just at the
end of the serial_inp on LSR, drivers/serial/8250.c:1650.
The NULL deref happens at the beginning of the serial_inp(up, UART_RX)
call, when trying to dereference *up.

c01bfa70 <serial_in>:
c01bfa70:       55                      push   %ebp
c01bfa71:       89 e5                   mov    %esp,%ebp
c01bfa73:       53                      push   %ebx
c01bfa74:       8b 5d 08                mov    0x8(%ebp),%ebx << %ebx = up (which is NULL)
c01bfa77:       8b 55 0c                mov    0xc(%ebp),%edx
c01bfa7a:       0f b6 4b 12             movzbl 0x12(%ebx),%ecx << %ecx = *(%ebx+12) Oops
c01bfa7e:       0f b6 43 13             movzbl 0x13(%ebx),%eax

It seems that somehow, the pop %ebx at the end of
the serial_inp(up, UART_LSR) function poped a NULL value instead of the
expected pointer. Any suggestion on how this could happen?
Jose, did you try to msleep(10) before the "And clear the interrupt
registers again for luck." as suggested by Russell?

You should also revert the change I suggested, it seems I missed the
target by a few lines of code :).

Regards,
Frederik

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 7aca22c..385cc51 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1643,6 +1643,7 @@ static int serial8250_startup(struct uart_port *port)
 		(void) inb_p(icp);
 	}
 
+	msleep(10);
 	/*
 	 * And clear the interrupt registers again for luck.
 	 */



