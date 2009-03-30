Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbZC3Fok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbZC3Fok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 01:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbZC3Fo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 01:44:28 -0400
Received: from smtp-out.google.com ([216.239.33.17]:54806 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZC3Fo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 01:44:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=qmUchWaNhcdZZLNwl3XWpfRxqWJaPX8S74BF5DsmJCKyXEjITH3A07vJb4UjUHnVD
	M2TmQ4jL0XYE0/ZV17mRA==
Date: Sun, 29 Mar 2009 22:43:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 0/3] slub partial list thrashing performance degradation
Message-ID: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLUB causes a performance degradation in comparison to SLAB when a
workload has an object allocation and freeing pattern such that it spends
more time in partial list handling than utilizing the fastpaths.

This usually occurs when freeing to a non-cpu slab either due to remote
cpu freeing or freeing to a full or partial slab.  When the cpu slab is
later replaced with the freeing slab, it can only satisfy a limited
number of allocations before becoming full and requiring additional
partial list handling.

When the slowpath to fastpath ratio becomes high, this partial list
handling causes the entire allocator to become very slow for the specific
workload.

The bash script at the end of this email (inline) illustrates the
performance degradation well.  It uses the netperf TCP_RR benchmark to
measure transfer rates with various thread counts, each being multiples
of the number of cores.  The transfer rates are reported as an aggregate
of the individual thread results.

CONFIG_SLUB_STATS demonstrates that the kmalloc-256 and kmalloc-2048 are
performing quite poorly:

	cache		ALLOC_FASTPATH	ALLOC_SLOWPATH
	kmalloc-256	98125871	31585955
	kmalloc-2048	77243698	52347453

	cache		FREE_FASTPATH	FREE_SLOWPATH
	kmalloc-256	173624		129538000
	kmalloc-2048	90520		129500630

The majority of slowpath allocations were from the partial list
(30786261, or 97.5%, for kmalloc-256 and 51688159, or 98.7%, for
kmalloc-2048).

A large percentage of frees required the slab to be added back to the
partial list.  For kmalloc-256, 30786630 (23.8%) of slowpath frees
required partial list handling.  For kmalloc-2048, 51688697 (39.9%) of
slowpath frees required partial list handling.

On my 16-core machines with 64G of ram, these are the results:

	# threads	SLAB		SLUB		SLUB+patchset
	16		69892		71592		69505
	32		126490		95373		119731
	48		138050		113072		125014
	64		169240		149043		158919
	80		192294		172035		179679
	96		197779		187849		192154
	112		217283		204962		209988
	128		229848		217547		223507
	144		238550		232369		234565
	160		250333		239871		244789
	176		256878		242712		248971
	192		261611		243182		255596

 [ The SLUB+patchset results were attained with the latest git plus this
   patchset and slab_thrash_ratio set at 20 for both the kmalloc-256 and
   the kmalloc-2048 cache. ]

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/slub_def.h |    4 +
 mm/slub.c                |  138 +++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 122 insertions(+), 20 deletions(-)


#!/bin/bash

TIME=60				# seconds
HOSTNAME=<hostname>		# netserver

NR_CPUS=$(grep ^processor /proc/cpuinfo | wc -l)
echo NR_CPUS=$NR_CPUS

run_netperf() {
	for i in $(seq 1 $1); do
		netperf -H $HOSTNAME -t TCP_RR -l $TIME &
	done
}

ITERATIONS=0
while [ $ITERATIONS -lt 12 ]; do
	RATE=0
	ITERATIONS=$[$ITERATIONS + 1]	
	THREADS=$[$NR_CPUS * $ITERATIONS]
	RESULTS=$(run_netperf $THREADS | grep -v '[a-zA-Z]' | awk '{ print $6 }')

	for j in $RESULTS; do
		RATE=$[$RATE + ${j/.*}]
	done
	echo threads=$THREADS rate=$RATE
done
