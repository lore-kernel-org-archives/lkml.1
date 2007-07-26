Return-Path: <linux-kernel-owner+w=401wt.eu-S932937AbXGZOSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937AbXGZOSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 10:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757033AbXGZOSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 10:18:04 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:52363 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219AbXGZOSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 10:18:01 -0400
Date: Thu, 26 Jul 2007 15:17:57 +0100
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, ak@suse.de,
       Christoph Lameter <clameter@sgi.com>, apw@shadowen.org,
       kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: bind_zonelist() - are we definitely sizing this correctly?
Message-ID: <20070726141756.GB18825@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was looking closer at bind_zonelist() and it has the following snippet

        struct zonelist *zl;
        int num, max, nd;
        enum zone_type k;

        max = 1 + MAX_NR_ZONES * nodes_weight(*nodes);
        max++;                  /* space for zlcache_ptr (see mmzone.h) */
        zl = kmalloc(sizeof(struct zone *) * max, GFP_KERNEL);
        if (!zl)
                return ERR_PTR(-ENOMEM);

That set off alarm bells because we are allocating based on the size of a
zone, not the size of the zonelist.

This is the definition of struct zonelist

struct zonelist {
        struct zonelist_cache *zlcache_ptr;                  // NULL or &zlcache
        struct zone *zones[MAX_ZONES_PER_ZONELIST + 1];      // NULL delimited
#ifdef CONFIG_NUMA
        struct zonelist_cache zlcache;                       // optional ...
#endif
};

Important thing to note here is that zlcache is after *zones and it is
not a pointer. zlcache in turn is defined as

struct zonelist_cache {
        unsigned short z_to_n[MAX_ZONES_PER_ZONELIST];          /* zone->nid */
        DECLARE_BITMAP(fullzones, MAX_ZONES_PER_ZONELIST);      /* zone full? */
        unsigned long last_full_zap;            /* when last zap'd (jiffies) */
};

This is on NUMA only and it's a big structure.

The intention of bind_zonelist() appears to be that we only allocate enough
memory to hold all the zones in the active nodes. This was fine in 2.6.19
but now with zlcache after *zones[], I think we are in danger of allocating
too little memory and any reading of zlcache may be reading randomness when
MPOL_BIND is in use because it will be using the full offset within the
structure whether the memory is allocated or not.

At the risk of sounding stupid, what obvious thing am I missing that makes
this work?

If I'm right and this is broken and we still want to allocate as little memory
as possible, zlcache has to move before zones and the call to kmalloc needs
to take the size of zlcache into account.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
