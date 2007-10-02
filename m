Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbXJBWeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbXJBWeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 18:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbXJBWeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 18:34:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbXJBWeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 18:34:07 -0400
Message-ID: <4702C756.8090108@redhat.com>
Date: Tue, 02 Oct 2007 18:33:58 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: =?ISO-8859-1?Q?Anders_Bostr=F6m?= <anders@bostrom.dyndns.org>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       torvalds@linux-foundation.org
Subject: Re: PROBLEM: high load average when idle
References: <20071002.233731.119908363.anders@bostrom.dyndns.org> <20071002150748.906970bc.akpm@linux-foundation.org>
In-Reply-To: <20071002150748.906970bc.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2007 06:07 PM, Andrew Morton wrote:
> On Tue, 02 Oct 2007 23:37:31 +0200 (CEST)
> Anders Bostr__m <anders@bostrom.dyndns.org> wrote:
> 
>> My computer suffers from high load average when the system is idle,
>> introduced by commit 44d306e1508fef6fa7a6eb15a1aba86ef68389a6 .
>>
>> Long story:
>>
>> 2.6.20 and all later versions I've tested, including 2.6.21 and
>> 2.6.22, make the load average high. Even when the computer is totally
>> idle (I've tested in single user mode), the load average end up
>> at ~0.30. The computer is still responsive, and the only fault seems
>> to be the too high load average. All versions up to and including
>> 2.6.19.7 is fine, and don't suffer from the problem.
>>
>> I git bisect between 2.6.19 and 2.6.20 gave me
>> 44d306e1508fef6fa7a6eb15a1aba86ef68389a6 "[PATCH] user of the jiffies
>> rounding code: JBD" as the first patch with the
>> problem. 2.6.20 with 44d306e1508fef6fa7a6eb15a1aba86ef68389a6 reverted
>> works fine. 2.6.23-rc8 with 44d306e1508fef6fa7a6eb15a1aba86ef68389a6
>> reverted also works fine.
>>
>> This fixes the problem:
>>
>> -------------------------- fs/jbd/transaction.c -----------------------------
>> index cceaf57..d38e0d5 100644
>> @@ -55,7 +55,7 @@ get_transaction(journal_t *journal, transaction_t *transaction)
>>  	spin_lock_init(&transaction->t_handle_lock);
>>  
>>  	/* Set up the commit timer for the new transaction. */
>> -	journal->j_commit_timer.expires = round_jiffies(transaction->t_expires);
>> +	journal->j_commit_timer.expires = transaction->t_expires;
>>  	add_timer(&journal->j_commit_timer);
>>  
>>  	J_ASSERT(journal->j_running_transaction == NULL);
>>
>>
>> I've only seen this problem on my home desktop computer. My work
>> desktop computer and several other computers at work don't suffer from
>> this problem. However, all other computers I've tested on is using
>> AMD64 as architecture, and not i386 as my home desktop computer.
>>
>> Please let me know how I can assist in further debugging of this, if
>> needed.
> 
> This is unexpected.  High load average is due to either a task chewing a
> lot of CPU time or a task stuck in uninterruptible sleep.
> 

Or, everybody wakes up at once right when we are taking a sample.  :)
