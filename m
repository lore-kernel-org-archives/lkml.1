Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbXFKN7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbXFKN7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 09:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbXFKN7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 09:59:11 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3972 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXFKN7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 09:59:10 -0400
Message-ID: <466D550C.4030600@shadowen.org>
Date: Mon, 11 Jun 2007 14:58:36 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steve Fox <drfickle@us.ibm.com>
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464ADA5D.8050405@shadowen.org> <464B2048.7040103@zytor.com> <20070516174046.GE10225@skynet.ie> <464B9573.8030407@zytor.com> <Pine.LNX.4.64.0705171013560.27336@skynet.skynet.ie> <465CAA86.5020402@shadowen.org> <465FEBD3.7020801@shadowen.org> <4660A7E0.6070600@zytor.com> <4665AD8B.80506@shadowen.org> <4665EA4F.2090004@zytor.com> <4667D4BC.2020806@shadowen.org>
In-Reply-To: <4667D4BC.2020806@shadowen.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> H. Peter Anvin wrote:
>> Andy Whitcroft wrote:
>>>> It definitely sounds like a memory clobber of some sort.
>>>>
>>>> Usual suspects, in addition to the input/output buffers you already
>>>> looked at, would be the heap and the stack.  Finding where the stack
>>>> pointer lives would be my first, instinctive guess.
>>> The stack seems to be where it should be and seems to stay pretty much
>>> in the same place as it should.  Adding checks for the heap also seem to
>>> stay within bounds.  I've tried making the stack and the heap 64k to no
>>> effect.
>>>
>>> Moving the kernel to other places in memory seems to kill the decode
>>> completely during gunzip() which may be a hint I am not sure.
>>>
>>> This thing is trying to ruin my mind.
>>>
>> Yours and mine both.  Seems like *something* is clobbering memory, but
>> what and why is a mystery.  The fact that putting the kernel in a higher
>> point in memory is a good indication that this clobber is at a
>> relatively high address.
>>
>> How much RAM does this machine have?
> 
> This is as 12GB machine.  3 numa nodes.
> 
> I checked out the location of the IDT and GDT and both seem sane, in the
> 9xxxx range below the kernel destination.
> 
> I also note that on another machine of this type, one Node only in that
> case some of the "did work" cases do not work.  Also when I applied some
> of my patches on the top "working" cases stopped working.  So whatever
> it is is definatly related to the shape of the kernel to be loaded.
> Very confusing.

Ok, in fact when the kernel is moved elsewhere in the address space it
will decode properly.  There was a check in there for not loading at the
right address which was catching me out ... as errors do not show up as
we have no serial support.  Doh.

Once I had gotten this decoding at other addresses I simply tried moving
the base address for the kernel elsewhere.  I am able to successfully
boot the kernel at 16MB and 256MB.  This seems like something outside
the decoder scribbling.

I would not normally recommend moving the base address of the kernel.
However, this problem at least so far has only shown up on the NUMA-Q
platform which is at best described as a very small volume
sub-architecture.  There are areas in which it differers from mainstream
BIOS and we are no longer able to get details of these differences.

We actually have no proof as yet this is or is not a NUMA-Q specific
problem.  For instance these machines tend to run less modules and more
builtin stuff than the average due to an owner dislike of modules.  So
we could have a lurking kernel size issue or similar.

I am therefore proposing change the base address for NUMA-Q only (patch
to follow this email).  And that we remain aware of the issue and on the
lookout for similar breakage on mainstream x86 platforms.  At least with
this patch we can get wider testing on the rest of the kernel.

-apw
