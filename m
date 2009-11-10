Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbZKJTZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbZKJTZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 14:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757819AbZKJTZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 14:25:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:42975 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757854AbZKJTZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 14:25:50 -0500
Message-ID: <4AF9BE3A.40409@kernel.org>
Date: Wed, 11 Nov 2009 04:25:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
References: <4AF90254.40909@kernel.org> <alpine.LFD.2.01.0911100903370.31845@localhost.localdomain> <4AF9B1FD.1010408@kernel.org> <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Linus Torvalds wrote:
> On Wed, 11 Nov 2009, Tejun Heo wrote:
>> If I'm missing something, I'm sure you'll hammer it into me.
> 
> Here's from the comments on that function:
> 
>  * RETURNS:
>  * 0 if noop, 1 if successfully extended, -errno on failure.
> 
> and here's from one of the main callers:
> 
>                 list_for_each_entry(chunk, &pcpu_slot[slot], list) {
> 		...
>                         switch (pcpu_extend_area_map(chunk, &flags)) {
>                         case 0:
>                                 break;
>                         case 1:
>                                 goto restart;   /* pcpu_lock dropped, restart */
> 
> where that '&pcpu_slot[slot]' list is protected by the pcpu_lock, and 
> nothing else. At least according to all the _other_ comments in that file. 
> Including the one that very much tries to _explain_ the locking at the 
> top, quote:

Oh, yeah, right.  I was too fixated on the part modified by the patch.

>   "The latter is a spinlock and protects the index data structures - chunk 
>    slots, chunks and area maps in chunks."
> 
> So as far as I can tell, either the comments are all crap, the whole 
> restart code is pointless and in fact the whole spin-lock is seemingly 
> almost entirely pointless to begin with (since pcpu_alloc_mutex is the 
> only thing that matters), or the code is buggy.

The return value is wrong but it wouldn't lead to oops.  There's a
very slight chance that it might end up creating extra chunk when not
necessary - probably why it went unnoticed all this time.  The
spin-lock is only to allow free_percpu() to be called from atomic
context, so its usefulness would only be visible if you look at
free_percpu() too.

> Also, quite frankly, even if the code _isn't_ buggy, it's still wrong to 
> release a lock that somebody else took. It's a sure-fire way to write 
> unmaintainable code with bugs almost guaranteed in the future. Yes, it 
> happens, and sometimes it's the only sane way to do it, but in this case 
> that really isn't true as far as I can tell.
> 
> From my (admittedly fairly quick) look, my suggested split-up really would 
> make the code _more_ readable (no need for that subtle "negative, zero or 
> positive all mean different things" logic), and hopefully avoid the whole 
> "drop the lock that somebody else took", because we could drop it in the 
> caller where it was taken.
> 
> So it all boils down to: the code is unquestionably ugly and almost 
> certainly broken. And if it isn't broken, then _all_ the comments are 
> total crap. 

Yeap, the return value definitely is broken and the rather ugly
calling convention is remanant from the days when there was only
single mutex protecting the whole thing.

I think this type of function is a bit special in locking requirement
tho.  The initial step - checking whether the operation is necessary -
requires lock and the final step - copying over to the new thing and
installing it - also requires the lock, so unless there's one
unnecessary unlock/lock pair, the second function would be called
without lock but return with lock, which probably is safer than
releasing and regrabbing lock in the middle but still not quite
pretty.

In this case, as the second function needs to release to free the old
map, the extra unlock/lock pair is actually necessary.  Splitting into
two functions is fine but I think it would be better to fix it first
and then split them in following patches so that it can be bisected if
I screw up while splitting, right?

Thanks.

-- 
tejun
