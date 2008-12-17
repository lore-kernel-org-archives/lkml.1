Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752582AbYLQS7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbYLQS7T (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 13:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbYLQS6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 13:58:49 -0500
Received: from gw.goop.org ([64.81.55.164]:33860 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbYLQS6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 13:58:47 -0500
Message-ID: <49494BE4.1070408@goop.org>
Date: Wed, 17 Dec 2008 10:58:44 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        x86@kernel.org, ian.campbell@citrix.com, jbeulich@novell.com,
        joerg.roedel@amd.com
Subject: Re: [PATCH 00 of 14] swiotlb/x86: lay groundwork for xen dom0 use
 of swiotlb
References: <20081216203513.GA14787@elte.hu>	<20081217142637V.fujita.tomonori@lab.ntt.co.jp>	<4949296F.7000701@goop.org> <20081218015705Z.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081218015705Z.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Wed, 17 Dec 2008 08:31:43 -0800
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>>> I think that the whole patchset is against the swiotlb design. swiotlb
>>> is designed to be used as a library. Each architecture implements the
>>> own swiotlb by using swiotlb library
>>> (e.g. arch/x86/kernel/pci-swiotlb_64.c).
>>>   
>>>       
>> The whole patchset?  The bulk of the changes to lib/swiotlb.c are 
>> relatively minor to remove the unwarranted assumptions it is making in 
>> the face of a new user.  They will have no effect on other existing 
>> users, including non-Xen x86 builds.
>>
>> If you have specific objections we can discuss those, but I don't think 
>> there's anything fundamentally wrong with making lib/swiotlb.c a bit 
>> more generically useful.
>>     
>
> Sorry, but the highmem support is not generically useful.
>   

That's a circular argument.   lib/swiotlb currently used by 1 1/2 of the 
23 architectures, neither of which happens to use highmem.  If you 
consider swiotlb to be a general purpose mechanism, then presumably the 
other 21 1/2 architectures are at least potential users (and 6 1/2 of 
those have highmem configurations).  If you base your judgement of 
what's a "generically useful" change based on what the current users 
need, then you'll naturally exclude the requirements of all the other 
(potential) users.

And the matter arises now because we're trying to unify the use of 
swiotlb in x86, bringing the number of users up to 2.

> I'm especially against the highmem support. As you said, the rest
> looks fine but if you go with pci-swiotlb_32.c, I think that you don't
> need the most of them.
>   

I really don't want to have to duplicate a lot of code just to 
incorporate a few small changes.  In fact the original Xen patch set 
included its own swiotlb implementation, and that was rejected on the 
grounds that we should use the common swiotlb.c.

This patch set abstracts out a few more architecture-specific details, 
to allow the common swiotlb logic to be in one place.  By not putting 
highmem support into lib/swiotlb.c, you're effectively saying that we 
should have separate lib/swiotlb-nohighmem.c and lib/swiotlb-highmem.c 
files, with almost identical contents aside from the few places where we 
need to use page+offset rather than a kernel vaddr.

Yes, highmem is ugly, and there'll be cheering in the streets when we 
can finally kill the last highmem user.  But for now we need to deal 
with it, and unfortunately swiotlb is now one of the places that it 
affects.  Its true that adding highmem support to swiotlb.c increases 
the maintenance burden to some extent.  But I can't see an alternative 
that doesn't increase the burden a lot more.

We can look at abstracting things a bit more so that non-highmem 
architectures can keep using simple addresses rather than page+offset, 
but that highmem code has got to be *somewhere*.

>> > have zero effect on the code generated for IA64 or x86-64.  This is not 
>> > really a Xen-specific change, but a result of adding swiotlb support for 
>> > i386.  Other architectures which support a notion of highmem would also 
>> > need this code if they wanted to use swiotlb.
>>     
>
> Can you be more specific? What architecture is plan to use highmem
> support in swiotlb?
>   

Well, concretely, x86-32.  I don't know about the others, but I don't 
see why there's an inherent reason that they won't have a problem that 
swiotlb solves.

    J
