Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbYFSAiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbYFSAiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbYFSAiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 20:38:11 -0400
Received: from gw.goop.org ([64.81.55.164]:48471 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755971AbYFSAiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 20:38:11 -0400
Message-ID: <4859AA47.2020903@goop.org>
Date: Wed, 18 Jun 2008 17:37:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: benh@kernel.crashing.org, xen-devel <xen-devel@lists.xensource.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel <kvm-devel@lists.sourceforge.net>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1 of 4] mm: add a ptep_modify_prot transaction abstraction
References: <b020e42384197b824320.1213615800@localhost> <1213831403.8011.24.camel@pasglop> <4859A149.9090004@goop.org> <4859A528.1010107@goop.org> <alpine.LFD.1.10.0806181723400.2907@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806181723400.2907@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Wed, 18 Jun 2008, Jeremy Fitzhardinge wrote:
>   
>> Along the lines of:
>>     
>
> Hell no. There's a reason we have a special set_wrprotect() thing. We can 
> do it more efficiently on native hardware by just clearing the bit 
> atomically. No need to do the cmpxchg games.
>   

It's not cmpxchg, just xchg. 

In other words, is:

	lock btr $_PAGE_BIT_RW, (%rbx)

much cheaper than

	mov	$0, %rax
	xchg	%rax, (%rbx)
	and	$~_PAGE_RW, %rax
	mov	%rax, (%rbx)

?

It's the same number of locked RMW operations, so aside from being a few 
instructions longer, I think it would be much the same.

I guess the correct answer is "lmbench".

    J
