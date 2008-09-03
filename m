Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbYICRxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbYICRxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbYICRxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:53:35 -0400
Received: from mx1.suse.de ([195.135.220.2]:54290 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853AbYICRxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:53:34 -0400
Date: Wed, 3 Sep 2008 10:33:09 -0700
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
Subject: [patch 13/16] sctp: add verification checks to SCTP_AUTH_KEY option
Message-ID: <20080903173309.GN10429@suse.de>
References: <20080903172849.927077124@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0008-sctp-add-verification-checks-to-SCTP_AUTH_KEY-optio.patch"
In-Reply-To: <20080903173218.GA10429@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Vlad Yasevich <vladislav.yasevich@hp.com>

[ Upstream commit 30c2235cbc477d4629983d440cdc4f496fec9246 ]

The structure used for SCTP_AUTH_KEY option contains a
length that needs to be verfied to prevent buffer overflow
conditions.  Spoted by Eugene Teo <eteo@redhat.com>.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sctp/auth.c   |    4 ++++
 net/sctp/socket.c |    5 +++++
 2 files changed, 9 insertions(+)

--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -80,6 +80,10 @@ static struct sctp_auth_bytes *sctp_auth
 {
 	struct sctp_auth_bytes *key;
 
+	/* Verify that we are not going to overflow INT_MAX */
+	if ((INT_MAX - key_len) < sizeof(struct sctp_auth_bytes))
+		return NULL;
+
 	/* Allocate the shared key */
 	key = kmalloc(sizeof(struct sctp_auth_bytes) + key_len, gfp);
 	if (!key)
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3072,6 +3072,11 @@ static int sctp_setsockopt_auth_key(stru
 		goto out;
 	}
 
+	if (authkey->sca_keylength > optlen) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	asoc = sctp_id2assoc(sk, authkey->sca_assoc_id);
 	if (!asoc && authkey->sca_assoc_id && sctp_style(sk, UDP)) {
 		ret = -EINVAL;

-- 
