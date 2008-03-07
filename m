Return-Path: <linux-kernel-owner+w=401wt.eu-S1759757AbYCGQxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759757AbYCGQxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 11:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYCGQxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 11:53:04 -0500
Received: from viefep32-int.chello.at ([62.179.121.50]:35851 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942AbYCGQxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 11:53:02 -0500
Subject: Re: [PATCH] 3/4 combine RCU with seqlock to allow mmu notifier
	methods to sleep (#v9 was 1/4)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Nick Piggin <npiggin@suse.de>, akpm@linux-foundation.org,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       kvm-devel@lists.sourceforge.net, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
In-Reply-To: <20080307152328.GE24114@v2.random>
References: <20080302155457.GK8091@v2.random>
	 <20080303213707.GA8091@v2.random> <20080303220502.GA5301@v2.random>
	 <47CC9B57.5050402@qumranet.com>
	 <Pine.LNX.4.64.0803032327470.9642@schroedinger.engr.sgi.com>
	 <20080304133020.GC5301@v2.random>
	 <Pine.LNX.4.64.0803041059110.13957@schroedinger.engr.sgi.com>
	 <20080304222030.GB8951@v2.random>
	 <Pine.LNX.4.64.0803041422070.20821@schroedinger.engr.sgi.com>
	 <20080307151722.GD24114@v2.random>  <20080307152328.GE24114@v2.random>
Content-Type: text/plain
Date: Fri, 07 Mar 2008 17:52:42 +0100
Message-Id: <1204908762.8514.114.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-07 at 16:23 +0100, Andrea Arcangeli wrote:


> @@ -42,11 +45,19 @@ int __mmu_notifier_clear_flush_young(str
>  	struct mmu_notifier *mn;
>  	struct hlist_node *n;
>  	int young = 0;
> +	unsigned seq;
>  
>  	rcu_read_lock();
> +restart:
> +	seq = read_seqbegin(&mm->mmu_notifier_lock);
>  	hlist_for_each_entry_rcu(mn, n, &mm->mmu_notifier_list, hlist) {
> -		if (mn->ops->clear_flush_young)
> +		if (mn->ops->clear_flush_young) {

hlist_del_rcu(&mn->hlist)

> +			rcu_read_unlock();

kfree(mn);

>  			young |= mn->ops->clear_flush_young(mn, mm, address);

*BANG*

> +			rcu_read_lock();
> +		}
> +		if (read_seqretry(&mm->mmu_notifier_lock, seq))
> +			goto restart;
>  	}
>  	rcu_read_unlock();



