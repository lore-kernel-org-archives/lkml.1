Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbXIRKZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbXIRKZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 06:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbXIRKZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 06:25:21 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:58432 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752236AbXIRKZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 06:25:20 -0400
Message-ID: <46EFA8DC.2020909@bull.net>
Date: Tue, 18 Sep 2007 12:30:52 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
References: <20070918091728.GA6766@localhost.sw.ru> <20070918031723.05689e92.akpm@linux-foundation.org>
In-Reply-To: <20070918031723.05689e92.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 18/09/2007 12:31:07,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 18/09/2007 12:31:08,
	Serialize complete at 18/09/2007 12:31:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 18 Sep 2007 13:17:28 +0400 Alexey Dobriyan <adobriyan@sw.ru> wrote:
> 
> 
>>I'm getting tons of this, and X fails to start
>>
>>CONFIG_SYSVIPC=y
>>CONFIG_SYSVIPC_SYSCTL=y
>># CONFIG_PREEMPT_NONE is not set
>># CONFIG_PREEMPT_VOLUNTARY is not set
>>CONFIG_PREEMPT=y
>>CONFIG_PREEMPT_BKL=y
>>CONFIG_DEBUG_PREEMPT=y
>>
>>BUG: sleeping function called from invalid context at kernel/rwsem.c:47
>>in_atomic():1, irqs_disabled():0
>>no locks held by X/5879.
>> [<c012bcb1>] down_write+0x15/0x50
>> [<c01b53af>] do_shmat+0x235/0x3a0
>> [<c0106be2>] sys_ipc+0x146/0x263
>> [<c0102892>] sysenter_past_esp+0xa7/0xb5
>> [<c0102856>] sysenter_past_esp+0x6b/0xb5
>> =======================
> 
> 
> Here's a bug:
> 
> --- a/ipc/util.c~ipc-integrate-ipc_checkid-into-ipc_lock-fix-2
> +++ a/ipc/util.c
> @@ -691,7 +691,7 @@ struct kern_ipc_perm *ipc_lock(struct ip
>  		rcu_read_unlock();
>  		return ERR_PTR(-EINVAL);
>  	}
> -
> +	rcu_read_unlock();
>  	return out;
>  }
>  

Andrew,

Actually the rcu_read_lock is released in ipc_unlock(). So I think we 
shouldn't add an rcu_read_unlock() before leaving ipc_lock().
This is a part that has not changed since the ref code.

I'm looking also on my side.

Regards,
Nadia

