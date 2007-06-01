Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbXFAJu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbXFAJu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 05:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757465AbXFAJuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 05:50:20 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1700 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460AbXFAJuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 05:50:19 -0400
Message-ID: <465FEBD3.7020801@shadowen.org>
Date: Fri, 01 Jun 2007 10:50:11 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andy Whitcroft <apw@shadowen.org>, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steve Fox <drfickle@us.ibm.com>
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464ADA5D.8050405@shadowen.org> <464B2048.7040103@zytor.com> <20070516174046.GE10225@skynet.ie> <464B9573.8030407@zytor.com> <Pine.LNX.4.64.0705171013560.27336@skynet.skynet.ie> <465CAA86.5020402@shadowen.org>
In-Reply-To: <465CAA86.5020402@shadowen.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> Mel Gorman wrote:
>> On Wed, 16 May 2007, H. Peter Anvin wrote:
>>
>>> Correction, does *this patch* do it for you?
>>>
>> With these two patches in combination, previously failing machines
>> elm3b6 (x86_64 on test.kernel.org) and a modern x86 built a kernel and
>> booted correctly.
>>
>> elm3b132 and elm3b132 (x86 numaq on test.kernel.org) built with these
>> patches but silently fail on boot with no output via earlyprintk.
>> According to test.kernel.org, this failure occurs with git-newsetup
>> reverted so it is a separate problem.
> 
> Ok, I've been following up on this failure on elm3b132/3.  I moved
> forward to v2.6.22-rc2-mm1 and that also fails.  I ran a bisection on
> the git-newsetup patch in as in -mm and basically it came down to the
> first patch, ie. any and all of this tree stops the boot.
> 
> I just tried reproducing git-newsetup boot failures with the latest
> version of your tree (369f16fdd423d79640c4390915e6ab71189cb497) and that
> also fails.
> 
> Fails in this context is hard boot failure after loading the kernel and
> before anything is printed.  I also added a printf to the top of main()
> in boot/main.c and it doesn't come out, not that I really know if that
> means it got there or not.
> 
> Any suggestions how to debug this puppy?

Thanks to Peter for all his encouragement off list.

I cannot claim to have sorted this one out, I do however understand why
my experiences and Mels did not seem consistent.  Basically I am getting
inconsistent results with different machines.

I started my debug on a machine where 2.6.22-rc2 which worked and
2.6.22-rc2+newsetup which did not.  I debugged the latter and managed to
prove that it was in fact getting all the way to the kernel
decompressor, and then crashing hard.  The gzip image in memory was
intact and yet it did not decrypt correctly, the first about 60% was
intact, the remainder was damaged.

Suspecting that this was an "uncompress in place" overlap problem I
moved the compressed kernel way up out of the way and this then booted
successfully.  Experimenting I was able to get it to boot by increasing
the overlap 'gap' from 32KB's to 64KB's.  I was able to use the same
patch to boot 2.6.22-rc2-mm1 on the same problems machines. However,
this same overlap change did not fix another similar machine (the one in
the TKO grid).

I think that my debugging says that newsetup got the compressed kernel
and decompressor into memory ok and execution passed to it normally.
But I cannot figure out where the corruption is coming from.  I tried
annotating the gzip decompressor to see if the input and output buffers
were overlapping at any time and that debug said no (unsure how reliable
that is).  And yet at some point the output image is munched up.

One last piece of information.  The decompressor also always seems to
get to the end of the input stream in exactly the right place without
reporting any kind of error, that is with exactly 8 bytes left over for
the length and crc checks.  Which given the context sensitive nature of
the algorithm tends to imply the input stream was ok for the whole
duration of the decompress.  Yet the output stream is badly broken.

Anyone got any wacky suggestions ...

-apw
