Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbZGFW70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbZGFW70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 18:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbZGFW7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 18:59:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59555 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbZGFW7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 18:59:17 -0400
Subject: Re: Possible memory leak via inotify_add_watch
From: Eric Paris <eparis@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <b0943d9e0907061503r7a89a4e2lb5bc76b89e3e8ca6@mail.gmail.com>
References: <b0943d9e0907061503r7a89a4e2lb5bc76b89e3e8ca6@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 06 Jul 2009 18:59:00 -0400
Message-Id: <1246921140.2866.88.camel@dhcp235-23.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-06 at 23:03 +0100, Catalin Marinas wrote:
> Hi Eric,
> 
> I'm getting a few kmemleak reports like the one below (it may as well
> be just a false positive). All of these allocations happened during
> udevd.

Ok, I'll take a look.  I know it highly unlikely but possible to leak in
sys_inotify_add_watch on some of the error paths.  Seeing as how you
object has a mask it was at some point actually attached to an inode and
was removed.  Since free_i_list is still unused that means it was
removed by an explicit request from inotify (inotify_rm_watch I guess),
not from the inode disappearing.  I'll try to run it down exactly
tonight.

-Eric


> unreferenced object 0xc399fd80 (size 84):
>   comm "udevd", pid 879, jiffies 4294897228
>   backtrace:
>     [<c01e0c3a>] create_object+0xfa/0x250
>     [<c01e1e7d>] kmemleak_alloc+0x5d/0x70
>     [<c01dac1b>] kmem_cache_alloc+0x14b/0x190
>     [<c0213800>] sys_inotify_add_watch+0xc0/0x2a0
>     [<c010300c>] sysenter_do_call+0x12/0x38
>     [<ffffffff>] 0xffffffff
> 
> Printing this object with gdb on /proc/kcore shows:
> 
> (gdb) print {struct inotify_inode_mark_entry}0xc399fd80
> $2 = {fsn_entry = {mask = 134250504, refcnt = {counter = 1}, inode = 0x0,
>     group = 0x0, i_list = {next = 0x0, pprev = 0x0}, g_list = {
>       next = 0xc399fd98, prev = 0xc399fd98}, lock = {raw_lock = {
>         slock = 1028}, magic = 3735899821, owner_cpu = 4294967295,
>       owner = 0xffffffff, dep_map = {key = 0xc0d3e59c, class_cache = 0x0,
>         name = 0xc068413d "&entry->lock"}}, free_i_list = {next = 0x6b6b6b6b,
>       prev = 0x6b6b6b6b}, free_g_list = {next = 0x6b6b6b6b,
>       prev = 0x6b6b6b6b}, free_mark = 0xc0213720 <inotify_free_mark>}, wd = 28}
> 
> It seems that is was freed via fsnotify_destroy_mark_by_entry() since
> group and inode members are NULL and it was removed from any list. The
> fsn_entry.refcnt, however, is still 1. Kmemleak cannot find any
> pointer to this object (though it doesn't track alloc_pages memory
> blocks).
> 
> Thanks.
> 

