Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbYCYVDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbYCYVDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYCYVCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:02:54 -0400
Received: from usea-naimss2.unisys.com ([192.61.61.104]:3933 "EHLO
	usea-naimss2.unisys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbYCYVCx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:02:53 -0400
Subject: Re: [PATCH] list_add corruption in slab.c
From: Daniel Yeisley <dan.yeisley@unisys.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <84144f020803251145m6672e0acv16d27aaae1acb4d9@mail.gmail.com>
References: <1206464258.13473.11.camel@localhost.localdomain>
	 <84144f020803251145m6672e0acv16d27aaae1acb4d9@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 Mar 2008 16:44:18 -0400
Message-Id: <1206477858.8810.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 (2.22.0-2.fc9) 
X-OriginalArrivalTime: 25 Mar 2008 21:02:48.0613 (UTC) FILETIME=[94C69550:01C88EBB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-25 at 20:45 +0200, Pekka Enberg wrote:
> Hi Daniel,
> 
> On Tue, Mar 25, 2008 at 6:57 PM, Daniel Yeisley <dan.yeisley@unisys.com> wrote:
> > I've been seeing list_add corruption in slab.c on the ES7000 since the
> >  2.6.24.1 kernel.  There are several places where the initkmem_list3
> >  array is access by [somevalue + node].  This also needs to be done in
> >  kmem_cache_init().
> >
> >  Signed-off-by: Dan Yeisley <dan.yeisley@unisys.com>
> >
> >  ---
> >  diff -Naur linux-2.6.25-rc5/mm/slab.c linux-2.6.25-rc5-new/mm/slab.c
> >  --- linux-2.6.25-rc5/mm/slab.c  2008-03-10 01:22:27.000000000 -0400
> >  +++ linux-2.6.25-rc5-new/mm/slab.c      2008-03-20 13:59:24.000000000 -0400
> >  @@ -1481,7 +1481,7 @@
> >         list_add(&cache_cache.next, &cache_chain);
> >         cache_cache.colour_off = cache_line_size();
> >         cache_cache.array[smp_processor_id()] = &initarray_cache.cache;
> >  -       cache_cache.nodelists[node] = &initkmem_list3[CACHE_CACHE];
> >  +       cache_cache.nodelists[node] = &initkmem_list3[CACHE_CACHE + node];
> 
> Good catch! You'd need to fix up the use of initkmem_list3 farther
> down in kmem_init_cache():
> 
> >        /* 5) Replace the bootstrap kmem_list3's */
> >        {
> >                int nid;
> >
> >                for_each_online_node(nid) {
> >                        init_list(&cache_cache, &initkmem_list3[CACHE_CACHE], nid);
> 
> Care to send a tested patch that fixes that as well?
> 
>                           Pekka

I actually saw that initkmem_list reference, but didn't change it since
my original patch fixed my list corruption.  Anyway, I made the changed
and tested it.  The system booted fine.

﻿Signed-off-by: Dan Yeisley <dan.yeisley@unisys.com>

---
diff -Nuar linux-2.6.25-rc6/mm/slab.c linux-2.6.25-rc6-new/mm/slab.c
--- linux-2.6.25-rc6/mm/slab.c	2008-03-25 15:39:07.000000000 -0400
+++ linux-2.6.25-rc6-new/mm/slab.c	2008-03-25 15:13:01.000000000 -0400
@@ -1481,7 +1481,7 @@
 	list_add(&cache_cache.next, &cache_chain);
 	cache_cache.colour_off = cache_line_size();
 	cache_cache.array[smp_processor_id()] = &initarray_cache.cache;
-	cache_cache.nodelists[node] = &initkmem_list3[CACHE_CACHE];
+	cache_cache.nodelists[node] = &initkmem_list3[CACHE_CACHE + node];
 
 	/*
 	 * struct kmem_cache size depends on nr_node_ids, which
@@ -1602,7 +1602,7 @@
 		int nid;
 
 		for_each_online_node(nid) {
-			init_list(&cache_cache, &initkmem_list3[CACHE_CACHE], nid);
+			init_list(&cache_cache, &initkmem_list3[CACHE_CACHE + nid], nid);
 
 			init_list(malloc_sizes[INDEX_AC].cs_cachep,
 				  &initkmem_list3[SIZE_AC + nid], nid);

