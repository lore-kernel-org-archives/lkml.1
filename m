Return-Path: <linux-kernel-owner+w=401wt.eu-S1760380AbZFNMwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760380AbZFNMwG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758759AbZFNMvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:51:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33521 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758627AbZFNMvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:51:52 -0400
Message-ID: <4A34F262.6000206@redhat.com>
Date: Sun, 14 Jun 2009 15:51:46 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org
Subject: Re: [KVM PATCH v2 0/2] irqfd: use POLLHUP notification for close()
References: <20090604124047.10544.38861.stgit@dev.haskins.net> <20090612040837.GA8862@redhat.com> <4A34EF41.3020301@novell.com>
In-Reply-To: <4A34EF41.3020301@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
>   
>> [ Resending with correct address for Davide. Pls don't reply
>>   to the original one, you'll get bounces. ]
>>
>> On Thu, Jun 04, 2009 at 08:48:02AM -0400, Gregory Haskins wrote:
>>   
>>     
>>> (Applies to kvm.git/master:25deed73)
>>>
>>> Please see the header for 2/2 for a description.  This patch series has been
>>> fully tested and appears to be working correctly.
>>>
>>> [Review notes:
>>>       *) Paul has looked at the SRCU design and, to my knowledge, didn't find
>>>          any holes.
>>>       *) Michael, Avi, and myself agree that while the removal of the DEASSIGN
>>>          vector is not desirable, the fix on close() is more important in
>>>          the short-term.  We can always add DEASSIGN support again in the
>>> 	 future with a CAP bit.
>>> ]
>>>     
>>>       
>> So, I've been thinking about this, and this approach has another
>> problem: it depends on pollhup on close which is AFAIK an
>> eventfd-specific feature.
>>     
>
> Thats ok with me, as we are already married to eventfd for other reasons
> (see eventfd_fget()).
>
>   
>>  This will prevent us from supporting polling
>> other useful file types, such as sockets and pipes, down the road, with
>> this interface.
>>   
>>     
> I am thinking that we would add explicit support in the future if there
> are other fd types that might want to also inject interrupts.  For
> instance, perhaps POLLHUP is added to pipes if/when they are patched as
> a valid transport for irqfd.   Or perhaps irqfd is abstracted such that
> eventfd_fget/POLLHUP are eventfd specific assign/deassign implementation
> details.
>
> Another option is that we s/irqfd/irq-eventfd to leave room for other
> interfaces like irq-pollfd, irq-socketfd, etc.  IOW, there is no reason
> to make the current irqfd code "one-fd-interface to rule them all" per
> se.  The real abstraction is the kvm_set_irq() + gsi interface anyway. 
> The current irqfd code is a thin shim in front of that.  Perhaps each fd
> type would be better served with code to specifically handle each type,
> for its hard to predict what the requirements for translating, say, a
> pipe-write into a gsi-inject will be apriori.
>
>   

I don't see a reason to avoid a monogamous relationship with eventfd as 
it exactly captures the essence of an raising an interrupt: events are 
coalesced and it doesn't block.  Since irqfd will rarely work by itself 
(need a separate data channel), having things like a tcp socket inject 
an interrupt are, while exotic, fairly useless.

>> I didn't realise these implications when I suggested deassign on close.
>> To me, it now looks like we are better off reverting this patch.
>> We can later add 'deassign on close' support with CAP bit after all :)
>>
>> Avi, Gregory, what's your take?
>>
>>   
>>     
> I like the design with the single-call close in place, so my vote is to
> keep it as it is now.
>   

We could work around it by allocating a gsi private to the eventfd, and 
when we want to mask the gsi, simply drop all its routes.  Hacky.

-- 
error compiling committee.c: too many arguments to function

