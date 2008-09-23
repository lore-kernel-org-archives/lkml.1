Return-Path: <linux-kernel-owner+w=401wt.eu-S1753666AbYIWRiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbYIWRiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 13:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYIWRh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 13:37:56 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:58287 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYIWRhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 13:37:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FtmVcU9GxKJ/l/9Kvd1l9jXMQ/wHuV61BZMwZsmghnpVpU8TaMDniPe3+8cbatqEc0
         KDrJcbp2bLysTjWtpAuQNYm17KNYkfbLmCWgLRoQK1VxmkvNxETHqdaZGh32y/GDOYch
         hmvKx4v+It409iZozvlkjgShTByfKhJzZe1N0=
Message-ID: <2137b82d0809231037w3900ef3fta003b791bf36d4a@mail.gmail.com>
Date: Tue, 23 Sep 2008 10:37:52 -0700
From: "Chad Zanonie" <chad.zanonie@gmail.com>
To: "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: Re: + mm-oom-killer-kills-more-than-needed.patch added to -mm tree
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       rientjes@google.com
In-Reply-To: <2137b82d0809231025n359b3f59h53714d5acabd2107@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809222238.m8MMcgAp001695@imap1.linux-foundation.org>
	 <20080923124035.GA253@tv-sign.ru>
	 <2137b82d0809231025n359b3f59h53714d5acabd2107@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before I propagate this blunder anymore, I've found the root of my mistake.

I really mean TASK_DEAD, not EXIT_DEAD.

(p->state & TASK_DEAD)

-Chad

On Tue, Sep 23, 2008 at 10:25 AM, Chad Zanonie <chad.zanonie@gmail.com> wrote:
> On Tue, Sep 23, 2008 at 5:40 AM, Oleg Nesterov <oleg@tv-sign.ru> wrote:
>> On 09/22, Andrew Morton wrote:
>>>
>>> ------------------------------------------------------
>>> Subject: mm: oom-killer kills more than needed
>>> From: "Chad Zanonie" <chad.zanonie@gmail.com>
>>>
>>> Possibility exists for an exiting application to be in between marking its
>>> mm NULL and calling mmput when out_of_memory is invoked.
>>> select_bad_process() will continue past this process as opposed to
>>> returning -1UL due to its mm being NULL.  This causes the oom killer in
>>> certain scenarios to not only kill the memory culprit, but also kill the
>>> runner up.
>>>
>>> EXIT_DEAD seems to be the only flag that guarantees that mmput() has
>>> finished.
>>
>> I don't think this is right.
>>
>> Let's suppose we have a single zombie. Now select_bad_process() always
>> returns -1 ? IOW, doesn't this means that, say,
>>
>>        $ perl -e 'fork && sleep'
>>
>> disables oom-kill completely and forever?
>
> Ugh, looks like my description was slightly incorrect. I don't mean
> for it to return -1 upon noticing a null mm. I mean for
> select_bad_process to not skip (continue) over processes that haven't
> provably finished unmapping their memory (which EXIT_DEAD infers).
>
>>
>> Hmm. But please see below. This doesn't happen because the usage
>> of EXIT_DEAD is not right.
>>
>>> Checking for PF_KTHREAD should replace p->mm regardless.
>>
>> Yes, almost every check for ->mm in oom_kill.c is not right.
>>
>>> Adding EXIT_DEAD to the check seems to prevent unnecessary kills in local
>>> testing.
>>
>> This is strange, could you re-test? Because
>>
>>> @@ -216,7 +216,7 @@ static struct task_struct *select_bad_pr
>>>                * skip kernel threads and tasks which have already released
>>>                * their mm.
>>>                */
>>> -             if (!p->mm)
>>> +             if (p->flags & PF_KTHREAD || p->flags & EXIT_DEAD)
>>                                                ^^^^^^^^^^^^^^^^^
>>
>> this is not possible. EXIT_DEAD lives in ->exit_state, not in ->flags.
>
> Good catch. I had actually done the testing in an older kernel that
> used PF_DEAD and while noticing the change to only EXIT_DEAD forgot to
> use the new appropriate flag in the patch.
>
>>
>> Oleg.
>>
>>
>
> I'm new to this endeavor. Should I propose a new patch, or, will
> things be fixed from this omission? I still support the EXIT_DEAD
> inclusion, as it'll allow the OOM killer to make the similar progress
> that !p->mm provided.
>
> Chad
>
