Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbZHZUrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbZHZUrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbZHZUrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:47:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbZHZUrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:47:46 -0400
Message-ID: <4A95A10C.5040008@redhat.com>
Date: Wed, 26 Aug 2009 23:54:36 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Justin M. Forbes" <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 13/12] ksm: fix munlock during exit_mmap deadlock
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils> <Pine.LNX.4.64.0908031317190.16754@sister.anvils> <20090825145832.GP14722@random.random> <20090825152217.GQ14722@random.random> <Pine.LNX.4.64.0908251836050.30372@sister.anvils> <20090825181019.GT14722@random.random> <Pine.LNX.4.64.0908251958170.5871@sister.anvils> <20090825194530.GU14722@random.random> <Pine.LNX.4.64.0908261910530.15622@sister.anvils> <20090826194444.GB14722@random.random> <Pine.LNX.4.64.0908262048270.21188@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0908262048270.21188@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Wed, 26 Aug 2009, Andrea Arcangeli wrote:
>   
>> All is left to address is to teach page_alloc.c that the mm is going
>> away in a second patch. That might also help when it's aio triggering
>> gup page allocations or other kernel threads with use_mm just like ksm
>> and the oom killer selected those "mm" for release.
>>
>> Having ksm using use_mm before triggering the handle_mm_fault (so
>> tsk->mm points to the mm of the task) and adding a MMF_MEMDIE to
>> mm->flags checked by page_alloc would work just fine and should solve
>> the double task killed... but then I'm unsure.. this is just the first
>> idea I had.
>>     
>
> Yes, I began to have thoughts along those lines too as I was writing
> my reply.  It is a different angle on the problem, I hadn't looked at
> it that way before, and it does seem worth pursuing.  MMF_MEMDIE, yes,
> that might be useful.  But KSM_RUN_UNMERGE wouldn't be able to use_mm
> since it's coming from a normal user process - perhaps it should be a
> kill-me-first like swapoff via PF_SWAPOFF.
>
> Hugh
>   
About the KSM case:
The oom should work on problomatic processes, such that allocate big 
amount of memory.
But then as we now plane it to be, what might be a just fine application 
that used ksm and told it to stop merge it pages, might be what 
considered "bad application that need to be killed"

Is this what we really want?

But before getting into this, why is it so important to break the ksm 
pages when madvise(UNMERGEABLE) get called?

When thinking about it, lets say I want to use ksm to scan 2 
applications and merged their STATIC identical data, and then i want to 
stop scanning them after i know ksm merged the pages, as soon as i will 
try to unregister this 2 applications ksm will unmerge the pages, so we 
dont allow such thing for the user (we can tell him ofcurse for such 
case to use normal way of sharing, so this isnt a really strong case for 
this)
