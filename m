Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbYAIJqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbYAIJqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 04:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbYAIJqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 04:46:14 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:34922
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464AbYAIJqN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 04:46:13 -0500
Message-Id: <4784A601.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 09 Jan 2008 09:46:25 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Matthew Helsley" <matthltc@us.ibm.com>
Cc: "Paul Jackson" <pj@sgi.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] add task handling notifier: base definitions
References: <476A7832.76E4.0078.0@novell.com>
 <1199852889.17010.243.camel@localhost.localdomain>
In-Reply-To: <1199852889.17010.243.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +BLOCKING_NOTIFIER_HEAD(task_notifier_list);
>> +EXPORT_SYMBOL_GPL(task_notifier_list);
>> +ATOMIC_NOTIFIER_HEAD(atomic_task_notifier_list);
>> +EXPORT_SYMBOL_GPL(atomic_task_notifier_list);
>> +
>
>When these global notifier lists were proposed years ago folks at SGI
>loudly objected with concerns over anticipated cache line bouncing on
>512+ cpu machines. Is that no longer a concern?

I can't see an alternative, since the serialization is unavoidable.

>> @@ -121,6 +127,9 @@ void __put_task_struct(struct task_struc
>>  	WARN_ON(atomic_read(&tsk->usage));
>>  	WARN_ON(tsk == current);
>> 
>> +	atomic_notifier_call_chain(&atomic_task_notifier_list,
>> +				   TASK_DELETE, tsk);
>> +
>>  	security_task_free(tsk);
>>  	free_uid(tsk->user);
>>  	put_group_info(tsk->group_info);
>
>Would the atomic notifier call chain be necessary if you hooked into an
>earlier section of do_exit() instead?

I'm afraid it is, as I was told that sleeping in the do_exit() path is not
generally possible.

Jan

