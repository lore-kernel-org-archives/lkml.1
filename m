Return-Path: <linux-kernel-owner+w=401wt.eu-S1030362AbXCAV4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030362AbXCAV4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 16:56:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030369AbXCAV4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 16:56:13 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:25832 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030365AbXCAV4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 16:56:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jjpHq97rsVXWtw2aMJa4qGE5tSJpBJ2M5Di7xCQsRXZYh4fJ6P03/aO+8Ntv93SALwcVZSJWfv09VREYQddrP6rs8Trk4YuOLqtB0ocX6fz3qwyhRS6TuAfsUUwo155t3r6qWWUwt4r1edGjsNNTOEZr7ecFvDDL4aRAWJ0WSvY=
Message-ID: <8bd0f97a0703011356v3bcb205fmc308465182ee9a39@mail.gmail.com>
Date: Thu, 1 Mar 2007 16:56:02 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: + blackfin-on-chip-rtc-controller-driver.patch added to -mm tree
Cc: akpm@linux-foundation.org, bryan.wu@analog.com, mm-commits@vger.kernel.org,
       a.zummo@towertech.it, "Paul Mundt" <lethal@linux-sh.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200703011335.48430.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703010848.l218me3e008819@shell0.pdx.osdl.net>
	 <200703011039.32876.david-b@pacbell.net>
	 <8bd0f97a0703011106j7cb3664dx190686b0251cd1fa@mail.gmail.com>
	 <200703011335.48430.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/1/07, David Brownell <david-b@pacbell.net> wrote:
> Look again, but at 2.6.21-rc2 instead ... ISTR that fix went into RC1,
> but that one's been fixed in various trees (like handhelds.org) for
> some time.

this driver was originally written against 2.6.19.x as we havent
gotten the Blackfin arch into mainline yet so it's hard to track the
latest git

i'll pull the latest git and look into the pointers you've posted ...
and send out a sep patch for updating the documentation ;)

> > > It looks to me like you're handling the time in set_alarm()
> > > incorrectly.  Do the conversion and test in set_alarm, not
> > > AIE_ON ... since set_alarm() needs to be able to include AIE_ON
> > > capability.
> >
> > the reason for this is so that i do not have to worry about keeping
> > two structures in sync ... there's the common RTC representation and
> > then there's the funky Blackfin representation, so by delaying the
> > conversion until RTC_AIE_ON, i didnt have to worry about keeping these
> > fields in sync
>
> Yes, Blackfin has an unusually funky representation, but that
> doesn't mean you can't do the conversion when the alarm time
> comes into the driver.  It's not like the alarm is based on
> offset-from-current-time, so that it'd need to be adjusted when
> the current time gets updated (like some RTCs)... it's just a
> strange way to encode an absolute time.

fair enough ... my other concern was that now i'll also have to
translate it back out in rtc_read_alarm so by maintaining everything
in common RTC terms, there would be no overhead

> > > The fields tm_{wday,yday,isdst} are never used,
> > > but you're testing tm_yday.  If you meant to test tm_mday in
> > > order to distinguish the WKALM_SET and ALM_SET cases, then you
> > > are mishandling a wraparound case; see how rtc-omap handles
> > > it.  (If it's 23:00 now, an 01:00 alarm means TOMORROW.  I
> > > think other RTCs may goof this case too.)
> >
> > this is exactly why i'm checking tm_yday ... the rtc-dev interface
> > sets those fields to -1 when using the WKALM ioctls and there's no
> > other way to distinguish this
>
> Thing is, "man 4 rtc" reports those fields as unused, which means
> they can come from userspace with arbitrary values.  You should
> stick to testing tm_mday, which *is* used.

i dont rely on the manpages for kernel interfaces as they get stale
too fast ... i read the files found in Documentation, rtc.txt in this
case

i guess rtc.txt needs more stuff added to it
-mike
