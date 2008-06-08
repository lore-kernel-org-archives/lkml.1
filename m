Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbYFHSoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbYFHSoP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 14:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbYFHSn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 14:43:59 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41263 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbYFHSn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 14:43:59 -0400
Date: Sun, 8 Jun 2008 21:43:10 +0300
From: Adrian Bunk <bunk@kernel.org>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank Seidel <fseidel@suse.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Onur =?utf-8?B?S8O8w6fDvGs=?= <onur@pardus.org.tr>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6.26 patch] fat_valid_media() isn't for userspace
Message-ID: <20080608184310.GD4048@cs181133002.pp.htv.fi>
References: <200806082116.50355.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200806082116.50355.caglar@pardus.org.tr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 09:16:48PM +0300, S.Çağlar Onur wrote:
> include/linux/msdos_fs.h header should use __u## rather than u## types else any userspace code (like syslinux) includes that header fails to compile like following;
> 
> [...]
> gcc -Wp,-MT,bootsect_bin.o,-MMD,.bootsect_bin.o.d -W -Wall -D_FILE_OFFSET_BITS=64 -g -Os -I. -I.. -I../libinstaller -c -o bootsect_bin.o ../bootsect_bin.c
> gcc -Wp,-MT,ldlinux_bin.o,-MMD,.ldlinux_bin.o.d -W -Wall -D_FILE_OFFSET_BITS=64 -g -Os -I. -I.. -I../libinstaller -c -o ldlinux_bin.o ../ldlinux_bin.c
> In file included from syslinux.c:52:
> /usr/include/linux/msdos_fs.h:61: error: expected ')' before 'media'
> [...]
> 
> Noticed by Onur Küçük <onur@pardus.org.tr>
> 
> Cc: Frank Seidel <fseidel@suse.de>
> CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> CC: Onur Küçük <onur@pardus.org.tr>
> 
> Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
> 
>  include/linux/msdos_fs.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
> index b03b274..3825b1c 100644
> --- a/include/linux/msdos_fs.h
> +++ b/include/linux/msdos_fs.h
> @@ -58,7 +58,7 @@
>  #define MSDOS_DOTDOT	"..         "	/* "..", padded to MSDOS_NAME chars */
>  
>  /* media of boot sector */
> -static inline int fat_valid_media(u8 media)
> +static inline int fat_valid_media(__u8 media)
>  {
>  	return 0xf8 <= media || media == 0xf0;
>  }

This function isn't part of the kernel<->userspace API and therefore 
shouldn't have been added at this place.

I'd suggest the patch below instead.

> Cheers

cu
Adrian


<--  snip  -->


Commit 73f20e58b1d586e9f6d3ddc3aad872829aca7743
(FAT_VALID_MEDIA(): remove pointless test)
wrongly added the new fat_valid_media() function
to the userspace-visible part of include/linux/msdos_fs.h

Move it to the part of include/linux/msdos_fs.h that is not exported to 
userspace.

Reported-by: Onur Küçük <onur@pardus.org.tr>
Reported-by: S.Çağlar Onur <caglar@pardus.org.tr>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/linux/msdos_fs.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

4a56896ef4ef839cdc9d59fd7118c5051231c61e diff --git a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
index b03b274..81cd36b 100644
--- a/include/linux/msdos_fs.h
+++ b/include/linux/msdos_fs.h
@@ -57,12 +57,6 @@
 #define MSDOS_DOT	".          "	/* ".", padded to MSDOS_NAME chars */
 #define MSDOS_DOTDOT	"..         "	/* "..", padded to MSDOS_NAME chars */
 
-/* media of boot sector */
-static inline int fat_valid_media(u8 media)
-{
-	return 0xf8 <= media || media == 0xf0;
-}
-
 #define FAT_FIRST_ENT(s, x)	((MSDOS_SB(s)->fat_bits == 32 ? 0x0FFFFF00 : \
 	MSDOS_SB(s)->fat_bits == 16 ? 0xFF00 : 0xF00) | (x))
 
@@ -334,6 +328,12 @@ static inline void fatwchar_to16(__u8 *dst, const wchar_t *src, size_t len)
 #endif
 }
 
+/* media of boot sector */
+static inline int fat_valid_media(u8 media)
+{
+	return 0xf8 <= media || media == 0xf0;
+}
+
 /* fat/cache.c */
 extern void fat_cache_inval_inode(struct inode *inode);
 extern int fat_get_cluster(struct inode *inode, int cluster,

