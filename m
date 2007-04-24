Return-Path: <linux-kernel-owner+w=401wt.eu-S1161110AbXDXMHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161110AbXDXMHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 08:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031071AbXDXMHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 08:07:07 -0400
Received: from aeimail.aei.ca ([206.123.6.84]:59182 "EHLO aeimail.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030357AbXDXMHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 08:07:05 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] another scheduler beater
Date: Tue, 24 Apr 2007 08:06:30 -0400
User-Agent: KMail/1.9.5
Cc: davidsen@posidon.tmr.com, Linux Kernel M/L <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>
References: <462D2B4E.7050009@tmr.com> <20070424081726.GA2714@elte.hu>
In-Reply-To: <20070424081726.GA2714@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200704240806.30735.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 April 2007 04:17, Ingo Molnar wrote:
> 
> * Bill Davidsen <davidsen@tmr.com> wrote:
> 
> > The small attached script does a nice job of showing animation 
> > glitches in the glxgears animation. I have run one set of tests, and 
> > will have several more tomorrow. I'm off to a poker game, and would 
> > like to let people draw their own conclusions.
> > 
> > Based on just this script as load I would say renice on X isn't a good 
> > thing. Based on one small test, I would say that renice of X in 
> > conjunction with heavy disk i/o and a single fast scrolling xterm 
> > (think kernel compile) seems to slow the raid6 thread measurably. 
> > Results late tomorrow, it will be an early and long day :-(
> 
> hm, i'm wondering what you would expect the scheduler to do here?
> 
> for this particular test you'll get the best result by renicing X to 
> +19! Why? Because, as far as i can see this is a partially 'inverted' 
> test of X's scheduling.
> 
> While the script is definitely useful (you taught me that nice xterm 
> -geom trick to automate the placing of busy xterms :), some caveats do 
> apply when interpreting the results:
> 
> If you have a kernel 3D driver (which you seem to have, judging by the 
> glxgears numbers you are getting) then running 'glxgears' wont involve X 
> at all. glxgears just gets its own window and then the kernel driver 
> draws straight into it, without any side-trips to X. You can see this 
> for yourself by starting glitch1.sh from an ssh terminal, and then 
> _totally stop_ the X server via "kill -STOP 12345" - all the xterms will 
> stop, the X desktop freezes, but the glxgears instance will still 
> happily draw its stuff and wheels are happily turning on the screen.
> 
> So in this sense glxgears is a 'CPU hog' workload, largely independent 
> of X.
> 
> now, by renicing X to -10 and running the xterms you'll definitely hurt 
> "CPU hogs" - even if it happens to be a glxgears process that draws 3D 
> graphics in a window provided by X. But this is precisely what is 
> supposed to happen in this case. You should get the best glxgears 
> performance by renicing X to _+19_, and that seems to be happening 
> according to your numbers - and that's what happens in my own testing 
> too.
I
Ingo,

This turns out to be only part of the story.  There are two scroll options for
the glitch1 script.  With 'jump' scrolling I get:

cfs v5 	jump	-19	500 FPS
cfs v5 	jump 	-10	500 FPS
cfs v5 	jump	-5	150 FPS
cfs v5 	jump	0	25 FPS

cfs v5	1 line	-19	230 FPS
cfs v5 	1 line 	-10	195 FPS
cfs v5	1 line 	-5	720 FPS
cfs v5	1 line 	0	970 FPS
cfs v5	1 line 	10	430 FPS

sd 0.46	1 line 	-19	0.5 FPS
sd 0.46	1 line 	-10	0.8 FPS
sd 0.46	1 line 	0	2.3 FPS
sd 0.46	1 line 	10	93 FPS
sd 0.46	1 line 	19	93 FPS

sd 0.46	jump is basically the same as the 1 line case.

glxgears alone gets about 1500 FPS

So in one case nice -10 gives us the worst performance.  In the other case,
where you predicted nice 19 would get the best numbers nice 0 does...  Nor
does the SD scheduler produce the results predicted.

Thanks,
Ed Tomlinson

(2.6.20.7 gentoo, amd64 UP HZ=300, voluntary preempt, radeon 9200 agp with in kernel drivers)




