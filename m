Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbZGCAbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbZGCAbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 20:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbZGCAbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 20:31:42 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58024 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbZGCAbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:31:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=lwBF+gcF2j/OPLR5Q9MqeOOkRmme6X4LXWy7Gi0YSQNN4LYDPXDR8+HXjmldNSVED
	THSLQSzz7DDT4GtUGGQLw==
MIME-Version: 1.0
In-Reply-To: <20090702164649.303c4952.akpm@linux-foundation.org>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	 <20090702232620.3969.16680.stgit@menage.mtv.corp.google.com>
	 <20090702164649.303c4952.akpm@linux-foundation.org>
Date: Thu, 2 Jul 2009 17:31:38 -0700
Message-ID: <2f86c2480907021731h13e0bb95q94f06829eded9aa6@mail.gmail.com>
Subject: Re: [PATCH 1/2] Adds a read-only "procs" file similar to "tasks" that 
	shows only unique tgids
From: Benjamin Blum <bblum@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <menage@google.com>, lizf@cn.fujitzu.com, serue@us.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 4:46 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
>> +/**
>> + * pidlist_uniq - given a kmalloc()ed list, strip out all duplicate entries
>> + * returns -ENOMEM if the malloc fails; 0 on success
>> + */
>
> The comment purports to be kerneldoc ("/**") but didn't document the
> function's arguments.

Wasn't aware of that restriction. Recommend making
scripts/checkpatch.pl look for that sort of thing?

>> +     list = *p;
>> +     /*
>> +      * we presume the 0th element is unique, so i starts at 1. trivial
>> +      * edge cases first; no work needs to be done for either
>> +      */
>> +     if (*length == 0 || *length == 1)
>> +             return 0;
>> +     for (i = 1; i < *length; i++) {
>> +             BUG_ON(list[i] == PIDLIST_VALUE_NONE);
>> +             if (list[i] == list[last]) {
>> +                     list[i] = PIDLIST_VALUE_NONE;
>> +             } else {
>> +                     last = i;
>> +                     count++;
>> +             }
>> +     }
>> +     newlist = kmalloc(count * sizeof(pid_t), GFP_KERNEL);
>
> What is the maximum possible value of `count' here?
>
> Is there any way in which malicious code can exploit the potential
> multiplicative overflow in this statement?  (kcalloc() checks for
> this).
>> +     /*
>> +      * If cgroup gets more users after we read count, we won't have
>> +      * enough space - tough.  This race is indistinguishable to the
>> +      * caller from the case that the additional cgroup users didn't
>> +      * show up until sometime later on.
>> +      */
>> +     length = cgroup_task_count(cgrp);
>> +     array = kmalloc(length * sizeof(pid_t), GFP_KERNEL);
>
> max size?
>
> overflowable?

In the first snippet, count will be at most equal to length. As length
is determined from cgroup_task_count, it can be no greater than the
total number of pids on the system. (Also, the second snippet of code
was there before, just relocated, so if there's an overflow bug in
either it'll have already been there.)

>> @@ -2389,21 +2457,27 @@ static int cgroup_write_notify_on_release(struct cgroup *cgrp,
>>  /*
>>   * for the common functions, 'private' gives the type of file
>>   */
>> +/* for hysterical reasons, we can't put this on the older files */
>
> "raisins" ;)

They keys are right next to each other, I promise.

There was a bit of discussion on how to name these files. Paul wanted
to start naming the generic cgroup files with the "cgroup." prefix,
but we can't change "tasks" and "notify_on_release" etc. We decided to
use the new name format but only for the new file - can anything be
done about the other ones, or do they have to stay as is?
