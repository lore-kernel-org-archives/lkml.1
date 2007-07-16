Return-Path: <linux-kernel-owner+w=401wt.eu-S1760227AbXGPW3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227AbXGPW3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbXGPW3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:29:24 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:44197 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbXGPW3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:29:23 -0400
Message-ID: <469BF104.1040703@gmail.com>
Date: Tue, 17 Jul 2007 00:28:20 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>
CC: Matt Mackall <mpm@selenic.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <8FO1e-2jW-35@gated-at.bofh.it> <8FYWD-2eS-7@gated-at.bofh.it> <8GdsH-8dc-13@gated-at.bofh.it> <8Ghmx-60z-17@gated-at.bofh.it> <8Gj55-hJ-5@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it> <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it> <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com> <Pine.LNX.4.58.0707161523500.25779@be1.lrz>
In-Reply-To: <Pine.LNX.4.58.0707161523500.25779@be1.lrz>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2007 03:43 PM, Bodo Eggert wrote:

> So we are in a desperate situation, we can almost make no progress,
> adding another task is going to push the system into an unrecoverable
> situation, and we make sure this task can be started.-)

Hnng. He was just saying that odds of two pages being buddies is quite 
small, not talking about literally two pages.

>> Moreoveover -- literally two pages free was hardly his point. The point is 
>> just that (with a page being the allocation unit) single page allocations 
>> are guaranteed to succeed if _any_ memory is free, while two adjacent (yes, 
>> and stacksize aligned) pages will be pretty hard to get by once the system 
>> has been up and running for some time.
> 
> That never happened on my servers, therefore I'd opt for the little extra 
> security of having spare 4k on the stack. (I made a patch which would 
> printk a message if allocating a stack would ever fail).
> 
> I'm not at all opposed to letting the guys with zillions of threads 
> benefit from having less unused kernel stack, but unless it's secure for
> all users, it should not be default=y.

Given that as Arjan stated Fedora and even RHEL have been using 4K stacks 
for some time now, and certainly the latter being a distribution which I 
would expect to both host a relatively large number of lvm/md/xfs and what 
stackeaters have you users and to be fairly conservative with respect to the 
chances of scribbling over kernel memory (I'm a trusting person...) it seems 
  there might at this stage only be very few offenders left.

Seeing as how single-page stacks are much easier on the VM so that creating 
those zillion threads should also be faster, at _some_ percentage we get to 
say "and now to hell with the rest".

Do also note that with interrupts of the process stack, available stack is 
definitely not halved. I don't have data (if anyone reading does, please 
say) but I expect that on the kinds of busy networked systems that want 
many-thread creation to be fastest, their many concurrent interrupt sources 
might mean they are not actually experiencing less stack at all. That is, 
that "little extra security" you speak of might very well be none at all in 
practice and perhaps even negative.

Getting interrupts onto their own stack(s) certainly made for better (more 
deterministic that is) behaviour as well -- you're then independent on how 
deep into the stack you already are when the interrupt comes in which is 
otherwise anyone's guess. Now I must say I'm not particularly sure why you 
couldn't still also have those even if you don't pick 4K stacks, but as far 
as I'm aware they're a package deal at least today.

Single page stacks are much nicer on anyone. For all I care, that single 
page migth be a larger soft-page. No idea how the hell you'd investigate the 
optimum page-size for any given system, but I quite fully expect it's larger 
than 4K these days _anyway_ even on x86 and for modern loads.

Since Linux doesn't yet have those that's also not very important currently 
though. 4K is 1024 32-bit datums which isn't all that little if recursion is 
limited and programmers somewhat competent. With the interrupt stacks 
meaning available stack might not be worse or even _better_ for some 
systems, well, I's argue to just go with 4K if at all possible.

Rene.

