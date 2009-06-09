Return-Path: <linux-kernel-owner+w=401wt.eu-S932265AbZFIM5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbZFIM5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932067AbZFIM5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:57:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42878 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130AbZFIM5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:57:22 -0400
Message-ID: <4A2E5BF1.5060405@redhat.com>
Date: Tue, 09 Jun 2009 15:56:17 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
 kernels
References: <4A0B62F7.5030802@goop.org> <200906032208.28061.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906030901460.4880@localhost.localdomain> <200906041554.37102.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain> <20090609093918.GC16940@wotan.suse.de> <20090609111719.GA4463@elte.hu> <20090609121055.GA9158@wotan.suse.de> <20090609122529.GD25586@elte.hu>
In-Reply-To: <20090609122529.GD25586@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Fork is pretty much the worst-case measurement for larger pte 
> overhead, as it has to copy around a lot of pagetables.
>   

We could eliminate that if we use the R/W bit on pgd entries.  fork() 
would be 256 clear_bit()s (1536 and 768 on i386 pae and nonpae).

copy_one_pte() disagrees though:

        if (unlikely(!pte_present(pte))) {
                if (!pte_file(pte)) {
                        swp_entry_t entry = pte_to_swp_entry(pte);

                        swap_duplicate(entry);
                        /* make sure dst_mm is on swapoff's mmlist. */
                        if (unlikely(list_empty(&dst_mm->mmlist))) {
                                spin_lock(&mmlist_lock);
                                if (list_empty(&dst_mm->mmlist))
                                        list_add(&dst_mm->mmlist,
                                                 &src_mm->mmlist);
                                spin_unlock(&mmlist_lock);
                        }
                        if (is_write_migration_entry(entry) &&
                                        is_cow_mapping(vm_flags)) {
                                /*
                                 * COW mappings require pages in both parent
                                 * and child to be set to read.
                                 */
                                make_migration_entry_read(&entry);
                                pte = swp_entry_to_pte(entry);
                                set_pte_at(src_mm, addr, src_pte, pte);
                        }
                }
                goto out_set_pte;
        }


Not sure how we can enlaze this thing.

-- 
error compiling committee.c: too many arguments to function

