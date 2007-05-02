Return-Path: <linux-kernel-owner+w=401wt.eu-S1767129AbXEBV6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767129AbXEBV6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767123AbXEBV6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:58:10 -0400
Received: from creto.quietwind.net ([71.39.149.34]:52872 "EHLO
	creto.quietwind.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767129AbXEBV6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:58:08 -0400
X-Greylist: delayed 974 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2007 17:58:08 EDT
Subject: kernel oops when closing a pipe
From: Chris Kottaridis <chriskot@quietwind.net>
Reply-To: chriskot@quietwind.net
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 02 May 2007 15:41:52 -0600
Message-Id: <1178142112.42186.21.camel@creto.quietwind.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.3 FreeBSD GNOME Team Port 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I got an oops with the following backtrace:

============================================================
CPU:    2
EIP:    0060:[<c0179ee3>]    Not tainted VLI
EFLAGS: 00010002   (2.6.10-pne)
EIP is at fasync_helper+0x4f/0xcf
eax: c04d2e28   ebx: 00000000   ecx: d9562f6c   edx: 00000001
esi: f2686d80   edi: d9562f6c   ebp: f22cbf20   esp: f22cbf08
ds: 007b   es: 007b   ss: 0068
Process dsIpMgr (pid: 18122, threadinfo=f22ca000 task=f40a0710)
Stack: f40a0710 00000292 00000000 f5db1b70 c5246580 f5db1b70 f22cbf3c
c017470d
       ffffffff f2686d80 00000000 d9562f6c f2686d80 f22cbf50 c0174828
ffffffff
       f2686d80 00000000 f22cbf70 c016985d f5db1b70 f2686d80 ed0daab4
f2686d80
Call Trace:
 [<c010340f>] show_stack+0x80/0x96
 [<c01035a2>] show_registers+0x15d/0x1d6
 [<c0103900>] die+0x106/0x194
 [<c01125ed>] do_page_fault+0x583/0x8d8
 [<c01030bb>] error_code+0x2b/0x30
 [<c017470d>] pipe_read_fasync+0x3d/0x56
 [<c0174828>] pipe_read_release+0x21/0x3e
 [<c016985d>] __fput+0xf3/0x122
 [<c0167f69>] filp_close+0x50/0x8e
 [<c016803d>] sys_close+0x96/0xc1
 [<c0102554>] no_dpa_vsyscall_enter+0x8/0x1b
Code: c7 44 24 04 d0 00 00 00 89 04 24 e8 5f 60 fd ff 89 c3 b8 f4 ff ff
ff 85 db 74 50 b8 28 2e 4d c0 e8 52 b7 2e 00 89 f9 8b 17 eb 0b <39> 72
0c 74 43 8d 4a 08 8b 52 08 85 d2 75 f1 8b 45 10 85 c0 74

=====================================================================

I am running a flavor of 2.6.10 and am not really in a position to
upgrade to a newer version. I assume this is happening when fa is
getting de-referenced in the for loop. So, I assume the fasync reader
list has gotten corrupted somehow:

/*
 * fasync_helper() is used by some character device drivers (mainly
mice)
 * to set up the fasync queue. It returns negative on error, 0 if it did
 * no changes and positive if it added/deleted the entry.
 */
int fasync_helper(int fd, struct file * filp, int on, struct
fasync_struct **fapp)
{
        struct fasync_struct *fa, **fp;
        struct fasync_struct *new = NULL;
        int result = 0;

        if (on) {
                new = kmem_cache_alloc(fasync_cache, SLAB_KERNEL);
                if (!new)
                        return -ENOMEM;
        }
        write_lock_irq(&fasync_lock);
        for (fp = fapp; (fa = *fp) != NULL; fp = &fa->fa_next) {
                if (fa->fa_file == filp) {
                        if(on) {
                                fa->fa_fd = fd;
                                kmem_cache_free(fasync_cache, new);
                        } else {
                                *fp = fa->fa_next;
                                kmem_cache_free(fasync_cache, fa);
                                result = 1;
                        }
                        goto out;
                }
        }

        if (on) {
                new->magic = FASYNC_MAGIC;
                new->fa_file = filp;
                new->fa_fd = fd;
                new->fa_next = *fapp;
                *fapp = new;
                result = 1;
        }
out:
        write_unlock_irq(&fasync_lock);
        return result;
}

The variable "on" is zero when this gets called and fd is -1.

Anyone seen anything like this when trying to close down a pipe ?

Thanks
       Chris Kottaridis    (chriskot@quietwind.net)

