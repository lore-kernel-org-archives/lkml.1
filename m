Return-Path: <linux-kernel-owner+w=401wt.eu-S1758196AbXGOS40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbXGOS40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 14:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbXGOS4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 14:56:18 -0400
Received: from mx34.mail.ru ([194.67.23.200]:30280 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751483AbXGOS4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 14:56:16 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [possible regression] 2.6.22 reiserfs/libata sporadically hangs on resume from hibernation
Date: Sun, 15 Jul 2007 22:56:05 +0400
User-Agent: KMail/1.9.7
Cc: michal.k.k.piotrowski@gmail.com, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       reiserfs-devel@vger.kernel.org
References: <200706300859.47133.arvidjaar@mail.ru> <200707010134.30843.arvidjaar@mail.ru> <200707011209.29250.rjw@sisk.pl>
In-Reply-To: <200707011209.29250.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2441476.ea4NWOx8h9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707152256.07251.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2441476.ea4NWOx8h9
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 01 July 2007, Rafael J. Wysocki wrote:
> On Saturday, 30 June 2007 23:34, Andrey Borzenkov wrote:
> > On Sunday 01 July 2007, Rafael J. Wysocki wrote:
> > > On Saturday, 30 June 2007 06:59, Andrey Borzenkov wrote:
> > > > Since 2.6.18 I do not have suspend to RAM; now I am starting to lose
> > > > suspend to disk :)
> > > >
> > > > Environment - vanilla kernel (2.6.22-rc6 currently + squashfs +
> > > > single pata_ali patch to switch off DMA on CD-ROM), single root on
> > > > reiserfs, libata with pata_ali driver.
> > > >
> > > > Until 2.6.22-rc I never had problems with hibernation. With 2.6.22-=
rc
> > > > system hung at least once in every rcX. Up to rc6 those lockups were
> > > > absolutely silent (black screen without reaction to any key). In rc6
> > > > I just got something different. After resume I got on screem:
> > > >
> > > > swsusp: Marking nosave pages: 000000000009f000-0000000000100000
> > > > swsusp: Basic memory bitmaps created
> > > > swsusp: Basic memory bitmaps freed
> > > >
> > > > After that it just sits there doing nothing. Ther was brief sound of
> > > > HDD but I suspect it was related more to power-on. System was
> > > > responding to power-on button press:
> > > >
> > > > ACPI Error (event-0305): No installed handler for fixed event
> > > > [00000002 20070125]
> > > >
> > > > And SysRq was functioning.
> > >
> > > That probably means that there's a deadlock somewhere in there.
> > >
> > > > Unfortunately I do not have serial console so I
> > > > copy manually stacks from several last screens of output; I have
> > > > tried to make a photo but right now my kbluetooth is refusing to wo=
rk
> > > > at all so I cannot transfer them :( (but I suspect quality would be
> > > > too bad anyway)
> > > >
> > > > laptop_mode D
> > > > 	io_schedule+0xe/0x20
> > >
> > > Looks suspicious to me.  Can you identify what line of code this poin=
ts
> > > to?
> >
> > If you could explain how to ...
>
> Michal has already done that. :-)
>

(gdb) l *io_schedule+0xe
0xc02aa84e is in io_schedule (include2/asm/atomic.h:110).
105      *
106      * Atomically decrements @v by 1.
107      */
108     static __inline__ void atomic_dec(atomic_t *v)
109     {
110             __asm__ __volatile__(
111                     LOCK_PREFIX "decl %0"
112                     :"+m" (v->counter));
113     }
114

> [--snip--]
>
> > > I see you're using CFQ as the default IO scheduler.  Can you please
> > > switch to AS and see if that changes anything?
> >
> > Sure, but given that I have no idea how to reproduce the lockup, we may
> > never know whether it actually helped.
>
> Well, if the lockup never happens with AS, that will indicate something .=
=2E.
>

Well, I was about to say that it is probably gone as it hit again. Now with=
=20
IDE, so we at least can rule out libata. But reiserfs is still in path, so =
I=20
Cc list. It is stock 2.6.22. I will switch to AS, but it took 2 weeks to=20
happen with CFS and in one week I will be off for a couple of weeks.

Here is hand-copied information about locks and blocked processes.

Showing all locks held in the system:

1 lock held by syslogd/2515
 #0: (&inode->i_mutex){--..}, at: [<c02ab4d15>] mutex_lock+0x21/0x30
1 lock held by X/3800:
 #0: (&mm->mmap_sem){----}, at: [<c02ae2e8>] do_page_fault+0x1e8/0x5e0
6 times migetty - 1 lock held by mingetty/3838:
 #0: (&tty->atomic_read_lock){--..}, at: [<c02ab0915>]=20
mutex_lock_interruptible+0x21/0x30
2 times zsh - 1 lock held by zsh/4276:
 #0: (&tty->atomic_read_lock){--..}, at: [<c02ab0915>]=20
