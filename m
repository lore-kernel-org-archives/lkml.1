Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbXGMEWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbXGMEWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 00:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbXGMEVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 00:21:54 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:5771 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbXGMEVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 00:21:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=QRb9fy3jbfBwZZzM4K+ezTTskNHZed7ED0jPDGdxV3oazUcVIjorGp3wRdwnuwZgkOYs7p5mvQ1bdGqy1MIvRAU+Du6RO9B/2d59gzhRV/71yzEcGZDcPE2QOzSdnX13o0TWQyENJnngxtd/BzzyJO6TpLkkIhT4xyuTt9Gl2cM=
Message-ID: <4696FDDC.7050503@gmail.com>
Date: Fri, 13 Jul 2007 13:21:48 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: =?ISO-8859-1?Q?YOSHIFUJI_Hideaki_/_=3F=3F=3F=3F?= 
	<yoshfuji@linux-ipv6.org>,
       gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 24/61] sysfs: make sysfs_put() ignore NULL sd
References: <11841968512510-git-send-email-gregkh@suse.de>	 <20070712.085047.37780825.yoshfuji@linux-ipv6.org>	 <20070711235529.GA7485@suse.de>	 <20070712.100617.14203407.yoshfuji@linux-ipv6.org>	 <46959958.6080005@gmail.com> <a781481a0707121246tc1b62d1qe80db8422e6e26a3@mail.gmail.com>
In-Reply-To: <a781481a0707121246tc1b62d1qe80db8422e6e26a3@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Satyam Sharma wrote:
> Yoshifuji is 100% correct, IMNSHO.
> 
> Please, this is _basic_ refcounting semantics. For those who disagree,
> kindly read Yoshifuji's above paragraph again.

I did but I don't really see anything so basic about refcounting
semantics there.

>> Well, I'm okay either way.  It's not like one way is undisputably better
>> than the other
> 
> Yes, it is, of course. Allowing xxx_put(NULL) to succeed (without any
> warnings/oops) is *absolutely* nonsensical, and can *only* occur if the
> caller (or worse, the API itself) is buggy in the first place (i.e. does
> not
> use proper locking and/or refcounting).
> 
> I can't believe it should be so difficult to understand this. How can any
> caller (that first did a xxx_get() on that shared object) land up with that
> object getting NULL _from under it_ unless some logic is wrong
> somewhere? And instead of flagging this broken logic, the proposed
> change here would hide it.

NULL put is usually used to simplify error handling / cleanup codes.

> Worse, if that object did become NULL between the _get() and _put()
> code, then we'll have an oops (which would be even more difficult to
> debug now) anyway.

Yeah, if NULL was a mistake, we're gonna oops anyway.

>> but we're leaning toward accepting NULL argument in this
>> type of functions.  Think about kfree(NULL) and its usefulness.
> 
> Don't {mis}quote the kfree() mistake here, please.

Like it or not, kfree(NULL) is used the same way.

>> More
>> importantly, the ecosystem around sysfs - that is, kobject, driver model
>> - generally accepts NULL argument for their get/put functions
> 
> This can only mean two things:
> 
> (1) Either, they simply do not _need_ the refcounting in the first place
> (which means -- better do away with get() and put() for them altogether)

I don't really see how you can jump there from allowing NULL argument.
Your conclusion is really far from the origin.

> (2) Or, all that code / APIs are so horribly misdesigned and/or buggy that
> you're now having to hide that by allowing NULL arguments in get() and
> put() functions (which means -- fix the bugs, please)
> 
>> so unless
>> there's a compelling reason to convert them all, and I don't see any,
>> sysfs_put() needs to follow the same rule.
> 
> Ok, what's the compelling reason to change sysfs_put() then?
> I don't see any, either.

Because mixed situation is undisputably worse than one way or the other
&& making sysfs_put() to conform to its surroundings is the shortest
path to achieve uniformity.  Gees, what's so important about allowing or
not allowing NULL?  You can get used to either way.  If you feel
allowing NULL argument to get/put functions are wrong.  Just go ahead
and submit separate patches to change that.  I won't object to that
although I won't feel too hot for that either.

-- 
tejun
