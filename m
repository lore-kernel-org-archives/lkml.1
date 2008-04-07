Return-Path: <linux-kernel-owner+w=401wt.eu-S1757613AbYDGLh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbYDGLh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 07:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbYDGLhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 07:37:15 -0400
Received: from catapult-mx.catapult.com ([192.94.66.29]:1088 "EHLO
	Catapult-mx.catapult.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbYDGLhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 07:37:14 -0400
Subject: Re: Clock has stopped (time/date looping over 5 seconds), things
	are broken - what to check to debug?
From: "Joel K. Greene" <joel.greene@catapult.com>
To: Roger Heflin <rogerheflin@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Steckly <michaels@catapult.com>
In-Reply-To: <47F69D2F.8010607@gmail.com>
References: <47F69D2F.8010607@gmail.com>
Content-Type: text/plain
Organization: Catapult Communications Corporation
Date: Mon, 07 Apr 2008 07:37:11 -0400
Message-Id: <1207568231.4496.9.camel@linuxdt036.nc.catapult.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

Does this sound familiar:

http://lkml.org/lkml/2008/3/14/178


We've been chasing this for quite a while. Our PIC gets in a bad state
where it thinks the CPU is in the ISR, and so won't give another int. We
haven't much of an idea of how we get in that state other than that
HZ=1000 makes it happen faster and HZ=100 causes it less often.

I think that if you look at jiffies you will see it is not incrementing.
The 4 second loop seems to be in the conversion from jiffies to wall
time.


It _appears_ that there is a race in the kernel that can be triggered by
any number of hardware issues. There's another thread by Gregory Stark
with the same symptoms - he thinks his was fixed by replacing a bad
DIMM.

Note that we first saw this on 2.6.16, and Gregory found it on 2.6.5.
We've seen systems run for a couple of months before seeing this, so
it's a bear to debug.

How often is this happening for you? How repeatable?

What hardware are you running on?


Joel.





On Fri, 2008-04-04 at 16:27 -0500, Roger Heflin wrote:
> So far what I have is that the clock is moving between
> 10:01:03 to 10:01:07 (when it gets to 07 it goes back to 03), doing rdate -s
> results in things changing:
> 
> 16:12:38 to 16:12:43 (resets back to :38).
> 
> Doing this:
> while true ; do date; usleep 1000000; done
> Fri Apr  4 16:12:39 CDT 2008
> Fri Apr  4 16:12:40 CDT 2008
> Fri Apr  4 16:12:41 CDT 2008
> Fri Apr  4 16:12:42 CDT 2008
> Fri Apr  4 16:12:43 CDT 2008
> 
> It stops at :43, ^C is required, and you can then restart it with repeatable 
> results.
> 
> This F7 - 2.6.23.15-80.fc7
> 
> dmesg/messages contain nothing abnormal.
> 
> This machine has done it several times, a freqency of maybe 1x per every couple 
> of weeks or so.   I believe it had also done this with: 2.6.22.9-91.fc7 so it
> has been doing this for a while.   It used to work with some older kernel (I 
> don't know which).
> 
> Given what the clock is doing, things that sleep at the wrong time hang forever, 
> and a number of other things fail to work.
> 
> vmstat 1 results in a single line being printed out, and then a floating point 
> exception.
> 
> "shutdown -r now" fails to complete, power cycle is required to get the machine
> back up.
> 
> I don't believe any hardware failure that I can think of would cause the clock 
> to do what mine is doing.
> 
> Ideas?
> 
>                                 Roger
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

