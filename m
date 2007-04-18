Return-Path: <linux-kernel-owner+w=401wt.eu-S933046AbXDRIgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046AbXDRIgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 04:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933068AbXDRIgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 04:36:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:6031 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933046AbXDRIgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 04:36:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=k1rcY1kBxUo/81AxWR+0HNy6zojQE8X/jgZgYEBQEU2ExnvFx6vIv/tVKwaRsh/ncuKj+p6+xc56FV/j9S7Wyx8KkNnxwiF81zmr2gIP8VnMyF/5JpnoE0nBksLAU7A8enuqZVPA2RJdNBrljx3E8H2JCiizQEb8aqrm1HkacqM=
Message-ID: <4625D885.7020308@gmail.com>
Date: Wed, 18 Apr 2007 17:36:21 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>, dmitry.torokhov@gmail.com
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
References: <20070416193619.4659a847@gondolin.boeblingen.de.ibm.com>	<20070417184110.GJ10619@htj.dyndns.org> <20070418100709.3c710e00@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070418100709.3c710e00@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Wed, 18 Apr 2007 03:41:10 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> Hello, all.
>>
>> Agreed with the problem but I'm not very enthusiastic for adding
>> kobj->owner.  How about the following?  exit() routines will have to
>> do device_unregister_wait() instead of device_unregister().  On return
>> from it, it's guaranteed that all references to it are dropped and
>> ->release is finished.
> 
> Sounds interesting. Kind of like the completion approach, but with the
> dangerous bits outside the module.
> 
>> The caller is responsible for avoiding
>> deadlock, of course.
> 
> I think that wording is a bit too strong. Of course, if the device is
> unregistered in the exit routine, the module must make sure it gave up
> all references it itself obtained. However, it doesn't have any control
> about who obtained a reference during the object's lifetime. If an
> outsider holds on to a reference, we'll lock up until this reference
> has been given up (but I guess this is what we want).

Right, the better wording would be "the caller is responsible for not
causing deadlocks by dropping all references it owns on entry".

>> +void kobject_put_wait(struct kobject * kobj)
>> +{
>> +	struct kobj_wait kwait;
>> +	unsigned long flags;
>> +
>> +	if (!kobj)
>> +		return;
>> +
>> +	BUG_ON(!list_empty(&kobj->entry));
>> +
>> +	init_completion(&kwait.cmpl);
>> +	kwait.kobj = kobj;
>> +
>> +	spin_lock_irqsave(&kobj_wait_lock, flags);
>> +	list_add(&kwait.list, &kobj_wait_list);
>> +	spin_unlock_irqrestore(&kobj_wait_lock, flags);
>> +
>> +	kobject_put(kobj);
>> +
>> +	if (!wait_for_completion_timeout(&kwait.cmpl, 30 * HZ)) {
>> +		printk(KERN_WARNING "kobject_put_wait: kobject %p is still "
>> +		       "alive after 30s, possible reference count bug\n", kobj);
>> +		dump_stack();
>> +		wait_for_completion(&kwait.cmpl);
>> +	}
>> +}
>>
> 
> Couldn't this waiting be made simpler?
> - add completion to kobject in kobject_unregister_wait()
> - call kobject_put(), then wait_for_completion()
> - in kobject_cleanup(), save completion from kobject, call release
> function, then complete() on saved completion

I was trying to avoid adding a completion to all kobjects.

Thanks.

-- 
tejun
