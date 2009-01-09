Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbZAIBlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbZAIBlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 20:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbZAIBlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 20:41:00 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:49252 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044AbZAIBk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 20:40:59 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAN43Zkl5LDnl/2dsb2JhbADPRYV1
X-IronPort-AV: E=Sophos;i="4.37,236,1231075800"; 
   d="scan'208";a="289494889"
Date: Fri, 9 Jan 2009 12:40:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Grissiom <chaos.proton@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] async: Don't call async_synchronize_full_special()
	while holding sb_lock
Message-ID: <20090109014054.GN9448@disturbed>
Mail-Followup-To: Arjan van de Ven <arjan@linux.intel.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Grissiom <chaos.proton@gmail.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <a0adeea50901080007q5a3ed5c8y5a744ce37e677325@mail.gmail.com> <1231425472.21528.13.camel@norville.austin.ibm.com> <20090108072111.1ebadebd@infradead.org> <1231429591.27353.14.camel@norville.austin.ibm.com> <20090108225050.GL9448@disturbed> <49668388.708@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49668388.708@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 02:51:52PM -0800, Arjan van de Ven wrote:
> Dave Chinner wrote:
>> On Thu, Jan 08, 2009 at 09:46:31AM -0600, Dave Kleikamp wrote:
>>> sync_filesystems() shouldn't be calling async_synchronize_full_special
>>> while holding a spinlock.  The second while loop in that function is the
>>> right place for this anyway.
>>
>> Out of curiousity, what on earth does
>> async_synchronize_full_special() do and why does it need to be in
>> sync_filesystems()?
>>
> now that we have asynchronous operations, this function makes sure that all the functions
> that we started async before this point complete, so that what when you sync, you sync all in progress work.

So what you are saying that we now have async operations that
need magical undocumented sync primitives apparently randomly
strewn throughout the code base?

Could you name the interface somewhat better? it's an async
operation synchronisation primitive - currently the name is
full of words that are typically suffixes to something that
is typically "namespace_operation_suffix". This is whole API
looks like "suffix_suffix_suffix_suffix".....

<rummage around the code>

Oh, fuck. You've made generic_delete_inode() an asychronous operation.
This is bad. Really Bad.

XFS does transactions in ->clear_inode so what you've done is
removed one of the synchronous throttleѕ on inode removal that
prevents build-up of massive numbers of deleted XFS inodes in
memory that have run the first unlink phase but not the second.

I know for a fact (because this has been done within XFS before)
that this causes serious writeback, sync and unmount latency
problems with XFS as well as introducing a whole new class of OOM
problems when under heavy load.  The depth of the async queues
requires serious throttling to prevent these issues from occurring.

How bad? For example, rm -rf そf a larg enumber of files can cause
unmount or sync can take hours to run the async queues under heavy
load because the inodes existed only in memory and are randomly
spread around the filesystem (this is a real world example). In this
case under heavy memory load, XFS required inode buffer RMW to do
the modifcation, and given that it was on software RAID5 this also
required a RAID5 RMW cycle. The result?  The async inode delete
queue drained at *50* deleted inodes per second.  The synchronous
unlink rate was around 5000 inodes per second.....

So, given the potential impact of this change, what testing have
you done in terms of:

	- performance impact
	- regression testing
	- sync() safety
	- removing a million files and queuing all of the
	  deletes in the async queues....

On all the different filesystems under heavy I/O workloads?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
