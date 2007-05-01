Return-Path: <linux-kernel-owner+w=401wt.eu-S1161675AbXEAKSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161675AbXEAKSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161680AbXEAKSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:18:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161681AbXEAKSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:18:51 -0400
Subject: [DLM] change lkid format [19/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, David Teigland <teigland@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:14:17 +0100
Message-Id: <1178014457.5462.167.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From ce03f12b37c0bd81ad707d3642241cc55c944711 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Mon, 2 Apr 2007 12:12:55 -0500
Subject: [PATCH] [DLM] change lkid format

A lock id is a uint32 and is used as an opaque reference to the lock.  For
userland apps, the lkid is passed up, through libdlm, as the return value
from a write() on the dlm device.  This created a problem when the high
bit was 1, making the lkid look like an error.  This is fixed by changing
how the lkid is composed.  The low 16 bits identified the hash bucket for
the lock and the high 16 bits were a per-bucket counter (which eventually
hit 0x8000 causing the problem).  These are simply swapped around; the
number of hash table buckets is far below 0x8000, making all lkid's
positive when viewed as signed.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 9d26b3a..eac54d2 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -580,7 +580,7 @@ static int create_lkb(struct dlm_ls *ls, struct dlm_lkb **lkb_ret)
 	/* counter can roll over so we must verify lkid is not in use */
 
 	while (lkid == 0) {
-		lkid = bucket | (ls->ls_lkbtbl[bucket].counter++ << 16);
+		lkid = (bucket << 16) | ls->ls_lkbtbl[bucket].counter++;
 
 		list_for_each_entry(tmp, &ls->ls_lkbtbl[bucket].list,
 				    lkb_idtbl_list) {
@@ -601,8 +601,8 @@ static int create_lkb(struct dlm_ls *ls, struct dlm_lkb **lkb_ret)
 
 static struct dlm_lkb *__find_lkb(struct dlm_ls *ls, uint32_t lkid)
 {
-	uint16_t bucket = lkid & 0xFFFF;
 	struct dlm_lkb *lkb;
+	uint16_t bucket = (lkid >> 16);
 
 	list_for_each_entry(lkb, &ls->ls_lkbtbl[bucket].list, lkb_idtbl_list) {
 		if (lkb->lkb_id == lkid)
@@ -614,7 +614,7 @@ static struct dlm_lkb *__find_lkb(struct dlm_ls *ls, uint32_t lkid)
 static int find_lkb(struct dlm_ls *ls, uint32_t lkid, struct dlm_lkb **lkb_ret)
 {
 	struct dlm_lkb *lkb;
-	uint16_t bucket = lkid & 0xFFFF;
+	uint16_t bucket = (lkid >> 16);
 
 	if (bucket >= ls->ls_lkbtbl_size)
 		return -EBADSLT;
@@ -644,7 +644,7 @@ static void kill_lkb(struct kref *kref)
 
 static int __put_lkb(struct dlm_ls *ls, struct dlm_lkb *lkb)
 {
-	uint16_t bucket = lkb->lkb_id & 0xFFFF;
+	uint16_t bucket = (lkb->lkb_id >> 16);
 
 	write_lock(&ls->ls_lkbtbl[bucket].lock);
 	if (kref_put(&lkb->lkb_ref, kill_lkb)) {
-- 
1.5.1.2



