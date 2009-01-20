Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbZATPyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbZATPyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 10:54:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761526AbZATPxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 10:53:49 -0500
Received: from cantor.suse.de ([195.135.220.2]:39374 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761312AbZATPxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 10:53:48 -0500
Message-ID: <4975F376.4010506@suse.com>
Date: Tue, 20 Jan 2009 10:53:26 -0500
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] kmalloc: Return NULL instead of link failure
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

 The SLAB kmalloc with a constant value isn't consistent with the other
 implementations because it bails out with __you_cannot_kmalloc_that_much
 rather than returning NULL and properly allowing the caller to fall back
 to vmalloc or take other action. This doesn't happen with a non-constant
 value or with SLOB or SLUB.

 Starting with 2.6.28, I've been seeing build failures on s390x. This is
 due to init_section_page_cgroup trying to allocate 2.5MB when the max
 size for a kmalloc on s390x is 2MB.

 It's failing because the value is constant. The workarounds at the call
 size are ugly and the caller shouldn't have to change behavior depending
 on what the backend of the API is.

 So, this patch eliminates the link failure and returns NULL like the
 other implementations.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
- ---
 include/linux/slab_def.h |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

- --- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -43,10 +43,7 @@ static inline void *kmalloc(size_t size,
 			i++;
 #include <linux/kmalloc_sizes.h>
 #undef CACHE
- -		{
- -			extern void __you_cannot_kmalloc_that_much(void);
- -			__you_cannot_kmalloc_that_much();
- -		}
+		return NULL;
 found:
 #ifdef CONFIG_ZONE_DMA
 		if (flags & GFP_DMA)
@@ -77,10 +74,7 @@ static inline void *kmalloc_node(size_t
 			i++;
 #include <linux/kmalloc_sizes.h>
 #undef CACHE
- -		{
- -			extern void __you_cannot_kmalloc_that_much(void);
- -			__you_cannot_kmalloc_that_much();
- -		}
+		return NULL;
 found:
 #ifdef CONFIG_ZONE_DMA
 		if (flags & GFP_DMA)

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkl183YACgkQLPWxlyuTD7IMnQCfbf4NvJuyTustFrdJD/lcl6ub
QQ0AniWOsKCWnBWuLLnm6rM+Atq6LBfd
=/evL
-----END PGP SIGNATURE-----
