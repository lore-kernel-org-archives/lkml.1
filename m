Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYLIQZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYLIQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 11:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbYLIQZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 11:25:16 -0500
Received: from tomts22.bellnexxia.net ([209.226.175.184]:59433 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753041AbYLIQZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 11:25:14 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4EADkqPklMROB9/2dsb2JhbACBbM9Ugwc
Date: Tue, 9 Dec 2008 11:25:12 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Tom Zanussi <zanussi@comcast.net>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Relay : fix cpu offline problem
Message-ID: <20081209162512.GB24039@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:23:30 up 22 days, 17:03,  3 users,  load average: 0.94, 0.88,
	0.76
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a fix for how relay handles cpu hotplug in the allocation error path. If
a cpu goes down while allocating, it may result in a buffer never being freed.

Lai Jiangshan originally identified this problem in the LTTng fork of
relay (ltt-relay-alloc). Here is the fix which applies to the original
kernel/relay.c.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Tom Zanussi <zanussi@comcast.net>
---
 kernel/relay.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/kernel/relay.c
===================================================================
--- linux-2.6-lttng.orig/kernel/relay.c	2008-12-09 10:58:45.000000000 -0500
+++ linux-2.6-lttng/kernel/relay.c	2008-12-09 11:09:58.000000000 -0500
@@ -611,10 +611,9 @@ struct rchan *relay_open(const char *bas
 	return chan;
 
 free_bufs:
-	for_each_online_cpu(i) {
-		if (!chan->buf[i])
-			break;
-		relay_close_buf(chan->buf[i]);
+	for_each_possible_cpu(i) {
+		if (chan->buf[i])
+			relay_close_buf(chan->buf[i]);
 	}
 
 	kref_put(&chan->kref, relay_destroy_channel);
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
