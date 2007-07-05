Return-Path: <linux-kernel-owner+w=401wt.eu-S1762846AbXGEU5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762846AbXGEU5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760289AbXGEU5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:57:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758902AbXGEU5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:57:44 -0400
Message-ID: <468D5B28.8080308@redhat.com>
Date: Thu, 05 Jul 2007 16:57:12 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Jiri Kosina <jkosina@suse.cz>, Jakub Jelinek <jakub@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Kratochvil <honza@jikos.cz>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Ernie Petrides <petrides@redhat.com>
Subject: Re: [PATCH][RESEND] PIE randomization
References: <alpine.LRH.0.98.0705111338230.22353@twin.jikos.cz> <20070511125629.3df919cf.akpm@linux-foundation.org> <Pine.LNX.4.64.0705112211440.16923@twin.jikos.cz> <20070511133651.63f8a14d.akpm@linux-foundation.org> <Pine.LNX.4.64.0705120048230.11493@jikos.suse.cz> <Pine.LNX.4.64.0705161851120.25986@twin.jikos.cz> <alpine.LRH.0.98.0705172221440.22353@twin.jikos.cz> <20070522161642.b71ddacb.akpm@linux-foundation.org> <Pine.LNX.4.64.0705231044540.22906@jikos.suse.cz> <20070704082554.GQ7012@devserv.devel.redhat.com> <Pine.LNX.4.64.0707041927090.11634@jikos.suse.cz> <468D5A3A.1010306@redhat.com>
In-Reply-To: <468D5A3A.1010306@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> On 07/04/2007 01:35 PM, Jiri Kosina wrote:
>> On Wed, 4 Jul 2007, Jakub Jelinek wrote:
>>
>>> The above highlighted changes are the cause of random segfaults of PIE 
>>> binaries.  See 
>>> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=246623 
>> Thanks a lot for pointing this out. Andrew, could this be folded into 
>> pie-randomization.patch please?
>>
>>
>> From: Jiri Kosina <jkosina@suse.cz>
>>
>> pie randomization: fix BAD_ADDR macro
>>
>> pie-randomization.patch makes the load_addr in load_elf_interp() the load 
>> bias of ld.so (difference between the actual load base address and first 
>> PT_LOAD segment's p_vaddr). If the difference equals (on x86) to 
>> 0xfffff000 (which is valid [1]), SIGSEGV is incorrectly sent.
>>
>> This patch changes the BAD_ADDR so that it catches the mappings to the 
>> error-area properly.
> 
> But what about this patch that made the opposite change:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ce51059be56f63762089412b3ece348067afda85

Ohhh, interesting.

So the original patch has:

#define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)

For some reason(?) it got changed to the clearly buggy:

#define BAD_ADDR(x) ((unsigned long)(x) >= PAGE_MASK)

Jiri's patch undoes that second buggy define, which is very
different from the original that was sent in by you and Ernie.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
