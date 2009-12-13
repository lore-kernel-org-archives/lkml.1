Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbZLMO4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbZLMO4K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 09:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbZLMO4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 09:56:09 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:55099 "HELO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753494AbZLMO4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 09:56:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mXRFWTzVomYvAOfmuV39QAjTmnJMkdfYUiSNNKDnRIp7UPCdbJaQoLa58E5YFMA2qd
         Nb0Ayqqiz1C678F2gizzsFOCNDVGvQ6XI/VEMox5tFYfYvsAWWQXYjJiIvjWLc+Wtl07
         rcgGn7IoN3zt97W1tqchtZa6nBoJKZq/qHx5I=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: zbr@ioremap.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       sparclinux@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] Staging: dst: fix 'Client is not allowed' on sparc
Date: Sun, 13 Dec 2009 17:55:47 +0300
Message-Id: <1260716147-1569-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Not for applying, only describe the problem.


There is a warning on sparc
 Kernel unaligned access at TPC[6c0dec] inet_getname+0x4c/0xc0
which goes from
	net/ipv4/af_inet.c:
	int inet_getname(
		...
		*uaddr_len = sizeof(*sin);

sizeof(*sin) is 16, but inet_getname sets sa_data_len to 0.
That is why client is denied to access the device.
inet_getname() does not read uaddr_len, only
writes, so move initialization of sa_data_len after it.
Make struct saddr aligned similar to
struct __kernel_sockaddr_storage. This fixes the warning.

---
 drivers/staging/dst/export.c |    2 +-
 include/linux/dst.h          |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dst/export.c b/drivers/staging/dst/export.c
index c324230..4644804 100644
--- a/drivers/staging/dst/export.c
+++ b/drivers/staging/dst/export.c
@@ -166,12 +166,12 @@ static struct dst_state *dst_accept_client(struct dst_state *st)
 	}
 	new->socket = sock;
 
-	new->ctl.addr.sa_data_len = sizeof(struct sockaddr);
 	err = kernel_getpeername(sock, (struct sockaddr *)&new->ctl.addr,
 			(int *)&new->ctl.addr.sa_data_len);
 	if (err)
 		goto err_out_put;
 
+	new->ctl.addr.sa_data_len = sizeof(struct sockaddr);	
 	new->permissions = dst_check_permissions(st, new);
 	if (new->permissions == 0) {
 		err = -EPERM;
diff --git a/include/linux/dst.h b/include/linux/dst.h
index e26fed8..454b15a 100644
--- a/include/linux/dst.h
+++ b/include/linux/dst.h
@@ -74,10 +74,10 @@ struct saddr {
 	/* address family, AF_xxx	*/
 	unsigned short		sa_family;
 	/* 14 bytes of protocol address	*/
-	char			sa_data[SADDR_MAX_DATA];
+	char			sa_data[SADDR_MAX_DATA - sizeof(unsigned short)];
 	/* Number of bytes used in sa_data */
 	unsigned short		sa_data_len;
-};
+} __attribute__((aligned(16)));	/* sizeof(struct sockaddr) */
 
 /* Address structure */
 struct dst_network_ctl
-- 
1.6.5.6

