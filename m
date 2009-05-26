Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbZEZBXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbZEZBXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 21:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZEZBX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 21:23:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60173 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbZEZBX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 21:23:27 -0400
Message-ID: <4A1B44DC.5050000@cn.fujitsu.com>
Date: Tue, 26 May 2009 09:24:44 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] cgroups: handle failure of cgroup_populate_dir() at	mount/remount
References: <4A16153C.2080004@cn.fujitsu.com> <20090525131753.GL4858@balbir.in.ibm.com>
In-Reply-To: <20090525131753.GL4858@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> * Li Zefan <lizf@cn.fujitsu.com> [2009-05-22 11:00:12]:
> 
>> Now we have 'stat' file in both memory and cpuacct subsystems. If we
>> mount these 2 subsystems with option 'noprefix', the creation of 'stat'
>> file for cpuacct will fail, but without any notificatin to the user.
>>
>> With this patch, we fail the mount/remount in this case.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  kernel/cgroup.c |   18 ++++++++++++++++--
>>  1 files changed, 16 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index a7267bf..eab83f7 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -896,6 +896,7 @@ static int parse_cgroupfs_options(char *data,
>>  static int cgroup_remount(struct super_block *sb, int *flags, char *data)
>>  {
>>  	int ret = 0;
>> +	unsigned long subsys_bits;
>>  	struct cgroupfs_root *root = sb->s_fs_info;
>>  	struct cgroup *cgrp = &root->top_cgroup;
>>  	struct cgroup_sb_opts opts;
>> @@ -914,12 +915,17 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
>>  		goto out_unlock;
>>  	}
>>
>> +	subsys_bits = root->subsys_bits;
>>  	ret = rebind_subsystems(root, opts.subsys_bits);
>>  	if (ret)
>>  		goto out_unlock;
>>
>>  	/* (re)populate subsystem files */
>> -	cgroup_populate_dir(cgrp);
>> +	ret = cgroup_populate_dir(cgrp);
>> +	if (ret) {
> 
> if (ret) means a failure right? So we rebind_subsystems to the older
> subsys_bits? Could you please add a comment, the code can be misread.
> 

Sure.

>> +		rebind_subsystems(root, subsys_bits);
>> +		goto out_unlock;
>> +	}
>>
>>  	if (opts.release_agent)
>>  		strcpy(root->release_agent_path, opts.release_agent);
>> @@ -1122,9 +1128,13 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
>>  		BUG_ON(!list_empty(&root_cgrp->children));
>>  		BUG_ON(root->number_of_cgroups != 1);
>>
>> -		cgroup_populate_dir(root_cgrp);
>> +		ret = cgroup_populate_dir(root_cgrp);
>> +
>>  		mutex_unlock(&inode->i_mutex);
>>  		mutex_unlock(&cgroup_mutex);
>> +
>> +		if (ret)
>> +			goto drop_new_super;
>>  	}
>>
>>  	simple_set_mnt(mnt, sb);
>> @@ -1803,6 +1813,10 @@ int cgroup_add_file(struct cgroup *cgrp,
>>  		dput(dentry);
>>  	} else
>>  		error = PTR_ERR(dentry);
>> +
>> +	if (error)
>> +		printk(KERN_WARNING "cgroup: Failed to create file '%s': %d\n",
>> +		       name, error);
>>  	return error;
>>  }
>>
> 
> Looks good, should we mark cgroup_populate_dir with __must_check? 
> 

Actually cgroup_populate_dir() is called in 3 cases:
  - mount
  - remount
  - mkdir

This patch only handles the former 2 cases. The return value of
cgroup_populate_dir() is also ignored when mkdir, and that piece of code
is inhereted from cpuset. I guess it's because it's hard to handle this
failure and there was no possibility of name collisions in old cpuset.

Normally name collisions can be caught when mount/remount, thus there
won't be subsequent mkdir()s.


