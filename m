Return-Path: <linux-kernel-owner+w=401wt.eu-S1758882AbZBRVmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882AbZBRVmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757224AbZBRVfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:35:53 -0500
Received: from kroah.org ([198.145.64.141]:56250 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756896AbZBRVfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:35:45 -0500
Date: Wed, 18 Feb 2009 13:32:49 -0800
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
       alan@lxorguk.ukuu.org.uk, Li Zefan <lizf@cn.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, linux-ext4@vger.kernel.org,
       Miao Xie <miaox@cn.fujitsu.com>
Subject: [patch 19/39] ext4: Widen type of ext4_sb_info.s_mb_maxs[]
Message-ID: <20090218213249.GT19814@kroah.com>
References: <20090218212144.965748151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ext4-widen-type-of-ext4_sb_info.s_mb_maxs.patch"
In-Reply-To: <20090218213021.GA19814@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yasunori Goto <y-goto@jp.fujitsu.com>

(cherry picked from commit ff7ef329b268b603ea4a2303241ef1c3829fd574)

I chased the cause of following ext4 oops report which is tested on
ia64 box.

http://bugzilla.kernel.org/show_bug.cgi?id=12018

The cause is the size of s_mb_maxs array that is defined as "unsigned
short" in ext4_sb_info structure.  If the file system's block size is
8k or greater, an unsigned short is not wide enough to contain the
value fs->blocksize << 3.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/ext4_sb.h |    3 ++-
 fs/ext4/mballoc.c |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/fs/ext4/ext4_sb.h
+++ b/fs/ext4/ext4_sb.h
@@ -102,7 +102,8 @@ struct ext4_sb_info {
 	spinlock_t s_reserve_lock;
 	spinlock_t s_md_lock;
 	tid_t s_last_transaction;
-	unsigned short *s_mb_offsets, *s_mb_maxs;
+	unsigned short *s_mb_offsets;
+	unsigned int *s_mb_maxs;
 
 	/* tunables */
 	unsigned long s_stripe;
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2493,6 +2493,8 @@ int ext4_mb_init(struct super_block *sb,
 	if (sbi->s_mb_offsets == NULL) {
 		return -ENOMEM;
 	}
+
+	i = (sb->s_blocksize_bits + 2) * sizeof(unsigned int);
 	sbi->s_mb_maxs = kmalloc(i, GFP_KERNEL);
 	if (sbi->s_mb_maxs == NULL) {
 		kfree(sbi->s_mb_maxs);

