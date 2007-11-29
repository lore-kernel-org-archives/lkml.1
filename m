Return-Path: <linux-kernel-owner+w=401wt.eu-S932615AbXK2RuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615AbXK2RuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760880AbXK2RuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:50:08 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:57131 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760818AbXK2RuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:50:06 -0500
Date: Thu, 29 Nov 2007 09:44:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Daniel Drake <dsd@gentoo.org>
Cc: linux-kernel@vger.kernel.org, avuton@gmail.com, hancockr@shaw.ca,
       alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, mrmacman_g4@mac.com,
       dean@arctic.org, argggh@dolphinics.no, jengelh@computergmbh.de,
       shdl@zakalwe.fi, vlobanov@speakeasy.net, drzeus-list@drzeus.cx,
       strange@nsk.no-ip.org, dm.n9107@gmail.com, johannes@sipsolutions.net
Subject: Re: [RFC v2] Documentation about unaligned memory access
Message-Id: <20071129094426.47226ccd.randy.dunlap@oracle.com>
In-Reply-To: <20071129161523.E0C349D4B52@zog.reactivated.net>
References: <20071129161523.E0C349D4B52@zog.reactivated.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 16:15:23 +0000 (GMT) Daniel Drake wrote:

> Assuming there aren't too many comments/suggestions on this revision, the
> next version will be submitted for inclusion as
> Documentation/unaligned_memory_access.txt

I just have a few typo/punctuation/grammar fixes.  Otherwise it looks
good to me.  Thanks.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> Natural alignment
> =================
> 
> The rule mentioned above forms what we refer to as natural alignment:
> When accessing N bytes of memory, the base memory address must be evenly
> divisible by N, i.e. addr % N == 0

add ending '.'

> Why unaligned access is bad
> ===========================
> 
> The effects of performing an unaligned memory access vary from architecture
> to architecture. It would be easy to write a whole document on the differences
> here; a summary of the common scenarios is presented below:
> 
>  - Some architectures are able to transparently perform unaligned memory
>    accesses, but there is usually a significant performance cost.

(remove split infinitive:)

   - Some architecture are able to perform unaligned memory accesses
     transparently, but ...

>  - Some architectures raise processor exceptions when unaligned accesses
>    happen. The exception handler is able to correct the unaligned access,
>    at significant cost to performance.
>  - Some architectures raise processor exceptions when unaligned accesses
>    happen, but the exceptions do not contain enough information for the
>    unaligned access to be corrected.
>  - Some architectures are not capable of unaligned memory access, but will
>    silently perform a different memory access to the one that was requested,
>    resulting a a subtle code bug that is hard to detect!
> 
> It should be obvious from the above that if your code causes unaligned
> memory accesses to happen, your code will not work correctly on certain
> platforms and will cause performance problems on others.

> Code that causes unaligned access
> =================================
> 
> With the above in mind, let's move onto a real life example of a function
> that can cause an unaligned memory access. The following function adapted
> from include/linux/etherdevice.h is an optimized routine to compare two
> ethernet MAC addresses for equality.
> 
> unsigned int compare_ether_addr(const u8 *addr1, const u8 *addr2)
> {
> 	const u16 *a = (const u16 *) addr1;
> 	const u16 *b = (const u16 *) addr2;
> 	return ((a[0] ^ b[0]) | (a[1] ^ b[1]) | (a[2] ^ b[2])) != 0;
> }
> 
> In the above function, the reference to a[0] causes 2 bytes (16 bits) to
> be read from memory starting at address addr1. Think about what would happen
> if addr1 was an odd address such as 0x10003. (Hint: it'd be an unaligned
> access)

  access.)


> Avoiding unaligned accesses
> ===========================
> 
> The easiest way to avoid unaligned access is to use the get_unaligned() and
> put_unaligned() macros provided by the <asm/unaligned.h> header file.
> 
> Going back to an earlier example of code that potentially causes unaligned
> access:
> 
> 	void myfunc(u8 *data, u32 value)
> 	{
> 		[...]
> 		*((u32 *) data) = cpu_to_le32(value);
> 		[...]
> 	}
> 
> To avoid the unaligned memory access, you would rewrite it as follows:
> 
> 	void myfunc(u8 *data, u32 value)
> 	{
> 		[...]
> 		value = cpu_to_le32(value);
> 		put_unaligned(value, data);
> 		[...]
> 	}
> 
> The get_unaligned() macro works similarly. Assuming 'data' is a pointer to
> memory and you wish to avoid unaligned access, its usage is as follows:
> 
> 	u32 value = get_unaligned(data);
> 
> These macros work work for memory accesses of any length (not just 32 bits as
> in the examples above). Be aware that when compared to standard access of
> aligned memory, using these macros to access unaligned memory can be costy in

costly

> terms of performance.



---
~Randy
