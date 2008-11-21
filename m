Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbYKUQm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbYKUQm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYKUQmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:42:18 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:50307 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbYKUQmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:42:18 -0500
Message-ID: <4926E499.4070706@caviumnetworks.com>
Date: Fri, 21 Nov 2008 08:40:57 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>, gcc@gcc.gnu.org
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-mips <linux-mips@linux-mips.org>, linux-kernel@vger.kernel.org,
       Adam Nemet <anemet@caviumnetworks.com>
Subject: Re: [PATCH] MIPS: Make BUG() __noreturn.
References: <49260E4C.8080500@caviumnetworks.com> <20081121100035.3f5a640b@lxorguk.ukuu.org.uk> <Pine.LNX.4.64.0811211126420.26004@anakin>
In-Reply-To: <Pine.LNX.4.64.0811211126420.26004@anakin>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Nov 2008 16:40:58.0010 (UTC) FILETIME=[EE148FA0:01C94BF7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Fri, 21 Nov 2008, Alan Cox wrote:
>> On Thu, 20 Nov 2008 17:26:36 -0800
>> David Daney <ddaney@caviumnetworks.com> wrote:
>>
>>> MIPS: Make BUG() __noreturn.
>>>
>>> Often we do things like put BUG() in the default clause of a case
>>> statement.  Since it was not declared __noreturn, this could sometimes
>>> lead to bogus compiler warnings that variables were used
>>> uninitialized.
>>>
>>> There is a small problem in that we have to put a magic while(1); loop to
>>> fool GCC into really thinking it is noreturn.  
>> That sounds like your __noreturn macro is wrong.
>>
>> Try using __attribute__ ((__noreturn__))
>>
>> if that works then fix up the __noreturn definitions for the MIPS and gcc
>> you have.
> 
> Nope, gcc is too smart:
> 
> $ cat a.c
> 
> int f(void) __attribute__((__noreturn__));
> 
> int f(void)
> {
> }
> 
> $ gcc -c -Wall a.c
> a.c: In function f:
> a.c:6: warning: `noreturn' function does return
> $ 
> 

That's right.

I was discussing this issue with my colleague Adam Nemet, and we came
up with a couple of options:

1) Enhance the _builtin_trap() function so that we can specify the
   break code that is emitted.  This would allow us to do something
   like:

static inline void __attribute__((noreturn)) BUG()
{
	__builtin_trap(0x200);
}

2) Create a new builtin '__builtin_noreturn()' that expands to nothing
   but has no CFG edges leaving it, which would allow:

static inline void __attribute__((noreturn)) BUG()
{
	__asm__ __volatile__("break %0" : : "i" (0x200));
	__builtin_noreturn();
}


David Daney
