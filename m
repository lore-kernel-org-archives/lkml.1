Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbZGCTav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbZGCTav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 15:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbZGCTao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 15:30:44 -0400
Received: from claw.goop.org ([74.207.240.146]:35003 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197AbZGCTan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 15:30:43 -0400
Message-ID: <4A4E5C66.1090206@goop.org>
Date: Fri, 03 Jul 2009 12:30:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: lkml@MoreThan.org
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [Bug Fix]: Do 32-bit table calculations in pre-processor
References: <200907031314.36243.lkml@morethan.org> <200907031338.24778.lkml@morethan.org> <4A4E5738.6080407@goop.org> <200907031413.17556.lkml@morethan.org>
In-Reply-To: <200907031413.17556.lkml@morethan.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/09 12:13, Michael S. Zick wrote:
> On Fri July 3 2009, Jeremy Fitzhardinge wrote:
>   
>> On 07/03/09 11:38, Michael S. Zick wrote:
>>     
>>> I make no claims for it at the moment - too early in the test process.
>>> Just the general observation that it takes 0.5M to describe 0.5G of ram.
>>>   
>>>       
>> Only if you're using 4k pages.  With large pages, 1 pte can map 2M, so
>> 256 entries can map 512M, so you only need 1/2 a page of pagetable
>> (assuming PAE; if not a single entry can map 4M).
>>
>>     
>
> Ah, but you can't assume that - look at your VIA-C7M tech sheet - NO PAE.
>   

According to
http://www.via.com.tw/en/products/processors/c7-m/secure_by_design.jsp,
it supports NX, which means it must support PAE.

But even without PAE, it can still support PSE (large pages).

> Try ending the filename in ".S" and passing it to gcc, 
> like the build system does.
>   

It doesn't make any difference.  After going through cpp the expression is:

    # 62 "/home/jeremy/git/linux/arch/x86/kernel/head_32.S"
    MAPPING_BEYOND_END = (((((1<<32) - 0xC0000000) >> 12) / 512) + 4) << 12
      

which will be evaluated by the assembler.   The C preprocessor doesn't
evaluate expressions in the source; it only ever does substitutions and
leaves the results for the compiler/assembler to evaluate.  (It evals
expressions on cpp # lines, of course, but that's not relevant here.)

    J
