Return-Path: <linux-kernel-owner+w=401wt.eu-S936424AbZAPRyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936424AbZAPRyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 12:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762775AbZAPRy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 12:54:26 -0500
Received: from relay3.sgi.com ([192.48.171.31]:49501 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763719AbZAPRyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 12:54:24 -0500
Message-ID: <4970C9CE.6060208@sgi.com>
Date: Fri, 16 Jan 2009 09:54:22 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL}: latest tip/cpus4096 changes
References: <49704DF6.8040205@sgi.com> <20090116092859.GD4305@elte.hu>
In-Reply-To: <20090116092859.GD4305@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> diff --git a/kernel/kgdb.c b/kernel/kgdb.c
>> index e4dcfb2..21fde60 100644
>> --- a/kernel/kgdb.c
>> +++ b/kernel/kgdb.c
>> @@ -72,7 +72,7 @@ struct kgdb_state {
>>  static struct debuggerinfo_struct {
>>  	void			*debuggerinfo;
>>  	struct task_struct	*task;
>> -} kgdb_info[NR_CPUS];
>> +} *kgdb_info;
>>  
>>  /**
>>   * kgdb_connected - Is a host GDB connected to us?
>> @@ -1651,6 +1651,13 @@ int kgdb_register_io_module(struct kgdb_io *new_kgdb_io_ops)
>>  		return -EBUSY;
>>  	}
>>  
>> +	kgdb_info = kmalloc(nr_cpu_ids * sizeof(*kgdb_info), GFP_KERNEL);
>> +	if (unlikely(!kgdb_info)) {
>> +		spin_unlock(&kgdb_registration_lock);
>> +		printk(KERN_ERR "kgdb: No memory for kgdb_info\n");
>> +		return -ENOMEM;
>> +	}
>> +
>>  	if (new_kgdb_io_ops->init) {
>>  		err = new_kgdb_io_ops->init();
>>  		if (err) {
> 
> Look how it continues:
> 
>                         spin_unlock(&kgdb_registration_lock);
>                         return err;
>                 }
>         }
> 
> See the memory leak? This is _trivially_ broken. When you add dynamic 
> allocation to any codepath you _need_ to be careul and you need to check 
> all interim paths of return.
> 
> Also, please submit kgdb patches via the KGDB maintainer:
> 
>  KGDB
>  P:      Jason Wessel
>  M:      jason.wessel@windriver.com
>  L:      kgdb-bugreport@lists.sourceforge.net
>  S:      Maintained
> 
> 	Ingo

Yes, you're right I did miss that.  And I'll send it to Jason.

Thanks,
MIke

