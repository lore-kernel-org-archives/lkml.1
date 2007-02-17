Return-Path: <linux-kernel-owner+w=401wt.eu-S1030215AbXBQRxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030215AbXBQRxM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030220AbXBQRxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:53:12 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:53252 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030215AbXBQRxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:53:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LJMj8nUSTVpXS+s9lJi4uUGWxnsQR71KLiCgUcNZgYi9laMxe6HqqbijwCPGM2zYp7jThSSDVZLCAJqJsq8DqrEW3ELPAimnXamQZm74DjLlhbqd9svSpXCWEWFZL84AhKjFjdZ+6AdYVIONY/EkYTVjq0jBn4jDJ86/iqSyQjQ=
Message-ID: <f56c1ba00702170953l5dd4ea75ga2ae1e6d069e9f7@mail.gmail.com>
Date: Sat, 17 Feb 2007 18:53:09 +0100
From: "=?ISO-8859-1?Q?C=E9dric_Augonnet?=" <cedric.augonnet@gmail.com>
To: "=?ISO-8859-1?Q?Daniel_Aragon=E9s?=" <danarag@gmail.com>
Subject: Re: 2.6.20-mm1 - Oops using Minix 3 file system
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Cedric.augonnet@ens-lyon.org
In-Reply-To: <edd3ff190702170844q120c5f92l6c7c385665048c16@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <f56c1ba00702161500x775fe04bl91889b5819cf9ddc@mail.gmail.com>
	 <edd3ff190702170255w1c30fa08v96e5b92baacbd701@mail.gmail.com>
	 <f56c1ba00702170551k7cbbf79dkfc550e3d4b387d4c@mail.gmail.com>
	 <edd3ff190702170844q120c5f92l6c7c385665048c16@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/2/17, Daniel Aragonés <danarag@gmail.com>:
> On 2/17/07, Cédric Augonnet <cedric.augonnet@gmail.com> wrote:
>
> > It appears that the trouble is in  the count_free of file
> > fs/minix/bitmap.c . This procedure is actually called twice when we
> > issue a df command.
> > The point where things start to get strange is
> >         i = ((numbits - (numblocks-1) * bh->b_size * 8) / 16) * 2; at line 36
> >
> > In the first call to that procedure i have
> >        i = 3506
> >        bh->b_data = 0xd4e79000
> >
> > Whereas in the second call i have something much different :
> >        i = 536838736
> >        bh->b_data = d4e78000
> >

More precisely, i traced how we call the count_free procedure : it is
once called by minix_count_free_blocks (and succeeds) and then by
minix_count_free_inodes and fails.

For the first call, which does not fail :
   minix_count_free_blocks(0xd4105240)
       sbi->s_zmap_blocks = 0x00000010
       sbi->s_nzones = 0x00080000
       sbi->s_firstdatazone = 0x00001266
       (sbi->s_nzones - sbi->s_firstdatazone + 1) = 0x0007ed9b

  count_free( ...., 0x00000010, 0x0007ed9b)
        unsigned numblocks = 0x00000010 = 16
        __u32 numbits =0x0007ed9b = 519579
        bh->b_size = 0x00001000 = 4096
== > i = 3506
This is consistent with the formula



For the second call
   minix_count_free_inodes(0xd4105240)
       sbi->s_imap_blocks = 0x0000000a
       sbi->s_ninodes = 0x00009280

   count_free(..., 0x0000000a, 0x00009281)
        unsigned numblocks = 0x0000000a  = 10
        __u32 numbits = 0x00009281 = 37505
        bh->b_size =0x00001000 = 4096
==> i = 536838736

(gdb) p/x (( 0x00009281 - (0x00a-1) * 0x1000 * 8) / 16) * 2
$20 = 0xffff8252
$21 = -32174

(Very sorry for than mess !)

>
> Well, that line is modified by my patch. The original one is:
> i = ((numbits-(numblocks-1)*BLOCK_SIZE*8)/16)*2;
>
> As you see, the constant is substituted by a variable. As you are
> running under emulation, the true value of that variable ( 4096 in
> standard minix3 releases, instead of the constant 1024 in minix1 and
> minix2), is probably found where it should not be found, or not found
> at all. And the result is what you show. Minix 3 provides for a
> variable size of the blocks. Try to find what block size you are
> emulating.
>
> Also, though your dmesg shows a mounted loop partition, the minix
> subpartition in it is not stated. So it cannot be accessed.

Well i actually do access to this partition, i can edit it and use it,
this on Linux. Sorry if this is not clear.

> By the way, you don't need to support minix on your Linux box to run
> it through an emulator, do you?

Actually i am running a full Minix OS in the qemu emulator and all
Linux does is providing me some disk images.

To make it more clear, i created a disk image file on Linux.  I
created a FS on that partition in Minix using mkfs inside qemu running
Minix. And then i just want to mount this partition to have access to
this filesystem on my Linux. This is ugly for sure, but it should
still not be oopsing.

>
> Regards
>
> Daniel
>

I thought you could be interested in having the actual image doing all
these nasty things :
      http://perso.ens-lyon.fr/cedric.augonnet/Linux/br.tar
      tar -xvf br.tar   should produce some br.img file that you can
mount using
      mount -o loop -t minix br.img /mnt/foo
      df -h should there be issuing the oops.

      Please remark that all the files inside this image were created
with Linux, not Minix, the _only_ thing done with minix and qemu was
to create the file system on the image.

Hoping this will be a bit useful,
Regards,
Cédric
