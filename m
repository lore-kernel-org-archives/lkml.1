Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbXKOEZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbXKOEZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 23:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbXKOEZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 23:25:10 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35892 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751779AbXKOEZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 23:25:09 -0500
Date: Wed, 14 Nov 2007 20:24:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bron Gondwana <brong@fastmail.fm>
cc: Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] New Kernel Bugs
In-Reply-To: <20071115040708.GB15302@brong.net>
Message-ID: <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org>
References: <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113.043207.44732743.davem@davemloft.net> <20071113110259.44c56d42.akpm@linux-foundation.org>
 <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de> <20071113130411.26ccae12.akpm@linux-foundation.org> <alpine.DEB.0.99999.0711132239350.3960@sheep.housecafe.de> <20071115040708.GB15302@brong.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Nov 2007, Bron Gondwana wrote:
> 
> And congratulations to him for that.  We almost entirely dropped 2.6.16,
> but there's a regression some time since then that makes large MMAPed
> files a major pain (specifically the dcc database clean takes about 5
> minutes on 2.6.16 and about 12 hours on 2.6.20 or 2.6.23 series kernels)
> 
> But we keep putting off writing a small testcase that can repeat the
> issue so we can bisect it - because it's working fine with 2.6.16 on
> that machine.

Heh. I suspect you don't even need to bisect it.

The big difference with large mmap'ed files is that later kernels will 
actually track dirty ratios for dirty mmap'ed pages. Earlier kernels never 
did.

So in older kernels, you can dirty as much memory as you want, and the 
kernel will never try to write it back (well - "never" here means one of 
either (a) you ask it to with msync or (b) you run out of memory, when the 
kernel then totally falls down and the machine is essentially unusuable).

So *if* the symptom seems to be that the later kernels do a lot more IO, 
then try to change 

	/proc/sys/vm/dirty_[background_]ratio

which is just a percentage of memory (defaults to 5% for background and 
10% for foreground dirtying). Turn them both up a lot (say to 50 and 80 
percent respectively) and see if that makes a difference.

If so, you'll be the first one to officially even notice this change, I 
think.

		Linus
