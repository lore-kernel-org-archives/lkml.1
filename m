Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbYJQIIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbYJQIIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 04:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYJQIIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 04:08:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:53847 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYJQIIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 04:08:32 -0400
Message-ID: <2806174.1224230866176.SLOX.WebMail.wwwrun@exchange.deltacomputer.de>
Date: Fri, 17 Oct 2008 10:07:46 +0200 (CEST)
From: Oliver Weihe <o.weihe@deltacomputer.de>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: Fw: NUMA allocator on Opteron systems does non-local allocation on node0
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <48F793F8.8090806@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Priority: 3 (normal)
X-Mailer: SuSE Linux Openexchange Server 4 - WebMail (Build 2.4160)
X-Operating-System: Linux 2.4.21-295-smp i386 (JVM 1.3.1_13)
Organization: Delta Computer Products GmbH
References: <20081015014125.a546fcc4.akpm@linux-foundation.org> <48F793F8.8090806@linux-foundation.org>
X-AVK-Virus-Check: AVB 19.66;17.10.2008
X-AVK-Spam-Check: 1;str=0001.0A090204.48F847D5.0182,ss=1,fgs=0
X-Provags-ID: V01U2FsdGVkX18qC32wODEw8QOYvLP/4kut/9uPVFbl/ITEGMf
 XZJjCnYzy4LJFI823lTSjXvoxY36gbUczqi75ZLZOku7FZjKb4
 4UA9Xb6kIEOFS1bTVNlCQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this problem/question is allready solved for me. Andi suggested to post
this on the linux-mm mailing list and they helped me. :)

> > I've notived that the memory allocation on NUMA systems (Opterons)
> > does
> > memory allocation on non-local nodes for processes running node0
> > even if
> > local memory is available. (Kernel 2.6.25 and above)
> 
> How much local memory is available? 8GB per node? That means there
> will be 4GB
> on node 0 in ZONE_DMA32 and 4GB in ZONE_NORMAL. Other nodes will have
> 8GB in
> ZONE_NORMAL.

You're right. This machine has 8GiB per node. Due to the memory hole the
machine has ~3GiB ZONE_DMA32 which perfectly fits to my observations.


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
> NUMA only supports memory policies for the highest zone which is
> ZONE_NORMAL here. Only 4GB of ZONE_NORMAL are available on node 0, so
> it will
> go off node after that memory is exhausted. This is done in order to
> preserve
> the lower 4GB for I/O to 32 bit devices.

I've changed the policy from "default" to "node"
(/proc/sys/vm/numa_zonelist_order) and now it works fine for me.
Policy "default" does automaticly select "node" or "zone" depending on
the machine. When the policy is set to "default" the kernel (2.6.27)
chooses "node" if
1. there is no ZONE_DMA32
2. the size of ZONE_DMA32 is greater than 50% of the system memory
3. the size of ZONE_DMA32 is greater than 60% of the nodelocal memory


-- 

Regards,
Oliver Weihe

