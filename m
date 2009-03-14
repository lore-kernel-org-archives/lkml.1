Return-Path: <linux-kernel-owner+w=401wt.eu-S1765331AbZCNBzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765331AbZCNBzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbZCNBVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:47 -0400
Received: from kroah.org ([198.145.64.141]:35738 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754317AbZCNBVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:15 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:45 2009
Message-Id: <20090314011045.002488989@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:11:09 -0700
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
       alan@lxorguk.ukuu.org.uk, Wei Yongjun <yjwei@cn.fujitsu.com>
Subject: [patch 092/114] ext4: Fix to read empty directory blocks correctly in 64k
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=ext4-fix-to-read-empty-directory-blocks-correctly-in-64k.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wei Yongjun <yjwei@cn.fujitsu.com>

(cherry picked from commit 7be2baaa0322c59ba888aa5260a8c130666acd41)

The rec_len field in the directory entry is 16 bits, so there was a
problem representing rec_len for filesystems with a 64k block size in
the case where the directory entry takes the entire 64k block.
Unfortunately, there were two schemes that were proposed; one where
all zeros meant 65536 and one where all ones (65535) meant 65536.
E2fsprogs used 0, whereas the kernel used 65535.  Oops.  Fortunately
this case happens extremely rarely, with the most common case being
the lost+found directory, created by mke2fs.

So we will be liberal in what we accept, and accept both encodings,
but we will continue to encode 65536 as 65535.  This will require a
change in e2fsprogs, but with fortunately ext4 filesystems normally
have the dir_index feature enabled, which precludes having a
completely empty directory block.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/ext4.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -862,7 +862,7 @@ static inline unsigned ext4_rec_len_from
 {
 	unsigned len = le16_to_cpu(dlen);
 
-	if (len == EXT4_MAX_REC_LEN)
+	if (len == EXT4_MAX_REC_LEN || len == 0)
 		return 1 << 16;
 	return len;
 }


