Return-Path: <linux-kernel-owner+w=401wt.eu-S1760749AbXGJUIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760749AbXGJUIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756015AbXGJUIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:08:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:57066 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbXGJUIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:08:35 -0400
In-Reply-To: <4693AA56.9040109@zytor.com>
References: <11840359321823-git-send-email-hpa@zytor.com> <11840373002601-git-send-email-hpa@zytor.com> <108510B6-B9BE-49D4-BDCA-E25CA20CB29B@kernel.crashing.org> <200707101721.58937.ak@suse.de> <4693AA56.9040109@zytor.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <551EA412-3D35-4BCD-ACAE-B6A7BE3CBF9B@kernel.crashing.org>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Content-Transfer-Encoding: 7bit
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [x86 setup 13/33] Header file to produce 16-bit code with gcc
Date: Tue, 10 Jul 2007 22:08:21 +0200
To: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> gcc for i386 can be used with the assembly prefix ".code16gcc" to
>>>> generate
>>>> 16-bit (real-mode) code.  This header file provides the assembly
>>>> prefix.
>>> This only works correctly with newer GCCs if you pass the
>>> -fno-toplevel-reorder option (and it only works on older
>>> GCC versions by accident).
>>
>> And on older ones (gcc-3.3-hammer / 3.4 / 4.0 ) -fno-unit-at-a-time
>>
>> Still it seems quite fragile to me agreed.
>
> The alternative, of course, is to compile to an .s file and insert
> .code16gcc into the .s file.  This makes the Makefile uglier, but  
> would
> be more resilient against oddball gcc changes.

This would be even more fragile.  The exact format of GCC's
assembler code output isn't defined at all, so in principle
this is a hopeless task.  In practice just putting the
.code16gcc directive on the first line would likely work
though, GCC never generates a .code32 AFAIK, but it isn't
guaranteed that this will work (or will keep working).

> I'm a bit surprised about the claim w.r.t. -fno-unit-at-a-time  
> (although
> I guess that is the default and one would thus typically not see  
> this.)

-fno-unit-at-a-time is the default on three year old compilers,
yes.  Newer compilers have unit-at-a-time enabled by default.

>  Got any pointers why that would cause a global asm() to be scrambled
> around?

An asm() outside of a function is a top-level thing, just
like functions and file-scope variable definitions, and with
unit-at-a-time compilation all such blocks can be reordered
(or even omitted, or inlined, or whatever).  Note that even
before unit-at-a-time was introduced there was no guarantee
of emitting everything in the order it appears in the source
file.


Segher

