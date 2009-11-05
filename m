Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbZKEU4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbZKEU4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 15:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758611AbZKEU4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 15:56:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37459 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758509AbZKEU4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 15:56:14 -0500
To: Christoph Lameter <cl@linux-foundation.org>
Cc: npiggin@suse.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
Subject: Re: Subject: [RFC MM] mmap_sem scaling: Use mutex and percpu counter instead
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.DEB.1.10.0911051417370.24312@V090114053VZO-1>
	<alpine.DEB.1.10.0911051419320.24312@V090114053VZO-1>
Date: Thu, 05 Nov 2009 21:56:18 +0100
In-Reply-To: <alpine.DEB.1.10.0911051419320.24312@V090114053VZO-1> (Christoph Lameter's message of "Thu, 5 Nov 2009 14:20:47 -0500 (EST)")
Message-ID: <87r5sc7kst.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux-foundation.org> writes:

> Instead of a rw semaphore use a mutex and a per cpu counter for the number
> of the current readers. read locking then becomes very cheap requiring only
> the increment of a per cpu counter.
>
> Write locking is more expensive since the writer must scan the percpu array
> and wait until all readers are complete. Since the readers are not holding
> semaphores we have no wait queue from which the writer could wakeup. In this
> draft we simply wait for one millisecond between scans of the percpu
> array. A different solution must be found there.

I'm not sure making all writers more expensive is really a good idea.

For example it will definitely impact the AIM7 multi brk() issue
or the mysql allocation case, which are all writer intensive. I assume
doing a lot of mmaps/brks in parallel is not that uncommon.

My thinking was more that we simply need per VMA locking or
some other per larger address range locking. Unfortunately that
needs changes in a lot of users that mess with the VMA lists
(perhaps really needs some better abstractions for VMA list management
first)

That said also addressing the convoying issues in the current
semaphores would be a good idea, which is what your patch does.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
