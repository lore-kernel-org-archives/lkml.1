Return-Path: <linux-kernel-owner+w=401wt.eu-S1760119AbYD2RXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760119AbYD2RXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757955AbYD2RUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:20:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42937 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbYD2RUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:20:30 -0400
Date: Tue, 29 Apr 2008 10:18:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Pavel Emelyanov <xemul@openvz.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [09/37] net: Fix wrong interpretation of some copy_to_user()
	results.
Message-ID: <20080429171815.GJ14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-fix-wrong-interpretation-of-some-copy_to_user-results.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Pavel Emelyanov <xemul@openvz.org>

[ Upstream commit: 653252c2302cdf2dfbca66a7e177f7db783f9efa ]

I found some places, that erroneously return the value obtained from
the copy_to_user() call: if some amount of bytes were not able to get
to the user (this is what this one returns) the proper behavior is to
return the -EFAULT error, not that number itself.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/can/raw.c     |    3 ++-
 net/dccp/probe.c  |    2 +-
 net/tipc/socket.c |    4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)

--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -573,7 +573,8 @@ static int raw_getsockopt(struct socket 
 			int fsize = ro->count * sizeof(struct can_filter);
 			if (len > fsize)
 				len = fsize;
-			err = copy_to_user(optval, ro->filter, len);
+			if (copy_to_user(optval, ro->filter, len))
+				err = -EFAULT;
 		} else
 			len = 0;
 		release_sock(sk);
--- a/net/dccp/probe.c
+++ b/net/dccp/probe.c
@@ -145,7 +145,7 @@ static ssize_t dccpprobe_read(struct fil
 		goto out_free;
 
 	cnt = kfifo_get(dccpw.fifo, tbuf, len);
-	error = copy_to_user(buf, tbuf, cnt);
+	error = copy_to_user(buf, tbuf, cnt) ? -EFAULT : 0;
 
 out_free:
 	vfree(tbuf);
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1600,8 +1600,8 @@ static int getsockopt(struct socket *soc
 	else if (len < sizeof(value)) {
 		res = -EINVAL;
 	}
-	else if ((res = copy_to_user(ov, &value, sizeof(value)))) {
-		/* couldn't return value */
+	else if (copy_to_user(ov, &value, sizeof(value))) {
+		res = -EFAULT;
 	}
 	else {
 		res = put_user(sizeof(value), ol);

-- 
