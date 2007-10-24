Return-Path: <linux-kernel-owner+w=401wt.eu-S1759698AbXJXRbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698AbXJXRbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbXJXRau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:30:50 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:34731 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754440AbXJXRat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:30:49 -0400
Message-ID: <471F812B.2020005@suse.de>
Date: Wed, 24 Oct 2007 21:30:19 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Alexey Starikovskiy <aystarik@gmail.com>, Len Brown <len.brown@intel.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] acpi/ec.c: fix use-after-free
References: <20071024162600.GD30533@stusta.de> <471F7DA6.2060907@gmail.com> <20071024172604.GD30533@stusta.de>
In-Reply-To: <20071024172604.GD30533@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Wed, Oct 24, 2007 at 09:15:18PM +0400, Alexey Starikovskiy wrote:
>> Adrian,
>>
>> commit 30c08574da0ead1a47797ce028218ce5b2de61c7 can not introduce use-after-free.
>>
>> Please check...
> 
> 
> Commit 30c08574da0ead1a47797ce028218ce5b2de61c7 did:
> 
> <--  snip  -->
> 
>  	list_for_each_entry(handler, &ec->list, node) {
>                 if (query_bit == handler->query_bit) {
>                         list_del(&handler->node);
>                         kfree(handler);
> -                       break;
>                 }
> 	}
> 
> <--  snip  -->
> 
> 
> If you look at the definition of list_for_each_entry() in 
> include/linux/list.h:
> 
> <--  snip  -->
> 
> #define list_for_each_entry(pos, head, member)                          \
>         for (pos = list_entry((head)->next, typeof(*pos), member);      \
>              prefetch(pos->member.next), &pos->member != (head);        \
>              pos = list_entry(pos->member.next, typeof(*pos), member))
>                               ^^^^^^^^^^^^^^^^
> 
> <--  snip  -->
> 
> 
> Without the "break", "handler" is being dereferenced after it was freed.
Yes, found it minute before :( 
Acked, thanks.
> 
> 
>> Regards,
>> Alex.
>> Adrian Bunk wrote:
>>> This patch fixes a use-after-free introduced by
>>> commit 30c08574da0ead1a47797ce028218ce5b2de61c7.
>>>
>>> Spotted by the Coverity checker.
>>>
>>> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>>>
>>> ---
>>> --- linux-2.6/drivers/acpi/ec.c.old	2007-10-23 19:39:47.000000000 +0200
>>> +++ linux-2.6/drivers/acpi/ec.c	2007-10-23 19:34:55.000000000 +0200
>>> @@ -434,11 +442,11 @@
>>>  EXPORT_SYMBOL_GPL(acpi_ec_add_query_handler);
>>>  
>>>  void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8 query_bit)
>>>  {
>>> -	struct acpi_ec_query_handler *handler;
>>> +	struct acpi_ec_query_handler *handler, *tmp;
>>>  	mutex_lock(&ec->lock);
>>> -	list_for_each_entry(handler, &ec->list, node) {
>>> +	list_for_each_entry_safe(handler, tmp, &ec->list, node) {
>>>  		if (query_bit == handler->query_bit) {
>>>  			list_del(&handler->node);
>>>  			kfree(handler);
>>>  		}
>>>
> 
> 
> cu
> Adrian
> 

