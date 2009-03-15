Return-Path: <linux-kernel-owner+w=401wt.eu-S1752051AbZCOEmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbZCOEmD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 00:42:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbZCOElw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 00:41:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58597 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbZCOElw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 00:41:52 -0400
Message-ID: <49BC8704.4020705@cn.fujitsu.com>
Date: Sun, 15 Mar 2009 12:41:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Linux Containers <containers@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] devcgroup: avoid using cgroup_lock
References: <49B869BB.7030907@cn.fujitsu.com> <20090312181912.GA20144@us.ibm.com> <49B9BCC7.7090908@cn.fujitsu.com> <20090313134139.GB32304@us.ibm.com> <20090313195712.GA18439@us.ibm.com>
In-Reply-To: <20090313195712.GA18439@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting Serge E. Hallyn (serue@us.ibm.com):
>> Quoting Li Zefan (lizf@cn.fujitsu.com):
>>>>> @@ -426,11 +431,11 @@ static int devcgroup_access_write(struct cgroup *cgrp, struct cftype *cft,
>>>>>  				  const char *buffer)
>>>>>  {
>>>>>  	int retval;
>>>>> -	if (!cgroup_lock_live_group(cgrp))
>>>> Does it matter that we no longer check for cgroup_is_removed()?
>>>>
>>> No, this means in a rare case that the write handler is called when the cgroup
>>> is dead, we still do the update work instead of returning ENODEV.
>>>
>>> This is ok, since at that time, accessing cgroup and devcgroup is still valid,
>>> but will have no effect since there is no task in this cgroup and the cgroup
>>> will be destroyed soon.
>> Ok, just wanted to make sure the devcgroup couldn't be partially torn
>> down and risking NULL or freed-memory derefs...
> 
> Ok, so the cgroup's files will be deleted first, then on the directory
> removal the cgroup's data (each whitelist entry) is deleted.  So we can
> let that ordering (by cgroup_clear_directory) ensure that nothing inside
> a file write can happen while the destroy handler is called, right?
> 

When we are in the read/write handler, we have a pin in the dir's dentry
(dentry->d_count > 0), thus cgroup_diput() which destroys the cgroup won't
be called during the read/write.

> (That's why I was worried about not using the cgroup_lock: we need some
> way of synchronizing those.  But I guess we're fine)
> 

Many read/write handlers in other cgroup subsystems don't take cgroup_lock.
:)

>> BTW is that against linux-next?  (didn't seem to apply cleanly against
>> my 2.6.29-rc9)  I guess I'd like to do a little test before acking,
>> though it looks ok based on your answer.
> 
> Acked-by: Serge Hallyn <serue@us.ibm.com>
> 
> -serge
> 
> 


