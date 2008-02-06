Return-Path: <linux-kernel-owner+w=401wt.eu-S1765592AbYBGAYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765592AbYBGAYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932498AbYBFX7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:59:37 -0500
Received: from ns1.suse.de ([195.135.220.2]:46510 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932528AbYBFX7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:59:34 -0500
Date: Wed, 6 Feb 2008 15:54:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>,
       Peter Staubach <staubach@redhat.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>, nfs@lists.sourceforge.net
Subject: [patch 59/73] knfsd: Allow NFSv2/3 WRITE calls to succeed when
	krb5i etc is used.
Message-ID: <20080206235405.GH13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="knfsd-allow-nfsv2-3-write-calls-to-succeed-when-krb5i-etc-is-used.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: NeilBrown <neilb@suse.de>

patch ba67a39efde8312e386c6f603054f8945433d91f in mainline.

When RPCSEC/GSS and krb5i is used, requests are padded, typically to a multiple
of 8 bytes.  This can make the request look slightly longer than it
really is.

As of

	f34b95689d2ce001c "The NFSv2/NFSv3 server does not handle zero
		length WRITE request correctly",

the xdr decode routines for NFSv2 and NFSv3 reject requests that aren't
the right length, so krb5i (for example) WRITE requests can get lost.

This patch relaxes the appropriate test and enhances the related comment.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Peter Staubach <staubach@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs3xdr.c |    5 ++++-
 fs/nfsd/nfsxdr.c  |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -396,8 +396,11 @@ nfs3svc_decode_writeargs(struct svc_rqst
 	 * Round the length of the data which was specified up to
 	 * the next multiple of XDR units and then compare that
 	 * against the length which was actually received.
+	 * Note that when RPCSEC/GSS (for example) is used, the
+	 * data buffer can be padded so dlen might be larger
+	 * than required.  It must never be smaller.
 	 */
-	if (dlen != XDR_QUADLEN(len)*4)
+	if (dlen < XDR_QUADLEN(len)*4)
 		return 0;
 
 	if (args->count > max_blocksize) {
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -313,8 +313,11 @@ nfssvc_decode_writeargs(struct svc_rqst 
 	 * Round the length of the data which was specified up to
 	 * the next multiple of XDR units and then compare that
 	 * against the length which was actually received.
+	 * Note that when RPCSEC/GSS (for example) is used, the
+	 * data buffer can be padded so dlen might be larger
+	 * than required.  It must never be smaller.
 	 */
-	if (dlen != XDR_QUADLEN(len)*4)
+	if (dlen < XDR_QUADLEN(len)*4)
 		return 0;
 
 	rqstp->rq_vec[0].iov_base = (void*)p;

-- 
