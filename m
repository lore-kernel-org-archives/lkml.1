Return-Path: <linux-kernel-owner+w=401wt.eu-S932764AbXCFTWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764AbXCFTWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 14:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933286AbXCFTWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 14:22:17 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:4507 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932764AbXCFTWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 14:22:15 -0500
Subject: [Patch 2/2] add for_each_substring() and match_substring() -
	exploitation
From: Martin Peschke <mp3@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Wu Fengguang <wfg@mail.ustc.edu.cn>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 20:22:13 +0100
Message-Id: <1173208933.5266.12.camel@dix>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

simplifying statistics code by using for_each_substring() and
match_substring() instead of strsep() and match_token()

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---

 statistic.c |   67 +++++++++++++++++-------------------------------------------
 1 file changed, 20 insertions(+), 47 deletions(-)

Index: linux/lib/statistic.c
===================================================================
--- linux.orig/lib/statistic.c
+++ linux/lib/statistic.c
@@ -469,18 +469,13 @@ static int statistic_parse_single(struct
 {
 	struct statistic_discipline *disc = &statistic_discs[type];
 	int prev_state = stat->state, retval = 0;
-	char *copy;
 
 	if (info->flags & STATISTIC_FLAGS_NOFLEX && stat->type != type &&
 	    def != info->defaults)
 		return -EINVAL;
-	if (disc->parse) {
-		copy = kstrdup(def, GFP_KERNEL);
-		if (unlikely(!copy))
-			return -ENOMEM;
-		retval = disc->parse(stat, info, type, copy);
-		kfree(copy);
-	} else if (type != stat->type)
+	if (disc->parse)
+		retval = disc->parse(stat, info, type, def);
+	else if (type != stat->type)
 		statistic_transition(stat, info, STATISTIC_STATE_UNCONFIGURED);
 	if (!retval) {
 		stat->type = type;
@@ -500,30 +495,22 @@ static int statistic_parse_match(struct 
 				 struct statistic_info *info, char *def)
 {
 	int type, len;
-	char *p, *copy, *twisted;
-	substring_t args[MAX_OPT_ARGS];
+	substring_t args[MAX_OPT_ARGS], sub;
 	struct statistic_discipline *disc;
 
 	if (!def)
 		def = info->defaults;
-	twisted = copy = kstrdup(def, GFP_KERNEL);
-	if (unlikely(!copy))
-		return -ENOMEM;
-	while ((p = strsep(&twisted, " ")) != NULL) {
-		if (!*p)
-			continue;
-		if (match_token(p, statistic_match_type, args) != 1)
+	for_each_substring(&sub, def, " ") {
+		if (match_substring(&sub, statistic_match_type, args) != 1)
 			continue;
-		len = (args[0].to - args[0].from) + 1;
+		len = (args[0].to - args[0].from);
 		for (type = 0; type < STAT_NONE; type++) {
 			disc = &statistic_discs[type];
 			if (unlikely(strncmp(disc->name, args[0].from, len)))
 				continue;
-			kfree(copy);
 			return statistic_parse_single(stat, info, def, type);
 		}
 	}
-	kfree(copy);
 	if (unlikely(stat->type == STAT_NONE))
 		return -EINVAL;
 	return statistic_parse_single(stat, info, def, stat->type);
@@ -543,8 +530,8 @@ static match_table_t statistic_match_com
 static void statistic_parse_line(struct statistic_interface *interface,
 				 char *def)
 {
-	char *p, *copy, *twisted, *name = NULL;
-	substring_t args[MAX_OPT_ARGS];
+	char *name = NULL;
+	substring_t args[MAX_OPT_ARGS], sub;
 	int token, reset = 0, defaults = 0, i;
 	int state = STATISTIC_STATE_INVALID;
 	struct statistic *stat = interface->stat;
@@ -552,14 +539,8 @@ static void statistic_parse_line(struct 
 
 	if (unlikely(!def))
 		return;
-	twisted = copy = kstrdup(def, GFP_KERNEL);
-	if (unlikely(!copy))
-		return;
-
-	while ((p = strsep(&twisted, " ")) != NULL) {
-		if (!*p)
-			continue;
-		token = match_token(p, statistic_match_common, args);
+	for_each_substring(&sub, def, " ") {
+		token = match_substring(&sub, statistic_match_common, args);
 		switch (token) {
 		case STATISTIC_STATE_UNCONFIGURED:
 		case STATISTIC_STATE_RELEASED:
@@ -591,7 +572,6 @@ static void statistic_parse_line(struct 
 				statistic_reset(stat, info);
 		}
 	}
-	kfree(copy);
 	kfree(name);
 }
 
@@ -1113,16 +1093,13 @@ static int statistic_parse_histogram(str
 				     struct statistic_info *info,
 				     int type, char *def)
 {
-	char *p;
-	substring_t args[MAX_OPT_ARGS];
+	substring_t args[MAX_OPT_ARGS], sub;
 	int token, got_entries = 0, got_interval = 0, got_range = 0;
 	u32 entries, base_interval;
 	s64 range_min;
 
-	while ((p = strsep(&def, " ")) != NULL) {
-		if (!*p)
-			continue;
-		token = match_token(p, statistic_match_histogram, args);
+	for_each_substring(&sub, def, " ") {
+		token = match_substring(&sub, statistic_match_histogram, args);
 		switch (token) {
 		case 1:
 			match_int(&args[0], &entries);
@@ -1311,18 +1288,14 @@ static int statistic_parse_sparse(struct
 				  struct statistic_info *info,
 				  int type, char *def)
 {
-	char *p;
-	substring_t args[MAX_OPT_ARGS];
+	substring_t args[MAX_OPT_ARGS], sub;
 
-	while ((p = strsep(&def, " ")) != NULL) {
-		if (!*p)
+	for_each_substring(&sub, def, " ") {
+		if (match_substring(&sub, statistic_match_sparse, args) != 1)
 			continue;
-		if (match_token(p, statistic_match_sparse, args) == 1) {
-			statistic_transition(stat, info,
-					     STATISTIC_STATE_UNCONFIGURED);
-			match_int(&args[0], &stat->u.sparse.entries_max);
-			return 0;
-		}
+		statistic_transition(stat, info, STATISTIC_STATE_UNCONFIGURED);
+		match_int(&args[0], &stat->u.sparse.entries_max);
+		return 0;
 	}
 	return -EINVAL;
 }


