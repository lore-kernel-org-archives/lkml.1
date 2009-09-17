Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbZIQFVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbZIQFVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 01:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbZIQFVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 01:21:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbZIQFVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 01:21:09 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: davem@davemloft.net, kaber@trash.net, yoshfuji@linux-ipv6.org,
       jmorris@namei.org, pekkas@netcore.fi, kuznet@ms2.inr.ac.ru
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH 1/2] ipv4: fix do_ip_setsockopt optlen check for IP_MULTICAST_IF
Date: Thu, 17 Sep 2009 13:19:44 +0800
Message-Id: <1253164784-15789-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to man page of setsockopt, if optlen is not valid, kernel should return
-EINVAL. But a simple testcase as following, errno is 0, which means setsockopt
is successful.

        addr.s_addr = inet_addr("192.1.2.3");
        setsockopt(s, IPPROTO_IP, IP_MULTICAST_IF, &addr, 1);
	printf("errno is %d\n", errno);

This patch fixes the optlen check part, with the patch, we got errno EINVAL.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Patrick McHardy <kaber@trash.net>
Cc: David S. Miller <davem@davemloft.net>
---
 net/ipv4/ip_sockglue.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index fc7993e..5a29dce 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -615,13 +615,13 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 		if (optlen >= sizeof(struct ip_mreqn)) {
 			if (copy_from_user(&mreq, optval, sizeof(mreq)))
 				break;
-		} else {
+		} else if (optlen >= sizeof(struct in_addr)) {
 			memset(&mreq, 0, sizeof(mreq));
-			if (optlen >= sizeof(struct in_addr) &&
-			    copy_from_user(&mreq.imr_address, optval,
+			if (copy_from_user(&mreq.imr_address, optval,
 					   sizeof(struct in_addr)))
 				break;
-		}
+		} else /* Invalid optlen */
+			goto e_inval;
 
 		if (!mreq.imr_ifindex) {
 			if (mreq.imr_address.s_addr == htonl(INADDR_ANY)) {
-- 
1.6.2.5

