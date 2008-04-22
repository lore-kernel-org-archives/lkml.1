Return-Path: <linux-kernel-owner+w=401wt.eu-S1762225AbYDVBt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762225AbYDVBt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 21:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246AbYDVBts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 21:49:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43240 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151AbYDVBtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 21:49:47 -0400
Date: Mon, 21 Apr 2008 18:48:59 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Reuben Farrelly <reuben-linuxkernel@reub.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: StackProtector Oopses - Re: 2.6.25-mm1
Message-ID: <20080421184859.48efcb67@laptopd505.fenrus.org>
In-Reply-To: <20080421150604.GH5474@elte.hu>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
	<48089BDE.6040100@reub.net>
	<20080418133645.GF31797@elte.hu>
	<4808B4EF.8030901@reub.net>
	<20080421150604.GH5474@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2008 17:06:04 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Reuben Farrelly <reuben-linuxkernel@reub.net> wrote:
> 
> >> hm, does it boot up fine with the attached patch and
> >> stackprotector enabled? It appears that your system got to the
> >> self-test so stackprotector is working mostly - it's just that the
> >> self-test went wrong.
> >
> > It boots up fine with that patch below and:
> >
> > tornado boot # grep STACKPROTECT /boot/config-2.6.25-mm1-wip
> > CONFIG_CC_STACKPROTECTOR_ALL=y
> > CONFIG_CC_STACKPROTECTOR=y
> >
> > In fact I'm running with it applied right now and it all seems good
> > so far, so I guess that's confirmation that it is just the test
> > itself which is problematic?
> 
> yeah. Arjan - any new patches to try that might fix the bootup test?
>

I've looked at the disassembly and compared it to mine, and the gcc is doing
something... rather unexpected.
The only thing I can think of is the patch below, it should make it a ton 
more robust...


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: x86: be more conversative about the stack-protector test

This patch makes the stack-protector self-test more robust against
weird stack layouts; rather than assuming that a local variable is
layed out in a certain way, we first check this against the known
canary value (before we poison it).

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

diff --git a/kernel/panic.c b/kernel/panic.c
index c92c1e2..b4a6a05 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -351,7 +351,10 @@ static noinline void __stack_chk_test_func(void)
 	}
 #endif
 	barrier();
-	memset(&foo, 0, 2*sizeof(foo)); /* deliberate buffer overflow */
+	if (current->stack_canary == *(((unsigned long *)&foo)+1))
+		*(((unsigned long *)&foo)+1) = 0;
+	else
+		printk(KERN_ERR "No -ftack-protector canary found\n");
 	barrier();
 }
 
