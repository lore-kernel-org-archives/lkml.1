Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbYE3TKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbYE3TKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 15:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYE3TKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 15:10:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbYE3TJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 15:09:58 -0400
Date: Fri, 30 May 2008 15:03:14 -0400
From: Dave Jones <davej@redhat.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: chucklever@gmail.com, Chuck Lever <chuck.lever@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: NFS oops in 2.6.26rc4
Message-ID: <20080530190314.GC32480@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Trond Myklebust <Trond.Myklebust@netapp.com>, chucklever@gmail.com,
	Chuck Lever <chuck.lever@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20080527190419.GA14577@redhat.com> <76bd70e30805301059v461e8f0eocc38b6fe36dd3b21@mail.gmail.com> <20080530182126.GB32480@redhat.com> <1212172308.8579.20.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212172308.8579.20.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 11:31:48AM -0700, Trond Myklebust wrote:
 > On Fri, 2008-05-30 at 14:21 -0400, Dave Jones wrote:
 > 
 > > mount point in the fstab is ..
 > > 
 > > gelk:/mnt/data      /mnt/nfs/gelk       nfs     nfsvers=3,tcp        0 0
 > > 
 > >  >  What "brand" of server were you trying to mount?
 > > 
 > > It's just another linux box. A no-name core2 duo, running 2.6.25.
 > > 
 > >  > How often can you reproduce this?
 > > 
 > > Seems to do it every time I ask it to.
 > 
 > Could you provide us with a binary tcpdump in that case? I'd love to
 > have a look at the actual filehandle the server is producing.

This is from the client side: http://www.codemonkey.org.uk/junk/tcp.out
Wireshark picks up some of those packets as being 'malformed', which 
could be a clue ?

Something else of note which I hadn't seen before, usually things lock
up just after that first oops. For some reason, today it survived
a little longer, but things really went downhill fast.

After that first oops scrolled off the screen, and I saved the wireshark
output to disk, I got this..

=============================================================================
BUG files_cache (Tainted: G      D  ): Padding overwritten. 0xf4d31fc0-0xf4d31fff
-----------------------------------------------------------------------------

INFO: Slab 0xc1b902b8 objects=9 used=7 fp=0xf4d31a80 flags=0x400000c3
Pid: 1910, comm: hald-runner Tainted: G      D   2.6.26-0.33.rc4.fc10.i686 #1
 [<c04882df>] slab_err+0x51/0x58
 [<c041b326>] ? kernel_map_pages+0xf2/0x109
 [<c041d019>] ? kmap_atomic_prot+0x1dc/0x1de
 [<c048836b>] slab_pad_check+0x85/0xc1
 [<c0488439>] check_slab+0x92/0x9f
 [<c04898aa>] __slab_alloc+0x371/0x4ea
 [<c0489ced>] kmem_cache_alloc+0x62/0xc4
 [<c049ffa0>] ? dup_fd+0x22/0x2d4
 [<c049ffa0>] ? dup_fd+0x22/0x2d4
 [<c049ffa0>] dup_fd+0x22/0x2d4
 [<c0461d87>] ? audit_alloc+0xa7/0xec
 [<c0461d87>] ? audit_alloc+0xa7/0xec
 [<c0429b53>] copy_process+0x64c/0x1130
 [<c042a6e6>] do_fork+0xaf/0x1e4
 [<c0461cb6>] ? audit_syscall_entry+0xf9/0x123
 [<c0403556>] sys_clone+0x1f/0x21
 [<c0404c3a>] syscall_call+0x7/0xb
 =======================
 Padding 0xf4d31fc0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
 Padding 0xf4d31fd0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
 Padding 0xf4d31fe0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
 Padding 0xf4d31ff0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
FIX files_cache: Restoring 0xf4d31000-0xf4d31fff=0x5a

