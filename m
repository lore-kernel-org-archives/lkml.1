Return-Path: <linux-kernel-owner+w=401wt.eu-S1764031AbXGNDBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764031AbXGNDBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 23:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762920AbXGNDBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 23:01:17 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:26197 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbXGNDBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 23:01:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=LXmYiG27h7pmdA77dcgQumta33q0lJu1pKXvznyCGbv4uivr91SdNM+NUm0jjU0nCC2wC76CqrSVTq7EXQtYbAy+Rermg1lSmAffjzIQ8ztB3klSQj3dq7E1wsXkoPisjtt7Z2LN2bEcIRuKw8uISjqmE7xULAsLlO0dcnl2CjQ=
Message-ID: <46983C76.1040406@gmail.com>
Date: Sat, 14 Jul 2007 12:01:10 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 24/61] sysfs: make sysfs_put() ignore NULL sd
References: <11841968512510-git-send-email-gregkh@suse.de>	 <20070712.085047.37780825.yoshfuji@linux-ipv6.org>	 <20070711235529.GA7485@suse.de>	 <20070712.100617.14203407.yoshfuji@linux-ipv6.org>	 <46959958.6080005@gmail.com>	 <a781481a0707121246tc1b62d1qe80db8422e6e26a3@mail.gmail.com>	 <4696FDDC.7050503@gmail.com> <4697078D.4050601@gmail.com> <a781481a0707131028m36bf9e1eka20b783b5f350ae3@mail.gmail.com>
In-Reply-To: <a781481a0707131028m36bf9e1eka20b783b5f350ae3@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Satyam Sharma wrote:
>> Because mixed situation is undisputably worse than one way or the other
>> && making sysfs_put() to conform to its surroundings is the shortest
>> path to achieve uniformity.  Gees, what's so important about allowing or
>> not allowing NULL?
> 
> The whole _purpose_ of get()/put() functions (i.e. refcounting in general)
> is to ensure that the (shared) objects don't go away from under us while
> we're holding them. The proposed change _weakens_ the API itself by
> allowing a buggy driver (that somehow called into _put() codepath without
> a _get() before it) to not get flagged immediately (through an oops). This
> inevitably leads to some difficult-to-debug problems -- I have suffered
> debugging issues created by such weak/loose APIs myself.

Yeah, that's the advantage of not allowing NULL, well, or disadvantage
of allowing.  I get that.  If I were to reimplement all these functions,
I probably wouldn't allow NULL argument myself either.  As much as I
understand your POV, I just don't think it's as critical as maintaining
uniformity.  There are million and one ways to get refcounting wrong and
allowing or not allowing NULL seems like a very small factor to me.  On
the other hand, if you make things confusing by allowing on some but not
allowing on others, it's much more likely to trigger programmer error.

>> >> but we're leaning toward accepting NULL argument in this
>> >> type of functions.  Think about kfree(NULL) and its usefulness.
>> >
>> > Don't {mis}quote the kfree() mistake here, please.
>>
>> Like it or not, kfree(NULL) is used the same way.
> 
> But we pay a heavy price for the "programmer convenience" (just
> avoiding some conditionals / multiple goto labels in error cleanup
> paths) that we get in return. I do believe the kernel would've been
> much less buggy, if only kfree(NULL) wasn't legal.

I'm not sure whether it has contributed a lot to bugs, maybe.  But
still, on cases like this, I think staying with what people are used to
is the best way.  The advantages or disadvantages are really small
compared to the confusion overhead.

> But even if you do want to allow NULL arguments to such functions,
> for certain situations, you could always write a little wrapper over
> the lower function that'll include the "if (not NULL)" kind of check.

Yeap, sure.

>> I don't really see how you can jump there from allowing NULL argument.
>> Your conclusion is really far from the origin.
>> [...]
>> NULL put is usually used to simplify error handling / cleanup codes.
> 
> I'd be gladder if you could point me to code where this change really
> helps.
> I'd definitely like to send patches, why not.

It's added by later patches.  The patch itself is created because I was
hit by the confusion.  sysfs_get() allowed NULL argument but sysfs_put()
didn't.  Where's sense in that?  I thought about converting sysfs_get()
to not accepting NULL but then the whole kobject and friends would act
differently.

For sysfs, changing behavior is okay.  It's mostly self-contained
subsystem and sysfs_get/put() aren't even exported to outside world, but
kobject and driver model are different story.  Changing such subtle
behavior of such widely used interface is bound to create a lot of
confusion.

Think about what would happen if NULL is suddenly disallowed on kfree().
 Even if all the current in-kernel users are converted at once (I'm sure
we're gonna miss some tho), all the out of tree (including devel) codes
and future codes will suffer and some of the bugs would be really hard
to catch as kfree(NULL) is buried in error handling path which generally
isn't triggered too often.

The same thing holds for kobject/driver model interface.  The confusion
which will be caused by such change outweighs any benefit which can come
from it.  So, I can't change kobject/driver model behavior.  If I then
come back to sysfs, the only option I have is to make sysfs follow the
rule in its neighborhood.

It's almost similar in get() too, but I think we have better chance
there because NULL get() is much more useless than NULL put() which
means it's used less.  Also, another plus is that get() errors are easy
to catch.  It usually lives in hot paths, but still I can't tell whether
the cost of conversion would worth the gained benefit.

>> I agree with you about get().  Allowing NULL argument doesn't really
>> help anything.  It only increases the chance of getting things wrong.
>> I'm all for not allowing NULL argument to get().  For put(), as I wrote
>> before, I think allowing NULL has some advantages and I don't care
>> either way as long as it's not confusing.  The 'not confusing' part is
>> way more important to me than advantages of either way.
> 
> As I said, changing generic refcounting API functions (which is what
> xxx_put() is) to simplify open-coding of a conditional in the caller's
> error cleanup paths does not sound advantageous to me at all. On the
> contrary, it weakens the refcounting API, and I can only imagine the
> kernel getting buggier with such changes.

I hope my 'confusion' argument explained my logic a bit better.  Again,
if you wanna change it, I'm not necessarily against it but that should
be a completely separate step && till that happens, making sysfs_put()
to follow its surrounding world _is_ a good idea.

Thanks.

-- 
tejun
