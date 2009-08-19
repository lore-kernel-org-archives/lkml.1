Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbZHSNra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbZHSNra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbZHSNr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:47:28 -0400
Received: from mail-vw0-f172.google.com ([209.85.212.172]:55048 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZHSNr0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:47:26 -0400
MIME-Version: 1.0
In-Reply-To: <200908191448.50304.christoph.thielecke@gmx.de>
References: <200908191448.50304.christoph.thielecke@gmx.de>
Date: Wed, 19 Aug 2009 09:47:25 -0400
Message-ID: <7e0fb38c0908190647j2d59d498y4e0cf895152303c3@mail.gmail.com>
Subject: Re: kernel bug 2.6.31-rc6 (2)
From: Eric Paris <eparis@parisplace.org>
To: christoph.thielecke@gmx.de
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 8:48 AM, Christoph
Thielecke<christoph.thielecke@gmx.de> wrote:
> Hello list,
>
> another freeze comes here (still using xephr):
>
> Aug 19 14:04:22 develop kernel: plasma[30850]: segfault at 4 ip b6acef4d sp
> bfe72230 error 4 in libQtGui.so.4.5.1[b6993000+81a000]
> Aug 19 14:05:03 develop kernel: idr_remove called for id=1024 which is not
> allocated.
> Aug 19 14:05:03 develop kernel: Pid: 11958, comm: kded4 Tainted: P        W
> 2.6.31-rc6 #2
> Aug 19 14:05:03 develop kernel: Call Trace:
> Aug 19 14:05:03 develop kernel: [<c133a0b0>] ? printk+0x18/0x20
> Aug 19 14:05:03 develop kernel: [<c11d00c0>] idr_remove+0x79/0x1ad
> Aug 19 14:05:03 develop kernel: [<c10db9d1>] ?
> fsnotify_add_notify_event+0x105/0x205
> Aug 19 14:05:03 develop kernel: [<c10ddce3>] inotify_remove_from_idr+0x21/0x34
> Aug 19 14:05:03 develop kernel: [<c10de1ae>]
> inotify_ignored_and_remove_idr+0x85/0xb7
> Aug 19 14:05:03 develop kernel: [<c10dd753>] inotify_freeing_mark+0x8/0xa
> Aug 19 14:05:03 develop kernel: [<c10dc3ab>]
> fsnotify_destroy_mark_by_entry+0xf3/0x132
> Aug 19 14:05:03 develop kernel: [<c10dc532>]
> fsnotify_clear_marks_by_group+0x9b/0xc9
> Aug 19 14:05:03 develop kernel: [<c10dd8e5>] inotify_release+0x12/0x26
> Aug 19 14:05:03 develop kernel: [<c10b3dfa>] __fput+0xd3/0x1ba
> Aug 19 14:05:03 develop kernel: [<c10b3efc>] fput+0x1b/0x20
> Aug 19 14:05:03 develop kernel: [<c10b108e>] filp_close+0x41/0x5f
> Aug 19 14:05:03 develop kernel: [<c10342d5>] put_files_struct+0x68/0xa6
> Aug 19 14:05:03 develop kernel: [<c103434a>] exit_files+0x37/0x3c
> Aug 19 14:05:03 develop kernel: [<c1035777>] do_exit+0x146/0x6c6
> Aug 19 14:05:03 develop kernel: [<c1035d27>] do_group_exit+0x30/0x85
> Aug 19 14:05:03 develop kernel: [<c1035d8f>] sys_exit_group+0x13/0x17
> Aug 19 14:05:03 develop kernel: [<c1003610>] sysenter_do_call+0x12/0x2c
> Aug 19 14:05:03 develop kernel: ------------[ cut here ]------------

Hmmm, this one could possibly be a race between adding a new watch
while destroying the group, maybe?  I'm going to go over the add a new
watch function with a fine tooth comb.  The wd looks 'ok,' 1024
surprises me but it's sorta reasonable that we could have jut happened
to have 1023 other watches.

The second panic is because of the above problem (we left something in
the idr).

It might be the same as the other report in that it could be something
is overwriting entry->wd after it is in memory.  But that isn't
supposed to happen!

-Eric
