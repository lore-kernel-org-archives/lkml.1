Return-Path: <linux-kernel-owner+w=401wt.eu-S1758981AbYEIWdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981AbYEIWdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 18:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbYEIWdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 18:33:45 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:45808 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbYEIWdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 18:33:44 -0400
Message-ID: <4824D141.9060609@freescale.com>
Date: Fri, 09 May 2008 17:33:37 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Calling free_pages on part of the memory returned by get_free_pages?
References: <480D032E.20204@freescale.com> <87r6cvxdd4.fsf@basil.nowhere.org>
In-Reply-To: <87r6cvxdd4.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Timur Tabi <timur@freescale.com> writes:
> 
>> According to LDD3, if I call get_free_pages() to allocate X bytes, I have to
>> free all of those pages with free_pages().  The VM internals are a little bit
>> over my head, but I looked at the code and I didn't see why that is a requirement.
>>
>> For example, let's say I want to allocated 6MB of physically-contiguous memory.
>>  If I call x = get_free_pages(11) to get 8MB.  What happens if I then do
>> "free_pages(x + 6 * 1024 * 1024, 9)"?
>>
>> I remember doing this on the 2.4 kernel, and it never gave me any problems.
> 
> It is ok, as long as you don't use compound pages (__GFP_COMP) and call
> split_page() to fix up the reference counts.
> 
> Also you do this to save memory right? The large system hash code does it too
> and I used to do it in some 2.4 change with an alloc_pages_exact()
> which never made it into 2.6.
> 
> If it's reasonably common we should re-add alloc/get_pages_exact() helper to 
> make this pattern clear and easier to use.

Follow-up question:

Say I allocate 8MB with __get_free_pages() and then use multiple free_pages() /
split_page() calls to free the last 3MB.  Will the de-allocated blocks be merged
into larger-order chunks, if they're contiguous?  That is, if I repeat this process:

1. Allocate 8MB
2. Free 3MB
3. Free 5MB

over and over again, will I totally fragment memory to the point that 8MB
allocates will never work again?

-- 
Timur Tabi
Linux kernel developer at Freescale
