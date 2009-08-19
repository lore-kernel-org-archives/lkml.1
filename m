Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbZHSNip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbZHSNip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbZHSNip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:38:45 -0400
Received: from mail-vw0-f172.google.com ([209.85.212.172]:50230 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbZHSNio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:38:44 -0400
MIME-Version: 1.0
In-Reply-To: <200908181443.46652.christoph.thielecke@gmx.de>
References: <200908181443.46652.christoph.thielecke@gmx.de>
Date: Wed, 19 Aug 2009 09:38:44 -0400
Message-ID: <7e0fb38c0908190638g23f22b59v53a192182b9ee9a4@mail.gmail.com>
Subject: Re: kernel bug 2.6.31-rc6
From: Eric Paris <eparis@parisplace.org>
To: christoph.thielecke@gmx.de
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       eparis@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 8:43 AM, Christoph
Thielecke<christoph.thielecke@gmx.de> wrote:
> Hello list,
>
> I got an kernel bug using 2.6.31-rc6 (machine freeze, sysreq not working).
> Interesting: I use kde3 (user crissi) and start an second xserver in
> userspace (xephyr) (user kde-devel). I allow to write the xserver on my
> display via xhost +.
>
> @linus
> This is different from bug before because I start there a new session via kdm
> (2x xorg).
>
>
> Aug 18 10:24:09 develop kernel: idr_remove called for id=2147483647 which is
> not allocated.

2147483647 = 0x7FFFFFFF = INT_MAX

I don't use INT_MAX in my code anywhere!  Anyone on list have a clue
what could rewrite it to INT_MAX?  This doesn't look to me

Only thing I can think of is that it got freed and reused by something else ??


> Aug 18 10:24:09 develop kernel: Pid: 17363, comm: kded4 Tainted: P
> 2.6.31-rc6 #2
> Aug 18 10:24:09 develop kernel: Call Trace:
> Aug 18 10:24:09 develop kernel: [<c133a0b0>] ? printk+0x18/0x20
> Aug 18 10:24:09 develop kernel: [<c11d00c0>] idr_remove+0x79/0x1ad
> Aug 18 10:24:09 develop kernel: [<c10db9d1>] ?
> fsnotify_add_notify_event+0x105/0x205
> Aug 18 10:24:09 develop kernel: [<c10ddce3>] inotify_remove_from_idr+0x21/0x34
> Aug 18 10:24:09 develop kernel: [<c10de1ae>]
> inotify_ignored_and_remove_idr+0x85/0xb7
> Aug 18 10:24:09 develop kernel: [<c10dd753>] inotify_freeing_mark+0x8/0xa
> Aug 18 10:24:09 develop kernel: [<c10dc3ab>]
> fsnotify_destroy_mark_by_entry+0xf3/0x132
> Aug 18 10:24:09 develop kernel: [<c10ddc82>] sys_inotify_rm_watch+0x5e/0x8d
> Aug 18 10:24:09 develop kernel: [<c1003610>] sysenter_do_call+0x12/0x2c

So the syscall wd was correct, the entry was found in the idr, but the
entry->wd = INT_MAX which is not what it is supposed to be.  At some
point that entry had to be correct, since it was returned to userspace
from inotify_update_watch().

That function looks horrid, so I'll recheck it, but I'm once again stumped...

-Eric
