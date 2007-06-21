Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbXFUUib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbXFUUib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbXFUUiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:38:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39563 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097AbXFUUiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:38:21 -0400
Date: Thu, 21 Jun 2007 13:36:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Chuck Ebbert <cebbert@redhat.com>, Jarek Poplawski <jarkao2@o2.pl>,
       Miklos Szeredi <miklos@szeredi.hu>, chris@atlee.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
In-Reply-To: <20070621201816.GE22303@elte.hu>
Message-ID: <alpine.LFD.0.98.0706211325540.3593@woody.linux-foundation.org>
References: <20070620093612.GA1626@ff.dom.local>
 <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org>
 <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org>
 <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com>
 <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org>
 <20070621201816.GE22303@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Jun 2007, Ingo Molnar wrote:
> 
> yeah. I think Linux is i think the only OS on the planet that is using 
> the movb trick for unlock, it even triggered a hardware erratum ;)

I'm pretty sure others do it too.

Maybe not on an OS level (but I actually doubt that - I'd be surprised if 
Windows doesn't do the exact same thing), but I know for a fact that a lot 
of people in threaded libraries end up depending very much on the "simple 
store closes a locked section".

Just googling for "xchg" "mov" "spinlock" "-linux" shows discussion boards 
for Windows developers with open-coded spinlocks like


	int ResourceFlag = 0; // 0=Free, 1=Inuse
	...
	// Wait until we get the resource
	while(InterlockedExchange(&ResourceFlag, 1) != 0) {
	   Sleep(0); } // Wait a tad
	// Have the resource
	... // do your thing
	ResourceFlag = 0; // Release the resource


and that's definitely Windows code, not some Linux person doing it.

And this is from an OS2 forum

	unsigned owned=0;

	void request() {
	  while(LockedExchanged(&owned,1)!=0)
	    ;
	}

	void release() {
	  owned = 0;
	}

so it's not even something unusual.

So while arguably these people don't know (and don't care) about subtle 
issues like memory ordering, I can *guarantee* that a lot of programs 
depend on them, even if that dependency may often come from a lack of 
knowledge, rather than actively understanding what we do like in the Linux 
kernel community.

(And yes, they rely on compilers not reordering either. Tough.)

		Linus
