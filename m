Return-Path: <linux-kernel-owner+w=401wt.eu-S1161406AbXDKXBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161406AbXDKXBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161372AbXDKXA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 19:00:58 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55714 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161371AbXDKWzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:55:11 -0400
Date: Wed, 11 Apr 2007 15:52:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Neil Brown <neilb@suse.de>
Subject: [patch 22/31] knfsd: allow nfsd READDIR to return 64bit cookies
Message-ID: <20070411225233.GW24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="knfsd-allow-nfsd-readdir-to-return-64bit-cookies.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Neil Brown <neilb@suse.de>

[PATCH] knfsd: allow nfsd READDIR to return 64bit cookies

->readdir passes lofft_t offsets (used as nfs cookies) to
nfs3svc_encode_entry{,_plus}, but when they pass it on to encode_entry it
becomes an 'off_t', which isn't good.

So filesystems that returned 64bit offsets would lose.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/nfsd/nfs3xdr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -844,8 +844,8 @@ compose_entry_fh(struct nfsd3_readdirres
 #define NFS3_ENTRY_BAGGAGE	(2 + 1 + 2 + 1)
 #define NFS3_ENTRYPLUS_BAGGAGE	(1 + 21 + 1 + (NFS3_FHSIZE >> 2))
 static int
-encode_entry(struct readdir_cd *ccd, const char *name,
-	     int namlen, off_t offset, ino_t ino, unsigned int d_type, int plus)
+encode_entry(struct readdir_cd *ccd, const char *name, int namlen,
+	     loff_t offset, ino_t ino, unsigned int d_type, int plus)
 {
 	struct nfsd3_readdirres *cd = container_of(ccd, struct nfsd3_readdirres,
 		       					common);
@@ -865,7 +865,7 @@ encode_entry(struct readdir_cd *ccd, con
 			*cd->offset1 = htonl(offset64 & 0xffffffff);
 			cd->offset1 = NULL;
 		} else {
-			xdr_encode_hyper(cd->offset, (u64) offset);
+			xdr_encode_hyper(cd->offset, offset64);
 		}
 	}
 

-- 
