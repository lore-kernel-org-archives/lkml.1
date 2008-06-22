Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbYFVTFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbYFVTFw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890AbYFVTEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:04:44 -0400
Received: from ns2.suse.de ([195.135.220.15]:39921 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702AbYFVTEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:04:43 -0400
Date: Sun, 22 Jun 2008 12:01:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 3/5] sctp: Make sure N * sizeof(union sctp_addr) does not
	overflow.
Message-ID: <20080622190136.GC20141@suse.de>
References: <20080622185327.348377223@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sctp-make-sure-n-sizeof-does-not-overflow.patch"
In-Reply-To: <20080622190111.GA20141@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David S. Miller <davem@davemloft.net>

commit 735ce972fbc8a65fb17788debd7bbe7b4383cc62 upstream

As noticed by Gabriel Campana, the kmalloc() length arg
passed in by sctp_getsockopt_local_addrs_old() can overflow
if ->addr_num is large enough.

Therefore, enforce an appropriate limit.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sctp/socket.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4421,7 +4421,9 @@ static int sctp_getsockopt_local_addrs_o
 	if (copy_from_user(&getaddrs, optval, len))
 		return -EFAULT;
 
-	if (getaddrs.addr_num <= 0) return -EINVAL;
+	if (getaddrs.addr_num <= 0 ||
+	    getaddrs.addr_num >= (INT_MAX / sizeof(union sctp_addr)))
+		return -EINVAL;
 	/*
 	 *  For UDP-style sockets, id specifies the association to query.
 	 *  If the id field is set to the value '0' then the locally bound

-- 
