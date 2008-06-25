Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbYFYMxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbYFYMxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 08:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbYFYMxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 08:53:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187AbYFYMxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 08:53:33 -0400
Date: Wed, 25 Jun 2008 08:53:10 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Helge Hafting <helge.hafting@aitel.hist.no>
cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: [10 PATCHES] inline functions to avoid stack overflow
In-Reply-To: <486216E7.8000002@aitel.hist.no>
Message-ID: <Pine.LNX.4.64.0806250843460.20379@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240136200.27784@engineering.redhat.com>
 <486216E7.8000002@aitel.hist.no>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008, Helge Hafting wrote:

> Mikulas Patocka wrote:
>> Hi
>> 
>> Here I'm sending 10 patches to inline various functions.
>> 
>> To give you some understanding of sparc64, every function there uses big 
>> stack frame (at least 192 bytes). 128 bytes are required by architecture 
>> (16 64-bit registers), 48 bytes are there due to mistake of Sparc64 ABI 
>> designers (calling function has to allocate 48 bytes for called function) 
>> and 16 bytes are some dubious padding.
> I guess there is no way around those 128 bytes required by hardware - but
> is it necessary to allocate the 48 bytes of "mistake" and the dubious 
> padding?
>
> Linux kernel functions don't call any outside functions, and are not called 
> from
> outside either. So violating the ABI should be ok - there is nothing else to
> be compatible to. Similiar to how x86 experimented with --mregparm to get
> a little more performance from changing the kernel calling convention. 
> Helge Hafting

So, ask gcc developers to do kernel-specific ABI with only 128-byte stack 
frame.

BTW. could some gcc developer explain the reason for additional 16-bytes 
on stack on sparc64? 64-bit ABI mandates 176 bytes, but gcc allocates 192 
bytes.

Even worse, gcc doesn't use these additional bytes. If you try this:

extern void f(int *i);
void g()
{
         int a;
         f(&a);
}

, it allocates additional 16 bytes for the variable "a" (so there's total 
208 bytes), even though it could place the variable into 48-byte 
ABI-mandated area that it inherited from the caller or into it's own 
16-byte padding that it made when calling "f".

Mikulas
