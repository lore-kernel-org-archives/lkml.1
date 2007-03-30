Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbXC3VP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbXC3VP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbXC3VMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:12:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51751 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbXC3VM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:12:26 -0400
Date: Fri, 30 Mar 2007 14:06:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@citi.umich.edu>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 32/37] CRYPTO: api: scatterwalk_copychunks() fails to
	advance through scatterlist
Message-ID: <20070330210651.GI29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="crypto-api-scatterwalk_copychunks-fails-to-advance-through-scatterlist.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: J. Bruce Fields <bfields@citi.umich.edu>

[CRYPTO] api: scatterwalk_copychunks() fails to advance through scatterlist

In the loop in scatterwalk_copychunks(), if walk->offset is zero,
then scatterwalk_pagedone rounds that up to the nearest page boundary:

		walk->offset += PAGE_SIZE - 1;
		walk->offset &= PAGE_MASK;

which is a no-op in this case, so we don't advance to the next element
of the scatterlist array:

		if (walk->offset >= walk->sg->offset + walk->sg->length)
			scatterwalk_start(walk, sg_next(walk->sg));

and we end up copying the same data twice.

It appears that other callers of scatterwalk_{page}done first advance
walk->offset, so I believe that's the correct thing to do here.

This caused a bug in NFS when run with krb5p security, which would
cause some writes to fail with permissions errors--for example, writes
of less than 8 bytes (the des blocksize) at the start of a file.

A git-bisect shows the bug was originally introduced by
5c64097aa0f6dc4f27718ef47ca9a12538d62860, first in 2.6.19-rc1.

Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 crypto/scatterwalk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -91,6 +91,8 @@ void scatterwalk_copychunks(void *buf, s
 		memcpy_dir(buf, vaddr, len_this_page, out);
 		scatterwalk_unmap(vaddr, out);
 
+		scatterwalk_advance(walk, nbytes);
+
 		if (nbytes == len_this_page)
 			break;
 
@@ -99,7 +101,5 @@ void scatterwalk_copychunks(void *buf, s
 
 		scatterwalk_pagedone(walk, out, 1);
 	}
-
-	scatterwalk_advance(walk, nbytes);
 }
 EXPORT_SYMBOL_GPL(scatterwalk_copychunks);

-- 
