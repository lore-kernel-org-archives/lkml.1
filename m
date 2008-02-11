Return-Path: <linux-kernel-owner+w=401wt.eu-S1759343AbYBKTOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbYBKTOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbYBKTO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:14:27 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:1887 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbYBKTO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:14:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=P7nTbEt1IXEn/lQiQwiPpS538Y7FSnPBHtuu+jpnT7nUuUhBhCQQnePFaKjqj08cgIeDk7/XWbvNcmq2JCPBGEb94m6gz3AbdVA7s5VCV0o2KBY2jd1frmzpqO6gTR2hnrgr53gwV4V15vN6IZAwhx8vf3fO0GhuBf/xLiQjtrg=
Date: Mon, 11 Feb 2008 20:13:20 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: udf regression: broken directory handling
Message-ID: <20080211191313.GA12375@joi>
References: <20080210104754.GH6737@joi> <20080211110910.GB9622@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211110910.GB9622@duck.suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 12:09:10PM +0100, Jan Kara wrote:
>   Hi,
> 
> On Sun 10-02-08 11:48:17, Marcin Slusarz wrote:
> > Current mainline has a problem with reading file list.
> > Simple ls prints only 2 out of 8 files on my testing DVD.
> > Reverting your patch "udf: cleanup directory offset handling"
> > (af793295bf9ee92660f5e77d337b0493cea3f9b9) fixes the problem.
>   Thanks for testing! Do you have a way to create such UDF filesystem? For
> the filesystems I've created it seems to work just fine...

with patch applied:
joi tmp # dd if=/dev/zero of=./test.udf count=102400
102400+0 records in
102400+0 records out
52428800 bytes (52 MB) copied, 1.08618 s, 48.3 MB/s
joi tmp # mkudffs ./test.udf
start=0, blocks=16, type=RESERVED
start=16, blocks=3, type=VRS
start=19, blocks=237, type=USPACE
start=256, blocks=1, type=ANCHOR
start=257, blocks=16, type=PVDS
start=273, blocks=1, type=LVID
start=274, blocks=25069, type=PSPACE
start=25343, blocks=1, type=ANCHOR
start=25344, blocks=239, type=USPACE
start=25583, blocks=16, type=RVDS
start=25599, blocks=1, type=ANCHOR
joi tmp # mount -t udf -o loop ./test.udf ./udf/
joi tmp # cd udf/
joi udf # ls -l
total 0
joi udf # touch q w e r t y u i o p
joi udf # ls -l
total 0
drwxr-xr-x 2 root root 40 Feb 11 19:03 lost+found
-rw-r--r-- 1 root root  0 Feb 11 20:03 q
joi udf # cd ../
joi tmp # umount udf/
joi tmp # #(reverting patch)
joi tmp # rmmod udf
joi tmp # rm test.udf
joi tmp # dd if=/dev/zero of=./test.udf count=102400
102400+0 records in
102400+0 records out
52428800 bytes (52 MB) copied, 1.0559 s, 49.7 MB/s
joi tmp # mkudffs ./test.udf
start=0, blocks=16, type=RESERVED
start=16, blocks=3, type=VRS
start=19, blocks=237, type=USPACE
start=256, blocks=1, type=ANCHOR
start=257, blocks=16, type=PVDS
start=273, blocks=1, type=LVID
start=274, blocks=25069, type=PSPACE
start=25343, blocks=1, type=ANCHOR
start=25344, blocks=239, type=USPACE
start=25583, blocks=16, type=RVDS
start=25599, blocks=1, type=ANCHOR
joi tmp # mount -t udf -o loop ./test.udf ./udf/
joi tmp # cd udf/
joi udf # touch q w e r t y u i o p
joi udf # ls -l
total 0
-rw-r--r-- 1 root root  0 Feb 11 20:06 e
-rw-r--r-- 1 root root  0 Feb 11 20:06 i
drwxr-xr-x 2 root root 40 Feb 11 19:05 lost+found
-rw-r--r-- 1 root root  0 Feb 11 20:06 o
-rw-r--r-- 1 root root  0 Feb 11 20:06 p
-rw-r--r-- 1 root root  0 Feb 11 20:06 q
-rw-r--r-- 1 root root  0 Feb 11 20:06 r
-rw-r--r-- 1 root root  0 Feb 11 20:06 t
-rw-r--r-- 1 root root  0 Feb 11 20:06 u
-rw-r--r-- 1 root root  0 Feb 11 20:06 w
-rw-r--r-- 1 root root  0 Feb 11 20:06 y
joi udf # cd ../
joi tmp # umount udf/
joi tmp # #(applying patch again)
joi tmp # rmmod udf
joi tmp # mount -t udf -o loop ./test.udf ./udf/
joi tmp # ls -l udf/
total 0
drwxr-xr-x 2 root root 40 Feb 11 19:05 lost+found
-rw-r--r-- 1 root root  0 Feb 11 20:06 q
joi tmp #
