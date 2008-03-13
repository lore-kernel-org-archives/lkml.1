Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbYCMOtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbYCMOtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 10:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbYCMOtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 10:49:14 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:56647 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033AbYCMOtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 10:49:14 -0400
X-Greylist: delayed 1274 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Mar 2008 10:49:13 EDT
Message-Id: <1205418479.9375.1242203645@webmail.messagingengine.com>
X-Sasl-Enc: K31a7Xg4wW/KjybfBGN792cxFUNQ/Znq6wPW85SuFn0G 1205418479
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080309200103.GA895@mailshack.com> <20080313124424.GA18774@skywalker>
Subject: Re: [PATCH] x86: Change x86 to use generic find_next_bit
In-Reply-To: <20080313124424.GA18774@skywalker>
Date: Thu, 13 Mar 2008 15:27:59 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 13 Mar 2008 18:14:24 +0530, "Aneesh Kumar K.V"
<aneesh.kumar@linux.vnet.ibm.com> said:
> On Sun, Mar 09, 2008 at 09:01:04PM +0100, Alexander van Heukelum wrote:
> > x86: Change x86 to use the generic find_next_bit implementation
> > 
> > The versions with inline assembly are in fact slower on the machines I
> > tested them on (in userspace) (Athlon XP 2800+, p4-like Xeon 2.8GHz, AMD
> > Opteron 270). The i386-version needed a fix similar to 06024f21 to avoid
> > crashing the benchmark.
> > 
> > Benchmark using: gcc -fomit-frame-pointer -Os. For each bitmap size 
> > 1...512, for each possible bitmap with one bit set, for each possible 
> > offset: find the position of the first bit starting at offset. If you 
> > follow ;). Times include setup of the bitmap and checking of the 
> > results.
> > 
> > 		Athlon		Xeon		Opteron 32/64bit
> > x86-specific:	0m3.692s	0m2.820s	0m3.196s / 0m2.480s
> > generic:	0m2.622s	0m1.662s	0m2.100s / 0m1.572s
> > 
> > If the bitmap size is not a multiple of BITS_PER_LONG, and no set 
> > (cleared) bit is found, find_next_bit (find_next_zero_bit) returns a 
> > value outside of the range [0,size]. The generic version always returns 
> > exactly size. The generic version also uses unsigned long everywhere, 
> > while the x86 versions use a mishmash of int, unsigned (int), long and 
> > unsigned long.
> 
> This problem is observed on x86_64 and powerpc also.

I'm not entirely sure if it is a problem. In some cases it
certainly is an inconvenience, though ;). I mentioned the
difference between the old and generic versions, because
of the possibility of dependence of this behaviour.

Indeed I see for example (in fs/ext4/mballoc.c).

    bit = mb_find_next_zero_bit(bitmap_bh->b_data, end, bit);
    if (bit >= end)
        break;
    next = mb_find_next_bit(bitmap_bh->b_data, end, bit);
    if (next > end)
        next = end;
    free += next - bit;

So here it needed to adjust the value.

> We need a long
> aligned address for test_bit, set_bit find_bit etc.  In ext4 we have
> to make sure we align the address passed to
> 
> ext4_test_bit
> ext4_set_bit
> ext4_find_next_zero_bit
> ext4_find_next_bit
> 
> fs/ext4/mballoc.c have some examples.

This is a different 'problem'. find_next_bit works on arrays of long,
while the bitmaps in ext4_find_next_bit are of type void * and seem
not to have any alignment restrictions. ext4 implements wrappers
around find_next_bit to solve that 'problem'.

The question that arises is: do we want find_first_bit, find_next_bit.
etc. to always return a value in the range [0, size], or do we want
to allow implementations that return [0, size-1] if there is a bit
found and something else (roundup(size,bitsperlong) or ulongmax, for
example if, none were found?

The current x86_64 versions of find_first_bit and find_next_bit return
roundup(size,bitsperlong) if no bits were found, but on the other hand
I guess most bitmaps are a multiple of bitsperlong bits in size, which
hides the difference.

Greetings,
    Alexander

> -aneesh
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Or how I learned to stop worrying and
                          love email again

