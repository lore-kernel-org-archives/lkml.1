Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbYHDU0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbYHDU0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758706AbYHDU0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:26:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45825 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758704AbYHDU0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:26:07 -0400
Date: Mon, 4 Aug 2008 13:15:45 -0700
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
       alan@lxorguk.ukuu.org.uk, Frank Seidel <fseidel@suse.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [patch 16/33] FAT_VALID_MEDIA(): remove pointless test
Message-ID: <20080804201545.GQ1139@suse.de>
References: <20080804200515.110033151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fat_valid_media-remove-pointless-test.patch"
In-Reply-To: <20080804201321.GA1139@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit 73f20e58b1d586e9f6d3ddc3aad872829aca7743 upstream

The on-disk media specification field in FAT is only 8-bits, so testing for
<=0xff is pointless, and can generate a "comparison is always true due to
limited range of data type" warning.

While we're there, convert FAT_VALID_MEDIA() into a C function - the present
implementation is buggy: it generates either one or two references to its
argument.

Cc: Frank Seidel <fseidel@suse.de>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fat/inode.c           |    2 +-
 include/linux/msdos_fs.h |    6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1208,7 +1208,7 @@ int fat_fill_super(struct super_block *s
 	 */
 
 	media = b->media;
-	if (!FAT_VALID_MEDIA(media)) {
+	if (!fat_valid_media(media)) {
 		if (!silent)
 			printk(KERN_ERR "FAT: invalid media value (0x%02x)\n",
 			       media);
--- a/include/linux/msdos_fs.h
+++ b/include/linux/msdos_fs.h
@@ -58,7 +58,11 @@
 #define MSDOS_DOTDOT	"..         "	/* "..", padded to MSDOS_NAME chars */
 
 /* media of boot sector */
-#define FAT_VALID_MEDIA(x)	((0xF8 <= (x) && (x) <= 0xFF) || (x) == 0xF0)
+static inline int fat_valid_media(u8 media)
+{
+	return 0xf8 <= media || media == 0xf0;
+}
+
 #define FAT_FIRST_ENT(s, x)	((MSDOS_SB(s)->fat_bits == 32 ? 0x0FFFFF00 : \
 	MSDOS_SB(s)->fat_bits == 16 ? 0xFF00 : 0xF00) | (x))
 

-- 
