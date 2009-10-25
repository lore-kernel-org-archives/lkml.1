Return-Path: <linux-kernel-owner+w=401wt.eu-S1751837AbZJYOaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbZJYOaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 10:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbZJYOaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 10:30:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbZJYOaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 10:30:22 -0400
Message-ID: <4AE460F4.2090905@redhat.com>
Date: Sun, 25 Oct 2009 16:30:12 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net
Subject: Re: [KVM PATCH v2 1/2] KVM: export lockless GSI attribute
References: <20091023023512.3891.65889.stgit@dev.haskins.net> <20091023023845.3891.36857.stgit@dev.haskins.net>
In-Reply-To: <20091023023845.3891.36857.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2009 04:38 AM, Gregory Haskins wrote:
> Certain GSI's support lockless injecton, but we have no way to detect
> which ones at the GSI level.  Knowledge of this attribute will be
> useful later in the series so that we can optimize irqfd injection
> paths for cases where we know the code will not sleep.  Therefore,
> we provide an API to query a specific GSI.
>
>    

Instead of a lockless attribute, how about a ->set_atomic() method.  For 
msi this can be the same as ->set(), for non-msi it can be a function 
that schedules the work (which will eventually call ->set()).

The benefit is that we make a decision only once, when preparing the 
routing entry, and install that decision in the routing entry instead of 
making it again and again later.

> +int kvm_irq_check_lockless(struct kvm *kvm, u32 irq)
>    

bool kvm_irq_check_lockless(...)

> +{
> +	struct kvm_kernel_irq_routing_entry *e;
> +	struct kvm_irq_routing_table *irq_rt;
> +	struct hlist_node *n;
> +	int ret = -ENOENT;
> +
> +	rcu_read_lock();
> +	irq_rt = rcu_dereference(kvm->irq_routing);
> +	if (irq<  irq_rt->nr_rt_entries)
> +		hlist_for_each_entry(e, n,&irq_rt->map[irq], link)
> +			ret = e->lockless ? 1 : 0;
>    

     ret = e->lockless;

> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +
>    

-- 
error compiling committee.c: too many arguments to function

