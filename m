Return-Path: <linux-kernel-owner+w=401wt.eu-S1760672AbZENWt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760672AbZENWt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756792AbZENWma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:42:30 -0400
Received: from kroah.org ([198.145.64.141]:51620 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756433AbZENWmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:42:11 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:23 2009
Message-Id: <20090514223523.371045382@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:32:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-security-module@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Paul Moore <paul.moore@hp.com>
Subject: [patch 19/51] netlabel: Add new NetLabel KAPI interfaces for request_sock security attributes
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=netlabel-add-new-netlabel-kapi-interfaces-for-request_sock-security-attributes.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Moore <paul.moore@hp.com>

[NOTE: based on 389fb800ac8be2832efedd19978a2b8ced37eb61 and
                07feee8f812f7327a46186f7604df312c8c81962]

This patch adds the netlbl_req_setattr() and netlbl_req_delattr() functions
which can be used by LSMs to set and remove the NetLabel security attributes
from request_sock objects used in incoming connection requests.

Signed-off-by: Paul Moore <paul.moore@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 include/net/netlabel.h       |   15 +++++++
 net/netlabel/netlabel_kapi.c |   84 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+), 1 deletion(-)

--- a/include/net/netlabel.h
+++ b/include/net/netlabel.h
@@ -36,6 +36,7 @@
 #include <linux/in.h>
 #include <linux/in6.h>
 #include <net/netlink.h>
+#include <net/request_sock.h>
 #include <asm/atomic.h>
 
 struct cipso_v4_doi;
@@ -413,6 +414,9 @@ int netlbl_sock_getattr(struct sock *sk,
 int netlbl_conn_setattr(struct sock *sk,
 			struct sockaddr *addr,
 			const struct netlbl_lsm_secattr *secattr);
+int netlbl_req_setattr(struct request_sock *req,
+		       const struct netlbl_lsm_secattr *secattr);
+void netlbl_req_delattr(struct request_sock *req);
 int netlbl_skbuff_setattr(struct sk_buff *skb,
 			  u16 family,
 			  const struct netlbl_lsm_secattr *secattr);
@@ -519,7 +523,7 @@ static inline int netlbl_enabled(void)
 	return 0;
 }
 static inline int netlbl_sock_setattr(struct sock *sk,
-				     const struct netlbl_lsm_secattr *secattr)
+				      const struct netlbl_lsm_secattr *secattr)
 {
 	return -ENOSYS;
 }
@@ -537,6 +541,15 @@ static inline int netlbl_conn_setattr(st
 {
 	return -ENOSYS;
 }
+static inline int netlbl_req_setattr(struct request_sock *req,
+				     const struct netlbl_lsm_secattr *secattr)
+{
+	return -ENOSYS;
+}
+static inline void netlbl_req_delattr(struct request_sock *req)
+{
+	return;
+}
 static inline int netlbl_skbuff_setattr(struct sk_buff *skb,
 				      u16 family,
 				      const struct netlbl_lsm_secattr *secattr)
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -757,6 +757,90 @@ conn_setattr_return:
 }
 
 /**
+ * netlbl_req_setattr - Label a request socket using the correct protocol
+ * @req: the request socket to label
+ * @secattr: the security attributes
+ *
+ * Description:
+ * Attach the correct label to the given socket using the security attributes
+ * specified in @secattr.  Returns zero on success, negative values on failure.
+ *
+ */
+int netlbl_req_setattr(struct request_sock *req,
+		       const struct netlbl_lsm_secattr *secattr)
+{
+	int ret_val;
+	struct netlbl_dom_map *dom_entry;
+	struct netlbl_domaddr4_map *af4_entry;
+	u32 proto_type;
+	struct cipso_v4_doi *proto_cv4;
+
+	rcu_read_lock();
+	dom_entry = netlbl_domhsh_getentry(secattr->domain);
+	if (dom_entry == NULL) {
+		ret_val = -ENOENT;
+		goto req_setattr_return;
+	}
+	switch (req->rsk_ops->family) {
+	case AF_INET:
+		if (dom_entry->type == NETLBL_NLTYPE_ADDRSELECT) {
+			struct inet_request_sock *req_inet = inet_rsk(req);
+			af4_entry = netlbl_domhsh_getentry_af4(secattr->domain,
+							    req_inet->rmt_addr);
+			if (af4_entry == NULL) {
+				ret_val = -ENOENT;
+				goto req_setattr_return;
+			}
+			proto_type = af4_entry->type;
+			proto_cv4 = af4_entry->type_def.cipsov4;
+		} else {
+			proto_type = dom_entry->type;
+			proto_cv4 = dom_entry->type_def.cipsov4;
+		}
+		switch (proto_type) {
+		case NETLBL_NLTYPE_CIPSOV4:
+			ret_val = cipso_v4_req_setattr(req, proto_cv4, secattr);
+			break;
+		case NETLBL_NLTYPE_UNLABELED:
+			/* just delete the protocols we support for right now
+			 * but we could remove other protocols if needed */
+			cipso_v4_req_delattr(req);
+			ret_val = 0;
+			break;
+		default:
+			ret_val = -ENOENT;
+		}
+		break;
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+	case AF_INET6:
+		/* since we don't support any IPv6 labeling protocols right
+		 * now we can optimize everything away until we do */
+		ret_val = 0;
+		break;
+#endif /* IPv6 */
+	default:
+		ret_val = -EPROTONOSUPPORT;
+	}
+
+req_setattr_return:
+	rcu_read_unlock();
+	return ret_val;
+}
+
+/**
+* netlbl_req_delattr - Delete all the NetLabel labels on a socket
+* @req: the socket
+*
+* Description:
+* Remove all the NetLabel labeling from @req.
+*
+*/
+void netlbl_req_delattr(struct request_sock *req)
+{
+	cipso_v4_req_delattr(req);
+}
+
+/**
  * netlbl_skbuff_setattr - Label a packet using the correct protocol
  * @skb: the packet
  * @family: protocol family


