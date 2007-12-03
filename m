Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbXLCXd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbXLCXd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 18:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbXLCXdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 18:33:19 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45248 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbXLCXdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 18:33:18 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       devel@openvz.org
Subject: Re: [PATCH 1/7][QUOTA] Move sysctl management code under ifdef CONFIG_SYSCTL
References: <475008F5.3000506@openvz.org> <475009FA.20409@openvz.org>
	<20071203133844.40804dab.akpm@linux-foundation.org>
Date: Mon, 03 Dec 2007 16:32:02 -0700
In-Reply-To: <20071203133844.40804dab.akpm@linux-foundation.org> (Andrew
	Morton's message of "Mon, 3 Dec 2007 13:38:44 -0800")
Message-ID: <m1ir3fz765.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

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

Yes agreed.  What we need to do is to give the compiler enough information
to know that the sysctl table is not used.

Making the function an inline and having the table marked "static"
should be enough for the compiler to do the optimization for us instead
of having to manually remove sysctl tables by hand.

Doing it with an inline function should save us a lot of work and maintenance
in the long run.   I will see if I can cook up that patch.

> The same applies to register_sysctl_paths().

Agreed.

Eric
