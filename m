Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbZGWGvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbZGWGvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 02:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbZGWGvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 02:51:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62254 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbZGWGvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 02:51:50 -0400
Message-ID: <4A68082C.8010604@cn.fujitsu.com>
Date: Thu, 23 Jul 2009 14:50:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Support named cgroups hierarchies
References: <20090722194644.7481.47805.stgit@menage.mtv.corp.google.com>	 <20090722195029.7481.94700.stgit@menage.mtv.corp.google.com>	 <4A68013A.2020302@cn.fujitsu.com> <6599ad830907222327s31340956y9783db39d076520f@mail.gmail.com>
In-Reply-To: <6599ad830907222327s31340956y9783db39d076520f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>  static int cgroup_set_super(struct super_block *sb, void *data)
>>>  {
>>>       int ret;
>>> -     struct cgroupfs_root *root = data;
>>> +     struct cgroup_sb_opts *opts = data;
>>> +
>>> +     /* If we don't have a new root, we can't set up a new sb */
>>> +     if (!opts->new_root)
>>> +             return -EINVAL;
>>> +
>> I think this should be BUG_ON(). If set_super() is called,
>> we are allocating a new root, so opts->new_root won't be NULL.
> 
> Not true - if you try to mount a hierarchy by name, but with no
> subsystem options, then we don't construct a new root, but we still
> call sget(). If we find a superblock with the right name then we use
> it, else sget() will allocate a new superblock and call
> cgroup_set_super(), at which point we need to fail.
> 

Ah, I see.

>>> +             struct cgroupfs_root *new_root = cgroup_root_from_opts(&opts);
>> Why not just declare new_root in the beginning of cgroup_get_sb()?
> 
> Because it's not needed for the entire scope of the function. Keeping
> its scope as small as possible makes it clearer what it's being used
> for.
> 

If we had been doing this, we'll see many:

	(no if, while, for)
	{
		...
	}

in kernel code, but I don't remember I ever saw this style.

