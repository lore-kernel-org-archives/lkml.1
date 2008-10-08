Return-Path: <linux-kernel-owner+w=401wt.eu-S1758029AbYJHC0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbYJHC0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 22:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbYJHC0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 22:26:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64241 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753634AbYJHC0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 22:26:19 -0400
Message-ID: <48EC19A8.4010307@cn.fujitsu.com>
Date: Wed, 08 Oct 2008 10:23:36 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] markers: fix unchecked format
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when the second, third... probe is registered, its format is
not checked, this patch fix it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/marker.c b/kernel/marker.c
index 4440a09..1196a6b 100644
--- a/kernel/marker.c
+++ b/kernel/marker.c
@@ -651,11 +651,17 @@ int marker_probe_register(const char *name, const char *format,
 	entry = get_marker(name);
 	if (!entry) {
 		entry = add_marker(name, format);
-		if (IS_ERR(entry)) {
+		if (IS_ERR(entry))
 			ret = PTR_ERR(entry);
-			goto end;
-		}
+	} else if (format) {
+		if (!entry->format)
+			ret = marker_set_format(&entry, format);
+		else if (strcmp(entry->format, format))
+			ret = -EPERM;
 	}
+	if (ret)
+		goto end;
+
 	/*
 	 * If we detect that a call_rcu is pending for this marker,
 	 * make sure it's executed now.


