Return-Path: <linux-kernel-owner+w=401wt.eu-S1761962AbYGBEkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761962AbYGBEkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 00:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbYGBEkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 00:40:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbYGBEj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 00:39:59 -0400
Date: Wed, 2 Jul 2008 00:39:35 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: David Miller <davem@davemloft.net>
cc: helge.hafting@aitel.hist.no, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: [10 PATCHES] inline functions to avoid stack overflow
In-Reply-To: <20080625.150931.182895076.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0807020032510.19403@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240136200.27784@engineering.redhat.com>
 <486216E7.8000002@aitel.hist.no> <Pine.LNX.4.64.0806250843460.20379@engineering.redhat.com>
 <20080625.150931.182895076.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Jun 2008, David Miller wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> Date: Wed, 25 Jun 2008 08:53:10 -0400 (EDT)
>
>> Even worse, gcc doesn't use these additional bytes. If you try this:
>>
>> extern void f(int *i);
>> void g()
>> {
>>          int a;
>>          f(&a);
>> }
>>
>> , it allocates additional 16 bytes for the variable "a" (so there's total
>> 208 bytes), even though it could place the variable into 48-byte
>> ABI-mandated area that it inherited from the caller or into it's own
>> 16-byte padding that it made when calling "f".
>
> The extra 16 bytes of space allocated is so that GCC can perform a
> secondary reload of a quad floating point value.  It always has to be
> present, because we can't satisfy a secondary reload by emitting yet
> another reload, it's the end of the possible level of recursions
> allowed by the reload pass.
>
> GCC could be smart and eliminate that slot when it's not used, but
> such a thing is not implemented yet.
>
> It would also require quite a bit of new code to determine cases
> like you mention above, where the incoming arg slots from the
> caller are unused, assuming this would be legal.
>
> And that legality is doubtful.  We'd need to be careful because I
> think the caller is allowed to assume that those slots are untouched
> by the callee, and thus can be assumed to have whatever values the
> caller put there even after the callee returns.

The ABI is very vague about it. The V9 ABI just displays that 6-word space 
in a figure bug doesn't say anything about it's usage. The V8 ABI just 
says that "the function may write incoming arguments there". If it may 
write anything other, it is unknown --- probably yes, but it is not said 
in the document.

The document nicely specifies who owns which registers, but doesn't say 
that about the stack space :-(

Mikulas