mutex_lock_interruptible+0x21/0x30
1 lock held by consolehelper-g/21231:
 #0: (&inode->i_mutex){--..}, at: [<c02ab4b1>] mutex_lock+0x21/0x30
1 lock held by kio_http/31282:
 #0: (&inode->i_mutex){--..}, at: [<c02ab4b1>] mutex_lock+0x21/0x30

and list of blocked tasks:

syslogd
 io_schedule+0xe/0x20
 sync_buffer+0x35/0x40
 __wait_on_bit+0x45/0x70
 out_of_line_wait_on_bit+0x50/0x60
 __wait_on_buffer+0x27/0x30
 flush_commit_list+0x397/0x610 [reiserfs]
 do_journal_end+0xadc/0xc90 [reiserfs]
 journal_end_sync+0x5d/0x70 [reiserfs]
 reiserfs_commit_for_inode+0x17e/0x1a0 [reiserfs]
 reiserfs_sync_file+0x2d/0x70 [reiserfs]
 do_fsync+0x28/0x40
 sys_fsync+0xd/0x10
 sysenter_past_esp+0x5f/0x99

X
 io_schedule+0xe/0x20
 sync_page+0x3a/0x50
 __wait_on_bit_lock+0x3f/0x70
 __lock_page+0x4c/0x60
 __handle_mm_fault+0x657/0x860
 do_page_fault+0x2f4/0x5e0
 error_code+0x6a/0x70

consolehelper
 io_schedule+0xe/0x20
 sync_buffer+0x35/0x40
 __wait_on_bit+0x45/0x70
 out_of_line_wait_on_bit+0x50/0x60
 __wait_on_buffer+0x27/0x30
 search_by_key+0x17e/0x1370 [reiserfs]
 search_by_entry_key+0x1c/0x2a0 [reiserfs]
 reiserfs_find_entry+0x7d/0x3a0 [reiserfs]
 reiserfs_lookup+0x75/0x120 [reiserfs]
 do_lookup+0x133/0x180
 __link_path_walk+0x765/0xd10
 link_path_walk+0x44/0xc0
 path_walk+0x18/0x20
 do_path_lookup+0x7c/0x200
 __path_lookup_intent_open+0x1f/0x30
 open_namei+0x66/0x670
 do_filp_open+0x2c/0x50
 do_sys_open+0x47/0xd0
 sys_open+0x1c/0x20
 syscall_call+0x7/0xb

kio_http
 io_schedule+0xe/0x20
 sync_buffer+0x35/0x40
 __wait_on_bit+0x45/0x70
 out_of_line_wait_on_bit+0x50/0x60
 __wait_on_buffer+0x27/0x30
 search_by_key+0x17e/0x1370 [reiserfs]
 reiserfs_read_locked_inode+0x63/0x570 [reiserfs]
 reiserfs_iget+0x87/0x90 [reiserfs]
 reiserfs_lookup+0xed/0x120 [reiserfs]
 do_lookup+0x133/0x180
 __link_path_walk+0x765/0xd10
 link_path_walk+0x44/0xc0
 path_walk+0x18/0x20
 do_path_lookup+0x7c/0x200
 __user_walk_fd+0x38/0x50
 vfs_lstat_fd+0x1e/0x50
 vfs_lstat+0x11/0x20
 sys_lstat64+0x14/0x30
 sysenter_past_esp+0x5f/0x99

90clock
 io_schedule+0xe/0x20
 sync_page+0x3a/0x50
 __wait_on_bit_lock+0x3f/0x70
 __lock_page+0x4c/0x60
 do_generic_mapping_read+0x1cb/0x4e0
 generic_file_aio_read+0x132/0x160
 do_sync_read+0xcd/0x110
 vfs_read+0x94/0x130
 kernel_read+0x3a/0x50
 prepare_binprm+0xaf/0xe0
 do_execve+0xd7/0x1b0
 sys_execve+0x2e/0x80
 sysenter_past_esp+0x5f/0x99

65alsa
 io_schedule+0xe/0x20
 sync_page+0x3a/0x50
 __wait_on_bit_lock+0x3f/0x70
 __lock_page+0x4c/0x60
 do_generic_mapping_read+0x1cb/0x4e0
 generic_file_aio_read+0x132/0x160
 do_sync_read+0xcd/0x110
 vfs_read+0x94/0x130
 kernel_read+0x3a/0x50
 prepare_binprm+0xaf/0xe0
 do_execve+0xd7/0x1b0
 sys_execve+0x2e/0x80
 sysenter_past_esp+0x5f/0x99


current function is acpi_processor_idle so it is 100% deadlock.

dmesg with IDE drivers:

