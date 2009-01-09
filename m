Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbZAIMb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbZAIMb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 07:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbZAIMbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 07:31:47 -0500
Received: from genesysrack.ru ([195.178.208.66]:42216 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbZAIMbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 07:31:46 -0500
Date: Fri, 9 Jan 2009 15:31:41 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Grissiom <chaos.proton@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH] async: Don't call async_synchronize_full_special() while holding sb_lock
Message-ID: <20090109123140.GA18948@ioremap.net>
References: <a0adeea50901080007q5a3ed5c8y5a744ce37e677325@mail.gmail.com> <1231425472.21528.13.camel@norville.austin.ibm.com> <20090108072111.1ebadebd@infradead.org> <1231429591.27353.14.camel@norville.austin.ibm.com> <20090108225050.GL9448@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090108225050.GL9448@disturbed>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan.

Likely my mail is in your blacklist that's why you did not reply on
comment on the discussion about this async interface month or so ago :)

Anyway, what you did for the boot process should be only there, but vfs
changes have to be discussed in fsdevel.

For example generic_delete_inode() does not delete inode anymore,
instead it queues the work to the set of threads, serialized by the
global spinlock and atomic variables, allocating additional structure
for this not from the memory pool or at least memory cache, but
directly via slab.
This atomic allocation thus may be invoked during the cache shrink
path to free some memory, which is not a good idea. So if you do insist
that deletion of every inode should be async, at least shrink size of
the async_event and embed it into the inode, or use memory pool.

Just several other notes on the code.

__async_schedule() could first check amount of pending requests and
do not allocate and free the entry if all threads are busy.

entry processing code run_one_entry() should not free entry under the
irq-off lock.

Thread start routing should check if thread successfully started before
increasing number of the running thread, or this can be done in the
thread callback itself.

-- 
	Evgeniy Polyakov
