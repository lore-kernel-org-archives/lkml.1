Return-Path: <linux-kernel-owner+w=401wt.eu-S1759780AbYAaB1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759780AbYAaB1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 20:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbYAaB1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 20:27:40 -0500
Received: from relay2.sgi.com ([192.48.171.30]:34904 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751719AbYAaB1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 20:27:39 -0500
Date: Wed, 30 Jan 2008 17:27:37 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       daniel.blueman@quadrics.com, Robin Holt <holt@sgi.com>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [kvm-devel] [patch 1/6] mmu_notifier: Core code
In-Reply-To: <20080131001258.GD7185@v2.random>
Message-ID: <Pine.LNX.4.64.0801301718530.2454@schroedinger.engr.sgi.com>
References: <20080130022909.677301714@sgi.com> <20080130022944.236370194@sgi.com>
 <20080130153749.GN7233@v2.random> <20080130155306.GA13746@sgi.com>
 <Pine.LNX.4.64.0801301116510.27491@schroedinger.engr.sgi.com>
 <20080130222035.GX26420@sgi.com> <20080130233803.GB7185@v2.random>
 <Pine.LNX.4.64.0801301552210.1722@schroedinger.engr.sgi.com>
 <20080131001258.GD7185@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, Andrea Arcangeli wrote:

> > Hmmmm.. exit_mmap is only called when the last reference is removed 
> > against the mm right? So no tasks are running anymore. No pages are left. 
> > Do we need to serialize at all for mmu_notifier_release?
> 
> KVM sure doesn't need any locking there.  I thought somebody had to
> possibly take a pin on the "mm_count" and pretend to call
> mmu_notifier_register at will until mmdrop was finally called, in a
> out of order fashion given mmu_notifier_release was implemented like
> if the list could change from under it. Note mmdrop != mmput. mmput
> and in turn mm_users is the serialization point if you prefer to drop
> all locking from _release. Nobody must ever attempt a mmu_notifier_*
> after calling mmput for that mm. That should be enough to be
> safe. I'm fine either ways...

exit_mmap (where we call invalidate_all() and release()) is called when 
mm_users == 0:

void mmput(struct mm_struct *mm)
{
        might_sleep();

        if (atomic_dec_and_test(&mm->mm_users)) {
                exit_aio(mm);
                exit_mmap(mm);
                if (!list_empty(&mm->mmlist)) {
                        spin_lock(&mmlist_lock);
                        list_del(&mm->mmlist);
                        spin_unlock(&mmlist_lock);
                }
                put_swap_token(mm);
                mmdrop(mm);
        }
}
EXPORT_SYMBOL_GPL(mmput);

So there is only a single thread executing at the time when 
invalidate_all() is called from exit_mmap(). Then we drop the 
pages, and the page tables. After the page tables we call the ->release 
method and then remove the vmas.

So even dropping off the mmu_notifier chain in invalidate_all() could be 
done without an issue and without locking.

Trouble is if other callbacks attempt the same. Do we need to support the 
removal from the mmu_notifier list in invalidate_range()?

