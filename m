Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbZDWHds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbZDWHds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZDWH1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:27:52 -0400
Received: from sous-sol.org ([216.99.217.87]:48264 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755425AbZDWH1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:27:50 -0400
Message-Id: <20090423072319.950236137@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:43 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Douglas Gilbert <dgilbert@interlog.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 023/100] SCSI: sg: fix iovec bugs introduced by the block layer conversion
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=scsi-sg-fix-iovec-bugs-introduced-by-the-block-layer-conversion.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

upstream commit: 0fdf96b67ac2649cc1ddb29b316a0db11586c6a8

- needs to use copy_from_user for iovec before passing it to
blk_rq_map_user_iov().

- before the block layer conversion, if ->dxfer_len and sum of iovec
disagrees, the shorter one wins. However, currently sg returns
-EINVAL. This restores the old behavior.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Cc: stable@kernel.org
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/scsi/sg.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1673,10 +1673,30 @@ static int sg_start_req(Sg_request *srp,
 		md->null_mapped = hp->dxferp ? 0 : 1;
 	}
 
-	if (iov_count)
-		res = blk_rq_map_user_iov(q, rq, md, hp->dxferp, iov_count,
-					  hp->dxfer_len, GFP_ATOMIC);
-	else
+	if (iov_count) {
+		int len, size = sizeof(struct sg_iovec) * iov_count;
+		struct iovec *iov;
+
+		iov = kmalloc(size, GFP_ATOMIC);
+		if (!iov)
+			return -ENOMEM;
+
+		if (copy_from_user(iov, hp->dxferp, size)) {
+			kfree(iov);
+			return -EFAULT;
+		}
+
+		len = iov_length(iov, iov_count);
+		if (hp->dxfer_len < len) {
+			iov_count = iov_shorten(iov, iov_count, hp->dxfer_len);
+			len = hp->dxfer_len;
+		}
+
+		res = blk_rq_map_user_iov(q, rq, md, (struct sg_iovec *)iov,
+					  iov_count,
+					  len, GFP_ATOMIC);
+		kfree(iov);
+	} else
 		res = blk_rq_map_user(q, rq, md, hp->dxferp,
 				      hp->dxfer_len, GFP_ATOMIC);
 

