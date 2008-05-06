Return-Path: <linux-kernel-owner+w=401wt.eu-S932694AbYEFU2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbYEFU2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbYEFU2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:28:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754545AbYEFU2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:28:36 -0400
Date: Tue, 6 May 2008 13:27:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: acpi_cpu_freq_init warning...
In-Reply-To: <20080506202033.GA3114@suse.de>
Message-ID: <alpine.LFD.1.10.0805061325270.32269@woody.linux-foundation.org>
References: <86802c440805051951u153ebc21p15f0d73904496217@mail.gmail.com> <87k5i8hrmk.fsf@duaron.myhome.or.jp> <alpine.LFD.1.10.0805060741290.32269@woody.linux-foundation.org> <87skwvcl2a.fsf@duaron.myhome.or.jp> <20080506202033.GA3114@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 May 2008, Greg KH wrote:

> On Wed, May 07, 2008 at 04:02:53AM +0900, OGAWA Hirofumi wrote:
> > Linus Torvalds <torvalds@linux-foundation.org> writes:
> > 
> > > On Tue, 6 May 2008, OGAWA Hirofumi wrote:
> > >> -	if ((drv->entry.next != drv->entry.prev) ||
> > >> +	if ((drv->entry.next != drv->entry.prev) &&
> > >>  	    (drv->entry.next != NULL)) {
> > >
> > > Umm. That code still makes no sense.
> > >
> > > The "drv->entry.next == drv->entry.prev" condition will trigger under 
> > > *three* different circumstances:
> > >
> > >  - next/prev == NULL (uninitialized). Checked for by the explicit check 
> > >    against NULL.
> > >
> > >  - list empty (both next/prev point back to itself), which I assume the 
> > >    check was *meant* for.
> > >
> > >  - list has only *one* entry, when next/prev both point to the list head.
> > >
> > > and I'm pretty damn sure that whoever wrote that code didn't mean that 
> > > last one, but who knows..
> > >
> > > The fact is, looking at next/prev this way is a sure way to have bugs.
> > >
> > > What is that PoS *trying* to test for? I assume it is meant to test for
> > >
> > > 	/* Is the list initialized and non-empty? */
> > > 	if (drv->entry.next && !list_empty(&drv->entry)) {
> > > 		...
> > >
> > > and dammit, just doing it that way is shorter and simpler.
> 
> But I don't think that will work as others have pointed out, this
> structure's list field isn't initialized yet.

Umm. And what do you think the test for drv->entry.next is there for?

Ie the assumption is that it's at least zeroed out, if it's not 
initialized. 

Now, admittedly it could be *total* crud, but if so, I'd seriously suggest 
just fixing the callers, rather than passing totally uninitialized 
structures with random crap in it around.

			Linus
