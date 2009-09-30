Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbZI3LKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbZI3LKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 07:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZI3LKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 07:10:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:48772 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZI3LKl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 07:10:41 -0400
Date: Wed, 30 Sep 2009 13:11:09 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Wensong Zhang <wensong@linux-vs.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ipvs: Add boundary check on ioctl arguments
Message-ID: <20090930131109.2b3f71b8@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 761a182f96b3707e1fee44e1079ba227e48745d1 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Wed, 30 Sep 2009 13:05:51 +0200
Subject: [PATCH] ipvs: Add boundary check on ioctl arguments

The ipvs code has a nifty system for doing the size of ioctl command copies;
it defines an array with values into which it indexes the cmd to find the
right length.

Unfortunately, the ipvs code forgot to check if the cmd was in the range
that the array provides, allowing for an index outside of the array,
which then gives a "garbage" result into the length, which then gets
used for copying into a stack buffer.

Fix this by adding sanity checks on these as well as the copy size.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 net/netfilter/ipvs/ip_vs_ctl.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index ac624e5..3c52796 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2077,6 +2077,10 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
+	if (cmd < IP_VS_BASE_CTL || cmd > IP_VS_SO_SET_MAX + 1)
+		return -EINVAL;
+	if (len < 0 || len >  MAX_ARG_LEN)
+		return -EINVAL;
 	if (len != set_arglen[SET_CMDID(cmd)]) {
 		pr_err("set_ctl: len %u != %u\n",
 		       len, set_arglen[SET_CMDID(cmd)]);
@@ -2353,17 +2357,25 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 {
 	unsigned char arg[128];
 	int ret = 0;
+	unsigned int copylen;
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
+	if (cmd < IP_VS_BASE_CTL || cmd > IP_VS_SO_GET_MAX + 1)
+		return -EINVAL;
+
 	if (*len < get_arglen[GET_CMDID(cmd)]) {
 		pr_err("get_ctl: len %u < %u\n",
 		       *len, get_arglen[GET_CMDID(cmd)]);
 		return -EINVAL;
 	}
 
-	if (copy_from_user(arg, user, get_arglen[GET_CMDID(cmd)]) != 0)
+	copylen = get_arglen[GET_CMDID(cmd)];
+	if (copylen > 128)
+		return -EINVAL;
+
+	if (copy_from_user(arg, user, copylen) != 0)
 		return -EFAULT;
 
 	if (mutex_lock_interruptible(&__ip_vs_mutex))
-- 
1.6.2.5


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
