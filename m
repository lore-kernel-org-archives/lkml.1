Return-Path: <linux-kernel-owner+w=401wt.eu-S1752236AbXB1XaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752236AbXB1XaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 18:30:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbXB1XaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 18:30:04 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41611 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752236AbXB1XaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 18:30:01 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: Zwane Mwaikambo <zwane@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
       Justin Forbes <jmforbes@linuxtx.org>, Andi Kleen <ak@suse.de>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Chuck Wolber <chuckw@quantumlinux.com>,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/21] 2.6.19-stable review
References: <20070221013619.GA30227@kroah.com> <45DC9E1D.40805@redhat.com>
	<20070221114737.a09be761.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0702211208500.4043@woody.linux-foundation.org>
	<m1lkiikcth.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702272312580.2632@montezuma.windriver.com>
	<m1ps7uihzo.fsf@ebiederm.dsl.xmission.com>
	<20070228195255.GA7978@kroah.com>
Date: Wed, 28 Feb 2007 16:25:07 -0700
In-Reply-To: <20070228195255.GA7978@kroah.com> (Greg KH's message of "Wed, 28
	Feb 2007 11:52:55 -0800")
Message-ID: <m1mz2xg90s.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Wed, Feb 28, 2007 at 05:28:27AM -0700, Eric W. Biederman wrote:
>> 
>> What are the rules that are supposed to govern backports to stable
>> trees these days anyway?
>
> Documentation/stable_kernel_rules.txt


Ok if that is really what we are going with, the this silly patch isn't
simple enough for a backport.  There used to other rules to the effect
the patch must be merged in mainline, and we only backport to one kernel
revision.

I think it fails the 100 lines with context test.

The meaning of obviously correct is a little bit nebulous.  But if
something is obvious multiple people can easily understand what
is going on.  I haven't gotten any feedback that has said yes I
see what you are doing on the mentioned patch.

I'm really not certain how this patch got seriously proposed then.
I guess it was the serious of the issues of peoples boxes falling
over.

I guess somewhere I got the rules for weird vendor trees confused with
our stable branches.  The relaxed stable branch rules probably did it
to me.

So the best we can do is the commit below for a backport.  It doesn't
fix the issue but it generally keeps the machines from falling over.

p.s. The copy below is whitespace damaged because I just cut and
pasted it into this email.

commit 2fb12a9bca5ad9aa6dcd2c639b4a7656a8843ef8
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Tue Feb 13 13:26:25 2007 +0100

    [PATCH] x86-64: survive having no irq mapping for a vector
    
    Occasionally the kernel has bugs that result in no irq being found for a
    given cpu vector.  If we acknowledge the irq the system has a good chance
    of continuing even though we dropped an irq message.  If we continue to
    simply print a message and not acknowledge the irq the system is likely to
    become non-responsive shortly there after.
    
    AK: Fixed compilation for UP kernels
    
    Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
    Signed-off-by: Andi Kleen <ak@suse.de>
    Cc: "Luigi Genoni" <luigi.genoni@pirelli.com>
    Cc: Andi Kleen <ak@suse.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/arch/x86_64/kernel/irq.c b/arch/x86_64/kernel/irq.c
index 0c06af6..3bc30d2 100644
--- a/arch/x86_64/kernel/irq.c
+++ b/arch/x86_64/kernel/irq.c
@@ -18,6 +18,7 @@
 #include <asm/uaccess.h>
 #include <asm/io_apic.h>
 #include <asm/idle.h>
+#include <asm/smp.h>
 
 atomic_t irq_err_count;
 
@@ -120,9 +121,14 @@ asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
 
        if (likely(irq < NR_IRQS))
                generic_handle_irq(irq);
-       else if (printk_ratelimit())
-               printk(KERN_EMERG "%s: %d.%d No irq handler for vector\n",
-                       __func__, smp_processor_id(), vector);
+       else {
+               if (!disable_apic)
+                       ack_APIC_irq();
+
+               if (printk_ratelimit())
+                       printk(KERN_EMERG "%s: %d.%d No irq handler for vector\n",
+                               __func__, smp_processor_id(), vector);
+       }
 
        irq_exit();
 

