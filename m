Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab0CDPdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 10:33:55 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54333 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab0CDPdy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 10:33:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OV2eNSwYV1ls/137imC6pwFccjDKXI3EJj75/bjNmHYSHdLdJEHAs4+0aOin3e62Tk
         Lzpudw10J1F1Y6VQn4BTqf5UxKLg8LmQAbwSF+32U5UsODFj4GpAC08Mz34fjritSEER
         8afVN1ZN5Srb7AibDQGPIsVDE18Vu8O1hGhZ8=
MIME-Version: 1.0
In-Reply-To: <4B8FC6AC.4060801@teksavvy.com>
References: <f875e2fe1003032052p944f32ayfe9fe8cfbed056d4@mail.gmail.com>
	 <20100303224245.ae8d1f7a.akpm@linux-foundation.org>
	 <87f94c371003040617t4a4fcd0dt1c9fc0f50e6002c4@mail.gmail.com>
	 <4B8FC6AC.4060801@teksavvy.com>
Date: Thu, 4 Mar 2010 10:33:52 -0500
Message-ID: <f875e2fe1003040733h20d5523ex5d18b84f47fee8c7@mail.gmail.com>
Subject: Re: Linux kernel - Libata bad block error handling to user mode 
	program
From: foo saa <foosaa@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am using 4k aligned buffers for writing and reading.

Kernel / driver catches the error during the write cycle and I can get
the error messages about the media being bad or sector i/o errors. But
it is not propagated to the program and write always passes (even in
the case of the device being out of control. (i.e., the device fails
to respond to any further open / read / write queries and inaccessible
from the core). Isn't the error has to be notified to the program that
makes the call?

Reading is a completely different scenario and I am disabling the
read-ahead cache completely with fadvise call.

hdparm is good, but I don't want to use the internal ATA SECURE ERASE
because I can never get the amount of bad sectors the drive had.

On Thu, Mar 4, 2010 at 9:41 AM, Mark Lord <kernel@teksavvy.com> wrote:
> On 03/04/10 09:17, Greg Freemyer wrote:
> ..
>>
>> I think / suspect your major problem is you say above that you use a
>> 512-byte buffer to wipe with.  The kernel is using 4K pages.  So when
>> you write to a 4K section of the drive for the first time, the kernel
>> implements read-modify-write logic.
>>
>> Your i/o failures are almost certainly on the read cycle of the above,
>> not the write cycle.  You need to move to 4K buffers and you need to
>> ensure your 4K writes are aligned with how the kernel is working with
>> the disk.  ie. You need your 4K buffer to perfectly align with the
>> kernels 4K block handling so you never have a read-modify-write cycle.
>
> ..
>
> You'll also need to disable Linux read-ahead for the drive,
> or it may try reading beyond even the 4KB block.
>
> But really.. isn't "hdparm --security-erase NULL /dev/sdX" good enough ???
>
> Cheers
>
