Return-Path: <linux-kernel-owner+w=401wt.eu-S937019AbXHOWpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937019AbXHOWpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 18:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937209AbXHOWn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 18:43:59 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:23672 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937207AbXHOWn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 18:43:57 -0400
Message-ID: <46C38156.8060502@oracle.com>
Date: Wed, 15 Aug 2007 18:42:30 -0400
From: Chuck Lever <chuck.lever@oracle.com>
Reply-To: chuck.lever@oracle.com
Organization: Corporate Architecture, Linux Projects Group
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Eliminate result signage problem in asm-x86_64/bitops.h
References: <20070815204939.3518.63203.stgit@monet.1015granger.net> <20070815210247.3518.89243.stgit@monet.1015granger.net> <20070815222355.GA5069@one.firstfloor.org>
In-Reply-To: <20070815222355.GA5069@one.firstfloor.org>
Content-Type: multipart/mixed;
 boundary="------------040708000500070701000904"
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040708000500070701000904
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

I apologize for sending a separate cover letter for a single patch.

Andi Kleen wrote:
> On Wed, Aug 15, 2007 at 05:02:47PM -0400, Chuck Lever wrote:
>> The return type of __scanbit() doesn't match the return type of
>> find_{first,next}_bit().  Thus when you construct something like
>> this:
>>
>>    boolean ? __scanbit() : find_first_bit()
> 
> Why would you want to write this?  What is boolean?
> Do they have different arguments?

So here's the definition of the x86_64 find_first_bit() macro, straight 
from include/x86_64/bitops.h:

#define find_first_bit(addr,size) \
((__builtin_constant_p(size) && (size) <= BITS_PER_LONG ? \
   (__scanbit(*(unsigned long *)addr,(size))) : \
   find_first_bit(addr,size)))

In this case "boolean" is:

    __builtin_constant_p(size) && (size) <= BITS_PER_LONG

the first arm of the conditional is:

    __scanbit(*(unsigned long *)addr,(size))

the second arm of the conditional is:

    find_first_bit(addr,size)

(this is the "function" version of find_first_bit, not the macro that's 
being defined.  The naming here is unfortunately confusing).

Thus, roughly speaking, when the type of "size" is smaller than a long, 
the macro's return type evaluates to unsigned long.  If "size" is larger 
than a long, the macro's return type evaluates to signed long.

By making the return type of __scanbit() an unsigned long, both arms of 
the conditional evaluate to the same result type.

> It's on my todo list for some time to special case
> f_f_b() and friends for smaller arguments. Would
> that eliminate this construct?

Well, I can only assume what you mean by this, but I think that would 
address the problem.

My real interest here is to eliminate a whole lot of compiler noise when 
I enable -Wsign-compare for certain parts of the kernel.

--------------040708000500070701000904
Content-Type: text/x-vcard; charset=utf-8;
 name="chuck.lever.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="chuck.lever.vcf"

begin:vcard
fn:Chuck Lever
n:Lever;Chuck
org:Oracle Corporation;Corporate Architecture: Linux Projects Group
adr:;;1015 Granger Avenue;Ann Arbor;MI;48104;USA
title:Principal Member of Staff
tel;work:+1 248 614 5091
x-mozilla-html:FALSE
url:http://oss.oracle.com/~cel
version:2.1
end:vcard


--------------040708000500070701000904--
