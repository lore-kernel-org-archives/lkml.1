Return-Path: <linux-kernel-owner+w=401wt.eu-S1030989AbXDWGJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030989AbXDWGJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 02:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbXDWGJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 02:09:16 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925AbXDWGJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 02:09:14 -0400
Date: Sun, 22 Apr 2007 23:08:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: slab allocators: Remove SLAB_DEBUG_INITIAL flag
Message-Id: <20070422230841.7d99ebb1.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704201832030.13607@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704201832030.13607@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 18:39:43 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> I have never seen a use of SLAB_DEBUG_INITIAL. It is only supported by SLAB.
> 
> I think its purpose was to have a callback after an object has been freed
> to verify that the state is the constructor state again? The callback is
> performed before each freeing of an object.
> 
> I would think that it is much easier to check the object state manually
> before the free. That also places the check near the code object
> manipulation of the object.
> 
> Also the SLAB_DEBUG_INITIAL callback is only performed if the kernel was 
> compiled with SLAB debugging on. If there would be code in a constructor 
> handling SLAB_DEBUG_INITIAL then it would have to be conditional on 
> SLAB_DEBUG otherwise it would just be dead code. But there is no such code 
> in the kernel. I think SLUB_DEBUG_INITIAL is too problematic to make real 
> use of, difficult to understand and there are easier ways to accomplish 
> the same effect (i.e. add debug code before kfree).
> 
> There is a related flag SLAB_CTOR_VERIFY that is frequently checked
> to be clear in fs inode caches. Remove the pointless checks 
> (they would even be pointless without removeal of SLAB_DEBUG_INITIAL) 
> from the fs constructors.
> 
> This is the last slab flag that SLUB did not support. Remove the check
> for unimplemented flags from SLUB.

This patch causes a use-uninitialised crash in the locks code.



VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 316k freed
Write protecting the kernel read-only data: 961k
BUG: unable to handle kernel paging request at virtual address 5a5a5a66
 printing eip:
c0188f40
*pde = 00000000
Oops: 0000 [#1]
SMP 
Modules linked in:
CPU:    0
EIP:    0060:[<c0188f40>]    Not tainted VLI
EFLAGS: 00010206   (2.6.21-rc7-mm1 #17)
EIP is at locks_release_private+0x10/0x40
eax: 5a5a5a5a   ebx: c336f7cc   ecx: 00000000   edx: c336f850
esi: c336f850   edi: c336f850   ebp: c242fe40   esp: c242fe38
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process init (pid: 1, ti=c242e000 task=c242d550 task.ti=c242e000)
Stack: c336f850 c336f7cc c242fe50 c0189026 00000000 c3cfee2c c242fed0 c018a2fe 
       ffffffff c336f84c c242fe80 c0175b37 00000000 c3cfed24 c336f850 c242fe80 
       c01759f1 01003180 c336f7cc c336f748 00000000 000000d0 00000000 c013d825 
Call Trace:
 [<c0103e6a>] show_trace_log_lvl+0x1a/0x30
 [<c0103f29>] show_stack_log_lvl+0xa9/0xd0
 [<c0104139>] show_registers+0x1e9/0x2f0
 [<c0104355>] die+0x115/0x250
 [<c0116679>] do_page_fault+0x2d9/0x610
 [<c03e07b1>] error_code+0x79/0x80
 [<c0189026>] locks_copy_lock+0x16/0x50
 [<c018a2fe>] __posix_lock_file_conf+0x24e/0x530
 [<c018a613>] posix_lock_file+0x13/0x20
 [<c018bd49>] fcntl_setlk+0x129/0x260
 [<c0186a0a>] do_fcntl+0x2a/0x2a0
 [<c0186cbc>] sys_fcntl64+0x3c/0x80
 [<c0102dde>] sysenter_past_esp+0x5f/0x99
 =======================
Code: 4b fe ff ff 8d b4 26 00 00 00 00 8b 45 f0 e8 68 fd ff ff e9 4b ff ff ff 90 90 90 55 89 e5 53 89 c3 83 ec 04 8b 40 60 85 c0 74 12 <8b> 50 0c 85 d2 74 04 89 d8 ff d2 c7 43 60 00 00 00 00 8b 43 64 
EIP: [<c0188f40>] locks_release_private+0x10/0x40 SS:ESP 0068:c242fe38
Kernel panic - not syncing: Attempted to kill init!
