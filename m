Return-Path: <linux-kernel-owner+w=401wt.eu-S1761518AbZFRLZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761518AbZFRLZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 07:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759502AbZFRLZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 07:25:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:60287 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759212AbZFRLZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 07:25:15 -0400
Subject: Re: [PATCH] inotify: inotify_destroy_mark_entry could get called
 twice
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
In-Reply-To: <20090612202647.11976.87920.stgit@paris.rdu.redhat.com>
References: <20090612202647.11976.87920.stgit@paris.rdu.redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 18 Jun 2009 13:25:18 +0200
Message-Id: <1245324318.13761.23295.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 16:26 -0400, Eric Paris wrote:
> inotify_destroy_mark_entry could get called twice for the same mark since it
> is called directly in inotify_rm_watch and when the mark is being destroyed for
> another reason.  As an example assume that the file being watched was just
> deleted so inotify_destroy_mark_entry would get called from the path
> fsnotify_inoderemove() -> fsnotify_destroy_marks_by_inode() ->
> fsnotify_destroy_mark_entry() -> inotify_destroy_mark_entry().  If this
> happened at the same time as userspace tried to remove a watch via
> inotify_rm_watch we could attempt to remove the mark from the idr twice and
> could thus double dec the ref cnt and potentially could be in a use after
> free/double free situation.  The fix is to have inotify_rm_watch use the
> generic recursive safe fsnotify_destroy_mark_by_entry() so we are sure the
> inotify_destroy_mark_entry() function can only be called one.
> 
> This patch also renames the function to inotify_ingored_remove_idr() so it is
> clear what is actually going on in the function.
> 
> Hopefully this fixes:
> [   20.342058] idr_remove called for id=20 which is not allocated.
> [   20.348000] Pid: 1860, comm: udevd Not tainted 2.6.30-tip #1077
> [   20.353933] Call Trace:
> [   20.356410]  [<ffffffff811a82b7>] idr_remove+0x115/0x18f
> [   20.361737]  [<ffffffff8134259d>] ? _spin_lock+0x6d/0x75
> [   20.367061]  [<ffffffff8111640a>] ? inotify_destroy_mark_entry+0xa3/0xcf
> [   20.373771]  [<ffffffff8111641e>] inotify_destroy_mark_entry+0xb7/0xcf
> [   20.380306]  [<ffffffff81115913>] inotify_freeing_mark+0xe/0x10
> [   20.386238]  [<ffffffff8111410d>] fsnotify_destroy_mark_by_entry+0x143/0x170
> [   20.393293]  [<ffffffff811163a3>] inotify_destroy_mark_entry+0x3c/0xcf
> [   20.399829]  [<ffffffff811164d1>] sys_inotify_rm_watch+0x9b/0xc6
> [   20.405850]  [<ffffffff8100bcdb>] system_call_fastpath+0x16/0x1b
> 
> Reported-by: Peter Zijlstra <peterz@infradead.org>

Tested-by: Peter Zijlstra <peterz@infradead.org>

Thanks Eric!!

