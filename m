Return-Path: <linux-kernel-owner+w=401wt.eu-S934079AbXGLTqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934079AbXGLTqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 15:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932314AbXGLTqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 15:46:40 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:51736 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761213AbXGLTqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 15:46:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GQ/OZZh1CSZhWxPNBy+OzBn5/mVH9v3Qcm+wWOl/li3klqDRTfna4sO7OeQWhiJ68lBbdgaUKl0LCzQj5Gh3zNjuuLUOerLtZRmkQDoAiESXedA396YeKBRAo1a8S4NOmYke54uoNXkTfyCrkJdSeGdC21DWePgzGfxnFe60F0s=
Message-ID: <a781481a0707121246tc1b62d1qe80db8422e6e26a3@mail.gmail.com>
Date: Fri, 13 Jul 2007 01:16:35 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH 24/61] sysfs: make sysfs_put() ignore NULL sd
Cc: "=?BIG5?B?WU9TSElGVUpJIEhpZGVha2kgLyCmTsPDrV6p+g==?=" 
	<yoshfuji@linux-ipv6.org>,
       gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <46959958.6080005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11841968512510-git-send-email-gregkh@suse.de>
	 <20070712.085047.37780825.yoshfuji@linux-ipv6.org>
	 <20070711235529.GA7485@suse.de>
	 <20070712.100617.14203407.yoshfuji@linux-ipv6.org>
	 <46959958.6080005@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> >>>> Make sysfs_put() ignore NULL sd instead of oopsing.
> >>> I do not think this is a good idea; it is non-sense (and rather a bug)
> >>> to call "put" with NULL argument in general.
> >> It's better than having to check it all the time in the caller :)
> >
> > How many callers do we have that will get benefit from this change?
> >
> > Well, the change will hide the bug. It seems all callers in fs/sysfs
> > already assume that the argument is NOT NULL, and it is a bug to call
> > sysfs_put() with NULL; the function should be used to "put" something
> > you "have" (non-NULL). If it is called with NULL, I would say, we
> > should BUG here to detect the logical bug.

Yoshifuji is 100% correct, IMNSHO.

Please, this is _basic_ refcounting semantics. For those who disagree,
kindly read Yoshifuji's above paragraph again.

> Well, I'm okay either way.  It's not like one way is undisputably better
> than the other

Yes, it is, of course. Allowing xxx_put(NULL) to succeed (without any
warnings/oops) is *absolutely* nonsensical, and can *only* occur if the
caller (or worse, the API itself) is buggy in the first place (i.e. does not
use proper locking and/or refcounting).

I can't believe it should be so difficult to understand this. How can any
caller (that first did a xxx_get() on that shared object) land up with that
object getting NULL _from under it_ unless some logic is wrong
somewhere? And instead of flagging this broken logic, the proposed
change here would hide it.

Worse, if that object did become NULL between the _get() and _put()
code, then we'll have an oops (which would be even more difficult to
debug now) anyway.

> but we're leaning toward accepting NULL argument in this
> type of functions.  Think about kfree(NULL) and its usefulness.

Don't {mis}quote the kfree() mistake here, please.

> More
> importantly, the ecosystem around sysfs - that is, kobject, driver model
> - generally accepts NULL argument for their get/put functions

This can only mean two things:

(1) Either, they simply do not _need_ the refcounting in the first place
(which means -- better do away with get() and put() for them altogether)

(2) Or, all that code / APIs are so horribly misdesigned and/or buggy that
you're now having to hide that by allowing NULL arguments in get() and
put() functions (which means -- fix the bugs, please)

> so unless
> there's a compelling reason to convert them all, and I don't see any,
> sysfs_put() needs to follow the same rule.

Ok, what's the compelling reason to change sysfs_put() then?
I don't see any, either.

Satyam
