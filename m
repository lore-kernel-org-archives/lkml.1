Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbYDCFaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbYDCFaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 01:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbYDCF3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 01:29:54 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:44891 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752005AbYDCF3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 01:29:53 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2008 01:29:53 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FYhAKt2rqbP31z2laHgthfyb+/JSOo3ILYm4DM+gSrrWmrfLKFiAGB+gBvmBodMN0pcXYpxjRlsedMavngeRDDZpsBK8/eYUdviv83OM6PoSw/Skzw5fW76VU4bcsxysS3CXAfgshLbjZVDyvRWkUAKP2wq06W730d3M+cBnTx0=  ;
X-YMail-OSG: e_fpaHQVM1nNJEEeG4Vpo.uH.nidTL3HVv4_ok3.7XClau1XkRCeFhjY3a8C7sjPUcy_jElGlg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: GFP_ATOMIC page allocation failures.
Date: Thu, 3 Apr 2008 16:22:26 +1100
User-Agent: KMail/1.9.5
Cc: Chris Snook <csnook@redhat.com>, Dave Jones <davej@codemonkey.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
References: <20080401235609.GA6947@codemonkey.org.uk> <200804022012.58760.nickpiggin@yahoo.com.au> <20080402085437.7d9abf1f.akpm@linux-foundation.org>
In-Reply-To: <20080402085437.7d9abf1f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804031622.26973.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 April 2008 02:54, Andrew Morton wrote:
> On Wed, 2 Apr 2008 20:12:58 +1100 Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > On Wednesday 02 April 2008 18:56, Andrew Morton wrote:
> > > > Limiting this to once per boot should suffice for debugging purposes.
> > > > Even if you manage to concoct a bug that always survives the first
> > > > failure, you should be able to take the hint when you keep seeing
> > > > this in dmesg.
> > >
> > > The appropriate thing to do here is to convert known-good drivers (such
> > > as e1000[e]) to use __GFP_NOWARN.
> > >
> > > Unfortunately netdev_alloc_skb() went and assumed GFP_ATOMIC, but I
> > > guess we can dive below the covers and use __netdev_alloc_skb():
> >
> > It's still actually nice to know how often it is happening even for
> > these known good sites because too much can indicate a problem and
> > that you could actually bring performance up by tuning some things.
>
> Yes, it's useful debugging.  It tells us when we mucked up the page
> allocator.

Right.


> It also tells us when we mucked up the net driver - I doubt if we (or at
> least, I) would have discovered that e1000 does a 32k allocation for a
> 5k(?) frame if this warning wasn't coming out.

Is that right? If it is allocating for 9K MTU, then the slab allocator
(slub in this case) will bump that up to the 16K kmalloc slab. If it is
a 5K frame, then it would get the 8K kmalloc slab I think.

Oh, but SLUB's default MIN_OBJECTS is 4, so 4*8 is 32 indeed. So slub
is probably deciding to round the kmalloc-8192 allocations up to order-3.
I think. How did you know it was a 5k frame? :)

