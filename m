Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbYJNU5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbYJNU5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 16:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbYJNUxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 16:53:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37840 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624AbYJNUxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 16:53:05 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v2 12/16] fanotify: user interface for access decisions
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu
Date: Tue, 14 Oct 2008 16:52:33 -0400
Message-ID: <20081014205233.1057.45494.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081014205009.1057.12041.stgit@paris.rdu.redhat.com>
References: <20081014205009.1057.12041.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

turns out that access decisions are useless if there is no way to do
anything about them.  So we add an interface.  Alan will hate it, but at
least it works...

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/fanotify.h   |    7 +++++++
 net/fanotify/af_fanotify.c |   11 ++++++++++-
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 07b8e77..b5c9db9 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -81,8 +81,15 @@ struct fanotify_so_fastpath {
 	uint32_t mask;
 };
 
+/* struct used for FANOTIFY_SEND_RESPONSE */
+struct fanotify_so_access {
+	uint64_t cookie;
+	uint32_t response;
+};
+
 /* fanotify setsockopt optvals */
 #define FANOTIFY_SET_FASTPATH	1
+#define FANOTIFY_SEND_RESPONSE	2
 
 #ifdef __KERNEL__
 
diff --git a/net/fanotify/af_fanotify.c b/net/fanotify/af_fanotify.c
index a7d3b96..89099ab 100644
--- a/net/fanotify/af_fanotify.c
+++ b/net/fanotify/af_fanotify.c
@@ -164,6 +164,7 @@ static int fan_setsockopt(struct socket *sock, int level, int optname, char __us
 	struct fanotify_sock *fan_sock;
 	struct fanotify_group *group;
 	struct fanotify_so_fastpath fp_data;
+	struct fanotify_so_access access_data;
 	int ret = 0;
 
 	if (sock->state != SS_CONNECTED)
@@ -179,7 +180,15 @@ static int fan_setsockopt(struct socket *sock, int level, int optname, char __us
 		ret = copy_from_user(&fp_data, optval, sizeof(struct fanotify_so_fastpath));
 		if (ret)
 			return ret;
-		fanotify_fastpath_add(group, fp_data.fd, fp_data.mask);
+		ret = fanotify_fastpath_add(group, fp_data.fd, fp_data.mask);
+		break;
+	case FANOTIFY_SEND_RESPONSE:
+		if (optlen < sizeof(struct fanotify_so_access))
+			return -ENOMEM;
+		ret = copy_from_user(&access_data, optval, sizeof(struct fanotify_so_access));
+		if (ret)
+			return ret;
+		ret = fanotify_process_access_response(group, access_data.cookie, access_data.response);
 		break;
 	default:
 		return -ENOPROTOOPT;

