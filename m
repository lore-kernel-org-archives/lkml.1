Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbZCKOT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbZCKOT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 10:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbZCKOS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 10:18:57 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:59592 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754187AbZCKOS4 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 10:18:56 -0400
Date: Wed, 11 Mar 2009 15:18:53 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: Phillip Lougher <phil.lougher@gmail.com>,
       Stefan Lippers-Hollmann <s.L-H@gmx.de>, Linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] Squashfs fixes for 2.6.29?
In-Reply-To: <49B75666.5030106@lougher.demon.co.uk>
Message-ID: <alpine.LRH.2.00.0903111507550.1040@vixen.sonytel.be>
References: <49AF30EC.8010205@lougher.demon.co.uk>  <200903092239.13078.s.L-H@gmx.de>  <49B5CCB7.5030404@lougher.demon.co.uk>  <alpine.LRH.2.00.0903101149500.25436@vixen.sonytel.be> <cce9e37e0903101433r68f6140and965959f9063e798@mail.gmail.com>
 <49B75666.5030106@lougher.demon.co.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009, Phillip Lougher wrote:
> Phillip Lougher wrote:
> > Geert Uytterhoeven wrote:
> > > On Tue, 10 Mar 2009, Phillip Lougher wrote:
> > > > Stefan Lippers-Hollmann wrote:
> > > > > This patch seems to break squashfs for me on i386 and amd64.
> > > > > Test environment is a squashed filesystem image (live CD image, but
> > > > > also
> > > > > tested manually with a loop mounted iso9660 and loop mounted squashfs;
> > > > > kernel 2.6.29-rc7-git2). The squashfs image has been created with
> > > > > squashfs-tools CVS[1] as of today (latest commit 2009-03-03).
> > > > >
> > > > Can you send me a filesystem (or link to one) which exhibits this?  Zlib
> > > > is
> > > > obviously showing unexpected behaviour...
> > > I see the same thing here. I'll send you a test file system by private
> > > email.
> > >
> > 
> > OK thanks, I've received it, and reproduced the problem :-)
> > 
> > > The patch below fixes it. It seems zlib sometimes does need an additional
> > > loop ;-)
> > >
> > 
> > Yes thanks.
> > 
> > > Note that I expect it may now loop forever in case of file system
> > > corruption.
> > 
> > This is the next thing, to redo the file system corruption patch.
> 
> The following patch fixes the problems you've experienced with your test
> filesystems (thanks for making them available), and also deals with the
> corrupted
> filesystems issue.  It correctly works with all the corrupted filesystems sent
> earlier this year.
> 
> The problem arises due to an unexpected corner-case with zlib which the
> corrupted filesystems patch didn't address.  Very occasionally zlib exits
> needing a couple of extra bytes of input (1 and 2 bytes in the test
> filesystems),

I saw up to 6 extra bytes of input in another file system.

I tried to corrupt the extra bytes and see what happens. So far zlib detected
the corruption in all cases and returned Z_DATA_ERROR, hence there was no
infinite looping.

> but with avail_out == 0 and no more output buffers available.  This situation
> was incorrectly flagged as an error by the corrupted filesystems patch. I
> unfortunately didn't anticipate this scenario because it seems contrary to
> expectation that zlib will be still reading input having produced all the
> expected output.  The fix is to not print an error if zlib wants more input
> bytes and there's more input bytes to be read.
> 
> Geert I can put a signed off line from you on the patch if you like (as you
> sent the original fix).  I could add reported and tested lines from both of
> you?
> They seem to be being used more often and sound a good idea.

Tested-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Please note that I had to apply your patch manually, as it's
whitespace-damaged.  Below is a version that does apply.

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 321728f..b85173f 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -166,6 +166,22 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 
 		bytes = length;
 		do {
+			if (msblk->stream.avail_out == 0) {
+				if (page < pages) {
+					msblk->stream.next_out = buffer[page++];
+					msblk->stream.avail_out =
+								PAGE_CACHE_SIZE;
+				} else if (msblk->stream.avail_in > 0
+								|| bytes == 0) {
+					ERROR("zlib_inflate tried to "
+						"decompress too much data, "
+						"expected %d bytes.  Zlib "
+						"data probably corrupt\n",
+						srclength);
+					goto release_mutex;
+				}
+			}
+
 			if (msblk->stream.avail_in == 0 && k < b) {
 				avail = min(bytes, msblk->devblksize - offset);
 				bytes -= avail;
@@ -184,19 +200,6 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
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
-				msblk->stream.next_out = buffer[page++];
-				msblk->stream.avail_out = PAGE_CACHE_SIZE;
-			}
-
 			if (!zlib_init) {
 				zlib_err = zlib_inflateInit(&msblk->stream);
 				if (zlib_err != Z_OK) {

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
