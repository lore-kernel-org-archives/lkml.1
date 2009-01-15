Return-Path: <linux-kernel-owner+w=401wt.eu-S1762758AbZAON4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762758AbZAON4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:56:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbZAONzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:55:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49069 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140AbZAONzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:55:52 -0500
Date: Thu, 15 Jan 2009 14:55:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       travis@sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, steiner@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: regarding the x86_64 zero-based percpu patches
Message-ID: <20090115135518.GA9263@elte.hu>
References: <49649814.4040005@kernel.org> <Pine.LNX.4.64.0901121120280.30369@quilx.com> <m1mydwxvtx.fsf@frodo.ebiederm.org> <200901151204.23208.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901151204.23208.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Tuesday 13 January 2009 04:14:58 Eric W. Biederman wrote:
> > 2M of per cpu data doesn't make sense, and likely indicates a design
> > flaw somewhere.  It just doesn't make sense to have large amounts of
> > data allocated per cpu.
> > 
> > The most common user of per cpu data I am aware of is allocating one
> > word per cpu for counters.
> 
> This is why I did a brief audit.  Here it is:
> 
> With x86/32 allyesconfig (trimmed a little, until it booted under kvm) 
> we have 37148 bytes of static percpu data, and 117228 bytes of dynamic 
> percpu data.
> 
> File and line			Number		Size		Total
> net/ipv4/af_inet.c:1287		 21		2048		43008
> net/ipv4/af_inet.c:1290		 21		2048		43008
> kernel/workqueue.c:819		 72		 128		 9126
> net/ipv4/af_inet.c:1287		 48		 128		 6144
> net/ipv4/af_inet.c:1290		 48		 128		 6144
> net/ipv4/route.c:3258		  1		4096		 4096
> include/linux/genhd.h:271	 72		  40		 2880
> lib/percpu_counter.c:77		194		   4		  776
> net/ipv4/af_inet.c:1287		  1		 288		  288
> net/ipv4/af_inet.c:1290		  1		 288		  288
> net/ipv4/af_inet.c:1287		  1		 256		  256
> net/ipv4/af_inet.c:1290		  1		 256		  256
> net/core/neighbour.c:1424	  4		  44		  176
> kernel/kexec.c:1143		  1		 176		  176
> net/ipv4/af_inet.c:1287		  1		 104		  104
> net/ipv4/af_inet.c:1290		  1		 104		  104
> arch/x86/.../acpi-cpufreq.c:528	 96		   1		   96
> arch/x86/acpi/cstate.c:153	  1		  64		   64
> net/.../nf_conntrack_core.c:1209  1		  60		   60
> 
> Others:								  178
> 
> This is why my patch series adds "big_percpu_alloc" (basically identical 
> to current code) for the bigger/unbounded users.
> 
> I don't think moving per-cpu areas is going to fly.  We do put complex 
> datastructures in there. And you're going to need preempt_disable() on 
> all per-cpu ops on many archs to make it work (assuming you use 
> stop_machine to do the realloc.  Even a rough audit quickly becomes 
> overwhelming: 20 of the first 1/4 of DECLARE_PER_CPUs are non-movable 
> datastructures.

Why do we have to move them? Even on an allyesconfig the total ~150K size 
seems to be peanuts - compared to the ~+4MB CONFIG_MAXSMP .data/.bss 
bloat. I must be missing something ...

	Ingo