[    0.000000] Linux version 2.6.22-2avb (bor@cooker) (gcc version 4.2.1=20
20070704 (prerelease) (4.2.1-3mdv2008.0)) #23 Sat Jul 14 21:04:49 MSD 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 00000000000eee00 (reserved)
[    0.000000]  BIOS-e820: 00000000000eee00 - 00000000000ef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000000ef000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001ef60000 (usable)
[    0.000000]  BIOS-e820: 000000001ef60000 - 000000001ef70000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001ef70000 - 0000000020000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] 495MB LOWMEM available.
[    0.000000] Entering add_active_range(0, 0, 126816) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   126816
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   126816
[    0.000000] On node 0 totalpages: 126816
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 958 pages used for memmap
[    0.000000]   Normal zone: 121762 pages, LIFO batch:31
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F0090, 0014 (r0 TOSHIB)
[    0.000000] ACPI: RSDT 1EF60000, 0028 (r1 TOSHIB 750        970814 TASM =
=20
4010000)
[    0.000000] ACPI: FACP 1EF60054, 0084 (r2 TOSHIB 750        970814 TASM =
=20
4010000)
[    0.000000] ACPI: DSDT 1EF600D8, 68DA (r1 TOSHIB 4000     20020417 MSFT =
=20
100000A)
[    0.000000] ACPI: FACS 000EEE00, 0040
[    0.000000] ACPI: PM-Timer IO Port: 0xee08
[    0.000000] Allocating PCI resources starting at 30000000 (gap:=20
20000000:dff80000)
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 -=
=20
00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 -=
=20
00000000000e0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e0000 -=
=20
00000000000ee000
[    0.000000] swsusp: Registered nosave memory region: 00000000000ee000 -=
=20
00000000000ef000
[    0.000000] swsusp: Registered nosave memory region: 00000000000ef000 -=
=20
0000000000100000
[    0.000000] Built 1 zonelists.  Total pages: 125826
[    0.000000] Kernel command line: BOOT_IMAGE=3D2.6.22-2avb root=3DLABEL=
=3D/=20
resume=3DLABEL=3Dswap splash=3Dsilent vga=3D791
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 747.765 MHz processor.
[  146.118249] Console: colour dummy device 80x25
[  146.118448] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
=20
Ingo Molnar
[  146.118464] ... MAX_LOCKDEP_SUBCLASSES:    8
[  146.118473] ... MAX_LOCK_DEPTH:          30
[  146.118482] ... MAX_LOCKDEP_KEYS:        2048
[  146.118491] ... CLASSHASH_SIZE:           1024
[  146.118501] ... MAX_LOCKDEP_ENTRIES:     8192
[  146.118510] ... MAX_LOCKDEP_CHAINS:      16384
[  146.118520] ... CHAINHASH_SIZE:          8192
[  146.118529]  memory used by lock dependency info: 992 kB
[  146.118540]  per task-struct memory footprint: 1200 bytes
[  146.118551] ------------------------
[  146.118559] | Locking API testsuite:
[ =20
146.118569] ---------------------------------------------------------------=
=2D------------
[  146.118583]                                  | spin |wlock |rlock |mutex=
 |=20
