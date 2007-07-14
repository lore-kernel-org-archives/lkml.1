Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbXGNE13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbXGNE13 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 00:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbXGNE1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 00:27:22 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:37232 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbXGNE1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 00:27:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uLSjDINmZuo3kqq2AakhOjkTZlIzZSu1rIKb1xCelo7x0RayKLqRB309YXS4xx/du5DSsmWx4CdgOzTQMho6BIQX4IsxYFEYWJHmcPIOUE3PO9nfX1+RV0xe02DIxBU/HJiLKh8311RQDFt/fOH62uCIyduQc9nycYCN08N4KuY=
Message-ID: <a781481a0707132127h31b3c241wbb1a087bf469c006@mail.gmail.com>
Date: Sat, 14 Jul 2007 09:57:17 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH 24/61] sysfs: make sysfs_put() ignore NULL sd
Cc: "YOSHIFUJI Hideaki" <yoshfuji@linux-ipv6.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <46983C76.1040406@gmail.com>
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
	 <a781481a0707131028m36bf9e1eka20b783b5f350ae3@mail.gmail.com>
	 <46983C76.1040406@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 7/14/07, Tejun Heo <htejun@gmail.com> wrote:
> Hello,
>
> Satyam Sharma wrote:
> > The whole _purpose_ of get()/put() functions (i.e. refcounting in general)
> > is to ensure that the (shared) objects don't go away from under us while
> > we're holding them. The proposed change _weakens_ the API itself by
> > allowing a buggy driver (that somehow called into _put() codepath without
> > a _get() before it) to not get flagged immediately (through an oops). This
> > inevitably leads to some difficult-to-debug problems -- I have suffered
> > debugging issues created by such weak/loose APIs myself.
>
> Yeah, that's the advantage of not allowing NULL, well, or disadvantage
> of allowing.  I get that.  If I were to reimplement all these functions,
> I probably wouldn't allow NULL argument myself either.

Good, at least we're on the same plane here :-)

> As much as I
> understand your POV, I just don't think it's as critical as maintaining
> uniformity.
> [...] if you make things confusing by allowing on some but not
> allowing on others, it's much more likely to trigger programmer error.
> [...] The advantages or disadvantages are really small
> compared to the confusion overhead.

Well, I don't really buy the uniformity/confusion argument either:

fput() will oops on NULL file *
put_super() will oops on NULL super_block *
put_task_struct() will oops on NULL task_struct *
mmput() will oops on NULL mm_struct *
configfs_put() will oops on NULL configfs_dirent *
kref_put() will oops on NULL kref * (and this one better do)
dev_put() will oops on NULL net_device *
put_driver() will oops on NULL device_driver *

and sysfs_put() also oopsed on NULL sysfs_dirent *,
till you changed it not to, that is :-)

[ and there are other examples, of course ]

I think put()'s *must* oops on NULL arguments -- it's simply a matter
of writing a good, strict, (I could add "tasteful" but that would make it
subjective) API that will *prevent* mysterious bugs.

Of course, dput(), kobject_put() and put_device() are a few counter
examples that allowing put-ing NULL objects, but it's not as if this
_disease_ has become widespread enough throughout the kernel --
that is, till we _make_ it widespread by following the lead of *mistakes*.

[ Perhaps you don't really care for the examples I mentioned above
because sysfs is "closer" in some sense to kobjects / devices and
so because those allow put-ing NULL objects, you want to make
sysfs "uniform" to them in that sense ... but that's a bad excuse. ]

> > I'd be gladder if you could point me to code where this change really
> > helps.
> > I'd definitely like to send patches, why not.
>
> It's added by later patches.  The patch itself is created because I was
> hit by the confusion.  sysfs_get() allowed NULL argument but sysfs_put()
> didn't.  Where's sense in that?  I thought about converting sysfs_get()
> to not accepting NULL but then the whole kobject and friends would act
> differently.
>
> For sysfs, changing behavior is okay.  It's mostly self-contained
> subsystem and sysfs_get/put() aren't even exported to outside world, but
> kobject and driver model are different story.  Changing such subtle
> behavior of such widely used interface is bound to create a lot of
> confusion.

Well, what I'm asking here is not to change the mistakes already
made (it's probably too late for that), but to avoid *repeating* them.

> Think about what would happen if NULL is suddenly disallowed on kfree().
>  Even if all the current in-kernel users are converted at once (I'm sure
> we're gonna miss some tho), all the out of tree (including devel) codes
> and future codes will suffer and some of the bugs would be really hard
> to catch as kfree(NULL) is buried in error handling path which generally
> isn't triggered too often.

kfree(NULL) is not exactly analogous. And obviously I don't intend
changing that and then trying to change the 6,732,893 or so callsites
that assume the same :-) But what if everybody starts taking this lead
and starts {re}writing APIs accordingly throughout the kernel ...
*shudder to think*

Anyway, we've wasted enough time and bandwidth discussing this
(relatively trivial) matter, and I know nobody's mind is changed after
the end of it all (at least mine won't), so I suggest let's stop. The
proposed change is in Greg's tree already, and if he's fine with it,
then there's not much to do about it, is there :-)

Satyam
