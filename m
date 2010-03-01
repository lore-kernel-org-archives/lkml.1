Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab0CASj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:39:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab0CASj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:39:57 -0500
Message-ID: <4B8C09F5.9070506@redhat.com>
Date: Mon, 01 Mar 2010 08:39:49 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, avi@redhat.com,
       mtosatti@redhat.com
Subject: Re: use of setjmp/longjmp in x86 emulator.
References: <20100301091819.GD16909@redhat.com> <4B8BE7C1.40000@redhat.com> <20100301174724.GA12867@redhat.com>
In-Reply-To: <20100301174724.GA12867@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2010 07:47 AM, Gleb Natapov wrote:
> On Mon, Mar 01, 2010 at 06:13:53AM -1000, Zachary Amsden wrote:
>    
>
>> ... you are broken.  This case can be made very much more complex
>> and hard to reason about by using local variables which are reset by
>> the longjmp.
>>
>> Further, it requires use of the volatile keyword to interact
>> properly with logic involving more than one variable, and thus, by
>> definition is impossible to use in the kernel, which does not
>> implement the volatile keyword.  :)
>>      
> volatile is a language keyword how it can be not implemented by the
> kernel? And why volatile is needed to implement longjmp?
>    

Local variables which are not volatile are "undefined" after a longjmp.  
Thus setjmp() return value is the only valid rvalue otherwise.

As I said, the kernel does not implement the volatile keyword :)
(i.e. its use is heavily discouraged to the point one can consider it 
not implemented)

>> Instead, for this case, use the fact that there is an
>> architecturally designed finite number of exceptions that can be
>> processed simultaneously.  This means if you queue exceptions to a
>> pending list of control-flow interrupting events to be processed, as
>> long as the queue is appropriately sized, you will never overflow
>> this queue and never require dynamic allocation.  Further, you can
>> then naturally follow the exception priority rules at the top-level
>> of the emulator and never need to pass back complex exception
>> structures, merely a simple return value which indicates whether to
>> return to top-level control logic or continue with instruction
>> emulation.  I believe using this style of programming will make your
>> need for setjmp/longjmp go away.
>>
>>      
> Of course it is possible to use return values instead. This is what code
> does currently and this is completely unrelated to exception queue
> depth. Code will be much simpler if we will be able to bail out from the
> depth of emulator immediately if exception condition is met or exit to
> userspace is required instead of passing the condition up the call
> chain.
>    

Anything that can generate exceptions is going to need logic to handle 
error cases anyway... the depth can not be that bad.  Especially if you 
structure it so as to optimize for tail calling.

Zach
