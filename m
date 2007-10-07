Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbXJGPpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbXJGPpR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 11:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbXJGPpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 11:45:04 -0400
Received: from gw.goop.org ([64.81.55.164]:55346 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbXJGPpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 11:45:03 -0400
Message-ID: <4708F5FF.8090104@goop.org>
Date: Sun, 07 Oct 2007 08:06:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep: how to tell it multiple pte locks is OK?
References: <47087D45.2010904@goop.org> <1191745762.5602.5.camel@lappy>
In-Reply-To: <1191745762.5602.5.camel@lappy>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
>>
>> I presume this is because I'm holding multiple pte locks (class
>> "__pte_lockptr(new)").  Is there some way I can tell lockdep this is OK?
>>     
>
> Yeah, the typical way is to use spin_lock_nested(lock, nesting_level),
> this allows one to annotate these nestings. However, nesting_level must
> not be larger than 8, so if your batch is larger than that, we have a
> problem.
>   

Yeah, my batches are up to about 32.

>> I'm presume I'm the first person to try holding multiple pte locks at
>> once, so there's no existing locking order for these locks. 
>>     
>
> Not quite, things like copy_pte_range() take 2.
>   

Hm, and it uses SINGLE_DEPTH_NESTING...

>>  I'm always
>> traversing and locking the pagetable in virtual address order (and this
>> seems like a sane-enough rule for anyone else who wants to hold multiple
>> pte locks).
>>     
>
> I'm quite sure copy_pte_range() could be used so that it violates that
> order.
>   

Good point.   It's not a problem for me because they're two ptes in
different pagetables, whereas my multiple ptes are always within the
same pagetable.  Someone wanting to lock multiple ptes from multiple
pagetables would have a more complex locking order problem.
(Or if we end up sharing ptes between pagetables it might get tricky.)

    J
