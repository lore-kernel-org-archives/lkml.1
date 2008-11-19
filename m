Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbYKSIbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbYKSIbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 03:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYKSIbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 03:31:01 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:51326 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbYKSIbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 03:31:00 -0500
Message-ID: <4923CEBF.8000402@linux.vnet.ibm.com>
Date: Wed, 19 Nov 2008 14:00:55 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       stable@kernel.org
Subject: Re: [PATCH] cgroups: fix a serious bug in cgroupstats
References: <4923CAF1.1020404@cn.fujitsu.com> <20081119002552.3840e3d2.akpm@linux-foundation.org>
In-Reply-To: <20081119002552.3840e3d2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 19 Nov 2008 16:14:41 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> Try this, and you'll get oops immediately:
> 
> I guess that's wrong.
> 
>>  # cd Documentation/accounting/
>>  # gcc -o getdelays getdelays.c
>>  # mount -t cgroup -o debug xxx /mnt
>>  # ./getdelays -C /mnt/tasks
>>
>> Because a normal file's dentry->d_fsdata is a pointer to struct cftype,
>> not struct cgroup.
>>
>> After the patch, it returns EINVAL if we try to get cgroupstats
>> from a normal file.
>>
>> CC: Balbir Singh <balbir@linux.vnet.ibm.com>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  kernel/cgroup.c |    7 +++++--
>>  1 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index 358e775..f6f5219 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -2039,10 +2039,13 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
>>  	struct cgroup *cgrp;
>>  	struct cgroup_iter it;
>>  	struct task_struct *tsk;
>> +
>>  	/*
>> -	 * Validate dentry by checking the superblock operations
>> +	 * Validate dentry by checking the superblock operations,
>> +	 * and make sure it's a directory.
>>  	 */
>> -	if (dentry->d_sb->s_op != &cgroup_ops)
>> +	if (dentry->d_sb->s_op != &cgroup_ops ||
>> +	    !S_ISDIR(dentry->d_inode->i_mode))
>>  		 goto err;
>>  
>>  	ret = 0;
> 
> The patch applies OK to 2.6.25, 2.6.26 and to 2.6.27.  I marked it as
> needing backport to those kernel versions.  Please let me know if that
> was inappropriate.
> 

Thanks, it does need to be backported. Thanks Li for spotting the problem.


-- 
	Balbir
