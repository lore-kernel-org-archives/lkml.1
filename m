Return-Path: <linux-kernel-owner+w=401wt.eu-S935330AbXGRRAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935330AbXGRRAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935176AbXGRQ7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:59:48 -0400
Received: from waste.org ([66.93.16.53]:38711 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935153AbXGRQ7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:59:46 -0400
Date: Wed, 18 Jul 2007 11:54:03 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rene Herman <rene.herman@gmail.com>
Cc: Ray Lee <ray-lk@madrabbit.org>, Bodo Eggert <7eggert@gmx.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070718165402.GK11115@waste.org>
References: <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com> <Pine.LNX.4.58.0707161523500.25779@be1.lrz> <469BF104.1040703@gmail.com> <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com> <469BF768.6040200@gmail.com> <20070716230719.GC11115@waste.org> <469BFB73.3070105@gmail.com> <20070716232755.GD11115@waste.org> <469D7D1B.4050909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469D7D1B.4050909@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 04:38:19AM +0200, Rene Herman wrote:
> On 07/17/2007 01:27 AM, Matt Mackall wrote:
> 
> >Larger soft pages waste tremendous amounts of memory (mostly in page
> >cache) for minimal benefit on, say, the typical desktop. While there
> >are workloads where it's a win, it's probably on a small percentage of
> >machines.
> >
> >So it's absolutely no help in fixing our order-1 allocation problem
> >because we don't want to force large pages on people.
> 
> I was just now looking at how much space is in fact wasted in pagecache for 
> various pagesizes by running the attached dumb little program from a few 
> selected directories (heavy stack recursion, never mind).
> 
> Well, hmmm. This is on a (compiled) git tree:
> 
> rene@7ixe4:~/src/linux/local$ pageslack
> total	: 447350347
>  4k	: 67738037 (15%)
>  8k	: 147814837 (33%)
> 16k	: 324614581 (72%)
> 32k	: 724629941 (161%)
> 64k	: 1592785333 (356%)
> 
> Nicely constant factor 2.2 instead of the 2 one would expect but oh well. 
> On a collection of larger files the percentages obviously drop. This is on 
> a directory of ogg vorbis files:
> 
> root@7ixe4:/mnt/ogg/.../... # pageslack
> total	: 70817974
>  4k	: 26442 (0%)
>  8k	: 67402 (0%)
> 16k	: 124746 (0%)
> 32k	: 288586 (0%)
> 64k	: 419658 (0%)
> 
> The "typical desktop" is presented by neither I guess but does involve 
> audio and (much larger still) video and bloody huge browser apps.

I'd be surprised if a user had substantially more than one OGG, video,
or browser in memory at one time. In fact, you're likely to find only
a fraction of each of those in memory at any given time.

Meanwhile, they're likely to have thousands of small browser cache,
thumbnail, config, icon, maildir, etc. files in cache. And hundreds of
medium-sized libraries, utilities, applications, and so on.

You can expect the distribution of file sizes to follow a gamma
distribution, with a large hump towards the small end of the spectrum
around 1-10K, dropping off very rapidly as file sizes grow.

> Not too sure then that 8K wouldn't be something I'd want, given fewer 
> pagefaults and all that...

Fewer minor pagefaults, perhaps. Readahead already deals with most of
the major pagefaults that larger pages would.

Anyway, raising the systemwide memory overhead by up to 15% seems an
awfully silly way to address the problem of not being able to allocate
a stack when you're down to your last 1 or 2% of memory! In all
likelihood, we'll fail sooner because we're completely OOM.

-- 
Mathematics is the supreme nostalgia of our time.
