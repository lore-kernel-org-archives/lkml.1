Return-Path: <linux-kernel-owner+w=401wt.eu-S933692AbXFRXr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933692AbXFRXr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 19:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764632AbXFRXrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 19:47:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53777 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756430AbXFRXrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 19:47:19 -0400
Date: Mon, 18 Jun 2007 16:47:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tim.c.chen@linux.intel.com
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Change in default vm_dirty_ratio
Message-Id: <20070618164711.9de1c38e.akpm@linux-foundation.org>
In-Reply-To: <1182201271.4883.22.camel@localhost.localdomain>
References: <1182201271.4883.22.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007 14:14:30 -0700
Tim Chen <tim.c.chen@linux.intel.com> wrote:

> Andrew,
> 
> The default vm_dirty_ratio changed from 40 to 10
> for the 2.6.22-rc kernels in this patch:
>  
> http://git.kernel.org/?
> p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=07db59bd6b0f279c31044cba6787344f63be87ea;hp=de46c33745f5e2ad594c72f2cf5f490861b16ce1
> 
> IOZone write drops by about 60% when test file size is 50 percent of
> memory.  Rand-write drops by 90%. 

heh.

(Or is that an inappropriate reaction?)

> Is there a good reason for turning down the default dirty ratio?

It seems too large.  Memory sizes are going up faster than disk throughput
and it seems wrong to keep vast amounts of dirty data floating about in
memory like this.  It can cause long stalls while the system writes back
huge amounts of data and is generally ill-behaved.

> How will it help for most cases?  Intuitively, it seems like 
> a less aggressive writeback will have better performance.

I assume that iozone is either doing a lot of file overwrites or is
unlinking/truncating files shortly after having written them.

And some benchmarks are silly.  You have just demonstrated that IOZone
should have been called RAMZone....

Some workloads will work more nicely with this change and others will be
hurt.  Where does the optimum lie?  Don't know.  Nowhere, really.



Frankly, I find it very depressing that the kernel defaults matter.  These
things are trivially tunable and you'd think that after all these years,
distro initscripts would be establishing the settings, based upon expected
workload, amount of memory, number and bandwidth of attached devices, etc.

Heck, there should even be userspace daemons which observe ongoing system
behaviour and which adaptively tune these things to the most appropriate
level.

But nope, nothing.

