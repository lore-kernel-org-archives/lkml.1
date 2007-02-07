Return-Path: <linux-kernel-owner+w=401wt.eu-S1030618AbXBGP2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030618AbXBGP2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 10:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030630AbXBGP2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 10:28:39 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50298 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030618AbXBGP2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 10:28:38 -0500
Date: Thu, 8 Feb 2007 00:28:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: ak@suse.de, linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com,
       clameter@engr.sgi.com, akpm@osdl.org
Subject: Re: [2.6.20][PATCH] fix mempolicy error check on a system with
 memory-less-node
Message-Id: <20070208002809.c75b2742.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0702070604090.14056@schroedinger.engr.sgi.com>
References: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com>
	<p73ejp2mfqh.fsf@bingen.suse.de>
	<20070207190738.30f1d419.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0702070604090.14056@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 06:05:56 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 7 Feb 2007, KAMEZAWA Hiroyuki wrote:
> 
> > > IMHO there shouldn't be any memory less nodes. The architecture code
> > > should not create them. The CPU should be assigned to a nearby node instead.
> > > At least x86-64 ensures that.
> > > 
> > AFAIK, ia64 creates nodes just depends on SRAT's possible resource information.
> > Then, ia64 can create cpu-memory-less-node(node with no available resource.).
> > (*)I don't like this.
> 
> I think that is only true for !SN2 platforms? Could we fix this?
> 
AFAIK, some vendor(HP?) has following configraion
- node0 .... cpu only node
- node1 .... cpu only node
- node2 .... memory only node.
This is because of their memory-interleave technique.

Our 64cpu socket NUMA system also has a config
- node0 cpu+memory node
- node 1 - 7 cpu only node.
for deviding scheduler domain.(old kernel had problem with big-sched-domain)

To fix memory-less-node, we have to test the performance of
"very-big-scheduler-domain" and to define the rule for cpu-hot-add, as
"a new cpu will be added to the most nearby node" 
(node-hot-add will have to add some hook..)

I don't know someone who created memory-less-node in past may have some other issues.

There may be some complicated topology system with complicated PXM map.


> > If we don't allow memory-less-node, we may have to add several codes for cpu-hot-add.
> > cpus should be moved to nearby node at hotadd .
> > And node-hot-add have to care that cpus mustn't be added before memory, cpu-driven 
> > node-hot-add will never occur. (ACPI's 'container' device spec can't guaranntee this.)
> 
> Well you could bring down the cpu and bring it up again? This would also 
> assure the best placement of the runtime structures for node?
> 
cpu-to-node relationship is fixed in the early stage of cpu hotplug.
I'm not sure we can bring down/up cpu again in clean way. After a cpu is added,
the kernel losts its original PXM value now.

about runtime structures:
The runtime structure placement for a hot-added-node is another issue here.
I and Goto-san have a plan for optimized placement of structures and will 
try when we can do. (We are now assgined to RHEL5 stabilization tasks...)

Moving per-cpu-area at hotadd does not look easy.
IMHO, maybe we have to use stop_machine_run() to move it.

Anyway, I'll post an another *easy* patch just for fix the NULL pointer access.
please review.

Thanks,
-Kame




 

