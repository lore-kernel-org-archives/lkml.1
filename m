Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbZGWIdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbZGWIdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 04:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbZGWIdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 04:33:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54408 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbZGWIdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 04:33:52 -0400
Message-ID: <4A682011.5010400@cn.fujitsu.com>
Date: Thu, 23 Jul 2009 16:32:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Paul Menage <menage@google.com>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Allow cgroup hierarchies to be created with no bound
 subsystems
References: <20090722194644.7481.47805.stgit@menage.mtv.corp.google.com>	<20090722195045.7481.62013.stgit@menage.mtv.corp.google.com> <20090723171913.3279de8c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090723171913.3279de8c.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -	/* We can't have an empty hierarchy */
>> +
>> +	/* Can't specify "none" and some subsystems */
>> +	if (opts->subsys_bits && opts->none)
>> +		return -EINVAL;
> 
> Is this case never happens ?
> 
> 	BUG_ON(!opts->subsys_bits && !opts->none)
> 

It can happen:

  # mount -t cgroup -o none,memory

> 
>> +
>> +	/*
>> +	 * We either have to specify by name or by subsystems. (So all
>> +	 * empty hierarchies must have a name).
>> +	 */
>>  	if (!opts->subsys_bits && !opts->name)
>>  		return -EINVAL;
>>  
>> @@ -1129,6 +1124,31 @@ static void init_cgroup_root(struct cgroupfs_root *root)
>>  	init_cgroup_housekeeping(cgrp);
>>  }
>>  
>> +static bool init_root_id(struct cgroupfs_root *root)
>> +{
>> +	int ret = 0;
>> +
>> +	do {
>> +		if (!ida_pre_get(&hierarchy_ida, GFP_KERNEL))
>> +			return false;
>> +		spin_lock(&hierarchy_id_lock);
>> +		/* Try to allocate the next unused ID */
>> +		ret = ida_get_new_above(&hierarchy_ida, next_hierarchy_id,
>> +					&root->hierarchy_id);
> 
> Why new id should be greater than old one ?
> Just for avoiding reuse-id-too-soon ?
> 

Otherwise we can't identify each hierachy by it's id.


>> +		if (ret == -ENOSPC)
>> +			/* Try again starting from 0 */
>> +			ret = ida_get_new(&hierarchy_ida, &root->hierarchy_id);
>> +		if (!ret) {
>> +			next_hierarchy_id = root->hierarchy_id + 1;
>> +		} else if (ret != -EAGAIN) {
>> +			/* Can only get here if the 31-bit IDR is full ... */
>> +			BUG_ON(ret);
>> +		}
>> +		spin_unlock(&hierarchy_id_lock);
>> +	} while (ret);
>> +	return true;
>> +}
>> +

...

>> @@ -3910,8 +3950,8 @@ static int current_css_set_cg_links_read(struct cgroup *cont,
>>  			name = c->dentry->d_name.name;
>>  		else
>>  			name = "?";
>> -		seq_printf(seq, "Root %lu group %s\n",
>> -			   c->root->subsys_bits, name);
>> +		seq_printf(seq, "Root %d group %s\n",
>> +			   c->root->hierarchy_id, name);
>>  	}
> 
> I'm not sure but this "id" is worth to be printed ?
> 

It's a debug file, so I think at least it's not bad to print the id.

