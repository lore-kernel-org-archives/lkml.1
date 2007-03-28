Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbXC1OKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbXC1OKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 10:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbXC1OKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 10:10:31 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60297 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbXC1OKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 10:10:30 -0400
Subject: Re: Linux page cache issue?
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Xin Zhao <uszhaoxin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <4ae3c140703272345y3b3cb3cexf4c4b63e0035d5b9@mail.gmail.com>
References: <4ae3c140703272345y3b3cb3cexf4c4b63e0035d5b9@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 28 Mar 2007 09:10:28 -0500
Message-Id: <1175091028.12882.15.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-28 at 02:45 -0400, Xin Zhao wrote:
> Hi,
> 
> If a Linux process opens and reads a file A, then it closes the file.
> Will Linux keep the file A's data in cache for a while in case another
> process opens and reads the same in a short time? I think that is what
> I heard before.

Yes.

> But after I digged into the kernel code, I am confused.
> 
> When a process closes the file A, iput() will be called, which in turn
> calls the follows two functions:
> iput_final()->generic_drop_inode()

A comment from the top of fs/dcache.c:

/*
 * Notes on the allocation strategy:
 *
 * The dcache is a master of the icache - whenever a dcache entry
 * exists, the inode will always exist. "iput()" is done either when
 * the dcache entry is deleted or garbage collected.
 */

Basically, as long a a dentry is present, iput_final won't be called on
the inode.

> But from the following calling chain, we can see that file close will
> eventually lead to evict and free all cached pages. Actually in
> truncate_complete_page(), the pages will be freed.  This seems to
> imply that Linux has to re-read the same data from disk even if
> another process B read the same file right after process A closes the
> file. That does not make sense to me.
> 
> /***calling chain ***/
> generic_delete_inode/generic_forget_inode()->
> truncate_inode_pages()->truncate_inode_pages_range()->
> truncate_complete_page()->remove_from_page_cache()->
> __remove_from_page_cache()->radix_tree_delete()
> 
> Am I missing something? Can someone please provide some advise?
> 
> Thanks a lot
> -x

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

