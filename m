Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbZF3WwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbZF3WwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbZF3Wv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:51:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:39249 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbZF3Wv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:51:59 -0400
Message-ID: <4A4A96F7.4010302@kernel.org>
Date: Tue, 30 Jun 2009 15:51:35 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Mikael Pettersson <mikpe@it.uu.se>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
 x86
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se> <19013.29264.623540.275538@pilspetsen.it.uu.se> <4A45A5C1.5080701@zytor.com> <19013.59956.144640.331854@pilspetsen.it.uu.se> <20090629022911.GC20297@lackof.org> <4A484A8A.9020704@zytor.com> <19016.41349.636663.515540@pilspetsen.it.uu.se> <20090629112155.GJ5480@parisc-linux.org> <19016.44061.600652.676183@pilspetsen.it.uu.se> <4A490804.3040609@zytor.com> <4A494478.7020304@kernel.org> <4A494E3C.70304@kernel.org> <4A495C0D.2020807@zytor.com> <4A4966EF.6010809@kernel.org> <alpine.LFD.2.01.0906291820060.3605@localhost.localdomain> <4A496D4B.3040608@kernel.org> <19017.53428.834539.389495@pilspetsen.it.uu.se> <4A4A25B1.5010102@zytor.com> <4A4A6888.30001@kernel.org> <4A4A6B1C.7030405@zytor.com> <4A4A701F.3050700@kernel.org> <4A4A81C9.9070008@zytor.com> <4A4A88A2.7010509@kernel.org> <alpine.LFD.2.01.0906301456170.3605@localhost.localdomain> <4A4A921F.7080100@kernel.org>
In-Reply-To: <4A4A921F.7080100@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Linus Torvalds wrote:
>> On Tue, 30 Jun 2009, Yinghai Lu wrote:
>> ?
>>> +#define round_up(x, y) ({ __typeof__(x) __mask = (y)-1; \
>>> +			 ((x)+__mask) & ~__mask; })
>>> +#define round_down(x, y) ({ __typeof__(x) __mask = (y)-1; (x) & ~__mask; })
>> Yes, except we might as well simplify it. Do it without the statement 
>> expressions, using just a single 'y'. Like this:
>>
>>   #define __round_mask(x,y) ((__typeof__(x))((y)-1))
>>   #define round_up(x,y) (((x) | __round_mask(x,y))+1)
>>   #define round_down(x,y) ((x) & ~__round_mask(x,y))
>>
>> (Yeah, it uses 'x' twice, but the second one is for 'typeof', which 
>> doesn't actually cause the value to be evaluated, so it's ok).
>>
>> Now those 'round_xyz()' operations will always return a value of a type 
>> that is the same as the type of 'x' except it's gone through the normal C 
>> integer promotion rules (ie if 'x' is a smaller type than 'int', then it 
>> will be promoted to 'int').
>>
>> Not very well tested, but it _looks_ correct, and uses Peter's trick, and 
>> willlet the compiler notice that
>>
>> 	round_up(x,y)-1
>>
>> is the same thing as
>>
>> 	x | (y-1)
>>
>> which it _could_ have perhaps figured out before, but now it's way more 
>> obvious.
> 
> how about x = 0, y = 0x100?
> 

also x=0x100000, and y=0x100?

YH
