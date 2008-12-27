Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbYL0LAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbYL0LAl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 06:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYL0LAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 06:00:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40751 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbYL0LAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 06:00:31 -0500
Date: Sat, 27 Dec 2008 11:59:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Yinghai Lu <yinghai@kernel.org>,
       David Howells <dhowells@redhat.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mel@csn.ul.ie
Subject: Re: [PATCH] kbuild, sparseirq: work around GCC bug with __weak
	aliases
Message-ID: <20081227105944.GA13198@elte.hu>
References: <20081223132127.GA5450@linux.vnet.ibm.com> <495153A4.5060201@kernel.org> <20081224163400.GA11562@linux.vnet.ibm.com> <49529CE1.4040005@kernel.org> <20081226091217.GA5100@linux.vnet.ibm.com> <4954AC7B.3020603@kernel.org> <20081226102716.GA31450@uranus.ravnborg.org> <20081226133354.GC29265@elte.hu> <20081226134218.GA1054@elte.hu> <18773.43656.189438.155690@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18773.43656.189438.155690@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > > I recall David Howells had a similar issue with the bootparamter patch 
> > > > set. The workaround he used was to add a barrier(); call in the weak 
> > > > function to avoid the inline.
> > > 
> > > could we add some extra attribute to __weak that would have a similar 
> > > effect? Something like __attribute__((noinline)), or something silly 
> > > like __attribute__((deprecated)) - just to keep gcc from screwing up 
> > > __weak functions? Perhaps adding a section attribute would have a 
> > > similar effect? (putting weak definitions into an extra section is 
> > > probably helpful anyway)
> > 
> > I've applied the patch below to tip/irq/sparseirq - could someone with an 
> > affected GCC version please check whether this solves the crash?
> 
> I recall from discussions earlier that noinline doesn't fix the problem, 
> and I just tested a similar case and verified that adding noinline 
> doesn't stop some versions of gcc from inlining them.  The empty weak 
> functions in kernel/perf_counter.c were getting inlined by the cross-gcc 
> (gcc 4.1.1) I use for compiling powerpc kernels on my laptop, and adding 
> noinline doesn't help there.

hm, does Yinghai's patch below do the trick? (also in perfcounters/core 
and tip/master)

	Ingo

-------------------->
>From 01ea1ccaa24dea3552e103be13b7897211607a8b Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yinghai@kernel.org>
Date: Fri, 26 Dec 2008 21:05:06 -0800
Subject: [PATCH] perf_counter: more barrier in blank weak function

Impact: fix panic possible panic

Some versions of GCC inline the weak global function if it's empty.
Add a barrier() to work it around.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_counter.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d7a79f3..37f7716 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -45,8 +45,8 @@ hw_perf_counter_init(struct perf_counter *counter)
 }
 
 u64 __weak hw_perf_save_disable(void)		{ return 0; }
-void __weak hw_perf_restore(u64 ctrl)		{ }
-void __weak hw_perf_counter_setup(void)		{ }
+void __weak hw_perf_restore(u64 ctrl)		{ barrier(); }
+void __weak hw_perf_counter_setup(void)		{ barrier(); }
 
 static void
 list_add_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
