Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbXFLNIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbXFLNIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 09:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757230AbXFLNHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 09:07:35 -0400
Received: from canuck.infradead.org ([209.217.80.40]:43760 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757111AbXFLNHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 09:07:33 -0400
Message-Id: <20070612121916.727204166@chello.nl>
References: <20070612121351.448814658@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 12 Jun 2007 14:13:55 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Bill Huey <billh@gnuppy.monkey.org>, Jason Baron <jbaron@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch 4/4] lockstat: better class name representation
Content-Disposition: inline; filename=lockstat_class_name.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

optionally add class->name_version and class->subclass to the class name

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep_proc.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/lockdep_proc.c
===================================================================
--- linux-2.6.orig/kernel/lockdep_proc.c
+++ linux-2.6/kernel/lockdep_proc.c
@@ -421,8 +421,30 @@ static void seq_stats(struct seq_file *m
 	class = data->class;
 	stats = &data->stats;
 
-	snprintf(name, 38, "%s", class->name);
+	namelen = 38;
+	if (class->name_version > 1)
+		namelen -= 2; /* XXX truncates versions > 9 */
+	if (class->subclass)
+		namelen -= 2;
+
+	if (!class->name) {
+		char str[KSYM_NAME_LEN];
+		const char *key_name;
+
+		key_name = __get_key_name(class->key, str);
+		snprintf(name, namelen, "%s", key_name);
+	} else {
+		snprintf(name, namelen, "%s", class->name);
+	}
 	namelen = strlen(name);
+	if (class->name_version > 1) {
+		snprintf(name+namelen, 3, "#%d", class->name_version);
+		namelen += 2;
+	}
+	if (class->subclass) {
+		snprintf(name+namelen, 3, "/%d", class->subclass);
+		namelen += 2;
+	}
 
 	if (stats->write_holdtime.nr) {
 		if (stats->read_holdtime.nr)

-- 

