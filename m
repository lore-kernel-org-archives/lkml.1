Return-Path: <linux-kernel-owner+w=401wt.eu-S1761181AbYBTIkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761181AbYBTIkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 03:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbYBTIj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 03:39:59 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:33484 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbYBTIj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 03:39:58 -0500
Date: Wed, 20 Feb 2008 00:32:04 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 1/4] make dev_to_node return online node
In-reply-to: <200802200015.43547.yinghai.lu@sun.com>
To: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802200032.04915.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802200015.43547.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



some numa system ( with multi HT chains) may return node without ram. aka it
is not online.
try to get one online node.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/include/linux/device.h b/include/linux/device.h
index 2258d89..7f1a4d7 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -478,7 +478,12 @@ struct device {
 #ifdef CONFIG_NUMA
 static inline int dev_to_node(struct device *dev)
 {
-	return dev->numa_node;
+	int node;
+	node = dev->numa_node;
+
+	if (node != -1 && !node_online(node))
+		node = numa_node_id();
+	return node;
 }
 static inline void set_dev_node(struct device *dev, int node)
 {
