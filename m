Return-Path: <linux-kernel-owner+w=401wt.eu-S1758071AbXFOU0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbXFOU0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbXFOU0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:26:12 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38959 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbXFOU0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:26:11 -0400
Message-ID: <4672F5DF.7070506@zytor.com>
Date: Fri, 15 Jun 2007 13:26:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Optimize is_power_of_2().
References: <1181926602.25193.5.camel@grianne> <4672D89D.7010801@zytor.com> <Pine.LNX.4.64.0706151427370.12949@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0706151427370.12949@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Fri, 15 Jun 2007, H. Peter Anvin wrote:
> 
>> Vegard Nossum wrote:
>>> From: Vegard Nossum <vegard@peltkore.net>
>>> Date: Fri, 15 Jun 2007 18:35:49 +0200
>>> Subject: [PATCH] Optimize is_power_of_2().
>>>
>>> Rationale: Removes one conditional branch and reduces icache
>>> footprint. Proof: If n is false, the product of n and any value is
>>> false. If n is true, the truth of (n * x) is the truth of x.
>> You realize that on a lot of platforms, multiplication is done by an
>> out-of-line subroutine, and that even on those that aren't, it's
>> generally a long-pipeline operation, right?
> 
> i was *just* about to mention somthing of the sort, but probably not
> as succinctly.
> 

You also realize, I hope, that obfuscating this for the compiler just
hurts.  As has already been described, there are versions involving
jumps, selects, multiplication, tables, ffs, and popcount.  All of those
operations are hideously expensive on some architectures and cheap on
others.

Personally, I would bet that the version as originally written is
probably best, since select (conditional move) is a fairly commonly
supported operation, especially on architectures where jumps are expensive.

Just to confuse the situation further, here is yet another version:

bool is_power_of_2(unsigned long n)
{
	return !!n & !(n & (n-1));
}

... which, on i686 compiles to:
00000000 <is_power_of_2>:
   0:   85 c0                   test   %eax,%eax
   2:   8d 50 ff                lea    0xffffffff(%eax),%edx
   5:   0f 95 c1                setne  %cl
   8:   85 d0                   test   %edx,%eax
   a:   0f 94 c0                sete   %al
   d:   0f b6 c0                movzbl %al,%eax
  10:   21 c8                   and    %ecx,%eax
  12:   c3                      ret

In the current version, gcc does generate a jump on i686 and x86-64:

00000000 <is_power_of_2>:
   0:   89 c2                   mov    %eax,%edx
   2:   31 c0                   xor    %eax,%eax
   4:   85 d2                   test   %edx,%edx
   6:   74 0b                   je     13 <is_power_of_2+0x13>
   8:   8d 42 ff                lea    0xffffffff(%edx),%eax
   b:   85 c2                   test   %eax,%edx
   d:   0f 94 c0                sete   %al
  10:   83 e0 01                and    $0x1,%eax
  13:   f3 c3                   repz ret

	-hpa

