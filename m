Return-Path: <linux-kernel-owner+w=401wt.eu-S1760208AbZENWry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbZENWry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756568AbZENWmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:42:22 -0400
Received: from kroah.org ([198.145.64.141]:51596 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215AbZENWmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:42:09 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:23 2009
Message-Id: <20090514223523.032025485@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:32:52 -0700
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
Subject: [patch 17/51] lsm: Relocate the IPv4 security_inet_conn_request() hooks
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=lsm-relocate-the-ipv4-security_inet_conn_request-hooks.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Moore <paul.moore@hp.com>

[NOTE: present in Linus' tree as 284904aa79466a4736f4c775fdbe5c7407fa136c]

The current placement of the security_inet_conn_request() hooks do not allow
individual LSMs to override the IP options of the connection's request_sock.
This is a problem as both SELinux and Smack have the ability to use labeled
networking protocols which make use of IP options to carry security attributes
and the inability to set the IP options at the start of the TCP handshake is
problematic.

This patch moves the IPv4 security_inet_conn_request() hooks past the code
where the request_sock's IP options are set/reset so that the LSM can safely
manipulate the IP options as needed.  This patch intentionally does not change
the related IPv6 hooks as IPv6 based labeling protocols which use IPv6 options
are not currently implemented, once they are we will have a better idea of
the correct placement for the IPv6 hooks.

Signed-off-by: Paul Moore <paul.moore@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/syncookies.c |    9 +++++----
 net/ipv4/tcp_ipv4.c   |    7 ++++---
 2 files changed, 9 insertions(+), 7 deletions(-)

--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -288,10 +288,6 @@ struct sock *cookie_v4_check(struct sock
 	if (!req)
 		goto out;
 
-	if (security_inet_conn_request(sk, skb, req)) {
-		reqsk_free(req);
-		goto out;
-	}
 	ireq = inet_rsk(req);
 	treq = tcp_rsk(req);
 	treq->rcv_isn		= ntohl(th->seq) - 1;
@@ -322,6 +318,11 @@ struct sock *cookie_v4_check(struct sock
 		}
 	}
 
+	if (security_inet_conn_request(sk, skb, req)) {
+		reqsk_free(req);
+		goto out;
+	}
+
 	req->expires	= 0UL;
 	req->retrans	= 0;
 
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1239,14 +1239,15 @@ int tcp_v4_conn_request(struct sock *sk,
 
 	tcp_openreq_init(req, &tmp_opt, skb);
 
-	if (security_inet_conn_request(sk, skb, req))
-		goto drop_and_free;
-
 	ireq = inet_rsk(req);
 	ireq->loc_addr = daddr;
 	ireq->rmt_addr = saddr;
 	ireq->no_srccheck = inet_sk(sk)->transparent;
 	ireq->opt = tcp_v4_save_options(sk, skb);
+
+	if (security_inet_conn_request(sk, skb, req))
+		goto drop_and_free;
+
 	if (!want_cookie)
 		TCP_ECN_create_request(req, tcp_hdr(skb));
 


