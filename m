Return-Path: <linux-kernel-owner+w=401wt.eu-S932225AbZHRNQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225AbZHRNQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 09:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932123AbZHRNQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 09:16:56 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:3504 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932112AbZHRNQy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 09:16:54 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432R98dN4015L1b0bMzz1202hzzz32i6bh203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KOKQ6M-02-2JP-02
X-M-MSG: 
Date: Tue, 18 Aug 2009 15:15:58 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/12] cleanup __build_sched_domains()
Message-ID: <20090818131558.GO29515@alberich.amd.com>
References: <20090818104944.GA29515@alberich.amd.com> <20090818111644.GA23983@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090818111644.GA23983@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 18 Aug 2009 13:15:59.0283 (UTC) FILETIME=[07004030:01CA2006]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 01:16:44PM +0200, Ingo Molnar wrote:
> 
> * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> 
> > Hi,
> > 
> > Following patches try to make __build_sched_domains() less ugly 
> > and more readable. They shouldn't be harmful. Thus I think they 
> > can be applied for .32.
> > 
> > Patches are against tip/master as of today.
> > 
> > FYI, I need those patches as a base for introducing a new domain 
> > level for multi-node CPUs for which I intend to sent patches as 
> > RFC asap.
> 
> Very nice cleanups!
> 
> Magny-Cours indeed will need one more sched-domains level, 
> something like:
> 
>    [smt thread]
>    core
>    internal numa node
>    cpu socket
>    external numa node 

My current approach is to have the numa node domain either below CPU
(in case of multi-cpu node where SRAT describes each internal node as
a NUMA node) or as is, as the top-level domain (e.g. in case of node
interleaving or missing/broken ACPI SRAT detection).

Sched domain levels (note SMT==SIBLING, NODE==NUMA) are: 

(1) groups in NUMA domain are subsets of groups in CPU domain
(2) groups in NUMA domain are supersets groups in CPU domain

(1)         | (2)
------------|-------------------
SMT         | SMT
MC          | MC
MN (new)    | MN
NUMA        | CPU
CPU         | NUMA

I'll also introduce a new parameter sched_mn_power_savings which will
cause that tasks are scheduled on one socket until its capacity is
reached. If capacity is reached other sockets can also be occupied.

> ... which is certainly interesting, especially since the hierarchy 
> possibly 'crosses', i.e. we might have the two internal numa nodes 
> share a L2 or L3 cache, right?

> I'd also not be surprised if the load-balancer needed some care to 
> properly handle such a setup.

It needs some care and gave me some headache to get it working in all
cases (i.e. NUMA, no-NUMA, NUMA-but-no-SRAT). My current code (that
still needs to be split in proper patches for submission) works fine
in all but one case. And I am still debugging it.

The case that is not working is a normal (non-multi-node) NUMA system
on which switching to power policy does not take effect for already
running tasks. Just the new created ones are scheduled according to
the power policy.

> It's all welcome work in any case, and for .32.


Thanks,

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


