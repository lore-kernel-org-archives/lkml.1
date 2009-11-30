Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811AbZK3UVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbZK3UVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 15:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZK3UVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 15:21:20 -0500
Received: from smtp-out.google.com ([216.239.45.13]:49853 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbZK3UVT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 15:21:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=mhYI2OGVj+FIrhhGYuSmQUVAlXbhKbKrqODro2IzeqkHhEPpkqWqkMlX67f2Hfscb
	CsLZ/6QGgqxVBK4qXyrvg==
MIME-Version: 1.0
In-Reply-To: <20091130191307.GM11670@google.com>
References: <20091127022820.GU32182@kryten> <20091130191307.GM11670@google.com>
Date: Mon, 30 Nov 2009 12:21:20 -0800
Message-ID: <1fe6c7900911301221l710ccf34v2c7a69282b08bd37@mail.gmail.com>
Subject: Re: PATCH: softlockup: Fix hung_task_check_count sysctl
From: Mandeep Baines <msb@google.com>
To: Anton Blanchard <anton@samba.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, fweisbec@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 11:13 AM, Mandeep Singh Baines <msb@google.com> wrote:
> To disable hung_task at runtime:
>
> # echo 0 > /proc/sys/kernel/hung_task_check_count
>

D'oh. Copy and paste error. I meant

# echo 0 > /proc/sys/kernel/hung_task_timeout_secs

The nice thing about hung_task_timeout_secs=0 is that hungtaskd will
no longer run. Implementing
no checking done with hung_task_check_count=0 would result in the task
getting scheduled,
running, and then doing nothing.

> 33 /*
> 34  * Zero means infinite timeout - no checking done:
> 35  */
> 36 unsigned long __read_mostly sysctl_hung_task_timeout_secs = 120;
>
> For hung_task_check_count, 0 means there is no maximum so all tasks
> are checked.
>
> Anton Blanchard (anton@samba.org) wrote:
>>
>> I'm seeing spikes of up to 0.5ms in khungtaskd on a large machine. To reduce
>> this source of jitter I tried setting hung_task_check_count to 0:
>>
>
> Hmm, maybe khungtaskd should be run using SCHED_IDLE.
>
>> # echo 0 > /proc/sys/kernel/hung_task_check_count
>>
>> which didn't have the intended response. Change to a post increment of
>> max_count, so a value of 0 means check 0 tasks.
>>
>> Signed-off-by: Anton Blanchard <anton@samba.org>
>> ---
>>
>> Index: linux.trees.git/kernel/hung_task.c
>> ===================================================================
>> --- linux.trees.git.orig/kernel/hung_task.c   2009-11-27 13:11:46.000000000 +1100
>> +++ linux.trees.git/kernel/hung_task.c        2009-11-27 13:11:57.000000000 +1100
>> @@ -144,7 +144,7 @@ static void check_hung_uninterruptible_t
>>
>>       rcu_read_lock();
>>       do_each_thread(g, t) {
>> -             if (!--max_count)
>> +             if (!max_count--)
>>                       goto unlock;
>>               if (!--batch_count) {
>>                       batch_count = HUNG_TASK_BATCHING;
>
