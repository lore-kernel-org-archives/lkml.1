Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779Ab0AIRpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab0AIRpV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 12:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718Ab0AIRpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 12:45:20 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:51855 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab0AIRpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 12:45:19 -0500
Date: Sat, 9 Jan 2010 18:45:17 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: kprobes: get rid of distinct type warning
Message-ID: <20100109174517.GA3237@osiris.boeblingen.de.ibm.com>
References: <20091221101549.GA3850@osiris.boeblingen.de.ibm.com>
 <20091230132945.f32f49fd.akpm@linux-foundation.org>
 <20100104155702.GB5671@osiris.boeblingen.de.ibm.com>
 <201001050915.41334.rusty@rustcorp.com.au>
 <20100105084027.GA5480@osiris.boeblingen.de.ibm.com>
 <20100108161848.1fe19b5e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100108161848.1fe19b5e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 04:18:48PM -0800, Andrew Morton wrote:
> On Tue, 5 Jan 2010 09:40:27 +0100
> Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > --- a/include/linux/cpumask.h
> > +++ b/include/linux/cpumask.h
> > @@ -90,10 +90,10 @@ extern const struct cpumask *const cpu_a
> >  #define cpu_present(cpu)	cpumask_test_cpu((cpu), cpu_present_mask)
> >  #define cpu_active(cpu)		cpumask_test_cpu((cpu), cpu_active_mask)
> >  #else
> > -#define num_online_cpus()	1
> > -#define num_possible_cpus()	1
> > -#define num_present_cpus()	1
> > -#define num_active_cpus()	1
> > +#define num_online_cpus()	1U
> > +#define num_possible_cpus()	1U
> > +#define num_present_cpus()	1U
> > +#define num_active_cpus()	1U
> >  #define cpu_online(cpu)		((cpu) == 0)
> >  #define cpu_possible(cpu)	((cpu) == 0)
> >  #define cpu_present(cpu)	((cpu) == 0)
> 
> I assume that this fixes the kprobes warning, so 
> 
> Commit-ID:  c2ef6661ce62e26a8c0978e521fab646128a144b
> Gitweb:     http://git.kernel.org/tip/c2ef6661ce62e26a8c0978e521fab646128a144b
> Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
> AuthorDate: Mon, 21 Dec 2009 13:02:24 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 28 Dec 2009 10:25:31 +0100
> 
> becomes unneeded?

Nah, that would be too easy. The code still compares an int (10) and
an unsigned int. The only thing that could be changed with this patch
is that max_t isn't needed anymore, so that the patch below would
work as well (10U).
But I don't think it's worth it.

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index b7df302..85222a9 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1035,7 +1035,7 @@ int __kprobes register_kretprobe(struct kretprobe *rp)
 	/* Pre-allocate memory for max kretprobe instances */
 	if (rp->maxactive <= 0) {
 #ifdef CONFIG_PREEMPT
-		rp->maxactive = max_t(unsigned int, 10, 2*num_possible_cpus());
+		rp->maxactive = max(10U, 2*num_possible_cpus());
 #else
 		rp->maxactive = num_possible_cpus();
 #endif
