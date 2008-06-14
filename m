Return-Path: <linux-kernel-owner+w=401wt.eu-S1762924AbYFNARz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762924AbYFNARz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760442AbYFNANY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:13:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51756 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757942AbYFNANW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:13:22 -0400
Date: Fri, 13 Jun 2008 17:11:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Sam Ravnborg <sam@ravnborg.org>,
       Oliver Hartkopp <oliver.hartkopp@volkswagen.de>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 17/47] can: Fix copy_from_user() results interpretation
Message-ID: <20080614001101.GQ24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="can-fix-copy_from_user-results-interpretation.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sam Ravnborg <sam@ravnborg.org>

[ Upstream commit: 3f91bd420a955803421f2db17b2e04aacfbb2bb8 ]

Both copy_to_ and _from_user return the number of bytes, that failed to
reach their destination, not the 0/-EXXX values.

Based on patch from Pavel Emelyanov <xemul@openvz.org>

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Oliver Hartkopp <oliver.hartkopp@volkswagen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/can/raw.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -435,15 +435,13 @@ static int raw_setsockopt(struct socket 
 			if (!filter)
 				return -ENOMEM;
 
-			err = copy_from_user(filter, optval, optlen);
-			if (err) {
+			if (copy_from_user(filter, optval, optlen)) {
 				kfree(filter);
-				return err;
+				return -EFAULT;
 			}
 		} else if (count == 1) {
-			err = copy_from_user(&sfilter, optval, optlen);
-			if (err)
-				return err;
+			if (copy_from_user(&sfilter, optval, optlen))
+				return -EFAULT;
 		}
 
 		lock_sock(sk);
@@ -493,9 +491,8 @@ static int raw_setsockopt(struct socket 
 		if (optlen != sizeof(err_mask))
 			return -EINVAL;
 
-		err = copy_from_user(&err_mask, optval, optlen);
-		if (err)
-			return err;
+		if (copy_from_user(&err_mask, optval, optlen))
+			return -EFAULT;
 
 		err_mask &= CAN_ERR_MASK;
 
@@ -531,7 +528,8 @@ static int raw_setsockopt(struct socket 
 		if (optlen != sizeof(ro->loopback))
 			return -EINVAL;
 
-		err = copy_from_user(&ro->loopback, optval, optlen);
+		if (copy_from_user(&ro->loopback, optval, optlen))
+			return -EFAULT;
 
 		break;
 
@@ -539,7 +537,8 @@ static int raw_setsockopt(struct socket 
 		if (optlen != sizeof(ro->recv_own_msgs))
 			return -EINVAL;
 
-		err = copy_from_user(&ro->recv_own_msgs, optval, optlen);
+		if (copy_from_user(&ro->recv_own_msgs, optval, optlen))
+			return -EFAULT;
 
 		break;
 

-- 