wsem | rsem |
[ =20
146.118599]   -------------------------------------------------------------=
=2D------------
[  146.118644]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  146.121564]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  146.123727]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  146.125935]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  146.128140]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  146.130405]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  146.132668]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  146.134937]                     double unlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  146.137052]                   initialize held:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  146.139158]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[ =20
146.141310]   -------------------------------------------------------------=
=2D------------
[  146.141325]               recursive read-lock:             | =20
ok  |             |  ok  |
[  146.142040]            recursive read-lock #2:             | =20
ok  |             |  ok  |
[  146.142755]             mixed read-write-lock:             | =20
ok  |             |  ok  |
[  146.143476]             mixed write-read-lock:             | =20
ok  |             |  ok  |
[ =20
146.144196]   -------------------------------------------------------------=
=2D------------
[  146.144211]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[  146.145281]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[  146.146355]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[  146.147418]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[  146.148481]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[  146.149546]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[  146.150610]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[  146.151672]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[  146.152739]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[  146.153802]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[  146.154865]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[  146.155957]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[  146.157044]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[  146.158129]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[  146.159217]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[  146.160302]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[  146.161386]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[  146.162466]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[  146.163549]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[  146.164621]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[  146.165693]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[  146.166773]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[  146.167857]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[  146.168947]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[  146.170040]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[  146.171123]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[  146.172211]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[  146.173294]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[  146.174383]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[  146.175462]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[  146.176546]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[  146.177625]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[  146.178714]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[  146.179795]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[  146.180880]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[  146.181964]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[  146.183056]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[  146.184140]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[  146.185230]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[  146.186314]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[  146.187403]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[  146.188483]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[  146.189570]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[  146.190653]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[  146.191743]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[  146.192825]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[  146.193911]       hard-irq read-recursion/123:  ok  |
[  146.194280]       soft-irq read-recursion/123:  ok  |
[  146.194652]       hard-irq read-recursion/132:  ok  |
[  146.195019]       soft-irq read-recursion/132:  ok  |
[  146.195390]       hard-irq read-recursion/213:  ok  |
[  146.195758]       soft-irq read-recursion/213:  ok  |
[  146.196127]       hard-irq read-recursion/231:  ok  |
[  146.196495]       soft-irq read-recursion/231:  ok  |
[  146.196864]       hard-irq read-recursion/312:  ok  |
[  146.197233]       soft-irq read-recursion/312:  ok  |
[  146.197602]       hard-irq read-recursion/321:  ok  |
[  146.197971]       soft-irq read-recursion/321:  ok  |
[  146.198342] -------------------------------------------------------
[  146.198354] Good, all 218 testcases passed! |
[  146.198364] ---------------------------------
[  146.200019] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[  146.202916] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[  146.308222] Memory: 496732k/507264k available (1728k kernel code, 9908k=
=20
reserved, 789k data, 180k init, 0k highmem)
[  146.308297] virtual kernel memory layout:
[  146.308300]     fixmap  : 0xffff8000 - 0xfffff000   (  28 kB)
[  146.308305]     vmalloc : 0xdf800000 - 0xffff6000   ( 519 MB)
[  146.308309]     lowmem  : 0xc0000000 - 0xdef60000   ( 495 MB)
[  146.308314]       .init : 0xc0378000 - 0xc03a5000   ( 180 kB)
[  146.308318]       .data : 0xc02b0045 - 0xc0375564   ( 789 kB)
[  146.308322]       .text : 0xc0100000 - 0xc02b0045   (1728 kB)
[  146.308358] Checking if this processor honours the WP bit even in=20
supervisor mode... Ok.
[  146.308605] SLUB: Genslabs=3D22, HWalign=3D32, Order=3D0-1, MinObjects=
=3D4, CPUs=3D1,=20
Nodes=3D1
[  146.392001] Calibrating delay using timer specific routine.. 1497.71=20
BogoMIPS (lpj=3D2495547)
[  146.392203] Mount-cache hash table entries: 512
[  146.393145] CPU: After generic identify, caps: 0383f9ff 00000000 0000000=
0=20
00000000 00000000 00000000 00000000
[  146.393185] CPU: L1 I cache: 16K, L1 D cache: 16K
[  146.393200] CPU: L2 cache: 256K
[  146.393216] CPU: After all inits, caps: 0383f9ff 00000000 00000000 00000=
040=20
00000000 00000000 00000000
[  146.393253] Compat vDSO mapped to ffffe000.
[  146.393308] CPU: Intel Pentium III (Coppermine) stepping 0a
[  146.393333] Checking 'hlt' instruction... OK.
[  146.405681] ACPI: Core revision 20070126
[  146.413827] ACPI: setting ELCR to 0200 (from 0a00)
[  146.415895] NET: Registered protocol family 16
[  146.417085] ACPI: bus type pci registered
[  146.418107] PCI: PCI BIOS revision 2.10 entry at 0xfe5ae, last bus=3D5
[  146.418121] PCI: Using configuration type 1
[  146.418131] Setting up standard PCI resources
[  146.436807] ACPI: Interpreter enabled
[  146.436860] ACPI: (supports S0 S3 S4 S5)
[  146.436957] ACPI: Using PIC for interrupt routing
[  146.464951] ACPI: PCI Root Bridge [PCI0] (0000:00)
[  146.465088] PCI: Probing PCI hardware (bus 00)
[  146.466289] PCI quirk: region ee00-ee3f claimed by ali7101 ACPI
[  146.466322] PCI quirk: region ef00-ef1f claimed by ali7101 SMB
[  146.466391] PCI: Firmware left 0000:00:0a.0 e100 interrupts enabled,=20
disabling
[  146.468056] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[  146.468498] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[  146.488967] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11)
[  146.489593] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11)
[  146.490174] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11)
[  146.490754] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11)
[  146.491334] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11)
[  146.491932] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11)
[  146.492999] ACPI: Power Resource [PFAN] (off)
[  146.493056] Linux Plug and Play Support v0.97 (c) Adam Belay
[  146.493177] pnp: PnP ACPI init
[  146.493293] ACPI: bus type pnp registered
[  146.511398] pnp: Device 00:0a activated.
[  146.511456]  00:0a: SMCf010 not responding at SIR 0x100, FIR 0x2e8;=20
auto-configuring
[  146.513004] pnp: Device 00:0a disabled.
[  146.518367] pnp: Device 00:0a activated.
[  146.518394]  00:0a: not responding at SIR 0x100, FIR 0x2e8; swapping=20
SIR/FIR and reconfiguring
[  146.519911] pnp: Device 00:0a disabled.
[  146.526303] pnp: Device 00:0a activated.
[  146.526329]  00:0a: responds at SIR 0x2e8, FIR 0x100
[  146.533859] pnp: PnP ACPI: found 12 devices
[  146.533901] ACPI: ACPI bus type pnp unregistered
[  146.534220] PCI: Using ACPI for IRQ routing
[  146.534237] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it=
=20
helps, post a report
[  146.545182] pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
[  146.545211] pnp: 00:00: iomem range 0xe0000-0xeffff could not be reserved
[  146.545227] pnp: 00:00: iomem range 0xf0000-0xfffff could not be reserved
[  146.545243] pnp: 00:00: iomem range 0x100000-0x1ef5ffff could not be=20
reserved
[  146.545270] Time: tsc clocksource has been installed.
[  146.577296] PCI: Bridge: 0000:00:01.0
[  146.577317]   IO window: disabled.
[  146.577337]   MEM window: f7f00000-fdffffff
[  146.577354]   PREFETCH window: 48000000-480fffff
[  146.577374] PCI: Bus 2, cardbus bridge: 0000:00:10.0
[  146.577386]   IO window: 00001000-000010ff
[  146.577401]   IO window: 00001400-000014ff
[  146.577416]   PREFETCH window: 30000000-33ffffff
[  146.577431]   MEM window: 34000000-37ffffff
[  146.577447] PCI: Bus 6, cardbus bridge: 0000:00:11.0
[  146.577457]   IO window: 00001800-000018ff
[  146.577472]   IO window: 00001c00-00001cff
[  146.577488]   PREFETCH window: 38000000-3bffffff
[  146.577504]   MEM window: 3c000000-3fffffff
[  146.577519] PCI: Bus 10, cardbus bridge: 0000:00:11.1
[  146.577529]   IO window: 00002000-000020ff
[  146.577544]   IO window: 00002400-000024ff
[  146.577560]   PREFETCH window: 40000000-43ffffff
[  146.577576]   MEM window: 44000000-47ffffff
[  146.577613] PCI: Setting latency timer of device 0000:00:01.0 to 64
[  146.577657] PCI: Enabling device 0000:00:10.0 (0000 -> 0003)
[  146.579064] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[  146.579086] PCI: setting IRQ 11 as level-triggered
[  146.579095] ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKC] -> GSI 11=
=20
(level, low) -> IRQ 11
[  146.579151] PCI: Enabling device 0000:00:11.0 (0000 -> 0003)
[  146.580128] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[  146.580142] ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKA] -> GSI 11=
=20
(level, low) -> IRQ 11
[  146.580195] PCI: Enabling device 0000:00:11.1 (0000 -> 0003)
[  146.581166] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[  146.581180] ACPI: PCI Interrupt 0000:00:11.1[B] -> Link [LNKB] -> GSI 11=
=20
(level, low) -> IRQ 11
[  146.581272] NET: Registered protocol family 2
[  146.612106] IP route cache hash table entries: 4096 (order: 2, 16384 byt=
es)
[  146.612526] TCP established hash table entries: 16384 (order: 7, 720896=
=20
bytes)
[  146.619101] TCP bind hash table entries: 16384 (order: 7, 720896 bytes)
[  146.625913] TCP: Hash tables configured (established 16384 bind 16384)
[  146.626073] TCP reno registered
[  146.636127] checking if image is initramfs... it is
[  146.756565] Freeing initrd memory: 487k freed
[  146.759186] audit: initializing netlink socket (disabled)
[  146.759327] audit(1184521988.239:1): initialized
[  146.776388] io scheduler noop registered
[  146.776439] io scheduler anticipatory registered
[  146.776450] io scheduler deadline registered
[  146.776893] io scheduler cfq registered (default)
[  146.776986] Activating ISA DMA hang workarounds.
[  146.777032] Boot video device is 0000:01:00.0
[  146.777689] vesafb: framebuffer at 0xfc000000, mapped to 0xdf880000, usi=
ng=20
3072k, total 16384k
[  146.777726] vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D9
[  146.777738] vesafb: protected mode interface info at c000:775e
[  146.777752] vesafb: pmi: set display start =3D c00c777f, set palette =3D=
=20
c00c77e2
[  146.777763] vesafb: scrolling: redraw
[  146.777777] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[  146.847494] Console: switching to colour frame buffer device 128x48
[  146.910097] fb0: VESA VGA frame buffer device
[  147.078558] Switched to high resolution mode on CPU 0
[  147.204546] Real Time Clock Driver v1.12ac
[  147.209934] RAMDISK driver initialized: 16 RAM disks of 32000K size 1024=
=20
blocksize
[  147.212888] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64=
=20
irq 1,12
[  147.218692] serio: i8042 KBD port at 0x60,0x64 irq 1
[  147.219384] serio: i8042 AUX port at 0x60,0x64 irq 12
[  147.221082] mice: PS/2 mouse device common for all mice
[  147.222415] TCP cubic registered
[  147.223486] NET: Registered protocol family 1
[  147.224082] Using IPI Shortcut mode
[  147.225839] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[  147.227600] Freeing unused kernel memory: 180k freed
[  147.228588] Write protecting the kernel read-only data: 634k
[  147.251478] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[  147.252452] ide: Assuming 33MHz system bus speed for PIO modes; override=
=20
with idebus=3Dxx
[  147.307813] input: AT Translated Set 2 keyboard as /class/input/input0
[  147.334723] ALI15X3: IDE controller at PCI slot 0000:00:04.0
[  147.360583] ACPI: Unable to derive IRQ for device 0000:00:04.0
[  147.386108] ACPI: PCI Interrupt 0000:00:04.0[A]: no GSI
[  147.411406] ALI15X3: chipset revision 195
[  147.436332] ALI15X3: not 100% native mode: will probe irqs later
[  147.461604]     ide0: BM-DMA at 0xeff0-0xeff7, BIOS settings: hda:DMA,=20
hdb:pio
[  147.487333]     ide1: BM-DMA at 0xeff8-0xefff, BIOS settings: hdc:DMA,=20
hdd:pio
[  147.512683] Probing IDE interface ide0...
[  147.788565] hda: IC25N020ATDA04-0, ATA DISK drive
[  148.451540] hda: host side 80-wire cable detection failed, limiting max=
=20
speed to UDMA33
[  148.477492] hda: selected mode 0x42
[  148.477894] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[  148.522057] Probing IDE interface ide1...
[  149.221564] hdc: TOSHIBA DVD-ROM SD-C2502, ATAPI CD/DVD-ROM drive
[  149.887862] hdc: selected mode 0x42
[  149.908921] ide1 at 0x170-0x177,0x376 on irq 15
[  149.969074] hda: max request size: 128KiB
[  149.996202] hda: 39070080 sectors (20003 MB) w/1806KiB Cache,=20
CHS=3D38760/16/63, UDMA(33)
[  150.023520] hda: cache flushes not supported
[  150.050630]  hda: hda1 hda2
[  150.494277] swsusp: Marking nosave pages: 000000000009f000 -=20
0000000000100000
[  150.494305] swsusp: Basic memory bitmaps created
[  150.529321] swsusp: Basic memory bitmaps freed
[  150.656261] ReiserFS: hda2: found reiserfs format "3.6" with standard=20
journal
[  150.681676] ReiserFS: hda2: using ordered data mode
[  150.718127] ReiserFS: hda2: journal params: device hda2, size 8192, jour=
nal=20
first block 18, max trans len 1024, max batch 900, max commit age 30, max=20
trans age 30
[  150.778293] ReiserFS: hda2: checking transaction log (hda2)
[  217.761107] ReiserFS: hda2: replayed 351 transactions in 67 seconds
[  218.335983] ReiserFS: hda2: Using r5 hash to sort names
[  226.284018] Linux agpgart interface v0.102 (c) Dave Jones
[  226.352722] agpgart: Detected ALi M1644 chipset
[  226.362582] agpgart: AGP aperture is 64M @ 0xf0000000
[  226.577189] usbcore: registered new interface driver usbfs
[  226.577458] usbcore: registered new interface driver hub
[  226.577667] usbcore: registered new device driver usb
[  226.652012] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHC=
I)=20
Driver
[  226.653704] ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
[  226.653720] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKG] -> GSI 11=
=20
(level, low) -> IRQ 11
[  226.653776] ohci_hcd 0000:00:02.0: OHCI Host Controller
[  226.655696] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus=
=20
number 1
[  226.655787] ohci_hcd 0000:00:02.0: irq 11, io mem 0xf7eff000
[  226.709833] usb usb1: configuration #1 chosen from 1 choice
[  226.710157] hub 1-0:1.0: USB hub found
[  226.710253] hub 1-0:1.0: 3 ports detected
[  226.954131] e100: Intel(R) PRO/100 Network Driver, 3.5.17-k4-NAPI
[  226.954148] e100: Copyright(c) 1999-2006 Intel Corporation
[  226.955954] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[  226.955966] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKD] -> GSI 11=
=20
(level, low) -> IRQ 11
[  226.986154] e100: eth0: e100_probe: addr 0xf7efd000, irq 11, MAC addr=20
00:00:39:D7:14:A1
[  227.294046] hdc: ATAPI 24X DVD-ROM drive, 128kB Cache, UDMA(33)
[  227.294087] Uniform CD-ROM driver Revision: 3.20
[  227.395342] Yenta: CardBus bridge found at 0000:00:10.0 [12a3:ab01]
[  227.395399] Yenta: Using CSCINT to route CSC interrupts to PCI
[  227.395406] Yenta: Routing CardBus interrupts to PCI
[  227.395419] Yenta TI: socket 0000:00:10.0, mfunc 0x01000002, devctl 0x60
[  227.623765] Yenta: ISA IRQ mask 0x0000, PCI irq 11
[  227.623782] Socket status: 30000059
[  227.624796] Yenta: CardBus bridge found at 0000:00:11.0 [1179:0001]
[  227.750531] Yenta: ISA IRQ mask 0x04b8, PCI irq 11
[  227.750549] Socket status: 30000007
[  227.751283] Yenta: CardBus bridge found at 0000:00:11.1 [1179:0001]
[  227.877170] Yenta: ISA IRQ mask 0x04b8, PCI irq 11
[  227.877188] Socket status: 30000007
[  227.881919] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
[  227.881939] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI 11=
=20
(level, low) -> IRQ 11
[  228.038205] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ=20
sharing enabled
[  228.144257] 00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[  228.249319] NET: Registered protocol family 23
[  228.256343] pccard: PCMCIA card inserted into slot 0
[  228.291675] Detected unconfigured Toshiba laptop with ALi ISA bridge SMS=
C=20
IrDA chip, pre-configuring device.
[  228.291709] Activated ALi 1533 ISA bridge port 0x02e8.
[  228.291722] Activated ALi 1533 ISA bridge port 0x02f8.
[  228.291929] found SMC SuperIO Chip (devid=3D0x5a rev=3D00 base=3D0x002e)=
:=20
LPC47N227
[  228.291961] smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03, irq: 7=
,=20
mode: 0x0e
[  228.291996] SMsC IrDA Controller found
[  228.292000]  IrCC version 2.0, firport 0x2f8, sirport 0x2e8 dma=3D3, irq=
=3D7
[  228.292200] No transceiver found. Defaulting to Fast pin select
[  228.292765] IrDA: Registered device irda0
[  232.249472] cs: IO port probe 0x100-0x3af: excluding 0x200-0x207=20
0x220-0x22f 0x330-0x337 0x378-0x37f 0x388-0x38f
[  232.252448] cs: IO port probe 0x3e0-0x4ff: excluding 0x408-0x40f=20
0x480-0x48f 0x4d0-0x4d7
[  232.253743] cs: IO port probe 0x820-0x8ff: clean.
[  232.254912] cs: IO port probe 0xc00-0xcf7: clean.
[  232.256835] cs: IO port probe 0xa00-0xaff: clean.
[  232.267012] cs: IO port probe 0x100-0x3af: excluding 0x200-0x207=20
0x220-0x22f 0x330-0x337 0x378-0x37f 0x388-0x38f
[  232.294588] cs: IO port probe 0x100-0x3af: excluding 0x200-0x207=20
0x220-0x22f 0x330-0x337 0x378-0x37f 0x388-0x38f
[  232.297589] cs: IO port probe 0x3e0-0x4ff: excluding 0x408-0x40f=20
0x480-0x48f 0x4d0-0x4d7
[  232.298932] cs: IO port probe 0x820-0x8ff: clean.
[  232.300105] cs: IO port probe 0xc00-0xcf7: clean.
[  232.302039] cs: IO port probe 0xa00-0xaff: clean.
[  232.303572] cs: memory probe 0xa0000000-0xa0ffffff: clean.
[  232.315722] pcmcia: registering new device pcmcia0.0
[  232.334945] cs: IO port probe 0x3e0-0x4ff: excluding 0x408-0x40f=20
0x480-0x48f 0x4d0-0x4d7
[  232.336352] cs: IO port probe 0x820-0x8ff: clean.
[  232.337514] cs: IO port probe 0xc00-0xcf7: clean.
[  232.339443] cs: IO port probe 0xa00-0xaff: clean.
[  232.384182] wlags49_h1_cs v7.18 for PCMCIA, 03/31/2004 14:31:00 by Agere=
=20
Systems, http://www.agere.com
[  232.384202] *** Modified for kernel 2.6 by Andrey Borzenkov=20
<arvidjaar@mail.ru> $Revision: 39 $
[  232.384211] *** Station Mode (STA) Support: YES
[  232.384216] *** Access Point Mode (AP) Support: YES
[  232.873999] eth1: PRI 31 variant 2 version 9.48
[  232.874064] eth1: NIC 5 variant 2 version 1.02
[  232.877896] eth1: Wireless, io_addr 0x100, irq 11, mac_address=20
00:02:2D:26:95:6C
[  233.379918] Toshiba System Managment Mode driver v1.11 26/9/2001
[  233.563548] Non-volatile memory driver v1.2
[  233.675575] input: ImPS/2 Generic Wheel Mouse as /class/input/input1
[  234.292054] ACPI: AC Adapter [ADP1] (on-line)
[  234.351376] ACPI: Battery Slot [BAT1] (battery present)
[  234.351659] ACPI: Battery Slot [BAT2] (battery absent)
[  234.386464] input: Power Button (FF) as /class/input/input2
[  234.386616] ACPI: Power Button (FF) [PWRF]
[  234.387013] input: Lid Switch as /class/input/input3
[  234.387127] ACPI: Lid Switch [LID]
[  234.558828] ACPI: Transitioning device [FAN] to D3
[  234.558846] ACPI: Transitioning device [FAN] to D3
[  234.558871] ACPI: Fan [FAN] (off)
[  234.711418] ACPI: CPU0 (power states: C1[C1] C2[C2])
[  234.756382] ACPI: Thermal Zone [THRM] (59 C)
[  234.800663] toshiba_acpi: Toshiba Laptop ACPI Extras version 0.18
[  234.800684] toshiba_acpi:     HCI method: \_SB_.VALD.GHCI
[  234.839715] ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: n=
o)
[   88.683324] Marking TSC unstable due to: possible TSC halt in C2.
[   88.686657] Time: acpi_pm clocksource has been installed.
[   88.716657] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised:=
=20
dm-devel@redhat.com
[   89.216657] loop: module loaded
[   89.269991] Clocksource tsc unstable (delta =3D -145662416 ns)
[   92.553324] ReiserFS: hda2: Removing [671391 1519587 0x0 SD]..done
[   92.556657] ReiserFS: hda2: Removing [671391 1519520 0x0 SD]..done
[   92.556657] ReiserFS: hda2: Removing [671391 1516060 0x0 SD]..done
[   92.556657] ReiserFS: hda2: Removing [671391 1515999 0x0 SD]..done
[   92.556657] ReiserFS: hda2: Removing [671391 1515981 0x0 SD]..done
[   92.556657] ReiserFS: hda2: Removing [671391 1502008 0x0 SD]..done
[   92.556657] ReiserFS: hda2: Removing [671391 1498678 0x0 SD]..done
[   92.556657] ReiserFS: hda2: Removing [21277 1394770 0x0 SD]..done
[   92.556657] ReiserFS: hda2: Removing [671391 1210424 0x0 SD]..done
[   92.556657] ReiserFS: hda2: Removing [671391 1210410 0x0 SD]..done
[   92.556657] ReiserFS: hda2: Removing [671391 1210303 0x0 SD]..done
[   92.556657] ReiserFS: hda2: Removing [671391 1210296 0x0 SD]..done
[   92.556657] ReiserFS: hda2: Removing [671391 1210291 0x0 SD]..done
[   92.556657] ReiserFS: hda2: Removing [671391 1210274 0x0 SD]..done
[   92.573324] ReiserFS: hda2: Removing [671391 1210112 0x0 SD]..done
[   92.573324] ReiserFS: hda2: Removing [671391 1209595 0x0 SD]..done
[   92.576657] ReiserFS: hda2: Removing [671391 1151901 0x0 SD]..done
[   92.576657] ReiserFS: hda2: Removing [671391 1151853 0x0 SD]..done
[   92.576657] ReiserFS: hda2: Removing [671391 1135802 0x0 SD]..done
[   92.576657] ReiserFS: hda2: Removing [671391 1135733 0x0 SD]..done
[   92.576657] ReiserFS: hda2: Removing [671391 282007 0x0 SD]..done
[   92.576657] ReiserFS: hda2: Removing [21277 281960 0x0 SD]..done
[   92.576657] ReiserFS: hda2: Removing [21277 281955 0x0 SD]..done
[   92.576657] ReiserFS: hda2: There were 23 uncompleted unlinks/truncates.=
=20
Completed
[   93.533323] Adding 500432k swap on /dev/hda1.  Priority:-1 extents:1=20
across:500432k
[  104.616656] IrCOMM protocol (Dag Brattli)
[  108.646655] PPP generic driver version 2.4.2
[  111.209988] Bluetooth: Core ver 2.11
[  111.209988] NET: Registered protocol family 31
[  111.209988] Bluetooth: HCI device and connection manager initialized
[  111.209988] Bluetooth: HCI socket layer initialized
[  111.576655] Bluetooth: L2CAP ver 2.8
[  111.576655] Bluetooth: L2CAP socket layer initialized
[  112.349988] hdc: drive_cmd: status=3D0x51 { DriveReady SeekComplete Erro=
r }
[  112.349988] hdc: drive_cmd: error=3D0x04 { AbortedCommand }
[  112.349988] ide: failed opcode was: 0xec
[  112.873322] Bluetooth: RFCOMM socket layer initialized
[  112.873322] Bluetooth: RFCOMM TTY layer initialized
[  112.873322] Bluetooth: RFCOMM ver 1.8
[  113.349988] NET: Registered protocol family 17
[  113.543321] hdc: drive_cmd: status=3D0x51 { DriveReady SeekComplete Erro=
r }
[  113.543321] hdc: drive_cmd: error=3D0x04 { AbortedCommand }
[  113.543321] ide: failed opcode was: 0xec
[  117.346654] eth1: PRI 31 variant 2 version 9.48
[  117.346654] eth1: NIC 5 variant 2 version 1.02
[  118.053321] eth1: PRI 31 variant 2 version 9.48
[  118.053321] eth1: NIC 5 variant 2 version 1.02
[  118.379988] eth1: PRI 31 variant 2 version 9.48
[  118.379988] eth1: NIC 5 variant 2 version 1.02

--nextPart2441476.ea4NWOx8h9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGmm3HR6LMutpd94wRAjrVAJ9CFigWG72+kh03vxSeB5PUEH8okgCfe8LC
f84CPNOkSxTusfYD6AiFiqo=
=z8gz
-----END PGP SIGNATURE-----

--nextPart2441476.ea4NWOx8h9--
