Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbYFTQKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbYFTQKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 12:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYFTQKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 12:10:10 -0400
Received: from gw.goop.org ([64.81.55.164]:45301 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbYFTQKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 12:10:09 -0400
Message-ID: <485BD65F.6010600@goop.org>
Date: Fri, 20 Jun 2008 09:10:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [PATCH] i386: fix vmalloc_sync_all() for Xen
References: <48591049.76E4.0078.0@novell.com> <485969A4.6090406@goop.org> <485A465D.76E4.0078.0@novell.com> <485A7122.8090200@goop.org> <485A9EF5.76E4.0078.0@novell.com> <485AA296.6070008@goop.org> <485B712C.76E4.0078.0@novell.com>
In-Reply-To: <485B712C.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>> I think it would be better to separately test whether the vmalloc 
>> mapping is present in the init_mm and skip the syncing loop in that 
>> case, rather than this somewhat convoluted logic to overload the test in 
>> vmalloc_sync_one.
>>     
>
> That's what the x86-64 code does. When I wrote this originally, I tried
> to keep the pre-existing logic as much as possible, so I split out
> vmalloc_sync_one() by mostly moving existing code. I certainly agree
> that this has room for cleaning up (and then possibly including unification
> with x86-64).
>   

Yep.  I think the first step should be to simplify the code to remove 
all the insync/start optimisations and just implement it in a very 
straightforward way.  I can't see any way this code could be even 
slightly performance critical.

>> with respect to any other pgd you pass in.  So I don't think the BUG_ON 
>> will ever fire, and it's unclear what actual logical property it's 
>> testing for.
>>     
>
> My point of adding the BUG_ON() is that in vmalloc_sync_all() it is not
> clear that vmalloc_sync_one() can fail only due to init_mm's page table
> not being appropriately populated. So yes, this BUG_ON() is not
> expected to ever fire - but isn't that a property of all BUG_ON()'s?

Uh, I guess that's one way of putting it.  The other is that it tests 
for an obscure condition that's indirectly related to something that 
might indicate a bug if the code were written differently.  A good 
BUG_ON/assert acts as documentation because it tells the reader about 
the expected logical state at that point, but it needs to be expressed 
in terms which are directly relevant to the algorithm in question.

    J

