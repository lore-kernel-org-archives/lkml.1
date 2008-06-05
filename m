Return-Path: <linux-kernel-owner+w=401wt.eu-S1759383AbYFEKCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbYFEKCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 06:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757908AbYFEJ5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 05:57:30 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:24328 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052AbYFEJ53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 05:57:29 -0400
Message-Id: <4847D4D0.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 05 Jun 2008 10:58:08 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
Subject: Re: operation ordering during pgd_alloc/pgd_free
References: <4847C54B.76E4.0078.0@novell.com> <4847B177.7070501@goop.org>
In-Reply-To: <4847B177.7070501@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>But I think there's a problem *without* preemption.  
>pmd_prepopulate_pgd() allocates new pmds with GFP_KERNEL, and so it can 
>block, which undermines the precondition of the comment you quote.  This 
>allows an unlisted and unpinned pgd to be missed at save time.  I could 
>just use the freezer unconditionally, but there was some concern about 
>how much time it would take on a busy system.
>
>Alternatively, a different ordering would fix it:
>
>   1. preallocate - but don't install - the pmds
>   2. take pgd_lock
>   3. install pmds into pgd
>   4. insert pgd onto list
>   5. release pgd_lock

... which is precisely what the XenSource tree does.

>> The issue with vmalloc_sync_all() would even go unnoticed, since the
>> patch to unify the pgd_list mechanism with x86-64 removed the
>> BUG_ON() that was meant to trigger on issues like this.
>>   
>
>Is there an inherent reason vmalloc_sync_all can't deal with a partially 
>constructed pgd?  Couldn't it just skip them, as if it wasn't (or 
>rather, not yet) on the list?  In fact, that looks like what it does now.

It could be made so, but it doesn't at present - it exits the inner loop
when vmalloc_sync_one() returns NULL. The intention here is that if
the reference page table has a clear entry at some level, then there
shouldn't be any attempt to look at other page tables' entries mapping
the same va (and because it would be an error if page table other than
the reference one had a clear entry where the reference one didn't,
there was that BUG_ON() that your patch removed). Since the purpose
of vmalloc_sync_all() is to catch partially populated page tables, allowing
it to skip such that are under construction would need a way to
distinguish them from such being fully constructed but out of sync.

Jan

