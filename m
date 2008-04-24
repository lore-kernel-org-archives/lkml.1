Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbYDXXxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbYDXXxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 19:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYDXXxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 19:53:18 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:58758
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYDXXxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 19:53:17 -0400
Date: Fri, 25 Apr 2008 01:53:15 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@qumranet.com>,
       Christoph Lameter <clameter@sgi.com>, Robin Holt <holt@sgi.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Minimal mmu notifiers for kvm
Message-ID: <20080424235315.GA9407@duo.random>
References: <200804250813.00792.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804250813.00792.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 08:13:00AM +1000, Rusty Russell wrote:
> AFAICT this is the minimal mmu notifier support required by kvm.  It's pretty
> trivial and in fact contains all the parts noone's arguing over.

I posted things like this that can't work for XPMEM for a long time
with very negative feedback.

Besides, at the time we thought mmu notifiers were only to make
swapping more reliable, now its' more. And without range_begin kvm
can't remove the pin on the page and guarantee that rmap_remove isn't
the last put_page to be able to do the tlb flush after rmap_remove
returned. The kvm patch I used to post and only implements
invalidate_range_end is entirely obsolete, as lack of range_begin
entirely depends on having a page pin and having a page pin means
rmap_remove will release it allowing the vm to free the page one
nanosecond after in a different cpu.

To implement range_begin mm_lock is required.

To unregister reliably you need srcu and ->release is forbidden to
unpin the module.

The absolute minimum required for kvm to make progress is this as far
as I can tell:

http://www.kernel.org/pub/linux/kernel/people/andrea/patches/v2.6/2.6.25/mmu-notifier-v14-pre3/mmu-notifier-core

BTW, your patch also makes it impossible to know when a mmu notifier
will start firing as the fast path is read out of order. In the old
rcu days the register function had a synchronize_rcu but I quickly
realized that rcu wasn't enough in presence of a range_begin. These
days mm_lock solves both the guarantee that notifiers will start
firing when unregister returns, and it guarantees to register when no
other task is in the middle of range_begin/end critical section.

Hope this explains why my patch has to be a bit more complex than
this, I've no interest to keep things more complex than they need to
be, except with details like using srcu instead of rcu to avoid
unhappiness from Robin/Christoph given it's not much more complex than
rcu already is.
