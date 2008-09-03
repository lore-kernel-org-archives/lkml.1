Return-Path: <linux-kernel-owner+w=401wt.eu-S1759414AbYICRyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414AbYICRyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757371AbYICRyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:54:23 -0400
Received: from ns2.suse.de ([195.135.220.15]:59197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759497AbYICRyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:54:22 -0400
Date: Wed, 3 Sep 2008 10:33:14 -0700
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
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Vlad Yasevich <vladislav.yasevich@hp.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 15/16] sctp: fix random memory dereference with
	SCTP_HMAC_IDENT option.
Message-ID: <20080903173314.GP10429@suse.de>
References: <20080903172849.927077124@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0012-sctp-fix-random-memory-dereference-with-SCTP_HMAC_I.patch"
In-Reply-To: <20080903173218.GA10429@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Vlad Yasevich <vladislav.yasevich@hp.com>

[ Upstream commit d97240552cd98c4b07322f30f66fd9c3ba4171de ]

The number of identifiers needs to be checked against the option
length.  Also, the identifier index provided needs to be verified
to make sure that it doesn't exceed the bounds of the array.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sctp/auth.c   |    3 +++
 net/sctp/socket.c |    6 ++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -786,6 +786,9 @@ int sctp_auth_ep_set_hmacs(struct sctp_e
 	for (i = 0; i < hmacs->shmac_num_idents; i++) {
 		id = hmacs->shmac_idents[i];
 
+		if (id > SCTP_AUTH_HMAC_ID_MAX)
+			return -EOPNOTSUPP;
+
 		if (SCTP_AUTH_HMAC_ID_SHA1 == id)
 			has_sha1 = 1;
 
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3014,6 +3014,7 @@ static int sctp_setsockopt_hmac_ident(st
 				    int optlen)
 {
 	struct sctp_hmacalgo *hmacs;
+	u32 idents;
 	int err;
 
 	if (!sctp_auth_enable)
@@ -3031,8 +3032,9 @@ static int sctp_setsockopt_hmac_ident(st
 		goto out;
 	}
 
-	if (hmacs->shmac_num_idents == 0 ||
-	    hmacs->shmac_num_idents > SCTP_AUTH_NUM_HMACS) {
+	idents = hmacs->shmac_num_idents;
+	if (idents == 0 || idents > SCTP_AUTH_NUM_HMACS ||
+	    (idents * sizeof(u16)) > (optlen - sizeof(struct sctp_hmacalgo))) {
 		err = -EINVAL;
 		goto out;
 	}

-- 
