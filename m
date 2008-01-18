Return-Path: <linux-kernel-owner+w=401wt.eu-S1763509AbYARVa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763509AbYARVa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757262AbYARVaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:30:17 -0500
Received: from gir.skynet.ie ([193.1.99.77]:58154 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756948AbYARVaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:30:14 -0500
Date: Fri, 18 Jan 2008 21:30:11 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <clameter@sgi.com>
Cc: Olaf Hering <olaf@aepfle.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Linux MM <linux-mm@kvack.org>
Subject: Re: crash in kmem_cache_init
Message-ID: <20080118213011.GC10491@csn.ul.ie>
References: <20080115150949.GA14089@aepfle.de> <84144f020801170414q7d408a74uf47a84b777c36a4a@mail.gmail.com> <Pine.LNX.4.64.0801170628580.19208@schroedinger.engr.sgi.com> <20080117181222.GA24411@aepfle.de> <Pine.LNX.4.64.0801171049190.21058@schroedinger.engr.sgi.com> <20080117211511.GA25320@aepfle.de> <Pine.LNX.4.64.0801181043290.30348@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801181043290.30348@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (18/01/08 10:47), Christoph Lameter didst pronounce:
> On Thu, 17 Jan 2008, Olaf Hering wrote:
> 
> > early_node_map[1] active PFN ranges
> >     1:        0 ->   892928
> > Could not find start_pfn for node 0
> 
> Corrupted min_pfn?
> 

Doubtful. Node 0 has no memory but it is still being initialised.

Still, I looked closer at what is going on when that message gets
displayed and I see this in free_area_init_nodes()

        for_each_online_node(nid) {
                pg_data_t *pgdat = NODE_DATA(nid);
                free_area_init_node(nid, pgdat, NULL,
                                find_min_pfn_for_node(nid), NULL);

                /* Any memory on that node */
                if (pgdat->node_present_pages)
                        node_set_state(nid, N_HIGH_MEMORY);
                check_for_regular_memory(pgdat);
        }

This "Any memory on that node" thing is new and it says if there is any
memory on the node, set N_HIGH_MEMORY. Fine I guess, I haven't tracked these
changes closely. It calls check_for_regular_memory() which looks like

static void check_for_regular_memory(pg_data_t *pgdat)
{
#ifdef CONFIG_HIGHMEM
        enum zone_type zone_type;

        for (zone_type = 0; zone_type <= ZONE_NORMAL; zone_type++) {
                struct zone *zone = &pgdat->node_zones[zone_type];
                if (zone->present_pages)
                        node_set_state(zone_to_nid(zone), N_NORMAL_MEMORY);
        }
#endif
}

i.e. go through the other zones and if any of them have memory, set
N_NORMAL_MEMORY. But... it only does this on CONFIG_HIGHMEM which on
PPC64 is not going to be set so N_NORMAL_MEMORY never gets set on
POWER.... That sounds bad.

mel@arnold:~/git/linux-2.6/mm$ grep -n N_NORMAL_MEMORY slab.c 
1593:           for_each_node_state(nid, N_NORMAL_MEMORY) {
1971:   for_each_node_state(node, N_NORMAL_MEMORY) {
2102:                   for_each_node_state(node, N_NORMAL_MEMORY) {
3818:   for_each_node_state(node, N_NORMAL_MEMORY) {

and one of them is in kmem_cache_init(). That seems very significant.
Christoph, can you think of possibilities of where N_NORMAL_MEMORY not
being set would cause trouble for slab?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
