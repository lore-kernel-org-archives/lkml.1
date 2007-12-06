Return-Path: <linux-kernel-owner+w=401wt.eu-S1752402AbXLFSte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbXLFSte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 13:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXLFSt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 13:49:26 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:44559 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbXLFStZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 13:49:25 -0500
Message-ID: <47584429.8060801@linux.vnet.ibm.com>
Date: Fri, 07 Dec 2007 00:19:13 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rsa@us.ibm.com, apw@shadowen.org, balbir@in.ibm.com
Subject: Re: 2.6.24-rc4-mm1 kobject changes broken with hvcs driver on powerpc
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <20071205141202.GB13189@linux.vnet.ibm.com> <47583D4F.2050707@linux.vnet.ibm.com> <20071206185006.GA21641@kroah.com>
In-Reply-To: <20071206185006.GA21641@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Dec 06, 2007 at 11:49:59PM +0530, Balbir Singh wrote:
>> Kamalesh Babulal wrote:
>>> Hi Andrew,
>>>
>>> The 2.6.24-rc4-mm1 kernel build fails with build failure,
>>>
>>>   CC      drivers/char/hvcs.o
>>> drivers/char/hvcs.c: In function ‘hvcs_open’:
>>> drivers/char/hvcs.c:1180: error: wrong type argument to unary exclamation mark
>>> make[2]: *** [drivers/char/hvcs.o] Error 1
>>> make[1]: *** [drivers/char] Error 2
>>> make: *** [drivers] Error 2
>>>
>>> The kref_get begin void return type, check for the kobject return type
>>> as in the previous kobject_get()
>>>
>>>         if (!kref_get(&hvcsd->kref)) {
>>>                 spin_unlock_irqrestore(&hvcsd->lock, flags); 
>>>                 printk(KERN_ERR "HVCS: Kobject of open"
>>>                         " hvcs doesn't exist.\n");
>>>                 return -EFAULT; /* Is this the right return value? */
>>>         }
>>>
>>> I have tested for the build failure only.
>>>
>>> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
>>> --
>>> --- linux-2.6.24-rc4/drivers/char/hvcs.c	2007-12-05 12:17:37.000000000 +0530
>>> +++ linux-2.6.24-rc4/drivers/char/~hvcs.c	2007-12-05 19:17:12.000000000 +0530
>>> @@ -1177,12 +1177,8 @@ fast_open:
>>>  	hvcsd = tty->driver_data;
>>>
>>>  	spin_lock_irqsave(&hvcsd->lock, flags);
>>> -	if (!kref_get(&hvcsd->kref)) {
>>> -		spin_unlock_irqrestore(&hvcsd->lock, flags);
>>> -		printk(KERN_ERR "HVCS: Kobject of open"
>>> -			" hvcs doesn't exist.\n");
>>> -		return -EFAULT; /* Is this the right return value? */
>>> -	}
>>> +	kref_get(&hvcsd->kref);
>>> +	spin_unlock_irqrestore(&hvcsd->lock, flags);
>>>
>> Why release the spinlock here? It's done after the count is incremented.
>> This patch does not seem correct.
> 
> Doh, you are correct, I'll make sure that I fix this up before applying
> it.
> 
> thanks,
> 
> greg k-h

Sorry, my fault for overlooking that, thanks greg.

-- 
Thanks & Regards,
Kamalesh Babulal,

