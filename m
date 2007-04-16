Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbXDPLHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbXDPLHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 07:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbXDPLHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 07:07:12 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:4655 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089AbXDPLGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 07:06:53 -0400
Message-ID: <462359B2.7070706@sw.ru>
Date: Mon, 16 Apr 2007 15:10:42 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: sct@redhat.com, akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Check for error returned by kthread_create on creating
 journal thread
References: <4623289A.1000101@sw.ru> <20070416102107.GA12818@infradead.org>
In-Reply-To: <20070416102107.GA12818@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Apr 16, 2007 at 11:41:14AM +0400, Pavel Emelianov wrote:
>> If the thread failed to create the subsequent wait_event
>> will hang forever.
>>
>> This is likely to happen if kernel hits max_threads limit.
>>
>> Will be critical for virtualization systems that limit the
>> number of tasks and kernel memory usage within the container.
> 
>> --- ./fs/jbd/journal.c.jbdthreads	2007-04-16 11:17:36.000000000 +0400
>> +++ ./fs/jbd/journal.c	2007-04-16 11:30:09.000000000 +0400
>> @@ -211,10 +211,16 @@ end_loop:
>>  	return 0;
>>  }
>>  
>> -static void journal_start_thread(journal_t *journal)
>> +static int journal_start_thread(journal_t *journal)
>>  {
>> -	kthread_run(kjournald, journal, "kjournald");
>> +	struct task_struct *t;
>> +
>> +	t = kthread_run(kjournald, journal, "kjournald");
>> +	if (IS_ERR(t))
>> +		return PTR_ERR(t);
>> +
>>  	wait_event(journal->j_wait_done_commit, journal->j_task != 0);
> 
> Note that this wait_event should exist at all, and the return

Should NOT you mean?

> value of kthread_run should be assigned to journal->j_task.  Also
> the code doesn't use the kthread primitives in other places leading
> to crufty code.

Well, this could be done with a separate patch, I think.

> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

