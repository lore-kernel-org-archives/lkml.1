Return-Path: <linux-kernel-owner+w=401wt.eu-S1760275AbXFDSlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbXFDSlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758610AbXFDSlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:41:09 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:47484 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbXFDSlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:41:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BajuxvVO4liLHI469jWdjo8ABOgC5TgWUaTKQMXYQdhogRPqfDNCbOUU1hoUmfln1Ku1hB+AtYPVOlZwQsSdTkGZ1j0Tbkj3NhtNDkNCNnCWTWZOTqfY34IFUVY/H2+/ijPXj22lTHhNn8NXUYMuN1TabR9BpCY1EXxaQkCJzl8=
Message-ID: <84144f020706041141q26d0cba2u352c294d1ec90daf@mail.gmail.com>
Date: Mon, 4 Jun 2007 21:41:07 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: [Q] Bio traversal trouble?
Cc: "Jens Axboe" <axboe@suse.de>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <4663DE68.5030200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4663DE68.5030200@gmail.com>
X-Google-Sender-Auth: 9566f62b88ae9f75
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rene,

On 6/4/07, Rene Herman <rene.herman@gmail.com> wrote:
> BUG: unable to handle kernel paging request at virtual address 8c1d2071
>  printing eip:
> c10a6d6f
> *pde = 00000000
> Oops: 0002 [#1]
> Modules linked in: mitsumi nfsd exportfs lockd sunrpc nls_cp437 msdos
> fat nls_base
> CPU:    0
> EIP:    0060:[<c10a6d6f>]    Not tainted VLI
> EFLAGS: 00010246   (2.6.21.3 #1)
> EIP is at ioread8_rep+0x20/0x31

[snip]

On 6/4/07, Rene Herman <rene.herman@gmail.com> wrote:
> Code: 00 00 89 c8 ef c3 0f c9 89 0a c3 57 3d ff ff 03 00 53 89 d7 89 c3
> 89 ca 77 15 66 31 c0 3d 00 00 01 00 74 04 0f 0b eb fe 0f b7 d3 <f3> 6c
> eb 0a 4a 78 07 8a 03 88 07 47 eb f6 5b 5f c3 57 3d ff ff
> EIP: [<c10a6d6f>] ioread8_rep+0x20/0x31 SS:ESP 0068:c3145aec

So this is the repz/insb instruction (f3 6c) in ioread8_rep() which it
reads ECX bytes from port EDX and stores the data in ES:[EDI].

Looking at the registers and stack:

On 6/4/07, Rene Herman <rene.herman@gmail.com> wrote:
> eax: 00010000   ebx: 00010300   ecx: 00000800   edx: 00000300
> esi: c3145b30   edi: 8c1d2071   ebp: 8c1d2071   esp: c3145aec
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process dd (pid: 1770, ti=c3145000 task=c3114110 task.ti=c3145000)
> Stack: 00000000 c3a7ad48 c486504d c4865ab7 00000006 50020034 c1015f7b
> 00000292
>        00000000 00520300 00000100 0007e000 00000000 c3340300 c10a0531
> 00000000
>        c12adf60 00000000 00000001 00000000 00000000 00000000 dead4ead
> ffffffff

We can see that we're reading 2048 bytes from port 0x300 and storing
the data in memory location 0x8c1d2071 which causes the OOPS. What's
surprising is that EBP is set to 0x8c1d2071 too which suggests stack
corruption (note that ioread8_rep() is a fastcall so it does not
create a stack frame of its own). What you could do here is add some
printks and watch how dst changes over time to see if you can figure
out a pattern.

Also, assuming CFQ fiddles with the request after we've done
elv_next_request() and dropped the lock, one thing worth trying is to
do blk_stop_queue() before we drop it and blk_start_queue after we
reacquire it so that we don't actually get any new I/O while we wait
for mitsumi_get_frame() to finish.

				Pekka
