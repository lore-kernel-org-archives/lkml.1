Return-Path: <linux-kernel-owner+w=401wt.eu-S1753116AbZLWEpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbZLWEpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 23:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZLWEpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 23:45:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751035AbZLWEpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 23:45:31 -0500
Date: Tue, 22 Dec 2009 20:42:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tejun Heo <tj@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
In-Reply-To: <4B319A20.9010305@kernel.org>
Message-ID: <alpine.LFD.2.00.0912222032360.6879@localhost.localdomain>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>  <1261143924.20899.169.camel@laptop>  <4B2EE5A5.2030208@kernel.org>  <1261387377.4314.37.camel@laptop>  <4B2F7879.2080901@kernel.org>  <1261405604.4314.154.camel@laptop>  <4B3009DC.7020407@kernel.org>
 <1261480001.4937.21.camel@laptop> <4B319A20.9010305@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Dec 2009, Tejun Heo wrote:
> 
> So, if we can have a mehanism which can solve these issues, it's an
> obvious plus.  Shifting complexity out of peripheral code to better
> crafted and managed core code is the right thing to do and it will
> shift a lot of complexity out of peripheral codes.

I really think this is key. I don't think Peter really has worked much 
outside of very core code (direct CPU-related stuff), and hasn't seen the 
kind of annoying problems our current workqueue code has.

Half the kernel is drivers. And 95% of all workqueue users are those 
drivers.

Workqueues generally aren't about heavy CPU usage, although some workqueue 
usage has scalability issues. And the most common scalability problem is 
not "I need more than one CPU", but often "I need to run even though 
another workqueue entry is blocked on IO" - iow, it's not about lacking 
CPU power, it's about in-fighting with other workqueue users.

That said, if we can improve on this further, I'd be all for it. I'd love 
to have some generic async model that really works. So far, our async 
models have tended to not really work out well, whether they be softirq's 
or kernel threads (many of the same issues: some subsystems start tons of 
kernel threads just because one kernel thread blocks, not because you need 
multi-processor CPU usage per se). And AIO/threadlets never got anywhere 
etc etc.

		Linus
