Return-Path: <linux-kernel-owner+w=401wt.eu-S1758352AbZJENLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352AbZJENLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 09:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756598AbZJENLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 09:11:46 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:49657 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbZJENLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 09:11:45 -0400
Message-ID: <4AC9F06B.8020708@anirban.org>
Date: Mon, 05 Oct 2009 06:11:07 -0700
From: Anirban Sinha <ani@anirban.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.4pre) Gecko/20090915 Thunderbird/3.0b4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       Kaz Kylheku <kaz@zeugmasystems.com>,
       Anirban Sinha <asinha@zeugmasystems.com>
Subject: Re: futex question
References: <DDFD17CC94A9BD49A82147DDF7D545C501FD7F97@exchange.ZeugmaSystems.local>  <20091001092218.GH15345@elte.hu>  <DDFD17CC94A9BD49A82147DDF7D545C501FD8409@exchange.ZeugmaSystems.local>  <4AC68F13.8050601@us.ibm.com>  <alpine.LFD.2.00.0910041031330.2646@localhost.localdomain>  <DDFD17CC94A9BD49A82147DDF7D545C501F457C5@exchange.ZeugmaSystems.local>  <4AC8CF32.8060108@anirban.org>  <alpine.LFD.2.00.0910041853180.2646@localhost.localdomain>  <1254738974.26976.24.camel@twins>  <alpine.LFD.2.00.0910051251080.2646@localhost.localdomain> <1254741372.26976.35.camel@twins> <alpine.LFD.2.00.0910051346230.2646@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0910051346230.2646@localhost.localdomain>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:

catching up with the mails now. still pretty early here in the west coast.

Once upon a time, like on 09-10-05 4:47 AM, Thomas Gleixner wrote:
> On Mon, 5 Oct 2009, Peter Zijlstra wrote:
>> On Mon, 2009-10-05 at 12:56 +0200, Thomas Gleixner wrote:
>>>
>>> Looking more into that I think we should check whether the robust list
>>> has an entry (lock held) in do_execve() and return -EWOULDBLOCK to
>>> luser space. Same if pi_waiters is not empty. Holding a lock and
>>> calling execve() is simply broken.
>>

ha ha! Now you say it's broken :) Indeed, I also thought so. However, I  wonder if this behavior change could potentially break some user space application? 
 

>> Fine by me ;-)
>>
>> something like the below?
>>
>> The question is of course what Ani was doing that triggered this in the
>> first place and if he can live with this.. :-)
>>
>> ---
>>  fs/exec.c |   16 ++++++++++++++++
>>  1 files changed, 16 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/exec.c b/fs/exec.c
>> index d49be6b..0812ba6 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -1295,6 +1295,22 @@ int do_execve(char * filename,
>>  	bool clear_in_exec;
>>  	int retval;
>>  
>> +	retval = -EWOULDBLOCK;
>> +#ifdef CONFIG_FUTEX
>> +	if (unlikely(current->robust_list))
>> +		goto out_ret;
>> +#ifdef CONFIG_COMPAT
>> +	if (unlikely(current->compat_robust_list))
>> +		goto out_ret;
>> +#endif
> 
>   That needs to call into the futex code and check whether the list is
>   empty. If not empty, return. If empty set the pointer to NULL

True. Just because the head pointer has been registered does not mean that the list is non-empty. It can point back to itself when no locks are held as it's circular.

We need to clear those pointers regardless. After the exceve(), the address values are meaningless under the new mm context.

Ani
