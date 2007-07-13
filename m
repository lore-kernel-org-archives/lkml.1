Return-Path: <linux-kernel-owner+w=401wt.eu-S1759669AbXGMR2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759669AbXGMR2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 13:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbXGMR2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 13:28:06 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:59572 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbXGMR2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 13:28:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ADLf6V3VFVgP3EARy3yxX3KaIthULLlzAPM3465chluVbPVJtrkxGRWXSKnVPHEKwNsFszTjTPBMUVDnrvlq624UDqsqD1MVjj5SDJBZxaQ4fnMnkqGCUccxqB1NtZjsDe6teNrXKkPWWaGK2TM0lD+20535UotATSHdLYl4lvA=
Message-ID: <a781481a0707131028m36bf9e1eka20b783b5f350ae3@mail.gmail.com>
Date: Fri, 13 Jul 2007 22:58:02 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH 24/61] sysfs: make sysfs_put() ignore NULL sd
Cc: "YOSHIFUJI Hideaki" <yoshfuji@linux-ipv6.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <4697078D.4050601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11841968512510-git-send-email-gregkh@suse.de>
	 <20070712.085047.37780825.yoshfuji@linux-ipv6.org>
	 <20070711235529.GA7485@suse.de>
	 <20070712.100617.14203407.yoshfuji@linux-ipv6.org>
	 <46959958.6080005@gmail.com>
	 <a781481a0707121246tc1b62d1qe80db8422e6e26a3@mail.gmail.com>
	 <4696FDDC.7050503@gmail.com> <4697078D.4050601@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for explaining the purpose behind the proposed change,
but I'm still not convinced that allowing NULL argument in _put()
is a good idea, however:

On 7/13/07, Tejun Heo <htejun@gmail.com> wrote:
> Satyam Sharma wrote:
> > Please, this is _basic_ refcounting semantics. For those who disagree,
> > kindly read Yoshifuji's above paragraph again.
>
> I did but I don't really see anything so basic about refcounting
> semantics there.
> [...]
> > Ok, what's the compelling reason to change sysfs_put() then?
> > I don't see any, either.
>
> Because mixed situation is undisputably worse than one way or the other
> && making sysfs_put() to conform to its surroundings is the shortest
> path to achieve uniformity.  Gees, what's so important about allowing or
> not allowing NULL?

The whole _purpose_ of get()/put() functions (i.e. refcounting in general)
is to ensure that the (shared) objects don't go away from under us while
we're holding them. The proposed change _weakens_ the API itself by
allowing a buggy driver (that somehow called into _put() codepath without
a _get() before it) to not get flagged immediately (through an oops). This
inevitably leads to some difficult-to-debug problems -- I have suffered
debugging issues created by such weak/loose APIs myself.

> >> but we're leaning toward accepting NULL argument in this
> >> type of functions.  Think about kfree(NULL) and its usefulness.
> >
> > Don't {mis}quote the kfree() mistake here, please.
>
> Like it or not, kfree(NULL) is used the same way.

But we pay a heavy price for the "programmer convenience" (just
avoiding some conditionals / multiple goto labels in error cleanup
paths) that we get in return. I do believe the kernel would've been
much less buggy, if only kfree(NULL) wasn't legal.

But even if you do want to allow NULL arguments to such functions,
for certain situations, you could always write a little wrapper over
the lower function that'll include the "if (not NULL)" kind of check.

> >> More
> >> importantly, the ecosystem around sysfs - that is, kobject, driver model
> >> - generally accepts NULL argument for their get/put functions
> >
> > This can only mean two things:
> >
> > (1) Either, they simply do not _need_ the refcounting in the first place
> > (which means -- better do away with get() and put() for them altogether)
>
> I don't really see how you can jump there from allowing NULL argument.
> Your conclusion is really far from the origin.
> [...]
> NULL put is usually used to simplify error handling / cleanup codes.

I'd be gladder if you could point me to code where this change really helps.
I'd definitely like to send patches, why not.

On 7/13/07, Tejun Heo <htejun@gmail.com> wrote:
> >> I can't believe it should be so difficult to understand this. How can any
> >> caller (that first did a xxx_get() on that shared object) land up with that
> >> object getting NULL _from under it_ unless some logic is wrong
> >> somewhere? And instead of flagging this broken logic, the proposed
> >> change here would hide it.
>
> I agree with you about get().  Allowing NULL argument doesn't really
> help anything.  It only increases the chance of getting things wrong.
> I'm all for not allowing NULL argument to get().  For put(), as I wrote
> before, I think allowing NULL has some advantages and I don't care
> either way as long as it's not confusing.  The 'not confusing' part is
> way more important to me than advantages of either way.

As I said, changing generic refcounting API functions (which is what
xxx_put() is) to simplify open-coding of a conditional in the caller's
error cleanup paths does not sound advantageous to me at all. On the
contrary, it weakens the refcounting API, and I can only imagine the
kernel getting buggier with such changes.

Satyam
