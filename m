Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbZKBE1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbZKBE1N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 23:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbZKBE1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 23:27:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825AbZKBE1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 23:27:12 -0500
Message-ID: <4AEE5FA3.1020104@redhat.com>
Date: Sun, 01 Nov 2009 23:27:15 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] Add shared memory hypercall to PV Linux guest.
References: <1257076590-29559-1-git-send-email-gleb@redhat.com> <1257076590-29559-2-git-send-email-gleb@redhat.com>
In-Reply-To: <1257076590-29559-2-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2009 06:56 AM, Gleb Natapov wrote:
> Add hypercall that allows guest and host to setup per cpu shared
> memory.

While it is pretty obvious that we should implement
the asynchronous pagefaults for KVM, so a swap-in
of a page the host swapped out does not stall the
entire virtual CPU, I believe that adding extra
data accesses at context switch time may not be
the best tradeoff.

It may be better to simply tell the guest what
address is faulting (or give the guest some other
random unique number as a token).  Then, once the
host brings that page into memory, we can send a
signal to the guest with that same token.

The problem of finding the task(s) associated with
that token can be left to the guest.  A little more
complexity on the guest side, but probably worth it
if we can avoid adding cost to the context switch
path.

> +static void kvm_end_context_switch(struct task_struct *next)
> +{
> +	struct kvm_vcpu_pv_shm *pv_shm =
> +		per_cpu(kvm_vcpu_pv_shm, smp_processor_id());
> +
> +	if (!pv_shm)
> +		return;
> +
> +	pv_shm->current_task = (u64)next;
> +}
> +



-- 
All rights reversed.
