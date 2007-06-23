Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbXFWA4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbXFWA4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 20:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbXFWA4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 20:56:11 -0400
Received: from smtpout.mac.com ([17.250.248.174]:61800 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbXFWA4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 20:56:10 -0400
In-Reply-To: <200706230007.15622.info@gnebu.es>
References: <200706230007.15622.info@gnebu.es>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <B6065113-E9C7-42CE-A43D-55E6BF1EE2C0@mac.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Question about fair schedulers
Date: Fri, 22 Jun 2007 20:55:15 -0400
To: Alberto Gonzalez <info@gnebu.es>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 22, 2007, at 18:07:15, Alberto Gonzalez wrote:
> Let's say I have a HD video that uses ~70% CPU. Let's say I want to  
> watch it while I encode my music to vorbis (or rip a DVD). This is  
> the only reasonable scenario I can imagine on a normal desktop,  
> since most desktops have the CPU idle or under 10% usage during 95%  
> of the time and a CPU scheduler makes no difference (maybe people  
> on this list compile a few kernels every day, but that's not what  
> most normal users like me do).

> Ok, so what will a fair scheduler do in this case? It is my  
> understanding that it would give 50% CPU to each task, resulting in  
> the video dropping frames. Is this correct?

Yes, that's correct.

What this *actually* means is that you want the media player to have  
higher priority than the DVD ripping program.  Ergo you should run  
"nice +20 my_dvd_burner" or "nice +20 my_vorbis_encoder" under CFS or  
other fair schedulers.  (Although you might not need to nice the dvd  
burner) The key difference is this:

With the older scheduler your DVD ripping process would have had  
buffer underrun problems; even though it doesn't require much CPU at  
all (and can slow down burning if it doesn't get enough) it wouldn't  
get a chance to run at appropriate times to keep the buffer full.  If  
you were encoding vorbis files you would *definitely* want to renice  
it as it will consume all available CPU.

With CFS, your HD video player would get the 70% of the CPU that it  
needs (exactly), and the rest would be allocated to the DVD ripper  
and other processes.  In addition, the DVD ripper gets certain  
latency guarantees even though it's *LOWER* priority than the media  
player (which also gets latency guarantees).

> Now, the _ideal_ solution for this situation would be to give ~70%  
> to the video and the rest (~30%) to the encoder. But this goes  
> against fairness, doesn't it? Yet most reports I've read about  
> these two fair schedulers say that videos play smoother under load.  
> What am I missing?

Well, typically your video player *doesn't* chew up all of the CPU,  
so the fairness helps.  Here's another scenario for you:  You are  
running un-niced HD video player and recoding processes side-by-side,  
so that the HD video player only gets 50% of the CPU.  Under older  
schedulers the video player would not get uniformly allocated CPU, it  
would get it in fits and spurts, causing more _visibly_dropped_  
frames (IE: render 30 frames, drop 8, render 15, drop 2, etc).  Under  
the new CFS scheduler it will get evenly allocated CPU and so while  
you *will* get dropped frames, they will be less visible (IE: Render  
7 frames, drop 1, render 7 frames, drop 1, render 7 frames, drop 1).

> If I ask this question is because today I tested it and found that  
> using the -ck kernel (with SD scheduler) the video would drop  
> frames, while with the mainline kernel it played fine.

Basically you are telling the kernel that your video player is no  
more important than your re-encoder process which, judging by your  
email, is completely untrue.  If you really want it to treat the  
video player as specially important (or alternatively treat the  
reencoder process and specially unimportant) then you must tell it so  
with "nice" or "renice".

> My conclusion is that SD behaves as expected: it's more fair. But  
> for a desktop, shouldn't an "intelligently unfair" scheduler be  
> better?

Well, it is "intelligently unfair", but you the user have to tell it  
what is more important for *YOU*.  If I _really_ have to get some  
music recoded quickly then I may be willing to deal with some dropped  
frames in order to let that happen appropriately.

> P.S: As a second thought, a fair scheduler could behave really good  
> in other scenarios, like a server running a busy forum on apache 
> +mysql+php. Besides, this is a more real world scenario (and easier  
> to benchmark). Why aren't people testing these schedulers under  
> this kind of load?

That kind of load is boring precisely because it doesn't care about  
interactivity.  CFS/SD aren't a whole lot different from mainline- 
without-interactivity in that respect, precisely because the latency  
of the network is between ten and a hundred times more than the  
latency of the scheduler.  The only time it really matters is with  
desktops where users care about smoothness.

Cheers,
Kyle Moffett

