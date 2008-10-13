Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbYJMP1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbYJMP1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 11:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbYJMP1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 11:27:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:64873 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959AbYJMP1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 11:27:34 -0400
Message-ID: <5555373.1223911646283.SLOX.WebMail.wwwrun@exchange.deltacomputer.de>
Date: Mon, 13 Oct 2008 17:27:26 +0200 (CEST)
From: Oliver Weihe <o.weihe@deltacomputer.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: NUMA allocator on Opteron systems does non-local allocation on node0
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081013104622.GK12131@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Priority: 3 (normal)
X-Mailer: SuSE Linux Openexchange Server 4 - WebMail (Build 2.4160)
X-Operating-System: Linux 2.4.21-295-smp i386 (JVM 1.3.1_13)
Organization: Delta Computer Products GmbH
References: <20081013104622.GK12131@one.firstfloor.org>
X-AVK-Virus-Check: AVF 19.98;12.10.2008
X-AVK-Spam-Check: 1;str=0001.0A090204.48F368E1.0137,ss=1,fgs=0
X-Provags-ID: V01U2FsdGVkX1+GCnemAKE4q/yR88zka8H8qTrb5IIlEid2dLF
 ItUC8eAtBKWrI7nLraCQ9J9HkMlDD/8SCv/bDLb9njKEhrda63
 iXkl0hU2BYtL46L9DJyww==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

it seems that my reproducer is not very good. :(
It "works" much better when you start several processes at once.

for i in `seq 0 3`
do
  numactl --cpunodebind=${i} ./app &
done
wait

"app" still allocates some memory (7GiB per process) and fills the array
with data.


I've noticed this behaviour during some HPL (Linpack benchmark from/for
top500.org) runs. For small data sets there's no difference in speed
between the kernels while for big data sets (allmost the whole memory)
2.6.23 and newer kernels are slower than 2.6.22.
I'm using OpenMPI with the runtime option "--mca mpi_paffinity_alone 1"
to pin each process on a specific CPU.

The bad news is: I can crash allmost every Quadcore Opteron system with
kernels 2.6.21.x to 2.6.24.x with "parallel memory allocation and
filling the memory with data" (parallel means: there is one process per
core doing this). While it takes some time on dualsocket machines it
takes often less than 1 minute on quadsocket quadcores until the system
freezes.
Yust for the case it is some vendor specific BIOS bug: we're using
supermicro mainboards.

> [Another copy of the reply with linux-kernel added this time]
> 
> > In my setup I'm allocating an array of ~7GiB memory size in a
> > singlethreaded application.
> > Startup: numactl --cpunodebind=X ./app
> > For X=1,2,3 it works as expected, all memory is allocated on the
> > local
> > node.
> > For X=0 I can see the memory beeing allocated on node0 as long as
> > ~3GiB
> > are "free" on node0. At this point the kernel starts using memory
> > from
> > node1 for the app!
> 
> Hmm, that sounds like it doesn't want to use the 4GB DMA zone.
> 
> Normally there should be no protection on it, but perhaps something 
> broke.
> 
> What does cat /proc/sys/owmem_reserve_ratio say?

2.6.22.x:
# cat /proc/sys/vm/lowmem_reserve_ratio
256     256

2.6.23.8 (and above)
# cat /proc/sys/vm/lowmem_reserve_ratio
256     256     32


> > For parallel realworld apps I've seen a performance penalty of 30%
> > compared to older kernels!
> 
> Compared to what older kernels? When did it start?

I've tested some kernel Versions that I've laying around here...
working fine: 2.6.22.18-0.2-default (openSUSE) / 2.6.22.9 (kernel.org) 
showing the described behaviour: 2.6.23.8; 2.6.24.4; 2.6.25.4; 2.6.26.5;
2.6.27


> 
> -Andi
> 
> -- 
> ak@linux.intel.com
> 


-- 

Regards,
Oliver Weihe

