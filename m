Return-Path: <linux-kernel-owner+w=401wt.eu-S1763446AbYBSWur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763446AbYBSWur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762212AbYBSWuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:50:00 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:60773 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762165AbYBSWt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:49:59 -0500
Date: Wed, 20 Feb 2008 00:49:22 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Christoph Lameter <clameter@sgi.com>, penberg@cs.helsinki.fi,
       mpm@selenic.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: mm/slub.c: inconsequent NULL checking
Message-ID: <20080219224922.GO31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following inconsequent NULL checking 
introduced by commit 8ff12cfc009a2a38d87fa7058226fe197bb2696f:

<--  snip  -->

...
static inline int is_end(void *addr)
{
        return (unsigned long)addr & PAGE_MAPPING_ANON;
}
...
static void deactivate_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
{
...
        if (c->freelist)    <----------------------------------------
                stat(c, DEACTIVATE_REMOTE_FREES);
        /*
         * Merge cpu freelist into freelist. Typically we get here
         * because both freelists are empty. So this is unlikely
         * to occur.
         *
         * We need to use _is_end here because deactivate slab may
         * be called for a debug slab. Then c->freelist may contain
         * a dummy pointer.
         */
        while (unlikely(!is_end(c->freelist))) {
                void **object;

                tail = 0;       /* Hot objects. Put the slab first */

                /* Retrieve object from cpu_freelist */
                object = c->freelist;
                c->freelist = c->freelist[c->offset];
...                           ^^^^^^^^^^^^^^^^^^^^^^

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

