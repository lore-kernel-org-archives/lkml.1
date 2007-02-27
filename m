Return-Path: <linux-kernel-owner+w=401wt.eu-S1752095AbXB0UcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbXB0UcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:32:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbXB0UcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:32:04 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50579 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbXB0UcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:32:01 -0500
Date: Tue, 27 Feb 2007 12:25:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: hugh@veritas.com, paulmck@linux.vnet.ibm.com, clameter@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adapt page_lock_anon_vma() to PREEMPT_RCU
Message-Id: <20070227122517.c8bceaf5.akpm@linux-foundation.org>
In-Reply-To: <20070225200621.GA2259@tv-sign.ru>
References: <20070225200621.GA2259@tv-sign.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 25 Feb 2007 23:06:21 +0300 Oleg Nesterov <oleg@tv-sign.ru> wrote:
> page_lock_anon_vma() uses spin_lock() to block RCU. This doesn't work with
> PREEMPT_RCU, we have to do rcu_read_lock() explicitely. Otherwise, it is
> theoretically possible that slab returns anon_vma's memory to the system
> before we do spin_unlock(&anon_vma->lock).
> 
> ...
>
> +static void page_unlock_anon_vma(struct anon_vma *anon_vma)
> +{
> +	spin_unlock(&anon_vma->lock);
> +	rcu_read_unlock();
>  }

It's a bit sad doing a double preempt_disable() for non-PREEMPT_RCU builds.

Perhaps we would benefit from a new rcu_read_lock_preempt_rcu() which is a
no-op if !PREEMPT_RCU.