=============================================================================
BUG files_cache (Tainted: G      D  ): Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xf4d31c00-0xf4d31c03. First byte 0x5a instead of 0xbb
INFO: Allocated in 0x5a5a5a5a age=2782247384 cpu=1515870810 pid=1515870810
INFO: Freed in 0x5a5a5a5a age=2782247384 cpu=1515870810 pid=1515870810
INFO: Slab 0xc1b902b8 objects=9 used=7 fp=0xf4d31a80 flags=0x400000c3
INFO: Object 0xf4d31a80 @offset=2688 fp=0x5a5a5a5a

Bytes b4 0xf4d31a70:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xf4d31a80:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xf4d31a90:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xf4d31aa0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xf4d31ab0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xf4d31ac0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xf4d31ad0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xf4d31ae0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xf4d31af0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Redzone 0xf4d31c00:  5a 5a 5a 5a                                     ZZZZ            
 Padding 0xf4d31c28:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xf4d31c38:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
Pid: 1910, comm: hald-runner Tainted: G      D   2.6.26-0.33.rc4.fc10.i686 #1
 [<c04885b7>] print_trailer+0xe1/0xe9
 [<c0488640>] check_bytes_and_report+0x81/0xa4
 [<c04886d7>] check_object+0x44/0x18b
 [<c0489912>] __slab_alloc+0x3d9/0x4ea
 [<c0489ced>] kmem_cache_alloc+0x62/0xc4
 [<c049ffa0>] ? dup_fd+0x22/0x2d4
 [<c049ffa0>] ? dup_fd+0x22/0x2d4
 [<c049ffa0>] dup_fd+0x22/0x2d4
 [<c0461d87>] ? audit_alloc+0xa7/0xec
 [<c0461d87>] ? audit_alloc+0xa7/0xec
 [<c0429b53>] copy_process+0x64c/0x1130
 [<c042a6e6>] do_fork+0xaf/0x1e4
 [<c0461cb6>] ? audit_syscall_entry+0xf9/0x123
 [<c0403556>] sys_clone+0x1f/0x21
 [<c0404c3a>] syscall_call+0x7/0xb
 =======================
FIX files_cache: Restoring 0xf4d31c00-0xf4d31c03=0xbb

FIX files_cache: Marking all objects used
BUG: unable to handle kernel paging request at 5a5a5a5a
IP: [<c048e39a>] fget_light+0x59/0xb9
*pde = 00000000 
Oops: 0000 [#2] SMP DEBUG_PAGEALLOC
Modules linked in: nfs nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc ext2 sg via_ircc button irda crc_ccitt pata_sil680 via_rhine r8169 i2c_viapro pcspkr mii i2c_core dm_snapshot dm_zero dm_mirror dm_log dm_mod pata_via ata_generic pata_acpi libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]

