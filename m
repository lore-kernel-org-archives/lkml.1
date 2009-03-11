Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbZCKUrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbZCKUrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 16:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbZCKUrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 16:47:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:47448 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750954AbZCKUq7 convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 16:46:59 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1/V5ro21NDVtgPKX01INF4TnydBX2st4DlXFkavoQ
	Ol87Tyg8OlpAZH
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: [GIT PULL] Squashfs fixes for 2.6.29?
Date: Wed, 11 Mar 2009 21:46:50 +0100
User-Agent: KMail/1.9.9
Cc: Phillip Lougher <phil.lougher@gmail.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <49AF30EC.8010205@lougher.demon.co.uk> <cce9e37e0903101433r68f6140and965959f9063e798@mail.gmail.com> <49B75666.5030106@lougher.demon.co.uk>
In-Reply-To: <49B75666.5030106@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903112146.54280.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mittwoch, 11. März 2009, Phillip Lougher wrote:
> Phillip Lougher wrote:
[...]
> The following patch fixes the problems you've experienced with your test
> filesystems (thanks for making them available), and also deals with the corrupted
> filesystems issue.  It correctly works with all the corrupted filesystems sent
> earlier this year.
> 
> The problem arises due to an unexpected corner-case with zlib which the
> corrupted filesystems patch didn't address.  Very occasionally zlib exits
> needing a couple of extra bytes of input (1 and 2 bytes in the test filesystems),
> but with avail_out == 0 and no more output buffers available.  This situation
> was incorrectly flagged as an error by the corrupted filesystems patch. I
> unfortunately didn't anticipate this scenario because it seems contrary to
> expectation that zlib will be still reading input having produced all the
> expected output.  The fix is to not print an error if zlib wants more input
> bytes and there's more input bytes to be read.

I just got home and around to test it with 2.6.29-rc7-git4, no further 
issues with large filesystems (copying + live usage) and it's working 
reliably (after whitespace fixing), thank you a lot. 

> Geert I can put a signed off line from you on the patch if you like (as you
> sent the original fix).  I could add reported and tested lines from both of you?
> They seem to be being used more often and sound a good idea.

Feel free to add the tags as needed, thanks.
Reported-by: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Tested-by: Stefan Lippers-Hollmann <s.L-H@gmx.de>

> Thanks
> 
> Phillip

Regards
	Stefan Lippers-Hollmann

-- 
> diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
> index 321728f..b85173f 100644
> --- a/fs/squashfs/block.c
> +++ b/fs/squashfs/block.c
> @@ -166,6 +166,22 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
> 
>   		bytes = length;
>   		do {
> +			if (msblk->stream.avail_out == 0) {
> +				if (page < pages) {
> +					msblk->stream.next_out = buffer[page++];
> +					msblk->stream.avail_out =
> +								PAGE_CACHE_SIZE;
> +				} else if (msblk->stream.avail_in > 0
> +								|| bytes == 0) {
> +					ERROR("zlib_inflate tried to "
> +						"decompress too much data, "
> +						"expected %d bytes.  Zlib "
> +						"data probably corrupt\n",
> +						srclength);
> +					goto release_mutex;
> +				}
> +			}
> +
>   			if (msblk->stream.avail_in == 0 && k < b) {
>   				avail = min(bytes, msblk->devblksize - offset);
>   				bytes -= avail;
> @@ -184,19 +200,6 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
>   				offset = 0;
>   			}
> 
> -			if (msblk->stream.avail_out == 0) {
> -				if (page == pages) {
> -					ERROR("zlib_inflate tried to "
> -						"decompress too much data, "
> -						"expected %d bytes.  Zlib "
> -						"data probably corrupt\n",
> -						srclength);
> -					goto release_mutex;
> -				}
> -				msblk->stream.next_out = buffer[page++];
> -				msblk->stream.avail_out = PAGE_CACHE_SIZE;
> -			}
> -
>   			if (!zlib_init) {
>   				zlib_err = zlib_inflateInit(&msblk->stream);
>   				if (zlib_err != Z_OK) {
