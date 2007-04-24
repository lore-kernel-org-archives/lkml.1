Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbXDXISS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbXDXISS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbXDXIRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:17:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48762 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605AbXDXIRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:17:30 -0400
Date: Tue, 24 Apr 2007 10:17:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: davidsen@posidon.tmr.com
Cc: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] another scheduler beater
Message-ID: <20070424081726.GA2714@elte.hu>
References: <462D2B4E.7050009@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462D2B4E.7050009@tmr.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Bill Davidsen <davidsen@tmr.com> wrote:

> The small attached script does a nice job of showing animation 
> glitches in the glxgears animation. I have run one set of tests, and 
> will have several more tomorrow. I'm off to a poker game, and would 
> like to let people draw their own conclusions.
> 
> Based on just this script as load I would say renice on X isn't a good 
> thing. Based on one small test, I would say that renice of X in 
> conjunction with heavy disk i/o and a single fast scrolling xterm 
> (think kernel compile) seems to slow the raid6 thread measurably. 
> Results late tomorrow, it will be an early and long day :-(

hm, i'm wondering what you would expect the scheduler to do here?

for this particular test you'll get the best result by renicing X to 
+19! Why? Because, as far as i can see this is a partially 'inverted' 
test of X's scheduling.

While the script is definitely useful (you taught me that nice xterm 
-geom trick to automate the placing of busy xterms :), some caveats do 
apply when interpreting the results:

If you have a kernel 3D driver (which you seem to have, judging by the 
glxgears numbers you are getting) then running 'glxgears' wont involve X 
at all. glxgears just gets its own window and then the kernel driver 
draws straight into it, without any side-trips to X. You can see this 
for yourself by starting glitch1.sh from an ssh terminal, and then 
_totally stop_ the X server via "kill -STOP 12345" - all the xterms will 
stop, the X desktop freezes, but the glxgears instance will still 
happily draw its stuff and wheels are happily turning on the screen.

So in this sense glxgears is a 'CPU hog' workload, largely independent 
of X.

now, by renicing X to -10 and running the xterms you'll definitely hurt 
"CPU hogs" - even if it happens to be a glxgears process that draws 3D 
graphics in a window provided by X. But this is precisely what is 
supposed to happen in this case. You should get the best glxgears 
performance by renicing X to _+19_, and that seems to be happening 
according to your numbers - and that's what happens in my own testing 
too.

	Ingo
