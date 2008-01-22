Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbYAVWXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbYAVWXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 17:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYAVWXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 17:23:22 -0500
Received: from relay2.sgi.com ([192.48.171.30]:34488 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752040AbYAVWXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:23:22 -0500
Date: Tue, 22 Jan 2008 14:23:18 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Olaf Hering <olaf@aepfle.de>
cc: Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       hanth Aravamudan <nacc@us.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       lee.schermerhorn@hp.com, Linux MM <linux-mm@kvack.org>,
       akpm@linux-foundation.org
Subject: Re: crash in kmem_cache_init
In-Reply-To: <20080122214505.GA15674@aepfle.de>
Message-ID: <Pine.LNX.4.64.0801221417480.1912@schroedinger.engr.sgi.com>
References: <84144f020801170414q7d408a74uf47a84b777c36a4a@mail.gmail.com>
 <Pine.LNX.4.64.0801170628580.19208@schroedinger.engr.sgi.com>
 <20080117181222.GA24411@aepfle.de> <Pine.LNX.4.64.0801171049190.21058@schroedinger.engr.sgi.com>
 <20080117211511.GA25320@aepfle.de> <Pine.LNX.4.64.0801181043290.30348@schroedinger.engr.sgi.com>
 <20080118213011.GC10491@csn.ul.ie> <Pine.LNX.4.64.0801181414200.8924@schroedinger.engr.sgi.com>
 <20080118225713.GA31128@aepfle.de> <20080122195448.GA15567@csn.ul.ie>
 <20080122214505.GA15674@aepfle.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2008, Olaf Hering wrote:

> It crashes now in a different way if the patch below is applied:

Yup no l3 structure for the current node. We are early in boostrap. You 
could just check if the l3 is there and if not just skip starting the 
reaper? This will be redone later anyways. Not sure if this will solve all 
your issues though. An l3 for the current node that we are booting on 
needs to be created early on for SLAB bootstrap to succeed. AFAICT SLUB 
doesnt care and simply uses whatever the page allocator gives it for the 
cpu slab. We may have gotten there because you only tested with SLUB 
recently and thus changes got in that broke SLAB boot assumptions.


> 0xc0000000000fe018 is in setup_cpu_cache (/home/olaf/kernel/git/linux-2.6-numa/mm/slab.c:2111).
> 2106                                    BUG_ON(!cachep->nodelists[node]);
> 2107                                    kmem_list3_init(cachep->nodelists[node]);
> 2108                            }
> 2109                    }
> 2110            }

if (cachep->nodelists[numa_node_id()])
	return;

> 2111            cachep->nodelists[numa_node_id()]->next_reap =
> 2112                            jiffies + REAPTIMEOUT_LIST3 +
> 2113                            ((unsigned long)cachep) % REAPTIMEOUT_LIST3;
> 2114
> 2115            cpu_cache_get(cachep)->avail = 0;
> 
> 
