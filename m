Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbYDRLq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbYDRLq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 07:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbYDRLqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 07:46:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:13318 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbYDRLqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 07:46:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ewB89U4HaLfJVSc48xJ6uJzXnqUck044N8LXObvyjWWETSaxnp/CK4yYNOusOzEfd6PG5OmG0AX6ibc2okwxUVznbss2u+3A9VRHkvAmg9KIt6Rcxgu/7eMFb6NvCwVA1w4eN7tBkMrcpe+eIgiSzsHZF8aKFRaZEGlV+KFvuIk=
Message-ID: <19f34abd0804180446u2d6f17damf391a8c0584358b8@mail.gmail.com>
Date: Fri, 18 Apr 2008 13:46:48 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.25-mm1: not looking good
Cc: "Jason Wessel" <jason.wessel@windriver.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, tglx@linutronix.de,
       penberg@cs.helsinki.fi, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, jmorris@namei.org,
       sds@tycho.nsa.gov
In-Reply-To: <20080418073732.GA22724@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080417160331.b4729f0c.akpm@linux-foundation.org>
	 <20080417164034.e406ef53.akpm@linux-foundation.org>
	 <20080417171413.6f8458e4.akpm@linux-foundation.org>
	 <48080FE7.1070400@windriver.com> <20080418073732.GA22724@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 9:37 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Jason Wessel <jason.wessel@windriver.com> wrote:
>
>  > > [...] The final initcall is init_kgdbts() and disabling KGDB
>  > > prevents the hang.
>
>
>  > That enables verbose logging of exactly what is going on and will show
>  > where wheels fall off the cart.  If the kernel is dying silently it
>  > means the early exception code has completely failed in some way on
>  > the kernel architecture that was selected, and of course the .config
>  > is always useful in this case.
>
>  incidentally, just today, in overnight testing i triggered a similar
>  hang in the KGDB self-test:
>
>   http://redhat.com/~mingo/misc/config-Thu_Apr_17_23_46_36_CEST_2008.bad
>
>  to get a similar tree to the one i tested, pick up sched-devel/latest
>  from:
>
>    http://people.redhat.com/mingo/sched-devel.git/README
>
>  pick up that failing .config, do 'make oldconfig' and accept all the
>  defaults to get a comparable kernel to mine. (kgdb is embedded in
>  sched-devel.git.)
>
>  the hang was at:
>
>  [   12.504057] Calling initcall 0xffffffff80b800c1: init_kgdbts+0x0/0x1b()
>  [   12.511298] kgdb: Registered I/O driver kgdbts.
>  [   12.515062] kgdbts:RUN plant and detach test
>  [   12.520283] kgdbts:RUN sw breakpoint test
>  [   12.524651] kgdbts:RUN bad memory access test
>  [   12.529052] kgdbts:RUN singlestep breakpoint test
>
>  full log:
>
>   http://redhat.com/~mingo/misc/log-Thu_Apr_17_23_46_36_CEST_2008.bad
>
>  note that this was a 64-bit config too - our tests do a perfect mix of
>  50% 32-bit and 50% 64-bit kernels. So single-stepping of the kernel
>  broke in some circumstances.
>
>  find the boot log below. (it also includes all command line parameters)
>
>  This is the first time ever i saw the self-test in KGDB hanging, so it's
>  some recent non-KGDB change that provoked it or made it more likely. The
>  KGDB self-test runs very frequently in my bootup tests:
>
>  [   12.508236] kgdb: Registered I/O driver kgdbts.
>  [   12.511245] kgdbts:RUN plant and detach test
>  [   12.517418] kgdbts:RUN sw breakpoint test
>  [   12.521056] kgdbts:RUN bad memory access test
>  [   12.525515] kgdbts:RUN singlestep breakpoint test
>  [   12.531483] kgdbts:RUN hw breakpoint test
>  [   12.536142] kgdbts:RUN hw write breakpoint test
>  [   12.541007] kgdbts:RUN access write breakpoint test
>  [   12.546223] kgdbts:RUN do_fork for 100 breakpoints
>
>  so the latest kgdb-light tree literally survived thousands of such tests
>  since it was changed last.
>
>  unfortunately, the condition was not reproducible - i booted it once
>  more and then it came up just fine - using the same bzImage.
>
>  there's no recent change in x86.git related to the TF flag that i could
>  think of to cause something like this. I checked changes to traps_64.c
>  and entry_64.S, and nothing suspicious.

With the patch below, it seems 100% reproducible to me (7 out of 7
bootups hung).

The number of loops it could do before hanging were, in order: 697,
898, 237, 55, 45, 92, 59

It seems timing-related, so I'm guessing it could be some interaction
with interrupts?


Vegard


diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index 6d6286c..ee87820 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -895,7 +895,13 @@ static void kgdbts_run_tests(void)
        v1printk("kgdbts:RUN bad memory access test\n");
        run_bad_read_test();
        v1printk("kgdbts:RUN singlestep breakpoint test\n");
-       run_singlestep_break_test();
+
+       while(1) {
+               static int i = 0;
+
+               run_singlestep_break_test();
+               printk(KERN_EMERG "test #%d successfull\n", i++);
+       }

        /* ===Optional tests=== */
