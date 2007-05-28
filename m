Return-Path: <linux-kernel-owner+w=401wt.eu-S1761100AbXE1PuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761100AbXE1PuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 11:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbXE1PuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 11:50:12 -0400
Received: from keil-draco.com ([216.193.185.50]:50323 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751175AbXE1PuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 11:50:10 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [RFC] LZO de/compression support - take 6
Date: Mon, 28 May 2007 11:49:55 -0400
User-Agent: KMail/1.9.6
Cc: Nitin Gupta <nitingupta910@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm-cc@laptop.org, linuxcompressed-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Richard Purdie <richard@openedhand.com>, Bret Towe <magnade@gmail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <4cefeab80705280740l36c00bf8t4a6f5b426a7a380a@mail.gmail.com> <20070528153055.GN3899@stusta.de>
In-Reply-To: <20070528153055.GN3899@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705281149.55759.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 May 2007 11:30:55 Adrian Bunk wrote:
> On Mon, May 28, 2007 at 08:10:31PM +0530, Nitin Gupta wrote:
> > Hi,
> >
> > Attached is tester code used for testing.
> > (developed by Daniel Hazelton -- modified slightly to now use 'take 6'
> > version for 'TinyLZO')
> >
> > Cheers,
> > Nitin
> >
> > On 5/28/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> >> (Using tester program from Daniel)
> >>
> >> Following compares this kernel port ('take 6') vs original miniLZO code:
> >>
> >> 'TinyLZO' refers to this kernel port.
> >>
> >> 10000 run averages:
> >> 'Tiny LZO':
> >>        Combined: 61.2223 usec
> >>        Compression: 41.8412 usec
> >>        Decompression: 19.3811 usec
> >> 'miniLZO':
> >>        Combined: 66.0444 usec
> >>        Compression: 46.6323 usec
> >>        Decompression: 19.4121 usec
> >>
> >> Result:
> >> Overall: TinyLZO is 7.3% faster
> >> Compressor: TinyLZO is 10.2% faster
> >> Decompressor: TinyLZO is 0.15% faster
>
> So your the compressor of your version runs 10.2% faster than the
> original version.
>
> That's a huge difference.
>
> Why exactly is it that much faster?

All I've done is write the code used for testing the compressor in userspace, 
but I think it might have something to do with the NOP that cpu_to_le16() is 
on LE systems (the original has an open-coded byte-swap and I don't think it 
ever really gets passed) and the removal of a lot of un-needed casts. 
(version 5 of the code re-introduced one of the macro's that had a lot of 
casts and it showed a drastic slow-down). Anyway, I'm going to get back into 
my testbed and see about actually making a lot of the stuff that is currently 
just a NOP (I made exceedingly minor changes to the files to get the working 
in userspace - one of the changes was to define the kernel-specific macros's 
likely(), unlikely(), noinline and cpu_to_le16() to be NOP's.) into 
functional code. That set of changes may affect the performance and bring it 
closer to the original or it may not.

And the testbed code is open - I guess I should stick the GPL headers in it, 
even though it isn't likely to see much use outside a very small circle. If 
*anyone* is skeptical about the numbers, feel free to use the testbed 
yourself. (It currently only works as intended on LE systems, however) Just 
untar the source into a directory, run make and the run 'tester.pl' to 
actually perform the test runs and gather the numbers. There is no overhead 
included in the numbers - they come directly from running gettimeofday() 
before and after the calls to the respective functions (well, a bit of magic 
is done to make the numbers have meaning).

DRH

PS: the variable '$RUNS' in tester.pl determines how many times the script 
loops each program to generate the numbers. I'm currently using 10000 runs to 
generate the average timings, but if you feel that is too large or too small 
a sample set, go ahead and change it.
