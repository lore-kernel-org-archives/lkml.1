Return-Path: <linux-kernel-owner+w=401wt.eu-S1759375AbZEGJsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375AbZEGJsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbZEGJs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:48:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57198 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751AbZEGJsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:48:25 -0400
Message-ID: <4A02AE65.3000800@redhat.com>
Date: Thu, 07 May 2009 12:48:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Gregory Haskins <ghaskins@novell.com>, viro@ZenIV.linux.org.uk,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [KVM PATCH v4 2/2] kvm: add support for irqfd via eventfd-notification
 interface
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <20090504175750.26758.7023.stgit@dev.haskins.net> <4A0175F0.1090705@novell.com> <alpine.DEB.1.10.0905060818000.32007@makko.or.mcafeemobile.com> <4A01AEC1.8020201@novell.com> <alpine.DEB.1.10.0905061834080.32606@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0905061834080.32606@makko.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> On Wed, 6 May 2009, Gregory Haskins wrote:
>
>   
>> I think we are ok in this regard (at least in v5) without the callback. 
>> kvm holds irqfd, which holds eventfd.  In a normal situation, we will
>> have eventfd with 2 references.  If userspace closes the eventfd, it
>> will drop 1 of the 2 eventfd file references, but the object should
>> remain intact as long as kvm still holds it as well.  When the kvm-fd is
>> released, we will then decouple from the eventfd->wqh and drop the last
>> fput(), officially freeing it.
>>
>> Likewise, if kvm is closed before the eventfd, we will simply decouple
>> from the wqh and fput(eventfd), leaving the last reference held by
>> userspace until it closes as well.
>>
>> Let me know if you see any holes in that.
>>     
>
> Looks OK, modulo my knowledge of KVM internals.
>   

What's your take on adding irq context safe callbacks to irqfd?

To give some background here, we would like to use eventfd as a generic 
connector between components, so the components do not know about each 
other.  So far eventfd successfully abstracts among components in the 
same process, in different processes, and in the kernel.

eventfd_signal() can be safely called from irq context, and will wake up 
a waiting task.  But in some cases, if the consumer is in the kernel, it 
may be able to consume the event from irq context, saving a context switch.

So, will you consider patches adding this capability to eventfd?

-- 
error compiling committee.c: too many arguments to function

