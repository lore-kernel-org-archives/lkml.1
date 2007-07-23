Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbXGWFpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbXGWFpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 01:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbXGWFpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 01:45:01 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:54031 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbXGWFo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 01:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ck9ENoccSyoBrRLZJPaFwfTxiAaBA2yXQr4SxnoFhW8vYJWzv4q3CPUT6a1LwhhBuWaYZPHerCkXhXirnpvLh69eO+DJO5Lu8Xjy5ymssqGRjHJ2DrXvm2hq/TvTnzE/YS/z6vMCeyXUuFC6Jjg69b2HZmxamrodY+q5lkKnoqc=
Message-ID: <4bacf17f0707222244p664e7a6ap850b3357a57d73c@mail.gmail.com>
Date: Mon, 23 Jul 2007 07:44:58 +0200
From: "=?ISO-8859-2?Q?Marcin_=A6lusarz?=" <marcin.slusarz@gmail.com>
To: "Jarek Poplawski" <jarkao2@o2.pl>,
       "Jean-Baptiste Vignaud" <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
In-Reply-To: <20070629150759.GC2771@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <JKE37W$0126317E099DF36884CC046B6F8A7AA9@xandmail.com>
	 <20070629150759.GC2771@ff.dom.local>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I've bisected this problem and found that this patch broke my NIC:

76d2160147f43f982dfe881404cfde9fd0a9da21 is first bad commit
commit 76d2160147f43f982dfe881404cfde9fd0a9da21
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Feb 16 01:28:24 2007 -0800

    [PATCH] genirq: do not mask interrupts by default

    Never mask interrupts immediately upon request.  Disabling interrupts in
    high-performance codepaths is rare, and on the other hand this change could
    recover lost edges (or even other types of lost interrupts) by
conservatively
    only masking interrupts after they happen.  (NOTE: with this change the
    highlevel irq-disable code still soft-disables this IRQ line - and
if such an
    interrupt happens then the IRQ flow handler keeps the IRQ masked.)

    Mark i8529A controllers as 'never loses an edge'.

    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=76d2160147f43f982dfe881404cfde9fd0a9da21

After reverting it on top of 2.6.21.3 (with
d7e25f3394ba05a6d64cb2be42c2765fe72ea6b2 - [PATCH] genirq: remove
IRQ_DISABLED (which ment "remove IRQ_DELAYED_DISABLE")), the problem
didn't show up :)
(http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d7e25f3394ba05a6d64cb2be42c2765fe72ea6b2)

So I cooked patch like below and everything is working fine (so far)

Fix default_disable interrupt function (broken by [PATCH] genirq: do
not mask interrupts by default) - revert removal of codepath which was
invoked when removed flag (IRQ_DELAYED_DISABLE) wag NOT set

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 76a9106..0bb23cd 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -230,6 +230,8 @@ static void default_enable(unsigned int irq)
  */
 static void default_disable(unsigned int irq)
 {
+	struct irq_desc *desc = irq_desc + irq;
+	desc->chip->mask(irq);
 }

 /*

(Sorry for whitespace damage, but I have to send it from webmail :|)
(I'm a kernel noob, so don't kill me if my patch is wrong ;)
ps: Here is the beginning of this thread: http://lkml.org/lkml/2007/6/16/182


Regards,
Marcin Slusarz
