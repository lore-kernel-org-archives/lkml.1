Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbYGWVRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbYGWVRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 17:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbYGWVRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 17:17:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbYGWVRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:17:32 -0400
Date: Wed, 23 Jul 2008 17:16:02 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@devserv.devel.redhat.com
To: Alasdair G Kergon <agk@redhat.com>
cc: Thomas Meyer <thomas@m3y3r.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>, linux-next@vger.kernel.org
Subject: [PATCHES] Re: next-20080723: build fails for dm-snapshot.ko
In-Reply-To: <20080723205102.GC5991@cs181140183.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0807231710360.11001@devserv.devel.redhat.com>
References: <1216835917.19707.3.camel@dhcppc2> <20080723205102.GC5991@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here is the patch for the problem.

Mikulas

---

Use sector_div to properly handle 64-bit modulo on 32-bit machines.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-exception-store.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.26-fast/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.26-fast.orig/drivers/md/dm-exception-store.c	2008-07-23 21:21:50.000000000 +0200
+++ linux-2.6.26-fast/drivers/md/dm-exception-store.c	2008-07-23 22:34:54.000000000 +0200
@@ -520,6 +520,7 @@ static int persistent_prepare(struct exc
 {
 	struct pstore *ps = get_info(store);
 	uint32_t stride;
+	chunk_t next_free;
 	sector_t size = get_dev_size(store->snap->cow->bdev);
 
 	/* Is there enough room ? */
@@ -533,7 +534,8 @@ static int persistent_prepare(struct exc
 	 * into account the location of the metadata chunks.
 	 */
 	stride = (ps->exceptions_per_area + 1);
-	if ((++ps->next_free % stride) == 1)
+	next_free = ++ps->next_free;
+	if (sector_div(next_free, stride) == 1)
 		ps->next_free++;
 
 	atomic_inc(&ps->pending_count);
