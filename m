Return-Path: <linux-kernel-owner+w=401wt.eu-S1758677AbZIGCB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbZIGCB5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 22:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758554AbZIGCB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 22:01:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758537AbZIGCB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 22:01:56 -0400
Subject: Re: Linux 2.6.31-rc9
From: Eric Paris <eparis@redhat.com>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Eric Paris <eparis@parisplace.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AA44ABC.1040305@gmail.com>
References: <4AA44ABC.1040305@gmail.com>
Content-Type: text/plain
Date: Sun, 06 Sep 2009 22:01:47 -0400
Message-Id: <1252288907.27723.8.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-06 at 20:50 -0300, Kevin Winchester wrote:
> Hi Eric,
> 
> I am not sure all of the inotify issues have been corrected in 2.6.31-rc9:

http://bugzilla.kernel.org/show_bug.cgi?id=14090

I already ask rjw to add it to the regression list.

I've spent the last 4 days hunting this issue down, and have a reliable
reproducer now.  I have 2 patches which stop the problem but I can only
explain why they stop the problem, but not identify what the root
problem is.  If I don't figure it out tomorrow I'm going to send them
both to linus (with explanations why they solve the issues) but I'm not
giving up until I figure out exactly what's going on and can solve this
race the right way.

I really want to run my torture test against the old inotify since I'm
using the same logic, I just actually check all over the place to make
sure everything stays consistent since these are not performance hot
paths.....

-Eric

> [  165.823580] ------------[ cut here ]------------
> [  165.823600] WARNING: at fs/notify/inotify/inotify_fsnotify.c:129 idr_callback+0x43/0x67()
> [  165.823604] Hardware name: MS-6702
> [  165.823607] inotify closing but id=0 for entry=ffff88004ce36a28 in group=ffff88004a2229c0 still in idr.  Probably leaking memory
> [  165.823610] Modules linked in: k8temp
> [  165.823618] Pid: 1555, comm: gam_server Not tainted 2.6.31-rc9 #392
> [  165.823621] Call Trace:
> [  165.823626]  [<ffffffff810c405e>] ? idr_callback+0x43/0x67
> [  165.823635]  [<ffffffff8103204c>] warn_slowpath_common+0x7c/0xa9
> [  165.823640]  [<ffffffff810320f8>] warn_slowpath_fmt+0x69/0x6b
> [  165.823646]  [<ffffffff8109a140>] ? lookup_object+0x37/0x6e
> [  165.823653]  [<ffffffff8105a90a>] ? call_rcu+0x15/0x17
> [  165.823657]  [<ffffffff8109a21d>] ? put_object+0x44/0x48
> [  165.823661]  [<ffffffff810c405e>] idr_callback+0x43/0x67
> [  165.823667]  [<ffffffff8115de32>] idr_for_each+0x6f/0xb2
> [  165.823671]  [<ffffffff810c401b>] ? idr_callback+0x0/0x67
> [  165.823676]  [<ffffffff810c4007>] inotify_free_group_priv+0x27/0x3b
> [  165.823680]  [<ffffffff810c2a11>] fsnotify_final_destroy_group+0x28/0x34
> [  165.823684]  [<ffffffff810c2b02>] fsnotify_put_group+0x93/0x97
> [  165.823688]  [<ffffffff810c41e4>] inotify_release+0x2a/0x3b
> [  165.823692]  [<ffffffff8109e185>] __fput+0x112/0x1c4
> [  165.823696]  [<ffffffff8109e253>] fput+0x1c/0x1e
> [  165.823700]  [<ffffffff8109b6a5>] filp_close+0x5e/0x68
> [  165.823704]  [<ffffffff810336c5>] put_files_struct+0x6f/0xc6
> [  165.823708]  [<ffffffff81033744>] exit_files+0x28/0x2a
> [  165.823711]  [<ffffffff81034b81>] do_exit+0x186/0x59d
> [  165.823716]  [<ffffffff810225b3>] ? do_page_fault+0x21b/0x24d
> [  165.823720]  [<ffffffff81034feb>] do_group_exit+0x53/0x7d
> [  165.823723]  [<ffffffff8103502c>] sys_exit_group+0x17/0x1b
> [  165.823728]  [<ffffffff8100afd8>] system_call_fastpath+0x16/0x1b
> [  165.823731] ---[ end trace 34f3b8e033c3e431 ]---
> [  165.823735] entry->group=(null) inode=(null) wd=4096
> 
> Is there anything I can do to help debug this?
> 


