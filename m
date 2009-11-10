Return-Path: <linux-kernel-owner+w=401wt.eu-S1757675AbZKJSzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbZKJSzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 13:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757655AbZKJSzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 13:55:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757651AbZKJSzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 13:55:31 -0500
Date: Tue, 10 Nov 2009 10:54:27 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tejun Heo <tj@kernel.org>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
In-Reply-To: <4AF9B1FD.1010408@kernel.org>
Message-ID: <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain>
References: <4AF90254.40909@kernel.org> <alpine.LFD.2.01.0911100903370.31845@localhost.localdomain> <4AF9B1FD.1010408@kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Nov 2009, Tejun Heo wrote:
> 
> If I'm missing something, I'm sure you'll hammer it into me.

Here's from the comments on that function:

 * RETURNS:
 * 0 if noop, 1 if successfully extended, -errno on failure.

and here's from one of the main callers:

                list_for_each_entry(chunk, &pcpu_slot[slot], list) {
		...
                        switch (pcpu_extend_area_map(chunk, &flags)) {
                        case 0:
                                break;
                        case 1:
                                goto restart;   /* pcpu_lock dropped, restart */

where that '&pcpu_slot[slot]' list is protected by the pcpu_lock, and 
nothing else. At least according to all the _other_ comments in that file. 
Including the one that very much tries to _explain_ the locking at the 
top, quote:

  "The latter is a spinlock and protects the index data structures - chunk 
   slots, chunks and area maps in chunks."

So as far as I can tell, either the comments are all crap, the whole 
restart code is pointless and in fact the whole spin-lock is seemingly 
almost entirely pointless to begin with (since pcpu_alloc_mutex is the 
only thing that matters), or the code is buggy.

Also, quite frankly, even if the code _isn't_ buggy, it's still wrong to 
release a lock that somebody else took. It's a sure-fire way to write 
unmaintainable code with bugs almost guaranteed in the future. Yes, it 
happens, and sometimes it's the only sane way to do it, but in this case 
that really isn't true as far as I can tell.

>From my (admittedly fairly quick) look, my suggested split-up really would 
make the code _more_ readable (no need for that subtle "negative, zero or 
positive all mean different things" logic), and hopefully avoid the whole 
"drop the lock that somebody else took", because we could drop it in the 
caller where it was taken.

So it all boils down to: the code is unquestionably ugly and almost 
certainly broken. And if it isn't broken, then _all_ the comments are 
total crap. 

Your choice. 

			Linus
