Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbZCJLDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbZCJLDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 07:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbZCJLDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 07:03:03 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:62953 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753962AbZCJLDB (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 07:03:01 -0400
Date: Tue, 10 Mar 2009 12:02:58 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, Linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] Squashfs fixes for 2.6.29?
In-Reply-To: <49B5CCB7.5030404@lougher.demon.co.uk>
Message-ID: <alpine.LRH.2.00.0903101149500.25436@vixen.sonytel.be>
References: <49AF30EC.8010205@lougher.demon.co.uk> <200903092239.13078.s.L-H@gmx.de> <49B5CCB7.5030404@lougher.demon.co.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, Phillip Lougher wrote:
> Stefan Lippers-Hollmann wrote:
> > This patch seems to break squashfs for me on i386 and amd64. 
> > Test environment is a squashed filesystem image (live CD image, but also
> > tested manually with a loop mounted iso9660 and loop mounted squashfs;
> > kernel 2.6.29-rc7-git2). The squashfs image has been created with
> > squashfs-tools CVS[1] as of today (latest commit 2009-03-03).
> > 
> 
> Can you send me a filesystem (or link to one) which exhibits this?  Zlib is
> obviously showing unexpected behaviour...

I see the same thing here. I'll send you a test file system by private email.

The patch below fixes it. It seems zlib sometimes does need an additional
loop ;-)

Note that I expect it may now loop forever in case of file system corruption.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 321728f..46358dd 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -184,15 +184,7 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 				offset = 0;
 			}
 
-			if (msblk->stream.avail_out == 0) {
-				if (page == pages) {
-					ERROR("zlib_inflate tried to "
-						"decompress too much data, "
-						"expected %d bytes.  Zlib "
-						"data probably corrupt\n",
-						srclength);
-					goto release_mutex;
-				}
+			if (msblk->stream.avail_out == 0 && page < pages) {
 				msblk->stream.next_out = buffer[page++];
 				msblk->stream.avail_out = PAGE_CACHE_SIZE;
 			}

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
