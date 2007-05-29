Return-Path: <linux-kernel-owner+w=401wt.eu-S1765912AbXE2Udz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765912AbXE2Udz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932167AbXE2UdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:33:17 -0400
Received: from keil-draco.com ([216.193.185.50]:50709 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760925AbXE2UdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:33:15 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 6
Date: Tue, 29 May 2007 16:33:10 -0400
User-Agent: KMail/1.9.6
Cc: "Bret Towe" <magnade@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm-cc@laptop.org, linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Richard Purdie" <richard@openedhand.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <4cefeab80705282258p570c649aja5a60b82f63c2440@mail.gmail.com> <200705291614.34504.dhazelton@enter.net>
In-Reply-To: <200705291614.34504.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705291633.10903.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 May 2007 16:14:34 Daniel Hazelton wrote:
> On Tuesday 29 May 2007 01:58:43 Nitin Gupta wrote:
> > On 5/29/07, Bret Towe <magnade@gmail.com> wrote:
> > > tested this on ppc and its still good
> > >
> > > is there any reason to bother with a test on amd64?
> > > if there is I might be able to get to it tonight
> >
> > Yes, this test is desired on 'take 6'
> > (In future I will append version to patch bz2)
> >
> > Thanks,
> > Nitin
>
> I added a few functions to my test-bed to see how well the LZO code coped
> with random input data. I'll extend my error checking so that it dumps all
> local variables at the first error, but for the time being I'm staring at a
> problem with what appears to be a double-free (in addition to
> lzo1x_decompress(_safe) screaming about overruns when I pass it the buffer
> of compressed, totally random data).
>
> (I fill the buffer by doing a read from /dev/urandom, though I'll certainly
> change it to use random() if anyone thinks that'll make a difference)
>
> I'll post the version with the random-data tests when I get the double-free
> solved. (I've looked and don't see how its happening)
>
> DRH

After some additional debugging the problem appears to be that both 
lzo1x_decompress_safe (from miniLZO) and lzo1x_decompress (from the 'Tiny' 
version) both are somehow corrupting memory.

*** glibc detected *** ./tinytest: double free or corruption (out): 0x08070e60 
***

The buffer at 0x08070e60 is the one I allocated specifically for the new 
random data tests. It has the same location when it is allocated as it is 
when free()'d, so the corruption has to be coming from somewhere. The problem 
*might* be in my code - that is, I might have made a mistake in the read() 
from /dev/urandom. I'm going to go test that now.

DRH
