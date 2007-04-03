Return-Path: <linux-kernel-owner+w=401wt.eu-S1030263AbXDCON5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030263AbXDCON5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 10:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030259AbXDCON5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 10:13:57 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:27395 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030258AbXDCONz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 10:13:55 -0400
Date: Tue, 3 Apr 2007 18:21:43 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@linux-foundation.org
Cc: mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Recursive ->i_mutex lockdep complaint
Message-ID: <20070403142143.GA6535@localhost.sw.ru>
References: <200703270735.l2R7Zg9t010611@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703270735.l2R7Zg9t010611@shell0.pdx.osdl.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 11:35:42PM -0800, akpm@linux-foundation.org wrote:
> The patch titled
>      add file position info to proc
> has been added to the -mm tree.  Its filename is
>      add-file-position-info-to-proc.patch

I tried to stress-test it with the following program and script and
lockdep barfs on me reasonably quickly:
--------------------------
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>

int main(void)
{
	int fd[2];

	printf("%u\n", getpid());
	while (1) {
		pipe(fd);
		close(fd[0]);
		close(fd[1]);
	}
	return 0;
}
----------------------------
#!/bin/sh
while true; do find /proc -type f 2>/dev/null   | \
grep -v '/proc/bus/pci'                         | \
xargs cat >/dev/null 2>/dev/null; done
----------------------------

=============================================
[ INFO: possible recursive locking detected ]
2.6.21-rc5-mm4 #1
---------------------------------------------
find/15348 is trying to acquire lock:
 (&inode->i_mutex){--..}, at: [<c016656e>] pipe_read_fasync+0x22/0x53

but task is already holding lock:
 (&inode->i_mutex){--..}, at: [<c016bdd2>] vfs_readdir+0x41/0x85

other info that might help us debug this:
1 lock held by find/15348:
 #0:  (&inode->i_mutex){--..}, at: [<c016bdd2>] vfs_readdir+0x41/0x85

stack backtrace:
 [<c0131b62>] __lock_acquire+0xbc1/0x1021
 [<c012ec07>] lockdep_init_map+0x31/0x45e
 [<c013202a>] lock_acquire+0x68/0x82
 [<c016656e>] pipe_read_fasync+0x22/0x53
 [<c01ca2d0>] _atomic_dec_and_lock+0x10/0x50
 [<c02e0ef3>] __mutex_lock_slowpath+0x6a/0x2c1
 [<c016656e>] pipe_read_fasync+0x22/0x53
 [<c015d33a>] kmem_cache_free+0xa2/0xd8
 [<c016656e>] pipe_read_fasync+0x22/0x53
 [<c01668f7>] pipe_read_release+0x12/0x24
 [<c0161ee1>] __fput+0x4e/0x12f
 [<c015fa14>] filp_close+0x3e/0x62
 [<c0118d33>] put_files_struct+0xb2/0xe0
 [<c01ce901>] snprintf+0x1f/0x23
 [<c018e812>] proc_readfd_common+0x173/0x286
 [<c018f57c>] proc_fdinfo_instantiate+0x0/0x64
 [<c02e0fe0>] __mutex_lock_slowpath+0x157/0x2c1
 [<c016bbe4>] filldir64+0x0/0xf2
 [<c016bbe4>] filldir64+0x0/0xf2
 [<c018e934>] proc_readfdinfo+0xf/0x13
 [<c018f57c>] proc_fdinfo_instantiate+0x0/0x64
 [<c016bbe4>] filldir64+0x0/0xf2
 [<c016be01>] vfs_readdir+0x70/0x85
 [<c016be7c>] sys_getdents64+0x66/0xa9
 [<c0130a8a>] trace_hardirqs_on+0xbe/0x15d
 [<c0103eaa>] sysenter_past_esp+0x5f/0x99
 =======================


It seems that lockdep is unhappy about ->i_mutex taken in
->release/pipe_read_release()/pipe_read_fasync()
which is triggered from put_files_struct() in proc_readfd_common()

Now checking if giving pipe's i_mutex its own lockdep class with fix
things.

