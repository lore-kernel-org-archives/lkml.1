Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbYCJRcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbYCJRcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 13:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbYCJRb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 13:31:56 -0400
Received: from gw.goop.org ([64.81.55.164]:33562 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbYCJRbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 13:31:55 -0400
Message-ID: <47D57056.3050204@goop.org>
Date: Mon, 10 Mar 2008 10:31:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andi Kleen <andi@firstfloor.org>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de> <20080309111456.GA21690@elte.hu> <20080309210000.C6DE.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080309120940.GA1695@elte.hu> <20080309123432.GA3267@elte.hu> <20080309114640.85c9c3eb.akpm@linux-foundation.org> <Pine.LNX.4.64.0803100851560.23575@schroedinger.engr.sgi.com> <87myp68r88.fsf@basil.nowhere.org> <Pine.LNX.4.64.0803101707070.3398@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0803101707070.3398@blonde.site>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Mon, 10 Mar 2008, Andi Kleen wrote:
>   
>> Christoph Lameter <clameter@sgi.com> writes:
>>     
>>> Zeroed pages however will not address the issue of having initialized pgd 
>>> (which seems to be what i386 needs).
>>>       
>> pgd is tiny on i386 PAE (4 * 16 bytes). Are you sure reinitializing that
>> is a serious issue? ...
>>     
>
> It used to be tiny (32 aligned bytes), then 2.6.22's quicklist enlarged
> that to a whole (lowmem) page.  I think we were all too busy with other
> stuff to protest loudly enough about that bloat.
>   

Yes, I was surprised about the pgd page allocation.  It's currently 
necessary for Xen (but I think I can fix that easily enough).  But I was 
especially surprised it was imposed for everyone.

> If the quicklists are going, it'd be good for PAE to go back to a
> kmem_cache of 32-byte entries as in 2.6.21 - I think Ingo's patch is
> still using a whole page there.
>   

+1.  We'd still need to maintain a list to link all the pgds together, 
but I think we can just allocate that out of the cache too (either the 
same object or a separate pgd list cache).

> Or have sl?b alignment changes, or virtualization issues (locking
> per underlying struct page?), made a kmem_cache awkward there now?
>   
I think only Xen has a constraint.  At the moment we rely on page-sized 
pgds for two things:

   1. Xen marks the whole page as being of pgd-type, and so it can't
      have non-pgd contents (as the page would be RO, and any contents
      would be validated as pgd entries).  However I can fix that by
      maintaining a separate per-cpu pgd page, and just copy the four
      entries over when cr3 is reloaded.  This would move the
      Xen-specific requirements into the Xen code without affecting the
      rest of the kernel.
   2. We still need to maintain a list of pgds, as I discussed above.

So from my perspective there are no insoluble problems, and I'd fully 
support the transition.

I've been working on unifying the pgalloc stuff, and the quicklist 
(i386) vs non-quicklist (x86-64) use has been a bit of a thorn in my 
side.  Of course there'll still be the page-sized pgd vs non-page-sized 
pgd, but we just have to live with that.

    J
