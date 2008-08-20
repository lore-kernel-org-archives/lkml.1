Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbYHTSlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbYHTSlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 14:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYHTSlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 14:41:46 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:57131 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbYHTSlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 14:41:45 -0400
Message-Id: <200808201847.AA00213@capsicum.lab.ntt.co.jp>
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Date: Thu, 21 Aug 2008 03:47:06 +0900
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] nilfs2: continuous snapshotting file system
In-Reply-To: <84144f020808200122w3e5adc4ci4eec761a1e570bda@mail.gmail.com>
References: <84144f020808200122w3e5adc4ci4eec761a1e570bda@mail.gmail.com>
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.13
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 11:22 AM, Pekka Enberg wrote:
>Hmm, this looks bit scary:
>
>> +/*
>> + * Low-level nilfs pages, page functions
>> + * Reviews should be made to adapt these to the common pagemap and buffer code.
>> + */
>> +static struct nilfs_pages {
>> +       spinlock_t              lru_lock;
>> +       struct list_head        active;
>> +       struct list_head        inactive;
>> +       unsigned long           nr_active;
>> +       unsigned long           nr_inactive;
>> +       struct rw_semaphore     shrink_sem;
>> +} nilfs_pages;
>> +
>> +/*
>> + * XXX per-cpu pagevecs may be able to reduce the overhead of list handlings
>> + *
>> + * static DEFINE_PER_CPU(struct pagevec, nilfs_lru_active) = { 0, };
>> + * static DEFINE_PER_CPU(struct pagevec, nilfs_lru_inactive) = { 0, };
>> + */
>> +
>> +void nilfs_pages_init(void)
>> +{
>> +       INIT_LIST_HEAD(&nilfs_pages.active);
>> +       INIT_LIST_HEAD(&nilfs_pages.inactive);
>> +       spin_lock_init(&nilfs_pages.lru_lock);
>> +       init_rwsem(&nilfs_pages.shrink_sem);
>> +       nilfs_pages.nr_active = 0;
>> +       nilfs_pages.nr_inactive = 0;
>> +}

Yeah, it's bothersome part.
I'd like to eliminate this peculiar code by using the standard mm/
functions or bd_inode, but still pending.

It's mainly used to maintain pages held by struct nilfs_btnode_cache,
which is a per-inode additional page cache used to store buffers of
B-tree.

Incidentally, for data blocks, mm/ page cache is used like other
file systems.

>(a) why does NILFS need this and (b) why aren't these patches against
>generic mm/*.c?

(a) I believe this is historical, but I will confirm the reason
    why filemap was not adopted.

(b) Because I think it should be eliminated rather than integrated 
    into mm/ at this point.

Thank you for comment.

Regards,
Ryusuke Konishi
