Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbXCPHu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbXCPHu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 03:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932244AbXCPHu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 03:50:58 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:39994 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932247AbXCPHu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 03:50:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=X7nk61k7puF9DXIaQg/xg6pRdlnkSY7cpVGUuL0ntNJ4dgAupp2gJn7nm6nqI3coNt4EfB/SGhmTmDw7qB1kJXVjp4DpCzr+fJK6H+HEDi9/zdUaokB0vi3GuArd9I6YChQemDwKRYOa3YKPRcJ7LP4eCxSTeHmPSkAV1j/lksU=  ;
X-YMail-OSG: dWcnqb4VM1lqq.h6xwBZeP5gQQsyMrkFQh6ewOhWenS9ANwb7WR1qXPMSL2tq_Di8OqIARqchAKXO9KbDrO9f87CrcXTnm5_mICB2WnxrcL3bdZ3LyVVpxRVrt46Ksa036fvbpmRD8SC2AVBACSq1gOFFvVk7WrN7g--
Message-ID: <45FA4C59.1000908@yahoo.com.au>
Date: Fri, 16 Mar 2007 18:50:49 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] revoke: misc fixes
References: <Pine.LNX.4.64.0703160916430.14651@sbz-30.cs.Helsinki.FI> <45FA458C.8050605@yahoo.com.au> <Pine.LNX.4.64.0703160927240.14902@sbz-30.cs.Helsinki.FI> <45FA4984.9000506@yahoo.com.au> <Pine.LNX.4.64.0703160943460.15253@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0703160943460.15253@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg wrote:
> Hi Nick,
> 
> On Fri, 16 Mar 2007, Nick Piggin wrote:
> 
>>Could you try something like walk the i_mmap lists to find mms with vmas that
>>haven't need revoking, then each time you find one, take a ref on the mm, drop
>>i_mmap_lock, take mmap_sem, and walk all its vmas looking for any that
>>reference the inode?
> 
> 
> Yes, that would work. What I am cooking up now is dropping 
> ->i_mmap_lock, restarting the scan after each revoke_vma() and skipping 
> vmas that are VM_REVOKED.

Of course you can't take a reference to a vma, so to pin a vma you need
the mmap_sem, and to do that you need to drop i_mmap_lock, which means
your vma might go away ;)

So I think you really do need to get back to the mm, and then search its
vmas.

Also, a down_write_trylock attempt inside i_mmap_lock should be a valid
optimisation.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
