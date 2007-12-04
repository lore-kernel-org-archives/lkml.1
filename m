Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbXLDI66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbXLDI66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 03:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbXLDI6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 03:58:51 -0500
Received: from sacred.ru ([62.205.161.221]:50964 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbXLDI6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 03:58:50 -0500
Message-ID: <475516B6.5000504@openvz.org>
Date: Tue, 04 Dec 2007 11:58:30 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ebiederm@xmission.com, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 1/7][QUOTA] Move sysctl management code under ifdef CONFIG_SYSCTL
References: <475008F5.3000506@openvz.org>	<475009FA.20409@openvz.org> <20071203133844.40804dab.akpm@linux-foundation.org>
In-Reply-To: <20071203133844.40804dab.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 04 Dec 2007 11:58:35 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 30 Nov 2007 16:02:50 +0300
> Pavel Emelyanov <xemul@openvz.org> wrote:
> 
>> This includes the tables themselves and the call to the
>> register_sysctl_table(). Since this call is done from the __init
>> call, I hope this is OK to keep the #ifdef inside the function, 
>> rather than making proper helpers outside it.
>>
>> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
>>
>> ---
>>
>> diff --git a/fs/dquot.c b/fs/dquot.c
>> index 50e7c2a..efee14d 100644
>> --- a/fs/dquot.c
>> +++ b/fs/dquot.c
>> @@ -1821,6 +1821,7 @@ struct quotactl_ops vfs_quotactl_ops = {
>>  	.set_dqblk	= vfs_set_dqblk
>>  };
>>  
>> +#ifdef CONFIG_SYSCTL
>>  static ctl_table fs_dqstats_table[] = {
>>  	{
>>  		.ctl_name	= FS_DQ_LOOKUPS,
>> @@ -1918,6 +1919,7 @@ static ctl_table sys_table[] = {
>>  	},
>>  	{ .ctl_name = 0 },
>>  };
>> +#endif
>>  
>>  static int __init dquot_init(void)
>>  {
>> @@ -1926,7 +1928,9 @@ static int __init dquot_init(void)
>>  
>>  	printk(KERN_NOTICE "VFS: Disk quotas %s\n", __DQUOT_VERSION__);
>>  
>> +#ifdef CONFIG_SYSCTL
>>  	register_sysctl_table(sys_table);
>> +#endif
>>  
>>  	dquot_cachep = kmem_cache_create("dquot",
>>  			sizeof(struct dquot), sizeof(unsigned long) * 4,
> 
> We should avoid the ifdefs around the register_sysctl_table() call.
> 
> At present the !CONFIG_SYSCTL implementation of register_sysctl_table() is
> a non-inlined NULL-returning stub.  All we have to do is to inline that stub
> then these ifdefs can go away.

What if some code checks for the return value to be not-NULL? In case
CONFIG_SYSCTL=n this code will always think, that the registration failed.

> The same applies to register_sysctl_paths().
> 
> 
> If that's all agreeable then there isn't a lot of point in me merging these
> seven patches.
> 
> 
> 
> btw, administrivia detail: please don't put the patch's subsystem
> identifier in [].  IOW, this:
> 
> Subject: [PATCH 1/7][QUOTA] Move sysctl management code under ifdef CONFIG_SYSCTL
> 
> should have been
> 
> Subject: [PATCH 1/7] quota: move sysctl management code under ifdef CONFIG_SYSCTL
> 
> for reasons described in section 2 of
> http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt.

OK. I saw people marking subsystems in this way in netdev tree and
though it was a common practice.

> Thanks.

Thanks,
Pavel

