Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbZGAHaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbZGAHaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbZGAHan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:30:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40806 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbZGAHam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:30:42 -0400
Message-ID: <4A4B1106.8000506@redhat.com>
Date: Wed, 01 Jul 2009 10:32:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: linux-next: manual merge of the kvm tree with Linus' tree
References: <20090701145711.1c9c8935.sfr@canb.auug.org.au> <alpine.DEB.1.10.0907010007020.8745@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0907010007020.8745@makko.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2009 10:10 AM, Davide Libenzi wrote:
> On Wed, 1 Jul 2009, Stephen Rothwell wrote:
>
>    
>> Hi Avi,
>>
>> Today's linux-next merge of the kvm tree got a conflict in fs/eventfd.c
>> between commit 133890103b9de08904f909995973e4b5c08a780e ("eventfd:
>> revised interface and cleanups") from Linus' tree and commit
>> 28ddf0aebbf546e56efd1951725d5457ce1ebf98 ("eventfd: Allow waiters to be
>> notified about the eventfd file* going away") from the kvm tree.
>>
>> Overlapping changes.  I fixed it up (see below), but don't know if this
>> is the correct fix.
>>
>> -- 
>> Cheers,
>> Stephen Rothwell                    sfr@canb.auug.org.au
>>
>> diff --cc fs/eventfd.c
>> index 31d12de,72f5f8d..0000000
>> --- a/fs/eventfd.c
>> +++ b/fs/eventfd.c
>> @@@ -105,8 -63,13 +105,13 @@@ static int eventfd_release(struct inod
>>    {
>>    	struct eventfd_ctx *ctx = file->private_data;
>>
>> - 	wake_up_poll(&ctx->wqh, POLLHUP);
>> + 	/*
>> + 	 * No need to hold the lock here, since we are on the file cleanup
>> + 	 * path and the ones still attached to the wait queue will be
>> + 	 * serialized by wake_up_locked_poll().
>> + 	 */
>> + 	wake_up_locked_poll(&ctx->wqh, POLLHUP);
>>   -	kfree(ctx);
>>   +	eventfd_ctx_put(ctx);
>>    	return 0;
>>    }
>>      
>
> That's fine.
> There are a couple of extra spaces before the last two -+ in that patch
> though ;)
>    

No, that's a git N-way diff format.  The first column shows the changes 
relative to mainline by kvm.git, and the second the changes to kvm.git 
made by mainline.

I've merged and will push soon, which will resolve the conflict, but I 
think the patch wake_up_locked_poll() is better off in mainline rather 
than kvm.git.

-- 
error compiling committee.c: too many arguments to function

