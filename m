Return-Path: <linux-kernel-owner+w=401wt.eu-S932818AbZHDVNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818AbZHDVNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 17:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754978AbZHDVNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 17:13:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726AbZHDVNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 17:13:41 -0400
From: "NeilBrown" <neilb@suse.de>
To: "Dave Jones" <davej@redhat.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, neilb@suse.de
Date: Wed, 5 Aug 2009 07:13:08 +1000 (EST)
Message-ID: <58e2e493d0855face4e7d3fbf7ee65b9.squirrel@neil.brown.name>
In-Reply-To: <20090804141425.GA2831@redhat.com>
References: <20090804141425.GA2831@redhat.com>
Subject: Re: 2.6.31rc5 RAID10 lockdep report - sysfs_nofity_dirent locking 
     issue
Cc: gregkh@suse.de
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20090805071308_49574"
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_20090805071308_49574
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

On Wed, August 5, 2009 12:14 am, Dave Jones wrote:
> Report from a user we received today ..
> (https://bugzilla.redhat.com/show_bug.cgi?id=515471)
>
> 	Dave
>
>
> =================================
> [ INFO: inconsistent lock state ]
> 2.6.31-0.118.rc5.fc12.x86_64 #1
> ---------------------------------
> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> md126_resync/475 [HC0[0]:SC1[1]:HE1:SE0] takes:
> (sysfs_open_dirent_lock){+.?...}, at: [<ffffffff811a7d08>]
> sysfs_notify_dirent+0x2c/0x75

So the problem is that sysfs_open_dirent_lock is sometimes called
with SOFTIRQs enabled, and sometimes called in a SOFTIRQ and this
can lead to a deadlock.

The call from in a softirq is in sysfs_notify_dirent which is a very
small atomic function which I would certainly like to be able to
call from any context.

So the fix would be to use spin_lock_irq on the sysfs_open_dirent_lock ??
Or should it be spin_lock_bh ??

Attached is a suggestion for a patch.

Greg: does that look right?  If so I'll add a changelog entry and
submit it properly (after at least a compile test...)

Thanks,
NeilBrown


> {SOFTIRQ-ON-W} state was registered at:
>  [<ffffffff81097468>] __lock_acquire+0x2e9/0xc0e
>  [<ffffffff81097e7b>] lock_acquire+0xee/0x12e
>  [<ffffffff814fc99f>] _spin_lock+0x45/0x8e
>  [<ffffffff811a70e0>] sysfs_open_file+0x18f/0x295
>  [<ffffffff8113fba1>] __dentry_open+0x197/0x316
>  [<ffffffff8113fe20>] nameidata_to_filp+0x51/0x76
>  [<ffffffff8114e900>] do_filp_open+0x516/0x9d8
>  [<ffffffff8113f889>] do_sys_open+0x71/0x131
>  [<ffffffff8113f9b6>] sys_open+0x33/0x49
>  [<ffffffff81012f42>] system_call_fastpath+0x16/0x1b
>  [<ffffffffffffffff>] 0xffffffffffffffff
> irq event stamp: 12243532
> hardirqs last  enabled at (12243532): [<ffffffff814fc69b>]
> _spin_unlock_irq+0x3f/0x61
> hardirqs last disabled at (12243531): [<ffffffff814fcaa9>]
> _spin_lock_irq+0x2e/0x9a
> softirqs last  enabled at (12243378): [<ffffffff8106c9ad>]
> __do_softirq+0x1c4/0x1f0
> softirqs last disabled at (12243471): [<ffffffff8101422c>]
> call_softirq+0x1c/0x30
>
> other info that might help us debug this:
> 1 lock held by md126_resync/475:
> #0:  (&new->safemode_timer){+.-...}, at: [<ffffffff8107233a>]
> run_timer_softirq+0x198/0x2a3
>
> stack backtrace:
> Pid: 475, comm: md126_resync Not tainted 2.6.31-0.118.rc5.fc12.x86_64 #1
> Call Trace:
> <IRQ>  [<ffffffff81095f60>] valid_state+0x187/0x1ae
> [<ffffffff810969f1>] ? check_usage_forwards+0x0/0x79
> [<ffffffff810960b0>] mark_lock+0x129/0x253
> [<ffffffff810973f4>] __lock_acquire+0x275/0xc0e
> [<ffffffff8109536a>] ? save_trace+0x4e/0xba
> [<ffffffff81097e7b>] lock_acquire+0xee/0x12e
> [<ffffffff811a7d08>] ? sysfs_notify_dirent+0x2c/0x75
> [<ffffffff811a7d08>] ? sysfs_notify_dirent+0x2c/0x75
> [<ffffffff813eb86a>] ? md_safemode_timeout+0x0/0x70
> [<ffffffff814fc99f>] _spin_lock+0x45/0x8e
> [<ffffffff811a7d08>] ? sysfs_notify_dirent+0x2c/0x75
> [<ffffffff811a7d08>] sysfs_notify_dirent+0x2c/0x75
> [<ffffffff813eb8b3>] md_safemode_timeout+0x49/0x70
> [<ffffffff8107239e>] run_timer_softirq+0x1fc/0x2a3
> [<ffffffff8107233a>] ? run_timer_softirq+0x198/0x2a3
> [<ffffffff8106c8df>] __do_softirq+0xf6/0x1f0
> [<ffffffff8101422c>] call_softirq+0x1c/0x30
> [<ffffffff81015d77>] do_softirq+0x5f/0xd7
> [<ffffffff8106c1f6>] irq_exit+0x66/0xbc
> [<ffffffff814fc0ec>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> [<ffffffff81015406>] do_IRQ+0xb8/0xe5
> [<ffffffff810139d3>] ret_from_intr+0x0/0x16
> <EOI>  [<ffffffff814fc71c>] ? _spin_unlock_irqrestore+0x5f/0x7f
> [<ffffffff813580a6>] ? scsi_dispatch_cmd+0x1d4/0x25f
> [<ffffffff8135f095>] ? scsi_request_fn+0x483/0x4c4
> [<ffffffff8125c00e>] ? __blk_run_queue+0x54/0x9a
> [<ffffffff8126e727>] ? cfq_insert_request+0x26c/0x3d4
> [<ffffffff81253d83>] ? elv_insert+0x120/0x1e0
> [<ffffffff81253eea>] ? __elv_add_request+0xa7/0xc2
> [<ffffffff8125ce11>] ? __make_request+0x35e/0x3f1
> [<ffffffff81259e20>] ? generic_make_request+0x29e/0x2fc
> [<ffffffffa00db8af>] ? sync_request+0x833/0x8b2 [raid10]
> [<ffffffff813f1104>] ? md_do_sync+0x756/0xb4f
> [<ffffffff8101aa23>] ? native_sched_clock+0x2d/0x62
> [<ffffffff813f1dbc>] ? md_thread+0x100/0x132
> [<ffffffff813f1cbc>] ? md_thread+0x0/0x132
> [<ffffffff810816f5>] ? kthread+0xa5/0xad
> [<ffffffff8101412a>] ? child_rip+0xa/0x20
> [<ffffffff81013a90>] ? restore_args+0x0/0x30
> [<ffffffff81081650>] ? kthread+0x0/0xad
> [<ffffffff81014120>] ? child_rip+0x0/0x20
>

------=_20090805071308_49574
Content-Type: application/octet-stream; name="diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="diff"

ZGlmZiAtLWdpdCBhL2ZzL3N5c2ZzL2ZpbGUuYyBiL2ZzL3N5c2ZzL2ZpbGUuYwppbmRleCA1NjFh
OWMwLi5mNWVhNDY4IDEwMDY0NAotLS0gYS9mcy9zeXNmcy9maWxlLmMKKysrIGIvZnMvc3lzZnMv
ZmlsZS5jCkBAIC0yNjgsNyArMjY4LDcgQEAgc3RhdGljIGludCBzeXNmc19nZXRfb3Blbl9kaXJl
bnQoc3RydWN0IHN5c2ZzX2RpcmVudCAqc2QsCiAJc3RydWN0IHN5c2ZzX29wZW5fZGlyZW50ICpv
ZCwgKm5ld19vZCA9IE5VTEw7CiAKICByZXRyeToKLQlzcGluX2xvY2soJnN5c2ZzX29wZW5fZGly
ZW50X2xvY2spOworCXNwaW5fbG9ja19pcnEoJnN5c2ZzX29wZW5fZGlyZW50X2xvY2spOwogCiAJ
aWYgKCFzZC0+c19hdHRyLm9wZW4gJiYgbmV3X29kKSB7CiAJCXNkLT5zX2F0dHIub3BlbiA9IG5l
d19vZDsKQEAgLTI4MSw3ICsyODEsNyBAQCBzdGF0aWMgaW50IHN5c2ZzX2dldF9vcGVuX2RpcmVu
dChzdHJ1Y3Qgc3lzZnNfZGlyZW50ICpzZCwKIAkJbGlzdF9hZGRfdGFpbCgmYnVmZmVyLT5saXN0
LCAmb2QtPmJ1ZmZlcnMpOwogCX0KIAotCXNwaW5fdW5sb2NrKCZzeXNmc19vcGVuX2RpcmVudF9s
b2NrKTsKKwlzcGluX3VubG9ja19pcnEoJnN5c2ZzX29wZW5fZGlyZW50X2xvY2spOwogCiAJaWYg
KG9kKSB7CiAJCWtmcmVlKG5ld19vZCk7CkBAIC0zMTUsOCArMzE1LDkgQEAgc3RhdGljIHZvaWQg
c3lzZnNfcHV0X29wZW5fZGlyZW50KHN0cnVjdCBzeXNmc19kaXJlbnQgKnNkLAogCQkJCSAgc3Ry
dWN0IHN5c2ZzX2J1ZmZlciAqYnVmZmVyKQogewogCXN0cnVjdCBzeXNmc19vcGVuX2RpcmVudCAq
b2QgPSBzZC0+c19hdHRyLm9wZW47CisJdW5zaWduZWQgbG9uZyBmbGFnczsKIAotCXNwaW5fbG9j
aygmc3lzZnNfb3Blbl9kaXJlbnRfbG9jayk7CisJc3Bpbl9sb2NrX2lycXNhdmUoJnN5c2ZzX29w
ZW5fZGlyZW50X2xvY2ssIGZsYWdzKTsKIAogCWxpc3RfZGVsKCZidWZmZXItPmxpc3QpOwogCWlm
IChhdG9taWNfZGVjX2FuZF90ZXN0KCZvZC0+cmVmY250KSkKQEAgLTMyNCw3ICszMjUsNyBAQCBz
dGF0aWMgdm9pZCBzeXNmc19wdXRfb3Blbl9kaXJlbnQoc3RydWN0IHN5c2ZzX2RpcmVudCAqc2Qs
CiAJZWxzZQogCQlvZCA9IE5VTEw7CiAKLQlzcGluX3VubG9jaygmc3lzZnNfb3Blbl9kaXJlbnRf
bG9jayk7CisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmc3lzZnNfb3Blbl9kaXJlbnRfbG9jaywg
ZmxhZ3MpOwogCiAJa2ZyZWUob2QpOwogfQpAQCAtNDU2LDggKzQ1Nyw5IEBAIHN0YXRpYyB1bnNp
Z25lZCBpbnQgc3lzZnNfcG9sbChzdHJ1Y3QgZmlsZSAqZmlscCwgcG9sbF90YWJsZSAqd2FpdCkK
IHZvaWQgc3lzZnNfbm90aWZ5X2RpcmVudChzdHJ1Y3Qgc3lzZnNfZGlyZW50ICpzZCkKIHsKIAlz
dHJ1Y3Qgc3lzZnNfb3Blbl9kaXJlbnQgKm9kOworCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CiAKLQlz
cGluX2xvY2soJnN5c2ZzX29wZW5fZGlyZW50X2xvY2spOworCXNwaW5fbG9ja19pcnFzYXZlKCZz
eXNmc19vcGVuX2RpcmVudF9sb2NrLCBmbGFncyk7CiAKIAlvZCA9IHNkLT5zX2F0dHIub3BlbjsK
IAlpZiAob2QpIHsKQEAgLTQ2NSw3ICs0NjcsNyBAQCB2b2lkIHN5c2ZzX25vdGlmeV9kaXJlbnQo
c3RydWN0IHN5c2ZzX2RpcmVudCAqc2QpCiAJCXdha2VfdXBfaW50ZXJydXB0aWJsZSgmb2QtPnBv
bGwpOwogCX0KIAotCXNwaW5fdW5sb2NrKCZzeXNmc19vcGVuX2RpcmVudF9sb2NrKTsKKwlzcGlu
X3VubG9ja19pcnFyZXN0b3JlKCZzeXNmc19vcGVuX2RpcmVudF9sb2NrLCBmbGFncyk7CiB9CiBF
WFBPUlRfU1lNQk9MX0dQTChzeXNmc19ub3RpZnlfZGlyZW50KTsKIAo=
------=_20090805071308_49574--

