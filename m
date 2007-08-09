Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbXHIVsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbXHIVsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 17:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbXHIVry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 17:47:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49418 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbXHIVrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 17:47:52 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH V2] limit minixfs printks on corrupted dir i_size, CVE-2006-6058
To: Eric Sandeen <sandeen@sandeen.net>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Thu, 09 Aug 2007 23:47:42 +0200
References: <8Qlff-3jX-29@gated-at.bofh.it> <8Qn7m-6li-27@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IJFr4-0000is-Ox@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19CEyExdCu62lpdXOX40kk/SfZAFM9RVr2mKcj
 KW2ECC4enDiLWKXv+eOcMO7RjY/BI/3v8G+RI3Ees9awbovmyE
 ESaq7QMtUyx5W+YPZwc4A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen <sandeen@sandeen.net> wrote:

> This attempts to address CVE-2006-6058
> http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-6058
>  
> first reported at http://projects.info-pull.com/mokb/MOKB-17-11-2006.html
> 
> Essentially a corrupted minix dir inode reporting a very large
> i_size will loop for a very long time in minix_readdir, minix_find_entry,
> etc, because on EIO they just move on to try the next page.  This is
> under the BKL, printk-storming as well.  This can lock up the machine
> for a very long time.  Simply ratelimiting the printks gets things back
> under control.

> Index: linux-2.6.22-rc4/fs/minix/itree_v1.c
> ===================================================================
> --- linux-2.6.22-rc4.orig/fs/minix/itree_v1.c
> +++ linux-2.6.22-rc4/fs/minix/itree_v1.c
> @@ -27,7 +27,8 @@ static int block_to_path(struct inode *
>  if (block < 0) {
>  printk("minix_bmap: block<0\n");
>  } else if (block >= (minix_sb(inode->i_sb)->s_max_size/BLOCK_SIZE)) {
> -             printk("minix_bmap: block>big\n");
> +             if (printk_ratelimit())
> +                     printk("minix_bmap: block>big\n");

Warning: I'm only looking at the patch.

You are supposed to print an error message for a user, not to write in a
chat window to a 1337 script kiddie. OK, you just matched the current style,
and your patch is IMHO OK for a quick security fix, but:

- Security fixes should be CCed to the security mailing list, shouldn't they?
  (It might be security@ or stable@, I'll remember tomorrow, but then I'd
   forget to comment)
- Imagine you have three mounts containing a minix fs, how can you tell which
  one is the the defective one?
- The message says "minix_bmap", while the patch suggests it's in
  block_to_path. Therefore I asume "minix_bmap" to have only random
  informational value.
- Does block < 0 or block > $size make a difference?
- the printk lacks the loglevel.
- Asuming minix supports error handling, shouldn't it do something?

I'd suggest a message saying something like "minix: Bad block address on
device 08:15, needs fsck".
-- 
Oops. My brain just hit a bad sector. 

Friﬂ, Spammer: ei@lyUAkvOE.7eggert.dyndns.org wod@2lvjUzk.7eggert.dyndns.org
 P2DmchzHNa@7eggert.dyndns.org eOnB@utcRck.7eggert.dyndns.org