Pid: 1817, comm: sendmail Tainted: G      D   (2.6.26-0.33.rc4.fc10.i686 #1)
EIP: 0060:[<c048e39a>] EFLAGS: 00210292 CPU: 0
EIP is at fget_light+0x59/0xb9
EAX: 00200246 EBX: f4d318c0 ECX: 00000000 EDX: 5a5a5a5a
ESI: 00000004 EDI: f4ee3c00 EBP: f4d43b70 ESP: f4d43b58
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process sendmail (pid: 1817, ti=f4d43000 task=f4ef8000 task.ti=f4d43000)
Stack: f4d43e18 006c6900 00000000 00000010 00000000 f4ee3c00 f4d43e28 c0499337 
       f4d43e44 c041ad7a f4d43e48 00000020 f4d43f9c f4d43f44 00000000 00000000 
       f4d43e50 f4d43e54 f4d43e58 f4d43e44 f4d43e48 f4d43e4c 00000010 00000000 
Call Trace:
 [<c0499337>] ? do_select+0x2e1/0x4f5
 [<c041ad7a>] ? __change_page_attr_set_clr+0x1c3/0x67d
 [<c0499ba9>] ? __pollwait+0x0/0xb3
 [<c0422900>] ? default_wake_function+0x0/0xd
 [<c040974f>] ? native_sched_clock+0xac/0xc8
 [<c040974f>] ? native_sched_clock+0xac/0xc8
 [<c041b326>] ? kernel_map_pages+0xf2/0x109
 [<c040974f>] ? native_sched_clock+0xac/0xc8
 [<c0447707>] ? mark_held_locks+0x4e/0x66
 [<c04479be>] ? debug_check_no_locks_freed+0x10e/0x123
 [<c044788f>] ? trace_hardirqs_on+0xe9/0x10a
 [<c041b326>] ? kernel_map_pages+0xf2/0x109
 [<c040974f>] ? native_sched_clock+0xac/0xc8
 [<c040974f>] ? native_sched_clock+0xac/0xc8
 [<c0448313>] ? __lock_acquire+0x564/0xc18
 [<c040974f>] ? native_sched_clock+0xac/0xc8
 [<c041aa06>] ? lookup_address+0x68/0x88
 [<c0448313>] ? __lock_acquire+0x564/0xc18
 [<c041ad7a>] ? __change_page_attr_set_clr+0x1c3/0x67d
 [<c040974f>] ? native_sched_clock+0xac/0xc8
 [<c040974f>] ? native_sched_clock+0xac/0xc8
 [<c0448313>] ? __lock_acquire+0x564/0xc18
 [<c040974f>] ? native_sched_clock+0xac/0xc8
 [<c040946e>] ? sched_clock+0x8/0xb
 [<c04460d1>] ? lock_release_holdtime+0x1a/0x115
 [<c0499577>] ? core_sys_select+0x2c/0x2d8
 [<c0499738>] ? core_sys_select+0x1ed/0x2d8
 [<c04887c7>] ? check_object+0x134/0x18b
 [<c0489c53>] ? __slab_free+0x230/0x268
 [<c040974f>] ? native_sched_clock+0xac/0xc8
 [<c04be9f2>] ? proc_destroy_inode+0x10/0x12
 [<c040974f>] ? native_sched_clock+0xac/0xc8
 [<c040946e>] ? sched_clock+0x8/0xb
 [<c0499ae9>] ? sys_select+0x88/0x148
 [<c040ac0b>] ? do_syscall_trace+0x138/0x17f
 [<c0404c3a>] ? syscall_call+0x7/0xb
 =======================
Code: 8d 04 b5 00 00 00 00 03 42 04 8b 18 eb 68 68 7d e3 48 c0 31 d2 6a 01 31 c9 6a 02 b8 80 62 74 c0 e8 33 a6 fb ff 8b 53 04 83 c4 0c <3b> 32 73 31 8d 04 b5 00 00 00 00 03 42 04 8b 18 85 db 74 23 8d 
EIP: [<c048e39a>] fget_light+0x59/0xb9 SS:ESP 0068:f4d43b58
---[ end trace 013a4d2d914c796e ]---
BUG: unable to handle kernel paging request at 5a5a5a5a
IP: [<c048e39a>] fget_light+0x59/0xb9
*pde = 00000000 
Oops: 0000 [#3] SMP DEBUG_PAGEALLOC
Modules linked in: nfs nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc ext2 sg via_ircc button irda crc_ccitt pata_sil680 via_rhine r8169 i2c_viapro pcspkr mii i2c_core dm_snapshot dm_zero dm_mirror dm_log dm_mod pata_via ata_generic pata_acpi libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]

Pid: 1721, comm: ntpd Tainted: G      D   (2.6.26-0.33.rc4.fc10.i686 #1)
EIP: 0060:[<c048e39a>] EFLAGS: 00210292 CPU: 0
EIP is at fget_light+0x59/0xb9
EAX: 00200246 EBX: f4d31000 ECX: 00000000 EDX: 5a5a5a5a
ESI: 00000010 EDI: f4c4bb00 EBP: f4d4eb70 ESP: f4d4eb58
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process ntpd (pid: 1721, ti=f4d4e000 task=f4d02fc0 task.ti=f4d4e000)
Stack: f4d4ee18 00000000 00000000 00010000 00000000 f4c4bb00 f4d4ee28 c0499337 
       f4d4ee44 f4d03030 f4d4ee48 00000020 f4d4ef9c f4d4ef44 00000000 00000000 
       f4d4ee50 f4d4ee54 f4d4ee58 f4d4ee44 f4d4ee48 f4d4ee4c 00070000 00000000 
Call Trace:
 [<c0499337>] ? do_select+0x2e1/0x4f5
 [<c0499ba9>] ? __pollwait+0x0/0xb3
 [<c0422900>] ? default_wake_function+0x0/0xd
 [<c0422900>] ? default_wake_function+0x0/0xd
 [<c0422900>] ? default_wake_function+0x0/0xd
 [<c040946e>] ? sched_clock+0x8/0xb
 [<c04dd3c8>] ? avc_has_perm_noaudit+0x3a6/0x3c4
 [<c040974f>] ? native_sched_clock+0xac/0xc8
 [<c040946e>] ? sched_clock+0x8/0xb
 [<c04460d1>] ? lock_release_holdtime+0x1a/0x115
 [<c0644bb8>] ? _spin_unlock_irqrestore+0x40/0x50
 [<c044788f>] ? trace_hardirqs_on+0xe9/0x10a
 [<c05ce52f>] ? __skb_recv_datagram+0xd8/0x1f5
 [<c04de040>] ? socket_has_perm+0x53/0x5d
 [<c060a0ce>] ? udp_recvmsg+0x5e/0x21e
 [<c05c8909>] ? sock_common_recvmsg+0x31/0x4a
 [<c040974f>] ? native_sched_clock+0xac/0xc8
 [<c0448313>] ? __lock_acquire+0x564/0xc18
 [<c040974f>] ? native_sched_clock+0xac/0xc8
 [<c040946e>] ? sched_clock+0x8/0xb
 [<c04460d1>] ? lock_release_holdtime+0x1a/0x115
 [<c0499577>] ? core_sys_select+0x2c/0x2d8
 [<c0499738>] ? core_sys_select+0x1ed/0x2d8
 [<c05cdd01>] ? verify_iovec+0x40/0x6f
 [<c05c8155>] ? sys_recvmsg+0xe8/0x17b
 [<c05c7ed0>] ? sys_sendto+0xa4/0xc3
 [<c04887c7>] ? check_object+0x134/0x18b
 [<c0489c53>] ? __slab_free+0x230/0x268
 [<c048af05>] ? kmem_cache_free+0xc9/0xde
 [<c044788f>] ? trace_hardirqs_on+0xe9/0x10a
 [<c049c77d>] ? d_free+0x3b/0x4d
 [<c0499ae9>] ? sys_select+0x88/0x148
 [<c040ac0b>] ? do_syscall_trace+0x138/0x17f
 [<c0404c3a>] ? syscall_call+0x7/0xb
 =======================
Code: 8d 04 b5 00 00 00 00 03 42 04 8b 18 eb 68 68 7d e3 48 c0 31 d2 6a 01 31 c9 6a 02 b8 80 62 74 c0 e8 33 a6 fb ff 8b 53 04 83 c4 0c <3b> 32 73 31 8d 04 b5 00 00 00 00 03 42 04 8b 18 85 db 74 23 8d 
EIP: [<c048e39a>] fget_light+0x59/0xb9 SS:ESP 0068:f4d4eb58
---[ end trace 013a4d2d914c796e ]---
------------[ cut here ]------------
kernel BUG at mm/mmap.c:2160!
invalid opcode: 0000 [#4] SMP DEBUG_PAGEALLOC
Modules linked in: nfs nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc ext2 sg via_ircc button irda crc_ccitt pata_sil680 via_rhine r8169 i2c_viapro pcspkr mii i2c_core dm_snapshot dm_zero dm_mirror dm_log dm_mod pata_via ata_generic pata_acpi libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]

Pid: 1721, comm: ntpd Tainted: G      D   (2.6.26-0.33.rc4.fc10.i686 #1)
EIP: 0060:[<c047b51e>] EFLAGS: 00210202 CPU: 0
EIP is at exit_mmap+0xca/0xd6
EAX: 00000000 EBX: c1e1364c ECX: 00000000 EDX: f4d40a00
ESI: 00000000 EDI: f731afc0 EBP: f4d4e948 ESP: f4d4e934
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process ntpd (pid: 1721, ti=f4d4e000 task=f4d02fc0 task.ti=f4d4e000)
Stack: 000000c1 c1e1364c f731afc0 f731b058 f4d02fc0 f4d4e958 c0428f2d f731afc0 
       f731affc f4d4e970 c042c79c f4d033ec 0000000b f4d02fc0 00000000 f4d4e9a4 
       c042de84 00200206 00000001 f4d4e990 c0648c47 c06eb561 f4d4e99c f4d4e9a4 
Call Trace:
 [<c0428f2d>] ? mmput+0x3a/0x8b
 [<c042c79c>] ? exit_mm+0xd8/0xde
 [<c042de84>] ? do_exit+0x1fc/0x635
 [<c042ad7a>] ? oops_exit+0x23/0x28
 [<c0406262>] ? die+0x15c/0x164
 [<c0646e58>] ? do_page_fault+0x618/0x70a
 [<c040974f>] ? native_sched_clock+0xac/0xc8
 [<c040974f>] ? native_sched_clock+0xac/0xc8
 [<c0500b99>] ? __next_cpu+0x15/0x25
 [<c041f172>] ? find_busiest_group+0x23f/0x5d3
 [<c0423826>] ? hrtick_set+0x80/0xe5
 [<c043316b>] ? lock_timer_base+0x1f/0x3e
 [<c0646840>] ? do_page_fault+0x0/0x70a
 [<c064521a>] ? error_code+0x72/0x78
 [<c048e39a>] ? fget_light+0x59/0xb9
 [<c0499337>] ? do_select+0x2e1/0x4f5
 [<c0499ba9>] ? __pollwait+0x0/0xb3
 [<c0422900>] ? default_wake_function+0x0/0xd
 [<c0422900>] ? default_wake_function+0x0/0xd
 [<c0422900>] ? default_wake_function+0x0/0xd
 [<c040946e>] ? sched_clock+0x8/0xb
 [<c04dd3c8>] ? avc_has_perm_noaudit+0x3a6/0x3c4
 [<c040974f>] ? native_sched_clock+0xac/0xc8
 [<c040946e>] ? sched_clock+0x8/0xb
 [<c04460d1>] ? lock_release_holdtime+0x1a/0x115
 [<c0644bb8>] ? _spin_unlock_irqrestore+0x40/0x50
 [<c044788f>] ? trace_hardirqs_on+0xe9/0x10a
 [<c05ce52f>] ? __skb_recv_datagram+0xd8/0x1f5
 [<c04de040>] ? socket_has_perm+0x53/0x5d
 [<c060a0ce>] ? udp_recvmsg+0x5e/0x21e
 [<c05c8909>] ? sock_common_recvmsg+0x31/0x4a
 [<c040974f>] ? native_sched_clock+0xac/0xc8
 [<c0448313>] ? __lock_acquire+0x564/0xc18
 [<c040974f>] ? native_sched_clock+0xac/0xc8
 [<c040946e>] ? sched_clock+0x8/0xb
 [<c04460d1>] ? lock_release_holdtime+0x1a/0x115
 [<c0499577>] ? core_sys_select+0x2c/0x2d8
 [<c0499738>] ? core_sys_select+0x1ed/0x2d8
 [<c05cdd01>] ? verify_iovec+0x40/0x6f
 [<c05c8155>] ? sys_recvmsg+0xe8/0x17b
 [<c05c7ed0>] ? sys_sendto+0xa4/0xc3
 [<c04887c7>] ? check_object+0x134/0x18b
 [<c0489c53>] ? __slab_free+0x230/0x268
 [<c048af05>] ? kmem_cache_free+0xc9/0xde
 [<c044788f>] ? trace_hardirqs_on+0xe9/0x10a
 [<c049c77d>] ? d_free+0x3b/0x4d
 [<c0499ae9>] ? sys_select+0x88/0x148
 [<c040ac0b>] ? do_syscall_trace+0x138/0x17f
 [<c0404c3a>] ? syscall_call+0x7/0xb
 =======================
Code: e8 95 50 00 00 c7 43 04 00 00 00 00 89 f8 e8 d2 7e f8 ff eb 09 89 f0 e8 ea fe ff ff 89 c6 85 f6 75 f3 83 bf cc 00 00 00 00 74 04 <0f> 0b eb fe 8d 65 f4 5b 5e 5f 5d c3 55 89 e5 57 89 c7 56 53 89 
EIP: [<c047b51e>] exit_mmap+0xca/0xd6 SS:ESP 0068:f4d4e934
---[ end trace 013a4d2d914c796e ]---
Fixing recursive fault but reboot is needed!
device eth1 left promiscuous mode
BUG: unable to handle kernel paging request at 5a5a5a5a
IP: [<c048bc69>] get_unused_fd_flags+0x3d/0xd3
*pde = 00000000 
Oops: 0000 [#5] SMP DEBUG_PAGEALLOC
Modules linked in: nfs nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc ext2 sg via_ircc button irda crc_ccitt pata_sil680 via_rhine r8169 i2c_viapro pcspkr mii i2c_core dm_snapshot dm_zero dm_mirror dm_log dm_mod pata_via ata_generic pata_acpi libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]

Pid: 1837, comm: crond Tainted: G      D   (2.6.26-0.33.rc4.fc10.i686 #1)
EIP: 0060:[<c048bc69>] EFLAGS: 00010282 CPU: 0
EIP is at get_unused_fd_flags+0x3d/0xd3
EAX: f4d31e00 EBX: 00098800 ECX: 5a5a5a5a EDX: f4d31e04
ESI: f788d140 EDI: 5a5a5a5a EBP: f4f18f7c ESP: f4f18f60
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process crond (pid: 1837, ti=f4f18000 task=f4f2df80 task.ti=f4f18000)
Stack: 00098800 f4d31e80 f4d31e04 f4d31e00 00098800 f788d140 ffffff9c f4f18f98 
       c048bd2a f788d140 00000000 09aa3708 00098800 080514b5 f4f18fb0 c048bdf7 
       09aa3708 080514b5 48401455 080514b5 f4f18000 c0404c3a 080514b5 00098800 
Call Trace:
 [<c048bd2a>] ? do_sys_open+0x2b/0xb6
 [<c048bdf7>] ? sys_open+0x1e/0x26
 [<c0404c3a>] ? syscall_call+0x7/0xb
 =======================
Code: 8b 80 c4 03 00 00 89 45 f0 83 e8 80 89 45 e8 e8 4c 90 1b 00 8b 45 f0 83 c0 04 89 45 ec 8b 55 ec 8b 45 f0 8b 3a 8b 88 a0 00 00 00 <8b> 17 8b 47 0c e8 b5 50 07 00 89 c3 64 a1 00 a0 7b c0 8b 80 cc 
EIP: [<c048bc69>] get_unused_fd_flags+0x3d/0xd3 SS:ESP 0068:f4f18f60
---[ end trace 013a4d2d914c796e ]---

It survived a 'dmesg ; scp dmesg davej@gelk', and then wedged solid.
So as well as the oops, it seems we're corrupting memory too.
For reference, this kernel has both SLUB_DEBUG and PAGEALLOC_DEBUG enabled.

	Dave

-- 
http://www.codemonkey.org.uk
