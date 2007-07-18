Return-Path: <linux-kernel-owner+w=401wt.eu-S934342AbXGRQaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934342AbXGRQaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933408AbXGRQaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:30:35 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:37550 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933301AbXGRQae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:30:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=pF+VHTFPl7YZuNKHWqj6TAV7UFjV9GCV08/MQHvOfJGhJC2Mpr2mvKA5yE20ncU7ZiWRTMn1hrC3Avz3v6uKOKhIuAoiPVDcaiE70UQudSz9o7Dv/FJs4DowsxVZjKFg9V+zdjJl6l98cvYgE55JlgGbTxg0/OiJFkRiFAh/Agg=
Message-ID: <469E401D.2020506@gmail.com>
Date: Thu, 19 Jul 2007 01:30:21 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Gabriel C <nix.or.die@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, gregkh@suse.de,
       miles.lane@gmail.com
Subject: Re: [PATCH] sysfs: kill an extra put in sysfs_create_link() failure
 path
References: <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>	 <469BB7B8.3060002@gmail.com> <469BB9CA.6090500@googlemail.com>	 <469BC2D6.5090008@googlemail.com> <469BC34C.4080107@googlemail.com>	 <20070718071445.GI23568@htj.dyndns.org>	 <a781481a0707180748j4760ab8bo237c1abc02feb593@mail.gmail.com>	 <469E2A68.6010307@gmail.com>	 <a781481a0707180816r478d2512v953036a1e4145a72@mail.gmail.com>	 <469E352A.90909@gmail.com> <a781481a0707180906w38b151faqd7077ee3da21aff3@mail.gmail.com>
In-Reply-To: <a781481a0707180906w38b151faqd7077ee3da21aff3@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
>> > sysfs_find_dirent() -- to check for -EEXIST -- should be called
>> > *before* we create the new dentry for the to-be-created symlink
>> > in the first place. [ It's weird to grab a reference on the target
>> > for ourselves (and in fact even allocate the new dirent for the
>> > to-be-created symlink) and /then/ check for erroneous usage,
>> > and then go about undoing all that we should never have done
>> > at all. ] So this test could, and should, be made earlier, IMHO.
>>
>> Locking.
> 
> Well s/sysfs_find_dirent/sysfs_get_dirent/ then. And then simply put
> down the reference later.

Isn't that the current code?

>> > And some similar others ... so attached (sorry, Gmail web
>> > interface) please find an attempt to make sysfs_create_link look
>> > a trifle more like what it should look like, IMHO. The code cleanup
>> > also leads to fewer LOC, smaller kernel image (lesser by 308 bytes),
>> > and even speeding up the no-error common case of this function,
>> > apart from the obvious readability benefits ... it's diffed on _top_ of
>> > your bugfix here, but not the other patch. [ Compile-tested only. ]
>>
>> Compounded if-else vs. flattened if () with common error path is pretty
>> much matter of being accustomed to.  I prefer the latter because it
>> scales better (less nesting and less need for extra intelligence as
>> error case grows).  As I'm already used to it, it's also easier on my
>> eyes.
> 
> Umm, I don't see any compounded if-else that I added that wasn't
> there already ... if any are, they only make the code clearly obvious
> as to what it's doing in the first place. And we've still got a common
> error path. Just that the error paths do not *need* to share any other
> code than the simple "return error;" precisely because it's been
> cleaned up. The existing code was just horrible, IMHO.

I just don't agree with you and with the locking bug fixed, you'll end
up with more code in the error path.

>> So, unless you have more to offer, I'm not really sure whether
>> the patch improves the situation noticeably.
> 
> Readability, fewer LOC, 308 lesser bytes in kernel image and
> faster for the common case -- not good enough for you?! Oh, well.

Sorry, not agreed on readability.  The rest doesn't really matter too
much and please stop making big deal out of this kind of stuff.  Things
like that do matter but not that much.  Mostly it's matter of getting
used to and there are many alternatives.  Some people like things one
way other people like another.  My taste might not be the best around
here but I don't think it's that awful either.  You may find my taste
disgusting but we all have to deal with such issue, don't we?

-- 
tejun
