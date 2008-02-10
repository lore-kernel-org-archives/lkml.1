Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbYBJQud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbYBJQud (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 11:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYBJQu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 11:50:26 -0500
Received: from www.tglx.de ([62.245.132.106]:48354 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbYBJQuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 11:50:25 -0500
Date: Sun, 10 Feb 2008 17:50:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [3/5] CPA: Make advised protection check truly
 advisory
In-Reply-To: <87myq9i2xk.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.1.00.0802101156220.12988@apollo.tec.linutronix.de>
References: <20080208536.837219990@suse.de> <20080208163614.DF4FC1B41AA@basil.firstfloor.org> <alpine.LFD.1.00.0802091602260.3145@apollo.tec.linutronix.de> <200802091756.06553.ak@suse.de> <alpine.LFD.1.00.0802091809480.3145@apollo.tec.linutronix.de>
 <87myq9i2xk.fsf@basil.nowhere.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Feb 2008, Andi Kleen wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
> 
> > 2) I care about RO as much as I care about the NX correctness. That's
> > the same logic and the same problem. If we have overlapping regions,
> > then we need to split large pages. Otherwise both protections are
> > useless to a certain degree.
> 
> That's laudable of you if you care about that so deeply, but then please just
> fix try_preserve_large_page() to do that correctly.

Done already :)

Btw. it's not a question of laudability. It's a question of
correctness.

Writing a piece of code, which has a thinko in the first place, is not
correct, but we are all humans and miss a detail from time to time.

What you did is far more than incorrect: 

You discovered the bug, you did not point it out upfront and you hid
an alleged fix in a bunch of changes, which happen to be around the
same area. And at the very end you ignore my objections against your
buggy fix by handwaving about your init_memory_mapping() cleanups.

> But I suspect you will need some sort of range check for this anyways 
> so applying  my patchkit as the foundation for your fix is probably
> not a bad idea. I hope we can agree on the simple fact that without
> ranges large pages cannot be handled correctly.

To fix the try_preserve_large_page() problem a range check is not
necessary at all. A range check, if done right, might optimize it.

For the proposed cleanup of init_memory_mapping() I tend to agree,
that a range check might be useful.

> > 3) For correctness reasons I even ponder to make the NX/RO mandatory.
> 
> That might make sense for cpa, but is not a good idea for 
> sharing these checks with init_memory_mapping() which was the main goal
> for my patchkit. I plan to do some further changes in that 
> area, but that first requires sharing of that code.
>
> There you don't want to get into the mess of handling 4K pages for these 
> boundaries because they are later split up anyways by cpa for the DEBUG_RODATA
> case. You've previously complained about other code reimplementing
> pageattr code and doing fine grained 4K splits in init_memory_mapping()
> would be exactly that so I assume you wouldn't like that either.
> 
> That is why I only wanted to apply the required checks there,
> to leave the exact work for later.
> 
> You have not previously commented on that aspect so I assume
> it's ok for you.

I can see the requirement for a range check for the kind of cleanup
you want to do and it's fine with me to modify static_protections() in
a way which allows us to do range checks and share that code. 

It just needs to be correct, while your so called fix is not even
close to correct.

To verify the incorrectness, lets apply the first two patches:

[PATCH] [1/5] CPA: Split static_protections into required_static_prot and advised_static_prot
[PATCH] [2/5] Support range checking for required/advisory protections

we get:

static inline int
within_range(unsigned long addr_start, unsigned long addr_end,
             unsigned long start, unsigned long end)
{
       return addr_end >= start && addr_start < end;
}

advised_static_prot(pgprot_t prot, unsigned long start, unsigned long end)
{
      if (within_range(start, end, (unsigned long)__start_rodata,
                      (unsigned long)__end_rodata)
                pgprot_val(forbidden) |= _PAGE_RW;

       prot = __pgprot(pgprot_val(prot) & ~pgprot_val(forbidden));
       return prot;
}

Called with:

   prot = advised_static_prot(prot | _PAGE_RW,
   	  		      (unsigned long)__start_rodata - PAGE_SIZE,
   	  		      (unsigned long)__end_rodata + PAGE_SIZE - 1);

ends up with the check for:

     (__end_rodata + PAGE_SIZE - 1) >= __start_rodata &&
     (__start_rodata - PAGE_SIZE) < __end_rodata

Which evaluates to true. So we write protect one page before the RO
section and one page after the RO section. 

How does this fix the incorrectness exactly ?

The next patch
[PATCH] [3/5] CPA: Make advised protection check truly advisory

morphes advised_static_prot() into:

advised_static_prot(pgprot_t prot, unsigned long start, unsigned long end)
{
      if (within_range((unsigned long)__start_rodata,
                      (unsigned long)__end_rodata,
                      start, end))
                pgprot_val(forbidden) |= _PAGE_RW;

       prot = __pgprot(pgprot_val(prot) & ~pgprot_val(forbidden));
       return prot;
}

Called with:

   prot = advised_static_prot(prot | _PAGE_RW,
   	  		      (unsigned long)__start_rodata - PAGE_SIZE,
   	  		      (unsigned long)__end_rodata + PAGE_SIZE - 1);
This results in:

     __end_rodata >= (__start_rodata - PAGE_SIZE) &&
     __start_rodata < (__end_rodata + PAGE_SIZE - 1)

which evaluates to true as well. So we still write protect one page
before the RO section and one page after the RO section. Probably not
what we want either, right ?

>From the changelog:

"Only force RO in the advisory protection checks when all pages in the 
range are RO. Previously it would trigger when any page in the range
was ro.
I believe this will make try_preserve_large_page much safer to use."

I had a reason to ask, whether you believe it or you are sure about
it. The changelog is so ludicrously detached from the code change,
that one needs to ask, whether you added it to the right patch.

The only change of this commit is:

    (end_range >= start_test_range) && (start_range < end_test_range)

becomes

    (end_test_range >= start_range) && (start_test_range < end_range)

which is the same as:

    (end_range > start_test_range) && (start_range <= end_test_range)

So you just moved the "or equal" check to the other side, which does
not really change the behaviour of your code significantly, except for
one off corner cases.

Also the correctness of the order of arguments to within_range(), which is
btw. a horrible misleading function name, should have been clear in
the first place, when introducing it and converting the exisiting code
to use it.

Are you still convinced, that it would be a good idea to apply your
patches as a foundation for a fix, which takes 5 lines of code to be
correct ?

Thanks,

	tglx
