Return-Path: <linux-kernel-owner+w=401wt.eu-S934829AbXEUTjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934829AbXEUTjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765200AbXEUT0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:26:45 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:35746 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932664AbXEUT0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:26:43 -0400
Message-Id: <20070521191730.253921000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:47 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Vlad Yasevich <vladislav.yasevich@hp.com>,
       David S Miller <davem@davemloft.net>
Subject: [patch 35/69] SCTP: Correctly copy addresses in sctp_copy_laddrs
Content-Disposition: inline; filename=sctp-correctly-copy-addresses-in-sctp_copy_laddrs.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Vlad Yasevich <vladislav.yasevich@hp.com>

I broke the  non-wildcard case recently.  This is to fixes it.
Now, explictitly bound addresses can ge retrieved using the API.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/sctp/socket.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- linux-2.6.21.1.orig/net/sctp/socket.c
+++ linux-2.6.21.1/net/sctp/socket.c
@@ -4016,6 +4016,7 @@ static int sctp_getsockopt_local_addrs_o
 	rwlock_t *addr_lock;
 	int err = 0;
 	void *addrs;
+	void *buf;
 	int bytes_copied = 0;
 
 	if (len != sizeof(struct sctp_getaddrs_old))
@@ -4069,13 +4070,14 @@ static int sctp_getsockopt_local_addrs_o
 		}
 	}
 
+	buf = addrs;
 	list_for_each(pos, &bp->address_list) {
 		addr = list_entry(pos, struct sctp_sockaddr_entry, list);
 		memcpy(&temp, &addr->a, sizeof(temp));
 		sctp_get_pf_specific(sk->sk_family)->addr_v4map(sp, &temp);
 		addrlen = sctp_get_af_specific(temp.sa.sa_family)->sockaddr_len;
-		memcpy(addrs, &temp, addrlen);
-		to += addrlen;
+		memcpy(buf, &temp, addrlen);
+		buf += addrlen;
 		bytes_copied += addrlen;
 		cnt ++;
 		if (cnt >= getaddrs.addr_num) break;
@@ -4118,6 +4120,7 @@ static int sctp_getsockopt_local_addrs(s
 	size_t space_left;
 	int bytes_copied = 0;
 	void *addrs;
+	void *buf;
 
 	if (len <= sizeof(struct sctp_getaddrs))
 		return -EINVAL;
@@ -4168,6 +4171,7 @@ static int sctp_getsockopt_local_addrs(s
 		}
 	}
 
+	buf = addrs;
 	list_for_each(pos, &bp->address_list) {
 		addr = list_entry(pos, struct sctp_sockaddr_entry, list);
 		memcpy(&temp, &addr->a, sizeof(temp));
@@ -4177,8 +4181,8 @@ static int sctp_getsockopt_local_addrs(s
 			err =  -ENOMEM; /*fixme: right error?*/
 			goto error;
 		}
-		memcpy(addrs, &temp, addrlen);
-		to += addrlen;
+		memcpy(buf, &temp, addrlen);
+		buf += addrlen;
 		bytes_copied += addrlen;
 		cnt ++;
 		space_left -= addrlen;

-- 
