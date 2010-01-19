Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811Ab0ASOEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab0ASOEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 09:04:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113Ab0ASOEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 09:04:10 -0500
Received: from david.siemens.de ([192.35.17.14]:18235 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab0ASOEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 09:04:08 -0500
Message-ID: <4B55BBB6.2020901@siemens.com>
Date: Tue, 19 Jan 2010 15:03:34 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kvm: fix spurious interrupt with irqfd
References: <cover.1263402727.git.mst@redhat.com> <20100113171230.GB19798@redhat.com> <4B55B2B8.5090105@siemens.com> <20100119134827.GA28191@redhat.com>
In-Reply-To: <20100119134827.GA28191@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
> On Tue, Jan 19, 2010 at 02:25:12PM +0100, Jan Kiszka wrote:
>> Michael S. Tsirkin wrote:
>>> kvm didn't clear irqfd counter on deassign, as a result we could get a
>>> spurious interrupt when irqfd is assigned back. this leads to poor
>>> performance and, in theory, guest crash.
>>>
>>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>> ---
>>>  virt/kvm/eventfd.c |    3 ++-
>>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>>> index 62e4cd9..a9d3fc6 100644
>>> --- a/virt/kvm/eventfd.c
>>> +++ b/virt/kvm/eventfd.c
>>> @@ -72,12 +72,13 @@ static void
>>>  irqfd_shutdown(struct work_struct *work)
>>>  {
>>>  	struct _irqfd *irqfd = container_of(work, struct _irqfd, shutdown);
>>> +	u64 cnt;
>>>  
>>>  	/*
>>>  	 * Synchronize with the wait-queue and unhook ourselves to prevent
>>>  	 * further events.
>>>  	 */
>>> -	remove_wait_queue(irqfd->wqh, &irqfd->wait);
>>> +	eventfd_ctx_remove_wait_queue(irqfd->eventfd, &irqfd->wait, &cnt);
>>>  
>>>  	/*
>>>  	 * We know no new events will be scheduled at this point, so block
>> For kvm-kmod, I'm fighting with compat support for
>> eventfd_ctx_remove_wait_queue. I basically have a solution for kernels
>> with CONFIG_KPROBES enabled (I need to look up unexported
>> __wake_up_locked[_key]), but there will also be target kernels that do
>> not have this. So there are three options for that case:
>>
>>  - Warn the user and fall back to the old racy approach
>>  - (Somehow) disable KVM subsystems that use eventfd
>>  - Refuse to start KVM
>> As far as I understood, irqfd is interesting for device assignment and
>> now also for vhost, right?
> 
> At the moment, only vhost.
> 
>> What about ioeventfd?
> 
> Same thing.
> 

OK...

>> I just wonder how broad
>> the impact of a broken or non-existent eventfd subsystem for kvm-kmod
>> is. Any thoughts welcome.
> 
> How do you handle kernels that don't export eventfd_ctx_fileget?

Now that you mention it: not yet properly. So far we pass the file
struct as pseudo eventfd_ctx around on < 2.6.31. But now that I peek
into the struct in kvm_eventfd_ctx_remove_wait_queue, this should should
crash. Guess I need to look up that module the same way as I acquire
__wake_up_locked[_key].

> 
>> Jan
>>
>> PS: If anyone forgot why Avi handed over this job, you should now
>> remember why. :)
> 
> Heh, I did the same kind of thing for infiniband for
> several years. It's hard to forget.
> 

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
