Return-Path: <linux-kernel-owner+w=401wt.eu-S1760298AbYESSd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760298AbYESSd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 14:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbYESSdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 14:33:16 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:25503 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbYESSdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 14:33:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=a23sxjOmwpSUwxLt+FXi9EYd8DjShy4swAtvXzzFUIxmAPWSXPbCXFu1UTWxsRhDLvkpP+9xoZ0lIDSEqq/U28tHRxhjF29yZr8hsJsGntLsOy1CUol1QwJI0MOPJmAIkBPWjJkDMB2bNas3QvHW5q5jTGJQ0crCdaZMmzqvjAQ=
Message-ID: <4831C7E7.2090804@users.sourceforge.net>
Date: Mon, 19 May 2008 20:33:11 +0200
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Swiftdove 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Shailabh Nagar <nagar@watson.ibm.com>, Mark Seger <Mark.Seger@hp.com>,
       Jes Sorensen <jes@sgi.com>, Chris Sturtivant <csturtiv@sgi.com>,
       Tony Ernst <tee@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] distinct tgid/tid I/O statistics
References: <482DF0C0.6050208@users.sourceforge.net> <4831BDBA.6090609@linux.vnet.ibm.com>
In-Reply-To: <4831BDBA.6090609@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
>> +
>> +    if (!whole) {
>> +#ifdef CONFIG_TASK_XACCT
> 
> Can't we abstract this into a function for ease?

Maybe:

#ifdef CONFIG_TASK_XACCT
#define _task_xacct 1
#else
#define _task_xacct 0
#endif

and:

rchar = __task_xacct ? task->rchar : 0;
wchar = __task_xacct ? task->wchar : 0;
syscr = __task_xacct ? task->syscr : 0;
syscw = __task_xacct ? task->syscw : 0;

But it's very ugly anyway. It seems a similar problem has been raised
here:

http://lkml.org/lkml/2008/5/17/154

Apparently with no solution.

> 
>> +        rchar = task->rchar;
>> +        wchar = task->wchar;
>> +        syscr = task->syscr;
>> +        syscw = task->syscw;
>> +#endif
>> +        memcpy(&ioac, &task->ioac, sizeof(ioac));
>> +    } else {
>> +        rchar = wchar = syscr = syscw = 0;
>> +        memset(&ioac, 0, sizeof(ioac));
>> +        rcu_read_lock();
>> +        if (lock_task_sighand(task, &flags)) {
> 
> If lock(), what happens otherwise?
> 

mmmh... we must surely move the threads stats accounting code out of
the if statement. OK, I'll post a new patch soon.

Thanks,
-Andrea

>> +        struct signal_struct *sig = task->signal;
>> +        struct task_struct *t = task;
>> +
>> +            do {
>> +#ifdef CONFIG_TASK_XACCT
>> +                rchar += t->rchar;
>> +                wchar += t->wchar;
>> +                syscr += t->syscr;
>> +                syscw += t->syscw;
>> +#endif
>> +                ioac.read_bytes += t->ioac.read_bytes;
>> +                ioac.write_bytes += t->ioac.write_bytes;
>> +                ioac.cancelled_write_bytes +=
>> +                        t->ioac.cancelled_write_bytes;
>> +                t = next_thread(t);
>> +            } while (t != task);
>> +
>> +#ifdef CONFIG_TASK_XACCT
>> +            rchar += sig->rchar;
>> +            wchar += sig->wchar;
>> +            syscr += sig->syscr;
>> +            syscw += sig->syscw;
>> +#endif
>> +            ioac.read_bytes += sig->ioac.read_bytes;
>> +            ioac.write_bytes += sig->ioac.write_bytes;
>> +            ioac.cancelled_write_bytes +=
>> +                    sig->ioac.cancelled_write_bytes;
>> +
>> +            unlock_task_sighand(task, &flags);
>> +        }
>> +        rcu_read_unlock();
>> +    }
