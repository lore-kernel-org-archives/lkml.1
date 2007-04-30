Return-Path: <linux-kernel-owner+w=401wt.eu-S1423375AbXD3XKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423375AbXD3XKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 19:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423392AbXD3XKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 19:10:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:3479 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423387AbXD3XKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 19:10:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R7ujBcCABWj4bO2SmCtIfKf92UFQzav858NYz+Se8EJr8Lshkm5mGIY13xDmG7hYEx+Y3nxPDaG803g9adsW+DJU3tWM3DsssOF0ptNizqeE012K51BXFRZ9njvVDlCnfbDDueBCUASlFmlCdZC/PrIPKh257N+M6XO2KaNrd1A=
Message-ID: <21d7e9970704301610u5d5132uc282ac697c9df2be@mail.gmail.com>
Date: Tue, 1 May 2007 09:10:00 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [RFC] [PATCH] DRM TTM Memory Manager patch
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Thomas Hellstr?m" <thomas@tungstengraphics.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Eric Anholt" <eric@anholt.net>
In-Reply-To: <20070427163951.GA12216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21d7e9970704252355m4765b65fyb547b9ba2763b103@mail.gmail.com>
	 <20070427163951.GA12216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> A few easy and simple comments based on looking at this for 5 minutes:
>   - drop the typedefs.  Yeah, they might be a drm thing, but we don't
>     need them here.

Okay I think in-kernel typedefs have to go, but we have a defined DRM
interface like it or not and I'd like to be consistent on the
userspace interface and continue to use typedefs, I don't want to have
a major inconsistency like half the interface in typedefs the other
half in non-typedefs, considering the old interface is frozen...

>   - the comment style for the functions is "odd" and not in kerneldoc
>     form, but something else.  Either use kerneldoc or nothing, don't
>     invent something new please.

Most likely in doxygen as that is what Mesa uses and the intersection
of developers is higher in that area, I'll take it as a task to try
and kerneldoc the drm at some stage..

>   - what's with the /proc interface?  Don't add new proc code for
>     non-process related things.  This should all go into sysfs
>     somewhere.  And yes, I know /proc/dri/ is there today, but don't add
>     new stuff please.

Well we should move all that stuff to sysfs, but we have all the
infrastructure for publishing this stuff under /proc/dri and adding
new files doesn't take a major amount, as much as I appreciate sysfs,
it isn't suitable for this sort of information dump, the whole one
value per file is quite useless to provide this sort of information
which is uni-directional for users to send to us for debugging without
have to install some special tool to join all the values into one
place.. and I don't think drmfs is the answer either... or maybe it
is....

>   - struct drm_bo_arg can't use an int or unsigned, as it crosses the
>     userspace/kernelspace boundry, use the proper types for all values
>     in those types of structures (__u32, etc.)

int is defined, unsigned I'm not so sure about, the drm user space
interface is usually specified in non-system specific types so the
drm.h file is consistent across systems, so we would probably have to
use uint32_t which other people have objected to, but I'd rather use
uint32_t than unspecified types..

>   - there doesn't seem to be any validity checking for the arguments
>     passed into this new ioctl.  Possibly that's just the way the rest
>     of the dri interface is, which is scary, but with the memory stuff,
>     you really should check things properly...

Okay this needs fixing, we do check most ioctls args, the main thing
passed in are handles and these are all looked up in the hash table,
it may not be so obvious, also most of the ioctls are probably going
to end up root or DRM master only, I'd like do an ioctl fuzzer at some
stage, I'd suspect a lot more then the dri would be oopsable with
permissions...

Thanks,
Dave.
