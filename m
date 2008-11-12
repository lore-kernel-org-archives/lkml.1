Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbYKLIlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbYKLIlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 03:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYKLIlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 03:41:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:40134 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbYKLIli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 03:41:38 -0500
Message-ID: <491A96AE.3080600@kernel.org>
Date: Wed, 12 Nov 2008 17:41:18 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 12 Nov 2008 08:41:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Miklos.  Sorry about the extra long delay.  I was buried alive
under bugs and regressions with SLE11 release date nearing and all.

Miklos Szeredi wrote:
> Great.  Just yesterday evening I was looking through your patches to
> see which ones I can submit for 2.6.28, and I've already applied
> 
>   0001-FUSE-add-include-protectors.patch
>   0003-FUSE-implement-nonseekable-open.patch

Thanks.

> Comments about the others:
> 
>   0002-FUSE-pass-nonblock-flag-to-client.patch
> 
> this is not needed, f_flags are already passed to userspace for read
> and write.

Hmmm... I'll try to find out whether I can use f_flags.  There was
something that prevented it from working properly.  I'll dig.

>   0004-FUSE-implement-direct-lseek-support.patch
> 
> this is trickier to get the interface right I think.  If we want to
> allow filesystems to implement a custom lseek, then we also want them
> to keep track of the file position, which means we must differentiate
> between a write(2) and a pwrite(2) and similarly for reads.  AFAICS
> this isn't needed for CUSE so we can leave this to later.

Read/write already passes @offset, so the only thing required is an
extra flag there.  I mainly wanted a way for a CUSE server to veto lseek
with proper error and still think it's better to have this as we don't
really know what wacky users are out there.  What do you think about an
extra flag?

>   0005-FUSE-implement-ioctl-support.patch
> 
> See below.
> 
>   0006-FUSE-implement-unsolicited-notification.patch
>   0007-FUSE-implement-poll-support.patch
> 
> This would be nice, but...  I don't really like the fact that it uses
> the file handle.  Could we have a separate "poll handle" that is
> returned in the POLL reply?

Sure thing.

>> 1. I'll try to incorporate all other comments here but regarding ioctl I
>> don't think we've reached any better solution, so I'm sticking with the
>> original one.
> 
> I still got qualms about this ioctl thing.  One is the security
> aspect, but that could be dealt with.  The other is that I really
> really don't want people to start implementing new custom ioctls for
> their filesystems, as I think that way lies madness.  We could limit
> ioctls to CUSE and that would be fine with me.  Or for non-CUSE users
> we could enforce the "standard" format where the type and length is
> encoded in the command number.

For now, I'll limit ioctl to CUSE.  Hmmm... Yeah, limiting ioctl to
well-formatted ones sounds like a good idea.

> I don't have any problems with the iterative way you implemented
> ioctls.  We just need some additional restrictions to the current
> implementation, I think.

Cool.

>> 2. You told me that the version branching in the userland library wasn't
>> necessary.  Can you explain to me when FUSE version bumping is necessary?
> 
> The version number has to be bumped anyway.  But if you are only
> adding new functions to the end of fuse_operations and
> fuse_lowlevel_ops, then the interface can handle that, without needing
> new compatibility functions.

Alright.

>> 3. Any other things on you mind?
> 
> One other thing I was thinking about is that do we really need
> emulated char devices to be char devices?  What I mean is, what would
> happen if instead of a char device /dev/dsp would be a regular file
> mounted on /dev/dsp (which implements all the necessary interfaces:
> ioctls, poll, etc)?

For most it would work, I suppose, but there are all sorts of wonky
users out in the wild (and quite a few that we don't have source access
to) and different configurations, so I think it's better to appear as
proper character device if it is a character device.  It will also help
udev and other desktop thingies deal with devices implemented in userland.

Thanks.

-- 
tejun
