Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbXHIXNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbXHIXNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 19:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbXHIXNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 19:13:44 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4685 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbXHIXNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 19:13:42 -0400
Date: Fri, 10 Aug 2007 01:14:04 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: <20070801190556.GA1199@elte.hu>
Message-ID: <Pine.LNX.4.64.0708100037460.1817@scrub.home>
References: <Pine.LNX.4.64.0707131728070.1817@scrub.home>
 <1184389456.6632.13.camel@Homer.simpson.net> <Pine.LNX.4.64.0708010439050.1817@scrub.home>
 <20070801071230.GA16375@elte.hu> <Pine.LNX.4.64.0708011511530.1817@scrub.home>
 <20070801150742.GA23670@elte.hu> <p73ps27npu0.fsf@bingen.suse.de>
 <alpine.LFD.0.999.0708010924490.3582@woody.linux-foundation.org>
 <20070801175004.GA17936@elte.hu> <Pine.LNX.4.64.0708011955430.1817@scrub.home>
 <20070801190556.GA1199@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 1 Aug 2007, Ingo Molnar wrote:

> just to make sure, how does 'top' output of the l + "lt 3" testcase look 
> like now on your laptop? Yesterday it was this:
> 
>  4544 roman     20   0  1796  520  432 S 32.1  0.4   0:21.08 lt
>  4545 roman     20   0  1796  344  256 R 32.1  0.3   0:21.07 lt
>  4546 roman     20   0  1796  344  256 R 31.7  0.3   0:21.07 lt
>  4547 roman     20   0  1532  272  216 R  3.3  0.2   0:01.94 l
> 
> and i'm still wondering how that output was possible.

I disabled the jiffies logic and the result is still the same, so this 
problem isn't related to resolution at all.
I traced it a little and what's happing is that the busy loop really only 
gets little time, it only runs inbetween the timer tasks. When the timer 
task is woken up __enqueue_sleeper() updates sleeper_bonus and a little 
later when the busy loop is preempted __update_curr() is called a last 
time and it's fully hit by the sleeper_bonus. So the timer tasks use less 
time than they actually get and thus produce overflows, the busy loop OTOH 
is punished and underflows.
So it seems my initial suspicion was right and this logic is dodgy, what 
is it actually supposed to do? Why is some random task accounted with the 
sleeper_bonus?

bye, Roman

PS: Can I still expect answer about all the other stuff?
