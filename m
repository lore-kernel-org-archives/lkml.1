Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbXHBFOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbXHBFOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 01:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbXHBFN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 01:13:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48875 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751139AbXHBFNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 01:13:55 -0400
Date: Wed, 1 Aug 2007 22:13:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, Eric Moore <Eric.Moore@lsi.com>,
       DL-MPTFusionLinux@lsi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       support@lsi.com, mpt_linux_developer@lsi.com,
       linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] Fix two potential mem leaks in MPT Fusion
 (mpt_attach())
Message-Id: <20070801221342.d1f0db35.akpm@linux-foundation.org>
In-Reply-To: <20070802030350.GF21219@parisc-linux.org>
References: <200708020155.33690.jesper.juhl@gmail.com>
	<20070801172653.1fd44e99.akpm@linux-foundation.org>
	<20070802030350.GF21219@parisc-linux.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007 21:03:50 -0600 Matthew Wilcox <matthew@wil.cx> wrote:

> On Wed, Aug 01, 2007 at 05:26:53PM -0700, Andrew Morton wrote:
> > Why on earth is that using GFP_ATOMIC?  This function later goes on to
> > create procfs files and such things.
> 
> Seems fairly common in driver initialisation code.  I removed three
> instances of this in the advansys driver.

hrm.  People reach for GFP_ATOMIC so often that it becomes a habit, I guess.

It makes one wonder how much that lovely fault-injection framework is being
used.


> > y'know, we could have a debug option which will spit warnings if someone
> > does a !__GFP_WAIT allocation while !in_atomic() (only works if
> > CONFIG_PREEMPT).  
> > 
> > But please, make it depend on !CONFIG_AKPM.  I shudder to think about all
> > the stuff it would pick up.
> 
> Seems like you'd get a lot of false positives.

There would be a few.  mempool does a non-__GFP_WAIT allocation
deliberately, for example (I still think that's fishy btw).

But I don't expect there would be a large number of falsies.  We could add
a __GFP_I_REALLY_MEANT_ATOMIC flag to shut those up.

>  How about a call:
> 
> slab_warn_about_atomic_allocs();
> 
> right before calling the initcalls, and then
> 
> slab_stop_warning_about_atomic_allocs();
> 
> after calling them?  That should give people a lot to chew on for a few
> months.  Obviously, you would need to not warn about allocations from
> interrupt context, as you say above.

Could.  But GFP_ATOMIC at initcall-time really isn't a problem (except that
it can probably also happen at modprobe-time).

What is the major concern is needlessly atomic allocations at regular
runtime.

