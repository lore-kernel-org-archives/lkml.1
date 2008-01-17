Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbYAQIbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbYAQIbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 03:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYAQIbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 03:31:47 -0500
Received: from hu-out-0506.google.com ([72.14.214.233]:29386 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbYAQIbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 03:31:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=EvcIlauYIZSkhpZqHaqVG+YJjgmcdDUeS/CkuAEdmMMkDHvMyu0MpxCt1k+IhCCBWFreon48Zx5yaRZeC0XuMqce7MMgenyb4FPCy4nnTYOLdVwC5WhEDhTeA8RWDU821DB0SWgIBNqE1lINeBJ6jhvpEnqY+JdeD1+bqNKzhc4=
Date: Thu, 17 Jan 2008 09:38:10 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <gregkh@suse.de>, stefanr@s5r6.in-berlin.de, david-b@pacbell.net,
       stern@rowland.harvard.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
	class
Message-ID: <20080117083810.GA1710@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0801161717r4cdc1e9cn6a8ec1731c8f831b@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17-01-2008 02:17, Dave Young wrote:
> On Jan 16, 2008 4:34 PM, Jarek Poplawski <jarkao2@gmail.com> wrote:
>> On Wed, Jan 16, 2008 at 09:03:03AM +0800, Dave Young wrote:
>> ...
>>> The lockdep warining was posted in the below thread, actually, I have
>>> built and run this patced kernel for several days, there's no more
>>> warnings.
>>> http://lkml.org/lkml/2008/1/3/2
>> Right... But, with something like this:
>>
>> ... have_some_fun(... cls)
>> {
>>         mutex_lock_nested(&cls->mutex, SINGLE_DEPTH_NESTING);
>>         have_other_fun(cls);
>>         mutex_unlock(&cls->mutex);
>>
>> }
>>
>> ... have_more_fun(...)
>> {
>>         ...
>>
>>         mutex_init(&cls->mutex);
>>
>>         mutex_lock(&cls->mutex);
>>         have_some_fun(cls);
>>         mutex_unlock(&cls->mutex);
>> }
>>
>> probably you wouldn't get any lockdep warning too...
> 
> Sorry for late reply.
> Actually, I don't know much about lockdep. Could you tell how to use
> it properly in this scenario?

As you have noticed while working on this patch, if two different
instances of the same structure containig some lock are created in
the same place, lockdep will treat this one (the same) lock. It looks
strange, but actually it's a feature which enables to track
dependencies between different locks on 'class' level instead of
instance 'level'. The downside is that lockdep is very often too
sensitive by default, so you have to 'annotate' when instancess are
actually on different level (e.g. parents and children here) and
could be locked at the same time or in some order.

You can use e.g. mutex_lock_nested() or lockdep_set_class*() for this.
Then lockdep simply trusts you, and starts to think they are different
locks. If you do it wrong there will be simply no more warnings, but
undercover lockups still possible (and diagnosing a bit harder then).
So, since in your patch there are two levels of locking, and you
started to annotate lockdep about a child taking parent's class lock
with: 
mutex_lock_nested(&parent_class->mutex, SINGLE_DEPTH_NESTING);

you should do the same everywhere in a situation like this.
lockdep will treat this simply as lock B vs. A (mutex_lock(&cls))
dependencies.

Regards,
Jarek P.

PS: BTW, it seems after this patch 1/1 the locking was changed a bit,
so these previous tests could be not enough.
