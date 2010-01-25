Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855Ab0AYQQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab0AYQQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 11:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226Ab0AYQP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 11:15:59 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:45928 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab0AYQP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 11:15:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UezCRY0jFQPXzR7e3ygGAohCBYLRtE+jnADTIWjARB2IMjx2alij93/rLsvEGX7JFM
         Gxhvyumq5X1QTaktPYNmzW60Umbb5VP1OHip3Tvph8U9+u6lHvEEqI8m2foYzqsXV59b
         W6NCdvs3TNjf0BohxXjv4tIzgKx48kKJDRK0Q=
MIME-Version: 1.0
In-Reply-To: <4B5DB78D.2090408@redhat.com>
References: <4B4EB5B9.4020809@hitachi.com> <4B4EDE5C.8040600@hitachi.com>
	 <4B4EEE86.7080807@hitachi.com> <20100114141803.GB3146@quack.suse.cz>
	 <20100118051847.GA8678@laptop> <20100118060518.GA9151@laptop>
	 <20100118122437.GF7264@discord.disaster>
	 <20100118140039.GA13909@laptop>
	 <D65C918F-8CCD-4626-BA84-FD0410A5E81F@cam.ac.uk>
	 <4B5DB78D.2090408@redhat.com>
Date: Mon, 25 Jan 2010 11:15:50 -0500
Message-ID: <87f94c371001250815t92cbce9t95df5c274745dae9@mail.gmail.com>
Subject: Re: IO error semantics
From: Greg Freemyer <greg.freemyer@gmail.com>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>, Nick Piggin <npiggin@suse.de>,
       Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andreas Dilger <adilger@sun.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 10:23 AM, Ric Wheeler <rwheeler@redhat.com> wrote:
> On 01/18/2010 06:33 PM, Anton Altaparmakov wrote:
>>
>> Hi,
>>
>> On 18 Jan 2010, at 14:00, Nick Piggin wrote:
>>
>>>
>>> For write errors, you could also do block re-allocation, which would be
>>> fun.
>>>
>>
>> Yes it would.  (-:
>>
>> FWIW, Windows does this with Microsoft's NTFS driver.  When a write fails
>> due to a bad block, the block is marked as bad (recorded in the bad cluster
>> list and marked as allocated in the in-use bitmap so no-one tries to
>> allocate it), a new block is allocated, inode metadata is updated to reflect
>> the change in the logical to physical block map of the file the block
>> belongs to, and the write is then re-tried to its new location.
>>
>> I have never bothered implementing it in NTFS on Linux partially because
>> there doesn't seem any obvious way to do it inside the file system.  I think
>> the VFS and/or the block layer would have to offer help there in some way.
>>  What I mean for example is that if ->writepage fails then the failure is
>> only detected inside the asynchronous i/o completion handler at which point
>> the page is not locked any more, it is marked as being under writeback, and
>> we are in IRQ context (or something) and thus it is not easy to see how we
>> can from there get to doing all the above needed actions that require memory
>> allocations, disk i/o, etc...  I suppose a separate thread could do it where
>> we just schedule the work to be done.  But problem with that is that that
>> work later on might fail so we can't simply pretend the block was written
>> successfully yet we do not want to report an error or the upper layers would
>> pick it up even though we hopefully will correct it in due course...
>>
>> Best regards,
>>
>>        Anton
>>
>
> For permanent write errors, I would expect any modern drive to do a sector
> remapping internally. We should never need to track this kind of information
> for any modern device that I know of (S-ATA, SAS, SSD's and raid arrays
> should all handle this).
>
> Would not seem to be worth the complexity.
>
> Also keep in mind that retrying IO errors is not always a good thing -
> devices retry failed IO multiple times internally. Adding additional retry
> loops up the stack only makes our unavoidable IO error take much longer to
> hit!
>
> Ric

I thought write errors returned by modern drives (last 15 years) in
general were caused by bad cables, controllers, power supplies, etc.

When a media error is returned on write it indicated the spare sector
area of the drive was full.

Thus a media write error is a major error.  I would think, if
anything, we should turn the filesystem readonly upon a write media
error.  Not try to hide such a major problem.

Greg
