Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbZBSW03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbZBSW03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 17:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbZBSW0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 17:26:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53925 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbZBSW0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 17:26:20 -0500
Subject: Re: [PATCH] drm: Fix lock order reversal between mmap_sem and
 struct_mutex.
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Hellstrom <thomas@shipmail.org>
Cc: Eric Anholt <eric@anholt.net>, Wang Chen <wangchen@cn.fujitsu.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <499DC8EC.3000806@shipmail.org>
References: <1234918786-854-1-git-send-email-eric@anholt.net>
	 <1234969734.4637.111.camel@laptop>  <499DC8EC.3000806@shipmail.org>
Content-Type: text/plain
Date: Thu, 19 Feb 2009 23:26:12 +0100
Message-Id: <1235082372.4612.665.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 22:02 +0100, Thomas Hellstrom wrote:
>  
> It looks to me like the driver preferred locking order is
> 
> object_mutex (which happens to be the device global struct_mutex)
>   mmap_sem
>      offset_mutex.
> 
> So if one could avoid using the struct_mutex for object bookkeeping (A 
> separate lock) then
> vm_open() and vm_close() would adhere to that locking order as well, 
> simply by not taking the struct_mutex at all.
> 
> So only fault() remains, in which that locking order is reversed. 
> Personally I think the trylock ->reschedule->retry method with proper 
> commenting is a good solution. It will be the _only_ place where locking 
> order is reversed and it is done in a deadlock-safe manner. Note that 
> fault() doesn't really fail, but requests a retry from user-space with 
> rescheduling to give the process holding the struct_mutex time to 
> release it.

It doesn't do the reschedule -- need_resched() will check if the current
task was marked to be scheduled away, furthermore yield based locking
sucks chunks.

What's so very difficult about pulling the copy_*_user() out from under
the locks?

