Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbYKLQO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbYKLQO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbYKLQME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:12:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45402 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbYKLQMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:12:00 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH =-v3 12/21] fanotify: user interface for access decisions
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Date: Wed, 12 Nov 2008 11:11:30 -0500
Message-ID: <20081112161129.25434.21744.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
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
 net/fanotify/af_fanotify.c |    9 +++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index efc62e9..7bc15ec 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -76,8 +76,15 @@ struct fanotify_so_fastpath {
 	__u32 mask;
 }  __attribute__((packed));
 
+/* struct used for FANOTIFY_SEND_RESPONSE */
+struct fanotify_so_access {
+	__u64 cookie;
+	__u32 response;
+}  __attribute__((packed));
+
 /* fanotify setsockopt optvals */
 #define FANOTIFY_SET_FASTPATH	1
+#define FANOTIFY_SEND_RESPONSE	2
 
 #ifdef __KERNEL__
 
diff --git a/net/fanotify/af_fanotify.c b/net/fanotify/af_fanotify.c
index 3b7283e..eef7e2a 100644
--- a/net/fanotify/af_fanotify.c
+++ b/net/fanotify/af_fanotify.c
@@ -162,6 +162,7 @@ static int fan_setsockopt(struct socket *sock, int level, int optname, char __us
 	struct fanotify_group *group;
 	union {
 		struct fanotify_so_fastpath fastpath;
+		struct fanotify_so_access access;
 	} data;
 	int ret = 0;
 
@@ -183,6 +184,14 @@ static int fan_setsockopt(struct socket *sock, int level, int optname, char __us
 			return ret;
 		ret = fanotify_fastpath_add(group, data.fastpath.fd, data.fastpath.mask);
 		break;
+	case FANOTIFY_SEND_RESPONSE:
+		if (optlen < sizeof(struct fanotify_so_access))
+			return -ENOMEM;
+		ret = copy_from_user(&data.access, optval, sizeof(struct fanotify_so_access));
+		if (ret)
+			return ret;
+		ret = fanotify_process_access_response(group, data.access.cookie, data.access.response);
+		break;
 	default:
 		return -ENOPROTOOPT;
 	}

