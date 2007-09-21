Return-Path: <linux-kernel-owner+w=401wt.eu-S933909AbXIUW7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909AbXIUW7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763865AbXIUW6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:58:25 -0400
Received: from smtpoutm.mac.com ([17.148.16.73]:60791 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933788AbXIUW6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:58:23 -0400
In-Reply-To: <1190412335.32660.55.camel@localhost>
References: <46F1645D.9050406@am.sony.com> <200709201538.43093.rob@landley.net> <59465.81.207.0.53.1190323573.squirrel@secure.samage.net> <200709201818.42125.rob@landley.net> <4477DB43-766B-4057-B33D-357A73AF69B0@mac.com> <1190412335.32660.55.camel@localhost>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <06405221-2131-49B4-B3C2-E9773255DC30@mac.com>
Cc: Rob Landley <rob@landley.net>, Indan Zupancic <indan@nul.nu>,
       linux-tiny@selenic.com, Michael Opdenacker <michael@free-electrons.com>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [Announce] Linux-tiny project revival
Date: Fri, 21 Sep 2007 18:57:30 -0400
To: Joe Perches <joe@perches.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 21, 2007, at 18:05:34, Joe Perches wrote:
> On Fri, 2007-09-21 at 17:34 -0400, Kyle Moffett wrote:
>> With a bit more glue that would cause GCC to notice that for a  
>> given qprintk_kmalloc the "qpk->type" is always zero because the  
>> level is too high, and therefore it would optimize out *ALL* of  
>> the _qprintk_kmalloc(), _qprintk(), and _qprintk_finish() calls.
>
> A negative is that lockup conditions swallow partial messages.

But typically you don't care if a "partial line" gets swallowed  
regardless.  The only reason people really use partial lines is when  
they're accumulating a variable number of things into a single line  
and so a single printk() won't do, and in that case it's really not a  
problem to "lose" the first half of the line in event of a crash.   
And hell, if it matters that much you could just make the qprintk_ 
{kmalloc,percpu,irq} functions chain the qpk variables on a little  
linked list and stuff an smp_wmb() in the _gprint() function after  
writing the text and before writing the size.  That way any panic  
could very carefully look at the messages being queued during the  
crash and attempt to write out partial buffers.

It's a technique which in combination with looking at the first 3  
characters of the arguments to printk() would let you elide 99% of  
the non-critical printks pretty easily while only needing to change  
the much smaller proportion of the printk()s which are partial  
lines.  Furthermore it's pretty easy to grep for the partial-line  
printk()s and you can even have it emit warnings when you hit a  
partial-line printk() (it doesn't start with "<"[0-9]">") in -mm to  
help fix up the last few users and keep people from adding new ones.

Cheers,
Kyle Moffett

