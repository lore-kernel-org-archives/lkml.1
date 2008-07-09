Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbYGIVEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbYGIVEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbYGIVEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:04:34 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:50775 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbYGIVEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:04:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mt6d/zxBrFF6WG28gPnrchpRSwDkz7gXgTnye3ZVGa3ya3Ddy7ma8Ry+sUsCxJwzGj
         02ojk/JNpdh0c5VZMnYvJLcO2WFHBN4lHjVz42hWxHmbMALLXlC1ZOHkbMUwwFXccRFo
         7tBknTShQClluX6UNDfg1cKHEVUIpw8wEwFNw=
Message-ID: <c56f29cb0807091404u29acc1d7nd24071c74f33e060@mail.gmail.com>
Date: Wed, 9 Jul 2008 23:04:28 +0200
From: "Jan Willem van den Brand" <janwillem.dev@googlemail.com>
To: "Theodore Tso" <tytso@mit.edu>,
       "Jan Willem van den Brand" <janwillem.dev@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] ext3/jbd, kernel 2.6.13, make ext3 mountable as ext2 when journal is empty.
In-Reply-To: <20080709162715.GC11797@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c56f29cb0807090821x74d0652ekc3ae4bb5725df76c@mail.gmail.com>
	 <c56f29cb0807090824k727b0da7se1a019394cdbeea7@mail.gmail.com>
	 <20080709162715.GC11797@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your reply!

On 7/9/08, Theodore Tso <tytso@mit.edu> wrote:
> On Wed, Jul 09, 2008 at 05:24:25PM +0200, Jan Willem van den Brand wrote:
>  > This patch makes ext3 mountable as ext2 even in case of a power
>  > failure while mounted as ext3. We have tested it for kernel 2.6.13 but
>  > it should be fairly easy to get it to work for other versions.
>
>
> What's the rationale for doing this.  Why is it *useful* to have the
>  filesystem be mountable as ext2 in case of a power failure?  The whole
>  point of ext3 is to be able to keep the filesystem consistent in case
>  of a power failure.
>
>  So the patch as given would never go into the kernel as-is, and in the
>  general case it is totally counterproductive.  Maybe it could go in as
>  a optional behaviour enabled by a mount option, but that's assuming we
>  can be convinced it's a good idea.

First of all, I totally agree that this should never be default. The
patch is usefull for us because the SD-card with ext3 file system is
(possibly unsafely) pulled out of our TomTom device (which is built
into a car) and then inserted in a Windows PC which only supports
ext2. We are also considering ext3 on Windows or running e2fsck to
replay the journal and then continue as ext2. But for now we are
accessing the file system as ext2.

>  > In case of a power failure, the INCOMPAT flag is not reset. Systems
>  > that suffer from frequent power failure (e.g. SD-cards that are
>  > unsafely removed) will often not be mountable as ext2.
>
>
> So what?  Why can't you just run the journal and check the filesystem
>  for consistency?  If the user did a hot-eject while the SD-card was
>  being written, even with your patch there is no guarantee that the
>  card will even be readable.  Some SD-cards go totally non-functional
>  due to corruption at the flash translation layer when they are yanked
>  in the middle of an update....

To run the journal, a user has to go from his PC to his car which is
kind of hard to explain. We are aware of the fact that there are many
SD-cards that can get corrupted due to power failure. We are only
using SD-cards that do not exhibit this problem. So on the embedded
device we have both the SD-card and the file system power fail
safeness covered. The solution passes extensive power fail safe
testing.

>  > Obviously, this solution will result in poor performance when many
>  > small files are frequently closed after write but that is not the case
>  > in our system (TomTom navigation device).
>
>
> How often does your TomTom device need to update files?  A better
>  (userspace-only) solution might be keep the filesystem mounted
>  read-only, and when you need to write to the filesystem, turn on the
>  LED (which hopefully will be a hint to the users to keep their grubby
>  little paws off the eject button), remount it read/write, do your file
>  writes, then remount it read/only, and turn off the LED.

The amount of writing is indeed limited. We actually considered
unmounting and then mounting again but dropped that idea because we do
not want to close files that are opened for reading. I thought that
remounting ro did not flush the journal and reset the INCOMPAT_RECOVER
flag. I will experiment with remounting, thanks!

Best regards,

Jan Willem
