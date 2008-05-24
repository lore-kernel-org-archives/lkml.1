Return-Path: <linux-kernel-owner+w=401wt.eu-S1761324AbYEXSP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761324AbYEXSP2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 14:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759717AbYEXSPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 14:15:16 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:55161 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758371AbYEXSPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 14:15:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=pt4OeGdrVc4HlnOB96P7O0NlslU85aWkojYinYzKzSrtgVN0KEn5B3RXfwr3HUKxHQuv1IAPjij9SVicAW08lzafrdzBcrBQp8uhPP300gHOe1PelZ8pfTdHDDYnC1dSvUl3vH0JXHaXHEFKxftvfVGjdnPJV/MAtg2Q3/Ipvw4=
Message-ID: <48385B26.7040509@gmail.com>
Date: Sat, 24 May 2008 23:45:02 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: safe traversal of ftrace_hash hlist
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

I noticed that concurrent instances of ftrace_record_ip() have a race between ftrace_hash list traversal during ftrace_ip_in_hash() (before acquiring ftrace_shutdown_lock) and ftrace_add_hash().If it's so then this should fix it.

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
---
Accommodate traversal of ftrace_hash hlist with concurrent insertions.

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 89bd9a6..bfba25c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -201,7 +201,7 @@ ftrace_ip_in_hash(unsigned long ip, unsigned long key)
 	struct hlist_node *t;
 	int found = 0;
 
-	hlist_for_each_entry(p, t, &ftrace_hash[key], node) {
+	hlist_for_each_entry_rcu(p, t, &ftrace_hash[key], node) {
 		if (p->ip == ip) {
 			found = 1;
 			break;
@@ -214,7 +214,7 @@ ftrace_ip_in_hash(unsigned long ip, unsigned long key)
 static inline void
 ftrace_add_hash(struct dyn_ftrace *node, unsigned long key)
 {
-	hlist_add_head(&node->node, &ftrace_hash[key]);
+	hlist_add_head_rcu(&node->node, &ftrace_hash[key]);
 }
 
 static void ftrace_free_rec(struct dyn_ftrace *rec)
