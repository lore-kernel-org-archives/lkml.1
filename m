Return-Path: <linux-kernel-owner+w=401wt.eu-S1946200AbXBCA6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946200AbXBCA6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 19:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946203AbXBCA6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 19:58:45 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:9423 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946200AbXBCA6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 19:58:45 -0500
Message-ID: <45C3DDEF.3040400@mvista.com>
Date: Fri, 02 Feb 2007 14:57:19 -1000
From: akuster <akuster@mvista.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <nigel@suspend2.net>
Subject: Re: [patch 1/1] PM: Adds remount fs ro at suspend
References: <20070202235132.EDBDF1C448@hermes.mvista.com> <20070202161611.cf8b4328.akpm@linux-foundation.org>
In-Reply-To: <20070202161611.cf8b4328.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton wrote:
> On Fri, 02 Feb 2007 13:50:10 -1000
> akuster@mvista.com wrote:
> 
>>
<snipped>

>> +struct suspremount {
>> +struct super_block *sb;
>> +struct suspremount *next;
>> +};
> 
> The fields of this struct need a leading tab.
ok.
> 
> The name "suspremount" might be unpopular.  suspend_remount_state would be
> more kernely.
> 
ok.

> 
>> +static struct suspremount *suspremount_list;
>> +
>> +void suspend_remount_log_fs(struct super_block *sb)
>> +{
>> +	struct suspremount *remountp;
>> +
>> +	if ((remountp = (struct suspremount *)
>> +		kmalloc(sizeof(struct suspremount), GFP_KERNEL)) != NULL) {
> 
> The typecast is unneeded, and the compounded assign-and-test is not
> preferred style.  So here, please use
> 
> 	struct suspremount *remountp;
> 
> 	remountp = kmalloc(sizeof(*remountp), GFP_KERNEL);
> 	if (remountp != NULL) {

ok.

>> +EXPORT_SYMBOL(suspend_remount_all_fs_ro);
> 
> Why is this exported to modules?
> 
it shouldn't. will remove


>> +		sb = remountp->sb;
>> +		flags = 0;
>> +		if (sb->s_op && sb->s_op->remount_fs) {
>> +			ret = sb->s_op->remount_fs(sb, &flags, NULL);
>> +			if (ret) printk("resume_remount_rw: error %d\n", ret);
> 
> newline needed here.

ok.
> 
> super_block_operations.remount_fs() is supposed to be called under lock_super().
> Some filesystems might go BUG over this, or something.   Was there a reason to
> not do this?

nope. will correct

> 
>> +		}
>> +
>> +		tp = remountp->next;
>> +		kfree(remountp);
>> +		remountp = tp;
>> +	}
>> +	suspremount_list = NULL;
>> +}
>> +EXPORT_SYMBOL(resume_remount_fs_rw);
> 
> Why the export?

shouldn't
> 
> All this code is singly-threaded at a much higher level (I hope), hence
> that list doesn't need locking.  However a comment explaining this might be
> good.

ok.

> 
>> @@ -613,6 +677,9 @@ int do_remount_sb(struct super_block *sb
>>  		unlock_super(sb);
>>  		if (retval)
>>  			return retval;
>> +#ifdef CONFIG_SUSPEND_REMOUNTFS
>> +		suspend_remount_log_fs(sb);
>> +#endif
> 
> We try to avoid putting ifdefs in C files.  So in a header file, do
> 
> struct super_block;
> #ifdef CONFIG_SUSPEND_REMOUNTFS
> extern void suspend_remount_log_fs(struct super_block *sb);
> #else
> static inline void suspend_remount_log_fs(struct super_block *sb) {}
> #endif
> 
will do.

Many thanks on the feedback.

Armin
