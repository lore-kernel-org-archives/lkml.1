Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbZKCRYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbZKCRYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZKCRYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:24:24 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:58959 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbZKCRYW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:24:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=KFtMtCGA+HISTNrQPVAiQQvkIGSlpdxWUZvg9pEKC9SziSRkA2sGtBUx5+nH+NJgRK
         rE2p2XSjQP5ywER3GqgFo8y+HUCKiZHVyDaSZg9CdrhS3MVN0LCfCE5ILeBEVyCySD7Y
         EvPZtifm0OZd9/8CDNraggME+ZJTkAGsM2qeg=
MIME-Version: 1.0
In-Reply-To: <20091103162955.GA4836@elte.hu>
References: <20091103053156.GA3212@core.coreip.homeip.net> 
	<20091102.224957.32364226.davem@davemloft.net> <20091103065238.GE3212@core.coreip.homeip.net> 
	<1257232587.3420.55.camel@localhost.localdomain> <alpine.LFD.2.01.0911030719430.31845@localhost.localdomain> 
	<1257262588.3420.79.camel@localhost.localdomain> <alpine.LFD.2.01.0911030738260.31845@localhost.localdomain> 
	<1257264485.3420.87.camel@localhost.localdomain> <20091103162955.GA4836@elte.hu>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 3 Nov 2009 09:24:06 -0800
Message-ID: <43e72e890911030924n26550ee4j619a41ec016281ea@mail.gmail.com>
Subject: Re: Please consider reverting 7d930bc33653d5592dc386a76a38f39c2e962344
To: Ingo Molnar <mingo@elte.hu>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 3, 2009 at 8:29 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Marcel Holtmann <marcel@holtmann.org> wrote:
>
>> Hi Linus,
>>
>> > > no questions that it needs fixed, I agree with you. However just blindly
>> > > reverting something, because it fixes it for one or two people, might
>> > > have side effects that causes more problems than the revert would
>> > > actually fix.
>> >
>> > Stop whining. Really.
>> >
>> > Everybody understands that it should be fixed.  That's not the question.
>> >
>> > But it should be fixed _quickly_. In this case, I have a bisection report
>> > FROM TWO DAYS AGO. And I'm still kicking myself for not just reverting
>> > that piece-of-shit commit then, because I spent the time to look at the
>> > oops and the commit, and could tell that it was crap.
>> >
>> > Instead, I _did_ wait for the subsystem maintainer to get around to it. As
>> > a result of waiting, I've now wasted time for a lot of other people.
>>
>> I do have a patch in my inbox from Johannes from 4 days ago that fixes
>> this issue.
>>
>>       http://marc.info/?l=linux-wireless&m=125697124819563&w=2
>>
>> So what is the take away from this now? Do you wanna have Johannes
>> step over John and Dave and send such a patch directly to you?
>
> The problem as i see it is the kind of answer Johannes gave when the bug
> was bisected to by Jeff Chua two days ago:
>
>  Subject: wpa2 hangs v2.6.32-rc5-402-gb6727b1. Revert
>           7d930bc33653d5592dc386a76a38f39c2e962344 fixed it.
>
>  [ <1257151742.3555.165.camel@johannes.local> ]
>  ...
>  |
>  | On Sun, 2009-11-01 at 23:18 +0800, Jeff Chua wrote:
>  | > wpa2 (wpa_supplicant) hangs v2.6.32-rc5-402-gb6727b1.
>  |
>  | Explain?
>  |
>  | > Reverting 7d930bc33653d5592dc386a76a38f39c2e962344 fixes it.
>  |
>  | Certainly not a good idea, will break when your AP denies association.

It certainly would have helped to have elaborated more on this and to
be fair let me elaborate a little more on the issue which the patch in
question tried to address.

After the merge window we have been getting WARN_ON()s on an extremely
rare situation which was very difficult to debug. The issue can be
seen even on the kerneloops.org track list [1]. This also applied to
people running older kernels but running our stable compat-wireless
for 2.6.32 [2]. Only a few of us have been able to trigger this
warning and report it but it was never possible to easily reproduce.
It usually took a day's worth of connectivity to reproduce.

Late in the merge window, right before the kernel summit I found a way
to finally reproduce and sent a one line patch to fix this [3] but as
noted by Johannes it was not the proper fix for a few reasons.

The unfortunate side of the issue is that once you hit the WARN_ON()
it is already too late and will simply not be able to associate to any
AP and hence Johannes' comment. The WARN_ON() was just a secondary
warning of shit already having hit the fan elsewhere. The problem was
reproducible whenever an Access Point denied association and you
typically would not run into this unless you mis-configure your
wireless settings or you happen to have some AP in some funny
situations (I believe in my case it was -E_TOO_MANY_PEOPLE_CONNECTED).
What this means is that the issue at hand was serious and it did need
to be fixed one way or another for 2.6.32.

At the kernel summit during the hacking session I poked Johannes and
we reviewed the issue at hand and tried to come up with a proper
solution. The solution were the two sets of patches, one of which
caused a regression as noted by a few people.
 Truth is an oops is worse than a WARN_ON() and also loosing the
ability to associate to your AP. Because of that perhaps this should
have been reverted but one way or another this issue needed to be
fixed for good for 2.6.32. So unfortunately reverting the patch would
re-introduce an issue for all users.

How this sort of issue is dealt with is subjective and it is up to
maintainers to deal with.

> Unhelpful, defensive, in denial.
>
> Plus that you tried to berate Dmitry in this particular thread about the
> revert was pretty bad form too IMO.
>
> _Anyone_ who went through the unnecessary, avoidable cost of having to
> do a bisection of a 3 days old commit merged at around -rc5 time is in
> his full rights to ask for a revert, straight from Linus if he thinks
> so. No ifs and when about it.
>
> So IMO you are showing the wrong kind of attitude for a post-rc5
> regression, by a _wide_ margin. The right kind of attitude would be:
>
>  "Oops, my bad - thanks. I've queued up a revert."
>
> or:
>
>  "Oops, my bad - thanks. Does the attached patch fix it?
>   If not we'll revert it."
>
> Furthermore, your 'hey, nothing happened, we fixed it after all'
> argument is just a forewarning that you learned nothing and such
> avoidable incidents could repeat in the future.

Having more information on the patch and better communication about
the issue it solved, and the issues that reverting it would have
caused would certainly have helped maintainers make a better call at a
regression caused by it but knowing Johannes he'd probably cook up a
followup fix ASAP and that is exactly what he did.

[1] http://kerneloops.org/guilty.php?guilty=__cfg80211_disconnected&version=2.6.32-rc&start=2097152&end=2129919&class=warn
[2] http://kerneloops.org/search.php?filter=2.6.31&search=__cfg80211_disconnected
[3] http://marc.info/?l=linux-wireless&m=125548148731042&w=2

  Luis
