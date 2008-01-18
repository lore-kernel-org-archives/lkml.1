Return-Path: <linux-kernel-owner+w=401wt.eu-S1762774AbYARVnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762774AbYARVnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757190AbYARVnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:43:47 -0500
Received: from relay2.sgi.com ([192.48.171.30]:39689 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757124AbYARVnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:43:46 -0500
Date: Fri, 18 Jan 2008 13:43:45 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Olaf Hering <olaf@aepfle.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Linux MM <linux-mm@kvack.org>
Subject: Re: crash in kmem_cache_init
In-Reply-To: <20080118213011.GC10491@csn.ul.ie>
Message-ID: <Pine.LNX.4.64.0801181342120.7778@schroedinger.engr.sgi.com>
References: <20080115150949.GA14089@aepfle.de>
 <84144f020801170414q7d408a74uf47a84b777c36a4a@mail.gmail.com>
 <Pine.LNX.4.64.0801170628580.19208@schroedinger.engr.sgi.com>
 <20080117181222.GA24411@aepfle.de> <Pine.LNX.4.64.0801171049190.21058@schroedinger.engr.sgi.com>
 <20080117211511.GA25320@aepfle.de> <Pine.LNX.4.64.0801181043290.30348@schroedinger.engr.sgi.com>
 <20080118213011.GC10491@csn.ul.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008, Mel Gorman wrote:

> static void check_for_regular_memory(pg_data_t *pgdat)
> {
> #ifdef CONFIG_HIGHMEM
>         enum zone_type zone_type;
> 
>         for (zone_type = 0; zone_type <= ZONE_NORMAL; zone_type++) {
>                 struct zone *zone = &pgdat->node_zones[zone_type];
>                 if (zone->present_pages)
>                         node_set_state(zone_to_nid(zone), N_NORMAL_MEMORY);
>         }
> #endif
> }
> 
> i.e. go through the other zones and if any of them have memory, set
> N_NORMAL_MEMORY. But... it only does this on CONFIG_HIGHMEM which on
> PPC64 is not going to be set so N_NORMAL_MEMORY never gets set on
> POWER.... That sounds bad.

Argh. We may need to do a

node_set_state(zone_to_nid(zone), N_NORMAL_MEMORY) in the !HIGHMEM case.

> and one of them is in kmem_cache_init(). That seems very significant.
> Christoph, can you think of possibilities of where N_NORMAL_MEMORY not
> being set would cause trouble for slab?

Yes. That results in the per node structures not being created and thus l3 
== NULL. Explains our failures.


