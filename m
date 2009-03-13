Return-Path: <linux-kernel-owner+w=401wt.eu-S1757051AbZCMByU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051AbZCMByU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 21:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZCMByJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 21:54:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58177 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbZCMByI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 21:54:08 -0400
Message-ID: <49B9BCC7.7090908@cn.fujitsu.com>
Date: Fri, 13 Mar 2009 09:54:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] devcgroup: avoid using cgroup_lock
References: <49B869BB.7030907@cn.fujitsu.com> <20090312181912.GA20144@us.ibm.com>
In-Reply-To: <20090312181912.GA20144@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -426,11 +431,11 @@ static int devcgroup_access_write(struct cgroup *cgrp, struct cftype *cft,
>>  				  const char *buffer)
>>  {
>>  	int retval;
>> -	if (!cgroup_lock_live_group(cgrp))
> 
> Does it matter that we no longer check for cgroup_is_removed()?
> 

No, this means in a rare case that the write handler is called when the cgroup
is dead, we still do the update work instead of returning ENODEV.

This is ok, since at that time, accessing cgroup and devcgroup is still valid,
but will have no effect since there is no task in this cgroup and the cgroup
will be destroyed soon.

>> -		return -ENODEV;
>> +
>> +	mutex_lock(&devcgroup_mutex);
>>  	retval = devcgroup_update_access(cgroup_to_devcgroup(cgrp),
>>  					 cft->private, buffer);
>> -	cgroup_unlock();
>> +	mutex_unlock(&devcgroup_mutex);
>>  	return retval;
>>  }

