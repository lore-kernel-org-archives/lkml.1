Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbYC0Mjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbYC0Mjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760118AbYC0MiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:38:21 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60140 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759853AbYC0MiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:38:10 -0400
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       "=?utf-8?q?Ilpo=20J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: [PATCH 5/7] [NET]: uninline dst_release
Date: Thu, 27 Mar 2008 14:38:04 +0200
Message-Id: <1206621486-5408-6-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: git-send-email 1.5.4.2.156.ge3c5
In-Reply-To: <1206621486-5408-5-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1206621486-5408-1-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1206621486-5408-2-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1206621486-5408-3-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1206621486-5408-4-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1206621486-5408-5-git-send-email-ilpo.jarvinen@helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Codiff stats (allyesconfig, v2.6.24-mm1):
-16420  187 funcs, 103 +, 16523 -, diff: -16420 --- dst_release

Without number of debug related CONFIGs (v2.6.25-rc2-mm1):
-7257  186 funcs, 70 +, 7327 -, diff: -7257 --- dst_release
dst_release                   |  +40

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 include/net/dst.h |   10 +---------
 net/core/dst.c    |   10 ++++++++++
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index ae13370..002500e 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -163,15 +163,7 @@ struct dst_entry * dst_clone(struct dst_entry * dst)
 	return dst;
 }
 
-static inline
-void dst_release(struct dst_entry * dst)
-{
-	if (dst) {
-		WARN_ON(atomic_read(&dst->__refcnt) < 1);
-		smp_mb__before_atomic_dec();
-		atomic_dec(&dst->__refcnt);
-	}
-}
+extern void dst_release(struct dst_entry *dst);
 
 /* Children define the path of the packet through the
  * Linux networking.  Thus, destinations are stackable.
diff --git a/net/core/dst.c b/net/core/dst.c
index 694cd2a..fe03266 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -259,6 +259,16 @@ again:
 	return NULL;
 }
 
+void dst_release(struct dst_entry *dst)
+{
+	if (dst) {
+		WARN_ON(atomic_read(&dst->__refcnt) < 1);
+		smp_mb__before_atomic_dec();
+		atomic_dec(&dst->__refcnt);
+	}
+}
+EXPORT_SYMBOL(dst_release);
+
 /* Dirty hack. We did it in 2.2 (in __dst_free),
  * we have _very_ good reasons not to repeat
  * this mistake in 2.3, but we have no choice
-- 
1.5.2.2

