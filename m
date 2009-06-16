Return-Path: <linux-kernel-owner+w=401wt.eu-S1765977AbZFPFpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765977AbZFPFpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbZFPFpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:45:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58129 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbZFPFph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:45:37 -0400
Date: Tue, 16 Jun 2009 01:45:36 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: bug in tty ldisc and friends
Message-ID: <alpine.DEB.2.00.0906160144340.26673@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-152093887-1245130225=:26673"
Content-ID: <alpine.DEB.2.00.0906160144341.26673@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-152093887-1245130225=:26673
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.DEB.2.00.0906160144342.26673@gandalf.stny.rr.com>


[ Ingo and Andrew, sorry for the repost, but I forgot to Cc LKML and I 
  also used Alan's old email. ]

I can easily trigger a bug in the tty code by enabling the event tracers.

Attached is the config.

One dump I get is:

RIP: 0010:[<ffffffff812591b4>]  [<ffffffff812591b4>] 
pty_chars_in_buffer+0x24/0x70
RSP: 0018:ffff880025f83938  EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff88003b986000 RCX: 0000000000000000
RDX: ffffffff81259190 RSI: 0000000000000001 RDI: ffff880030da5000
RBP: ffff880025f83948 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: ffff88003389ae40 R14: ffff88003b9fe400 R15: 0000000000000000
FS:  00007f97e5c6a710(0000) GS:ffff880004000000(0000) 
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000003d195000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
Process sshd (pid: 3378, threadinfo ffff880025f82000, task 
ffff880025f80840)
Stack:
 ffff88003b986000 ffff88003b986000 ffff880025f83958 ffffffff8100bebd
 ffff880025f83988 ffffffff8100bebd ffff88003389ae40 ffff88003b986000
 0000000000000000 ffff88003b9fe440 ffff880025f839c8 ffffffff8100bebd
Call Trace:
 [<ffffffff8100bebd>] return_to_handler+0x0/0x33
 [<ffffffff812557ea>] tty_chars_in_buffer+0x1a/0x20
 [<ffffffff8100bebd>] return_to_handler+0x0/0x33
 [<ffffffff81252a20>] n_tty_poll+0x170/0x1a0
 [<ffffffff8100bebd>] return_to_handler+0x0/0x33
 [<ffffffff8124e3ea>] tty_poll+0x8a/0xa0
 [<ffffffff8100bebd>] return_to_handler+0x0/0x33
 [<ffffffff811126aa>] do_select+0x3ba/0x6d0
 [<ffffffff811122f0>] ? do_select+0x0/0x6d0
 [<ffffffff81113070>] ? __pollwait+0x0/0x100
 [<ffffffff81113170>] ? pollwake+0x0/0x50
 [<ffffffff81113170>] ? pollwake+0x0/0x50
 [<ffffffff81113170>] ? pollwake+0x0/0x50
 [<ffffffff81113170>] ? pollwake+0x0/0x50
 [<ffffffff81113170>] ? pollwake+0x0/0x50
 [<ffffffff81113170>] ? pollwake+0x0/0x50
 [<ffffffff81113170>] ? pollwake+0x0/0x50
 [<ffffffff810a8615>] ? ring_buffer_lock_reserve+0x105/0x1e0
 [<ffffffff810aca30>] ? trace_buffer_lock_reserve+0x50/0x70
 [<ffffffff810ad588>] ? trace_nowake_buffer_unlock_commit+0x58/0x70
 [<ffffffff81077e4e>] ? put_lock_stats+0xe/0x30
 [<ffffffff81077f22>] ? lock_release_holdtime+0xb2/0x160
 [<ffffffff81112bfa>] core_sys_select+0x23a/0x390
 [<ffffffff81112a0d>] ? core_sys_select+0x4d/0x390
 [<ffffffff81077e4e>] ? put_lock_stats+0xe/0x30
 [<ffffffff81067ef0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff813bd642>] ? _spin_unlock_irqrestore+0x42/0x80
 [<ffffffff81112fa7>] sys_select+0x47/0x110
 [<ffffffff813bcfb7>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8100c0db>] system_call_fastpath+0x16/0x1b
Code: 1f 84 00 00 00 00 00 55 48 89 e5 53 48 83 ec 08 e8 32 2c db ff 48 89 
fb 48 8b bf 20 02 00 00 48 85 ff 74 3b 48 8b 87 b8 00 00 00 <48> 8b 00 48 
8b 40 30 48 85 c0 74 28 ff d0 48 8b 53 08 66 83 ba 


I don't know enough about the tty layer to debug it, but looking at the 
asm, I found I hit a bug NULL pointer here:

static int pty_chars_in_buffer(struct tty_struct *tty)
{
        struct tty_struct *to = tty->link;
        int count;

        /* We should get the line discipline lock for "tty->link" */
        if (!to || !to->ldisc->ops->chars_in_buffer)
                return 0;


The to->ldisc is NULL.

I can trigger other weird crashes too that all seem to happen when ldisc 
is being modified.

Here's what I did to get some good output:

# echo 1 > /proc/sys/kernel/ftrace_dump_on_oops
# echo no_context:traceoff no_context '*tty*' '*pty*' '*ldisc*' > /debug/tracing/set_ftrace_filter

The 'no_context:traceoff' will stop tracing when we hit the no_context 
function in the fault handler. This prevents us from losing too much data 
from the trace.

# echo function > /debug/tracing/current_tracer
# echo 1 > /debug/tracing/events/enable

Then I just ssh to the box, and exit over and over, and usually in about 2 
to 5 tries it crashes. If you have the box hooked up to a serial port, 
you'll see the trace up to the crash.

If you want to add more functions to trace (tracing all fuctions seems to 
be too much and does not trigger the race) just append to the file:

# echo new_func >> /debug/tracing/set_ftrace_filter

also, adding ftrace_dump_on_opps to the command line sets it 
automatically.

You can scatter trace_printk()'s in the code if you want more info too.

Here's a trace dump I got:

   udevd-3583    3...1 8218205us : lock_acquire: read &namespace_sem
    sshd-3579    0d..2 8218205us : lock_release: tty_ldisc_lock
    sshd-3584    2...1 8218205us : tty_ldisc_try_get <-tty_ldisc_get
   udevd-3583    3d..2 8218206us : lock_acquire: &sem->wait_lock
   udevd-3583    3d..2 8218206us : lock_acquired: &sem->wait_lock (0.000 us)
    sshd-3584    2...2 8218206us : kmalloc: call_site=ffffffff81256f90 ptr=ffff880028082b60 bytes_req=16 bytes_alloc=32 gfp_flags=GFP_KERNEL
    sshd-3579    0.... 8218207us : n_tty_poll <-tty_poll
   udevd-3583    3d..2 8218207us : lock_release: &sem->wait_lock
    sshd-3584    2d..3 8218207us : lock_acquire: tty_ldisc_lock
    sshd-3579    0.... 8218208us : tty_hung_up_p <-n_tty_poll
   udevd-3583    3d..1 8218208us : lock_acquired: &namespace_sem (0.000 us)
    sshd-3579    0.... 8218209us : tty_chars_in_buffer <-n_tty_poll
    sshd-3584    2d..3 8218209us : lock_acquired: tty_ldisc_lock (0.000 us)
   udevd-3583    3...1 8218209us : lock_release: &namespace_sem
   udevd-3583    3d..2 8218209us : lock_acquire: &sem->wait_lock
    sshd-3579    0.... 8218209us : pty_chars_in_buffer <-tty_chars_in_buffer
    sshd-3584    2d..3 8218210us : lock_release: tty_ldisc_lock
   udevd-3583    3d..2 8218211us : lock_acquired: &sem->wait_lock (0.000 us)
   udevd-3583    3d..2 8218211us : lock_release: &sem->wait_lock
    sshd-3584    2...1 8218211us : tty_set_termios_ldisc <-tty_ldisc_reinit
   udevd-3583    3d..1 8218212us : lock_release: &p->lock
    sshd-3579    0...3 8218212us : lock_acquire: read rcu_read_lock
    sshd-3584    2...3 8218212us : lock_acquire: &tty->termios_mutex
    sshd-3579    0...3 8218213us : lock_release: rcu_read_lock
    sshd-3584    2d..3 8218214us : lock_acquired: &tty->termios_mutex (0.000 us)
   udevd-3583    3...2 8218214us : lock_acquire: &newf->file_lock
    sshd-3579    0d..2 8218214us : lock_acquire: &sem->wait_lock
   udevd-3583    3d..2 8218215us : lock_acquired: &newf->file_lock (0.000 us)
   udevd-3583    3...2 8218215us : lock_release: &newf->file_lock
    sshd-3584    2d..2 8218215us : lock_release: &tty->termios_mutex
    sshd-3579    0d..2 8218216us : lock_acquired: &sem->wait_lock (0.000 us)
    sshd-3579    0d..2 8218217us : lock_release: &sem->wait_lock
    sshd-3584    2...1 8218217us : tty_ldisc_open <-tty_ldisc_hangup
   udevd-3583    3...1 8218217us : kfree: call_site=ffffffff8111e33d ptr=ffff88003b868000
    sshd-3579    0...1 8218218us : lock_acquire: try read &mm->mmap_sem
    sshd-3584    2...1 8218218us : n_tty_open <-tty_ldisc_open
   udevd-3583    3...1 8218218us : kfree: call_site=ffffffff8111e345 ptr=ffff88003cf7b8c0
    sshd-3584    2...1 8218220us : n_tty_open: tty=ffff88000a839000 read_buf=(null)
   udevd-3583    3...2 8218220us : lock_acquire: files_lock
    sshd-3579    0...1 8218221us : lock_release: &mm->mmap_sem
   udevd-3583    3d..2 8218221us : lock_acquired: files_lock (0.000 us)
   udevd-3583    3...2 8218222us : lock_release: files_lock
    sshd-3579    0d..2 8218222us : lock_acquire: &sem->wait_lock
    sshd-3584    2...2 8218222us : kmalloc: call_site=ffffffff8125566f ptr=ffff88000a83d000 bytes_req=4096 bytes_alloc=4096 gfp_flags=GFP_KERNEL|GFP_ZERO
    sshd-3579    0d..2 8218223us : lock_acquired: &sem->wait_lock (0.000 us)
    sshd-3584    2...1 8218224us : n_tty_open: tty=ffff88000a839000 read_buf=ffff88000a83d000
   udevd-3583    3...2 8218224us : lock_acquire: dcache_lock
    sshd-3579    0d..2 8218224us : lock_release: &sem->wait_lock
   udevd-3583    3d..2 8218225us : lock_acquired: dcache_lock (0.000 us)
   udevd-3583    3...3 8218225us : lock_acquire: &dentry->d_lock
   udevd-3583    3d..3 8218226us : lock_acquired: &dentry->d_lock (0.000 us)
    sshd-3579    0.... 8218226us : no_context <-__bad_area_nosemaphore

The cryptic '3d..2' is CPU 3, 'd' means interrupts are disabled, 'N' would 
mean need resched set (but it is not because it is a '.') and the last is 
the preempt count, although the event markers may disable preemption and 
report an incorrect preempt count.

-- Steve
--8323328-152093887-1245130225=:26673
Content-Type: APPLICATION/OCTET-STREAM; NAME=config.gz
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.00.0906160130250.26673@gandalf.stny.rr.com>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=config.gz

H4sICOMoN0oAA2NvbmZpZwCUXN1z27iuf9+/wtO9M/eeh90kTuq2O5MHmqJs
riVRJSXH7osmTdw2c5K4J3H2tP/9BagPkzKouA+7jQnwGwR+AEH9/tvvI/ay
2z5c7+5uru/vf46+bh43T9e7ze3o4frfm9HN9vHL3de/Rrfbx//djTa3dzuo
kdw9vvwY/Xvz9Li5H/2zeXq+2z7+NRr/Ofnz/BTI6fZx9PfL4+js7ejs3V9n
Z3+dfRiNT08//Pb7b1xlsZxVk4upLC5/Am9TsHo/qc7Ho7vn0eN2N3re7H5z
CJMLYN3/3v9QZZGXRRUrnbLi8s3m/svk4o8f7yd/TC7etDxM83kVibj+efnm
+unm2wnwnNQze8a/oYfqdvOlLulqzkQmtORVIVOx77Mt5akyVZlHrHCIPFF8
YVSpuaiuWMHnkZoRVZFLLEVWmEFiNdWKRZyZYs+G1EjklSnzXGmHYArGF4Vm
0PMBbc6WokpgpBlfF4qoHEMfMKN8xee2C5bsaWla7n98UpmoopQdjlsaFiCo
lOWHxdOSWBkorLSAkUoYcK5kVghNrNH8SsjZ3Bm/3eSUreuZ5ryKI76n6isj
0q6yyWWGq+iKX82Bs2dRVLFkprQs5ikhj7anOTMVz8tKRgnusyyIbWSJnGpY
cpC9hK0PGVCqqqVZG+BMejNp28elWBE0EGdWJoXtn6rK+Bz2W8JWGflJ9OTA
iKLMq1xo2wXTgvUYonXGUhjhAAsUp8wsKhVbDm+D62HIqdAZ7KPKYB+NkdOD
kZrS5CKLCHIrZOfjXpVc5SWKsakyFYlet2UkC8t20I8VdlOpHNYc1iOqQABk
JrNZiDMSKIg5mwnYG8UJAWQ6kvojJZoNBUZYVZGq4G/iSOiPVa7VlFAruCQw
Mr9eacRefNO8mosk9w5GrSWR5pe5ZwR/g35Ic4WS4Ur/wsoiCiLThMh3yhNE
ClTRm5P7u88nD9vbl/vN88n/lCAsAiVVMCNO/mx1KOj630cza0vusbGX73vt
L1YweugyK1w9g2eyWoDUCKcQtqmoRLaEDcLuUzhq52OnBkuWsBAgZZdv3uwn
5BJAMApFzMrKcd1dNfsk856EN5QpUMY0Kfnkaju/pf3SOs24g+gzYGPEIM2V
K+KgLJYy5wcF+C8vnFWDIyVXVfqxFKWgSw+qTE2EIsmFMRXj3DPOfVq1PCfG
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
pup6Fsao/ohIqbGUBg54YBHLeWkKBbtoIvKmyA4zgQOMd5PVWjB9edpr4UAA
fDJGS02iQjAFBKKHoOthgclkINMHmzE1sF5WaGGOo/hp85+XzePNz9HzzfX9
3eNX534KXQUtnLhDW1IVjdHbH6CWEp5Lx4J3cMMcrbGYqaWNLmP6TBa4qKIr
oawZsEhUFJmqgHcs9r4mMKk9pwKrDKMJXCtRNYCGdsrmjAyNpzdbciRHT+71
SR0/maFJtIKEcjT63kXSbp/u/vFijCiptVwCrydUVoZxShmY8cX7PhoGVSYi
U4jasdQyU+RgbSsXdVQNQObBEJ+/XT9tbh1tHOgkkdQtQZtL4x8Fm12Di5MA
mNnHE9PNw/bp5+i7NQnP1//AofI6lO/A6NrKB6Ocvjy3Qxz9H5z70WZ38+e/
HNvBHf2MeqHG+35ZmtY/epwqBXXguQQAC2k0Af6Vruy9AmWWuBSYhVJDxb1l
aRQn9oUsgZqsF1TEIpMHE5m6jJfU9GZ+UJCIGePrXuMD+siq1aKktnteNPFW
j1mqJcHbpJWhE+wgofdVNnWHx5mO/PZSLlnY9Fuy24Blx5uIiktzQJDKu0HF
3urtqcEJ/+Pm+ul29Pnp7varG9ReY6hmX83+rNS4X6IlV/N+YSH7JQIAVFG6
lwINpzIAO7yb4TyavBt/oGXv/fj0AxWwqxcRIxtoQNwwhCN6IYmM2YI2Hy6T
xWuvMXE8loTIOCxmnvPWxoofm5uX3fXn+83oyx3+D+9Rd8+jk5F4eLm/7mFD
vABLC7w1PoCsHmmvoxU4IwiwO4uDN85zwUAf0Vcu9V2fKik40fSRSjfMKNn5
uInHYRqTGwZBSqCp7uLJnwWGg8rJRY3ZU9/tbnKF+jUz0d1fZZvdf7dP/waF
SsBqgFjC1YT2d5V6OXhlJldeUAQ4FoKKgcnMbUyCzwqLK/1UV7ytjpZoq6PK
RrtcrGUWSI/lFDMe596y1cVgyygl6Vfq9Z+DwbHYy3i0OtRWc7BiTtCWQk+V
Eb1h5Bntc+KyyFwOEWc6MPjUdugNIZepSavlGVU49vC0zqmbVrPOQCrUQvoR
Ldyiis0DFgyDyIaegaynEHS5LX0V6xTVWSboqJRleo1uG8GYF16sZwZN2VHM
Rzc7FWKgxUTTYMkSI8ko01PwHMHerBPt/a51pKkf7+3KeQkUsseO5UqY4kop
GnF2XHP46xUO8zrLGvyuYZYlYAZaTXYsNuu0F4E45EpeGQu4uPRWdBzgGdKi
3HHIJAH0K6nweav8exvT3Z0H96XlCC54yxBeqZZjcGdbJt1bhx65nevlm893
N29cuUujt8aFtDJfTvZ+P/7CRKxljQDd0loxY5Q3pihVk3LiqEUg1WlrpsCs
FUbPCM/QZEj9TAb1z2RQAeEYUpnTl7N19WP00+R1hl/RUJPjVdTkWB3lMtoN
aTIGD0JU/uIYGWgSiUNjsyvrm9IBRjsi6qZOFKAU3GsOKMErWwzlYqqYR4hl
0sul6AqDHsCew9HDtRe5fdogEgI4uQMHk9t89pcnCyVdN3PfAo5WZovKJlaH
bHqPN1HkqDDRL8swS8ydIpQWbQI1wVn1VsQlHa6XS+3eIO1HavvCYLiqIh5Q
Wi6T4cXrTGWElyuBtXEHxDBaQhsVjy8e6LRjmp+Pz1/nkpq/shO4afbGJMPQ
Ht1Knh8zIsMC18Y+VwgZukzF0BIUrZwNSv6qgboPlKCuwFowPQMgU+fRx+tX
JNupAINEofulCo2gHl0nCWSeU7y/1HAW987mK9zHnPo9P74I66V3DfL/6rKA
LU9NMGF9z57i40TY2tJAwdHsKk17yaXD7Flm83V+pYJ94/MrFY5bnj2/PT7H
VgirQILXHM8bgi4EK3qqv7Qodb7M0dy0ISc4ZQ4IZnaEqNfsichmBQ3fKO5f
mWHKaLRNsh4vHTVuCSE0ooK6yo5f6HxRFOv86OX7WKoiYAgPmY/WKg27YAmd
V0ky81848304MMBZ4MvpkO3Z81g34eju8QbjCO1dc/+assRbwGN5y3M6xVLm
1dLrsM4bz/8aQJx7uw5unGYWO1/sfTMfzIRJ9i64C/65IwK2AyPmUWV+iBRq
Sj1bzDUJyrbHGHDnHBbBQ27JnqcoqCyCmqNxBh780tb6CsxHO5xGiykCht9j
KoPwIK6ywM1rO/hsFgh0eD30ptdj0uxqgAp4oey/WOixMJ0fOmaNHP4zGZLE
AIAGVy7Q3WRYtiZh4ZocITQOjyjlhM4F99jw+LzOBS5yyGl1uAKG0+PBpakv
C17nTY+YZih4UPM04jM8MFrUfZ7DMzR55RBNXpXvybDsTo4R3iAak3nYDwWT
TpsPVtA2cKplFIY5APNos7xMWFa9Px2ffQxE6HgmqJucJPFiivAzZDrohH9W
sISGOKvxW7I8YTn9hk/Av4FY0hVMrg71keR83q/prFj7fNhqkI8vm5fN3ePX
k+alVJ0S462wQaQ+pZexpc8LegodPQ48WGgZci3piHHLYNHg8CB02Ae1dBMP
1y/ExyD6rhmm8SB99toIIjMEgC0L/CuCYLBuRAdBrqUD4tLCHJoTfn/9/Hz3
5e6mj2RsUMH0LwqhCJ8fhsGe5Si4zCJBH4WWxwoqbQ5alphWRC05hN+6Hswy
fHvXMtBWsRtBoq4CB0ZYbe/FOJuyOlcVP4HhtdcQeSDe7bBYh/w1pqHZNyyp
CHsnLU8hViGVgAvA/A9C2NtGjBiqRAZy0VqWGeNBh8QypFIPnQxkAdgxSA9B
uW6YIgo7rJbDyIHtsAyLab+R3smKpX95EvHpwSlrLu1Hu83zjlCm4HbOBA2p
szpeZF8rh82dxie1KpPB1GiWahYFlClnATSvI+q1xLTYg44pgJQxZ7kLNKa4
LNQFFxB0jOEpr35dBHjaS1sCwjQTlJcKlLmM8ja3ZHr/stltt7tvo9vNP3c3
Gyfrzm1szuW0KA1tj2p6yQLIranO0/HpOa3TGo6cnZ0OMsTDI4iKhH5N2E7g
nFa7DTkpBWYHDbbwyiSXc05n/zDAhSudU1F4zNTQpZeOcSXxU0PGsx48niHw
oifYVqhUEuG7Aky0UeS7rI4T9NZhh1hap1p7cE1Ow12njA+NK2X0jup4IZMw
MPiQH+iAqJbPqJPP/deX7m6a4pHqp/SU9fcj6nhhZTNb3pw8f757PPm23X2/
f9l/CQ+sThaxRLnJZ7muq8dSp1dMi/4r6/jK5tO5STsdq8wOPvRUfwuk5fC+
5lR/jSvSchlAnw2DWOpArBm2rZqvYZZLaRT1iSv0ZttnaN382tx5/8sHBX0K
cnCre6HDlpK5zwuyvBluCjLVPCJrn8nvtjfbezfnKsv9JwPNhwkOCqo48tRk
gi+YPlaBm7SWzCVI9QAPNhwx/mFCv25pWco0gB9bBq6u7NVB4MK5ZUt6nxo4
YMimAQXU0M2KfsbdDZTKRW2JmqWHywqF9edVLs8mFM1+Xe9scv7+4rC3VeAW
j4NFTdEs82hJz4dhlugSn0wF4udtF3PyuxnScKTK3seR5DTFj78E3DeWFYqm
mRmm5nIaThcyTm2SJG3luflwPjYXp7QGFBlPlCk1fpJQ2/HSACOvZBJItDLJ
+MPpKX3Ly8f9A1lnjAo42eno+eX79+3TzrXlNQWWf0xPtqHXidBDHB/O+YoG
/3z67uz0YME6JIUfnInc5D77o1YP95vr5w2wg5rf3rzgIyjrVp3c3W7wvz93
P3aY/Tr6trn/fnL3+GU72j6OoIEatbifI4lEtYpBvDApxOsLQ9zgzBm/EMQx
9xJ/u8+jANGwggJySJpFfjuzCJvyRLIrDSQGOz1xWjg6PSWShaTeXLlNRA46
dIvb9M1KaK38jxA5fDBKWswdnn6Ks7u2NmXVTyTHcmtn4s4M4I7dfLv7DrVb
GT35/PL1y92P/h42X1igRtt+nmRYLafR5IJ6nejMx7NdTjlm5Js43mfAS3fg
z87pItp0H1nUvzGte1oCRNORn8jTVlNxPFU9ANpjGVgOzHmajAP4t1Xnn/B9
4/Bq4Ky90bc0JvhkvFoRhESevV2dE4Q0endB1iikXBGLbndrRc2u0DJOAhGR
rrZ5+3Y8bMaR5XxoAeZ5cT6ZUCP42z7MH7buhp+NB9c3l5Kcnvx/xq6suXFb
Wf8VPSZVSUWkZIm6t/IAgZSEMbchSC3zwnJszRlXvEzZnkrm359ugBQJEg2d
h1mErwmCWBrdQC9l4C3t5xE9Et+zhaQ0CKy1pzJYzr0bV7tC7k9hcOusL92O
0DQ6jFG5P9xKS7EA2X8b2QAYBG9ma6iM+WoaLezbSjcVEtgPHR+zFyzw+fFo
n0g8WPCpuVlbF0G77CWXotWNLftpwQQy97KwxoGEZzt2jL+a6NGd4IFl5dau
UyqQNnJS8ICzqtY2zdShqH55eHz/+7fJx933828THv4Oe/evY5YlDdma7wpd
SvhYNnAmCYJLrVY1pK18a30l31Gfqg6r67jqeeaqcq68eYxIe6o8zrZbHZTP
7FHJWQpS4im1aeOKAqNdK7L2lER1a/l29/KOHWscjugq0d14OAlMkg2/RiHU
31eIJJOoj0vCkFrTFLlzSmKwgxi0PsMPWb+dMuHWHX3crmeakCZap0ffQdNO
jdmhhhV6VOuHrgyoVkBFEzDyxEbDjLtfwARful+gCZAxuolWV2pZzV0Eyd45
omFe1sK36wf6BWjgK0+OKljBE+t6TEDUV1wMuDvIF8Y5QAtREcpa3KEuXGic
H5jkpe8k2GEQD8fcBMkK1ruwH/DBgtk4ECL6mROoNynxsobNH2feynPMmYgR
lwuaW1Ql6oza4ZYm24aE9qwZSu7iNhiMxDGjAGdUOBDNZUpCHtPoKbmZ8QBW
jl2saRpoP+tS4Gc1nrXnB45GfI5ZTQztBb/CsOLcVUHIZ6ubf9341LF9077D
Lat2tKxh042HruMljkmQyVCPNSutp4Korvb2YTyX0e6xaWjXRZDCPLFD/bjO
EyNMkSpj1HG4QqWIzUOI3gu03jWg39vuEtW7Uax+HpAne/rVqR0DQRc4aUL0
ND74WVJXRLoTQLoS0s419Dcc7ccubYe4QGIxI1jFjn7eU1NHg2UkXS2GucM9
UPyIA+FmMjhQomkaTKiDZgSLkuD4GlZKJI1r1b/OiSnY0Tg+zaFSXvCZCz/l
Q6sBkyDaWLNRINTq+s+DR7SKSleJ+NLxTYgfffum0hHYjxsVrhXNK7jjeZcm
rQhcyr4iSFgBbNG+WDQBcgQaBmHOTQBKF3e+IBXpJ0ZYEGgCpXM7poZFKR80
EiQeN0pxKkXg2DM0DryOEmoVAV54UxKlJhidJpn4+DRkgGPgtUIFKXU205/6
rvkMXHNBiAi5i3HmLt6owINI1xkR2Kb5QpuymliOUPplSajStYRRGZnWIQBg
BDEioAqgKEfbv7QBiSvaBnQ+Or8hwviGXVAAikA53toDiDcn10mfjYWWeGV9
kBen3HbJCJBMWa7CZz/3CtESJiuMoi9RkQ1e6f4K1aaY2XUYAPU9sl0dqOTA
z1QfckdRNPFmq/nkl83j2/kAf37tnSDpe5oXFdXj9eXpJ/wF//k6+fh2nnz8
8zp5/7i7//v9t8mPl6fz+/vk5+uPyd8vr/9M/vl296F+3b2dJw+vA2uYjSgi
vMy3NhRbpBpkBQn1MmFcpBh+pbmcth0qALvsLuOasiZYhzKvUcfT5kXdxm7I
EVZJYh8DXImU2wO0ES1TrVj0uQIR5Atxq15W9qf21LWkslpak4wPtGzKujTf
neyBoZQ1GUaGSyOTHRDxrXcsz09JREQ6lVW6Je6qOfo4pra7G2wCzO8wK+oZ
DFy/FfusoBS98pTvMmIjhw/KiHABtBFtCXKsoUWEke9NCQFNEdvfEM2P9o21
4eh1MLcPX5isvKl9V4e33fgLYh/SEZSOouDEBfMup3RpvLLGIMURTOL6CzXm
BlWx/Z/ISsqpoE+EfxEMoU+WZsqWs+ZlQVje96kx4jGPi1og6yBD9Y0fUfYT
eEFJzI9BcKYc1xohhIFmEXieR5oXsJDlsP+qwKEbimGu5/auUVk9QqrqiBrq
DazZlLDqZaWMEvugppF/S6oxATB04swWoTKzc/ViMSWWAIhLK6L9UQ6qIHUk
lEi+mhO6EvCkkAy+WFKcG2SzutgJwpscXudPZ3aBh5WxLfqX3qbaqLQdNY+o
s7ww9m03L5Gq4tkc8inlFUJuFmJr3wShfE/YxMtgFhCdvGMqKYwVO4Eykx02
xFFiEXgLeyA1mAzeihjTW8J/RN6e7EsSx3OP4Xgp75dSbLPUrjjirYIV+Byz
GXWAzyh7UATsjUfEPhU+JUQQj3ZKGXOK76IYpMK6tF00XsAZZoKDbVdaH7X3
BDlXxXFLmDgjYh8qnzgB3h+JwU1OhfCmtOfQMUprqoGpsOcbTOLjvCbMtxVG
2l6V0a4ilGScMPZZ8TmmJi5xDryOfLvIUpoB/ddJZt8bZ3x2Y19fZSJnwbQ0
9jslzqO2oOR+YI59+f6ADlh5ETlMblsXLW9UaaNtHB7RKPeXcSC8XycfoHec
z0oH0VQPprUt2l+3tvjs4e77x8BSHHCQMkt7PyJ4yw7UtolwjhGiKiqF4bou
yjjwiEDkiMMfWrq8BMQcym0zfhPYx6cjWNolgYZgk+w/eYFTOMxpxUATpAmn
dsKGQiZ85fEVcerUyaA+ce/TkLDjlZbATC7t6tKB2czPNmEoTKl9Q9113m7s
sspO5NQhck7ckAyk/95AbwwDKTzLy1KZEV6bAGNKRFLZQ1AFwi7gP5SPqwyJ
gdsNcqjok4GX7z8+xjYlbWVpXvUDRKYq+/sGg8YPfQI0hi2ETWj0mur9/PaE
MeQfMdni17t7w7hOPZpklYy0sfWg0hapc8mqo6WjB2SSFxHw/uOfoD/N3TSn
P5eLYPi+T9lp8A0GHO2trYz2g2OkXv+O/AWMJ2+jkzK26zq6LQEZ4HZtBNq9
ICDH3hL22Rea+PYqybG8SgJ6UUlo1l1ryuzADsweefTS8b1zR/wJ4+lbimoW
59JWjpew8G+e20B5SkGLEtz+pNhEayMLZIcpp3qVH8448LjgEXBC0M6IA8eu
mqziu1vCRU2TyagQxEmJJmB5HkeqIgfRmic3K2IL0BR7CVIos5oJt/NbNpku
OpGyKatZyqiACx0NkUetIwjtDPRCwLN1YT/tvpBsN77dkbajKIhDF4OiJrwC
O6JKADdNMvvQXchUZjTKEfJCJUUYHdBj1s6dL3RlEhKy/eV9SrN30xxYUQji
EvhChKaPMbWddw3HwPpZYRfOTao1I/aojqwU6fZqFxxECD/cRF92UbqrrkwV
ZNjVtWE+5mTkS1wUKiiGTVxrYFyVetMwQsV2xTDpl8FyVQufCBk7Ir1Ktqk+
iVISmdF7dNsq/UJoJT2qiHDq6NMcGM+S+hBMCReSPm1Cc6o+mUijI6HaGbXd
Lj27NNmnAg01Qf+gq4Tq/4XY7v5H0gNxHmF0TrJaEsJkn0wpHlmSZ5IKwTh6
uyipW2qDVHJ/Ol2Sc3QQ51wLZCo9txE8RJWznNHxThVBGTNZr0sqv3tDJDCv
QkZ855CICLTRCkHAXNLr1ancGglz0pwiNjRUHlDwxJsSAfsVXql/RuLc7u7t
4R+87RJ/ZJPW/rbVAmB772V7Vj9rEUzn/rAQ/kZXKcOqSAG8DHy+JC5HNUnO
UQayzAENx2JtSFW6tGCH/hTYsiSy+mrxb3dvd/cYikhrBL2v2xvB75UOo0Ps
6jj6/UTpZUvQle0O4zKg64oxVn9opC0HIfvWSHKnxae+RZhxVAUrriqpNJEF
5nEryVhz/AT6bkj4w4ViK6Kc2/egJDsynb8xJpicosCwIJSJo6AsAk8pJ2dx
CxK7XgvXhDl/Wu/C2L5PFZieMLF7dso8AqU8JsxVJOFeTZl2liwOC7v1W5p9
ycwrCG37fn57vHsaZ+Nppkbg30xH8wULx5NvI451xIr4BL9r2zRTjxnORwaQ
5sPVe3mV1dS9R5AWNbruS4wqYoEL2N5EEjU0cxuJJZliD01YeqpVlhk7Lnes
GCTg7sPaFoTGC3nxR0lfX37HMvhSNS7K02N0iNA8jCenoxpVvo9ucIYd+kna
Mulg1otVUOflyUz/E+1zzKzTRsMWik9QXq7aTFxVYl+VeSLqHfCZwUFLx9CA
+YXm/fSlUGcwExnlqd0RKtZxhWZgmTjC9/3UOune8KzWCYe7tThbEXHbUPcU
gyvjxtdQGW/dW7aGMbshvEbRMwKmZT2nrp86AuIqUORtXAg7kz0M8of1zhGD
5Wzxb73NCTYEe6Mr1gGmb7YDLN3q7J5qsO3SG4c/uX0OwLir7F6WocWZrOWD
9uv9Xv5A+FGrU5dRqH8AOCxu4vAK0Cb0BJp8GZXXLN5mmN+08TFCHeYi6mAS
r4GtUM4nMsHyb6/vH5P715ePt9enp/ObLWKLrl54NzO7HcQFX9gl4AtO2IEq
PAmXhM1YA+MFPNEpIKJ5hoCMZZLQbBBEe03KcInXqdLbCVEXcOVzuKL7AvAF
YcfbwCvC9ANhyoiwwXIzg8plsN9/vn+cnyd/wZA2Qzj55RnG9unn5Pz81/nh
4fww+aOh+h24Pjoe/zoc5Qy5OcFNVcsT2FlGr4/+BabyArsH0PyhZ9Wdvs6h
ZlMT+gNkXUq9Q6qSZbKO9vbFpwgE7JODKD46jsvb3fdvj/ddO7BlYciRB768
nJ+odu2zLMyy2ai+7ONbU4n+vF4vjz6NM7czuerIQZY3naXv8f3+/PR093J+
hepxTDmMkc1NNJTeIiA8YSLYiQsJzdgE9DUTYvb52z3PVjcz4h6/oUnYcRFc
qaeUsX9D3LFhT+jILnQ8jAsJ8rcrJGvirq/3nh1x3iitQQhUwr8DS0tlIJ2l
IM/gJgQaWp9pN0XWeg82lqX0X5VIMDazA/bKXWkCQ6ZJrWiTlhbmiL+kwtA0
JOvP/vJfKkfzIbEm5O1yzrZfiIHrwsxwjG3LQAk4sFNm0cIPdx/33x5e/zO+
V+mGJNuUl5rsAg//XIFIUR9COw9Rbox48E9TxCLBbc1JANq8RxJIfuNPSTSq
VI5sugFivZzSj4t1wiR1d4rxSMgHYf+ZRnI9JGjhkmcI9SQSLGlsNpsMl4Zc
UgZLz9/Q7wOcBHe5exi1ZT/5OIp/c29G4ovp8UgPz5oHswVdOc8revDRCg2t
8mee53gDEM2W66WjAw7QBH+5o7sPCVbXCYCBOQiC5dJZwcqFo7HXF1cv1lF+
rPnMOpJtQJPf/7p7BynjsrY5yJ/GksaTL+6cC9CCgW1iaylytXKgsVfefgRa
hGRSCp0oWp9GvL6glCAfnx5BBJ6s7+7//o4bsMGHLPJF8uPp4/Hrj5d7tHRx
xDpMNiG9tyEokxvinH5XopgkBbfLzPhwmVAHVgAekmBO8PYGnt1MyasOJAEx
4Wa6mNnffwkLaO+b5/PD411Pzxwi95gyyiLZ7EUYZfVA/enknv2a7k79aBKF
pvw8atPw5Clkxm6OZ/9Q5JQqRwckbNvPSL/NUV9ZzM0idU5gFsl+4lwsMM4B
wsL0c8HsauHGrjggWHh+YJn3CmLQN+mwNhEQ59QaJFQYBa4IXzMEk61dgUGM
cp9CjFJ81HNszwhDu/2WqcQYjkkBEoi6MciU3Y2ljzbGFLgEXYS5ZL9w3MAc
Ca3hN9eg2Gfo/iBZbyPtUA5/NiKOzSTZDcCz/ATvZSNABb9Zx8LYlBusUJGA
jlEsMUgkGawYKDGmY/tuF03bDBfNpUUUEeg/kdimNcgUgri5bpuUERZmiMPo
UrI1wLBtYUg28vE147cjHbP3OOb40ycq0ujzUsTq40p9n6FW/+bt7vkMmt/X
r6AKfmuPVixMH8dFFAWhjACaJ3bdDR88raPCp87YgIAVdoaNkBQxdDU5IiKR
JQlCP3v24xcAK5zO9i5EZDAp0zlhTArYjuANONRe6JHG11gtrGWCQ+AqEHsS
i6NgerO034dgv5AHuGqGAcsg26T5Kjkg5WnAkgco2RX2PRcRmg8iSnBXHCe6
69Iog8UsyHl1eyKS9gI2ozYkfKU6TCGnwr4MFkS2wY3KRR2SLpK4DOyXamp1
kZVyViSUBwjA2wj4Ad2BRVkRtl84TyKYJ2lG5DtCgnWAAe9ITlVkLJS7yGrA
cmFjdcxDm36GxSrpYBPG1FlHn7DnW3zBbWEBL2BeZFvKp7ijSta5a712hJLt
WDGW18LHd5DDfzoipYVC5jE7tZ0xqoG/vry/PgF/bmvSEZ1HkhvwPcu99pbB
//QJhORoqrs20ovacR3bdnG571Pep5Z7y4Il0braoP7Ox/dmFri90MsL2HWt
cbhtDxVZqe71jcpBArJdbmJ5Hfwb9FqpS7xFVxRnW+OyAn+ji3l1xGj3dhbR
oxntMGMSHlel7/fkZplVaS8EqfqJgeKGV5EGEZCo+xyzKOeJWVCwQwIz1CyU
0ecqSvnwYSjWw2kWQ0uipIqNhtQJyGIFQqP3k4V1Hldb0bfAMNqinutfrQK4
K+g7K/V1JR8R9ODwlLJEcGhsOgjfqt6sF5WK/86sJ6NI1YaAxaCBm1EdHQr7
K2EBgQ0hsg2rKhImy3409N6wYe8YQXpwOPJ4huYziJEvBKL5VSK5ZofISQHj
7k1vvSFNj4Lx1RLmaRhxc8wbx/dhf6GZF91LQ0f2fi+BtqLnsfFIUuaMiFmk
5pa6na+8BXU4r+rIq7k1uOXl+5oja7Y3V+MQbNOp/zk1Z78Y9gILvYDwnlFw
LGeUy6iGyftpjYub+Y1dIlE4HQSog5XWQAT+RqIqoNTqFqb8WhuY0LsVfCBu
fRD7Us5mhLiJ+LoMiMAniHI29aZ2BUDBiaB8htWiOp6olCnqaTn3A7rbAV5Q
Lj4KJsMiKbg8buiWhayImaPDge26YBAxnI/r6okoXG31NKyrp3HYV4loW2qj
obGI77IZcdyeYgi3UBDXaR1MGX1dCMJPV2ugR7WtgqZoWOw13FFBKr3Zkh48
jTteIL3VjF5QCC9oeJMExNGu2r9D5lA8NYVjQ0CQ5kE7sREO2QDkfo8y1b7g
1mB6euCg1cFxOtxw2nK6WbdZsfV8x4vj42K+mFMZSXDKs0iCnmVX8Brhi8qp
g3Ca+ISRid6PjjuHRCUwSBbh7It4EhHRIxp0Rb9ZoTf00zJLBd+LtaNrXAqz
FhNYQOmfPfzK7qa04EzSnGF/9H36O07JZrCN9MBKrofiAB7Gs4pKldVSVPLo
289SWgrOBKNlOV2H5/u2o+FGTB/4+upPzZVNMj2fQtV2bo++oMeVCBaqFB3U
92yqvBKu1lVPl9iJcHzaDIWGaaOwSNt9dJBq9OKi3XeA7OdCgl7Tr+i9IO8X
NBTa11Lft30/36OZKZSOL2LweTbH63KzTuVTZxatVe4Ks4zvoqI4DcsE/BoW
6jCKZiF8/TZLCyENZbwrrTcby0jgk9GX22jwhtvToL3bU9Hq4n0y2IBEui2H
5eglaXZDW1KbgUyxuKiSdRzlLPTpJqoQiXhaYb4HpAtQr4aNT4GTbAejylK0
+4gz02C/V0y/O49KFp/So1mjZAmGlhoUjoYKaEA1HgzVFl1pmDQX5KWQbomy
4P+UnZoau8XWK6efLrNcRtFgupe7opLlUE3tl+oR6z2i/LPMlYvh5czPbEuM
p3E5jRa54pBoprRjst7xkECyXd8O3oCiITS6DSWZhqonTYFZ8UgFX2rito3Y
iGnahkzldZRaTb0JH99Is6W6VB9bjtpmnGOQjZSVxMgoJJ6VtjMIRBLzAA2L
DlTewBas+ZptrKx0h8a2vDO2tZg9qecXy+N0isNJtArHTI3286i0wOvHXbWu
y8EsUWiJMfQObXphsw+Ole9Nd/nwtQaRkLnnLY5XaZYLV/OzrvlmE7B8LbbN
pSGMPJGS2EacDKwhhqR4nRdHDbXZNRXRHhkHnuf81iJgi8UNbMcuokNTPUmw
O7AhfpkyjYGcygxsu21Ua5DbJTYVBKVQbs9040L62TIZG/umWRn930T1TpkV
eBn1cP5+fnl4x+RZKjb6XyAtdJlAJs93P1sDkLun99fJX+fJy/n8cH74/wlG
h+nXtDs/fVcZuZ7RPAQzcg2/tKW0j3OMKZEqZZ3YSS/Pd//BqDQWnwe1vkMe
ECdGCsads4xurUOjnGWIIRlHCrg8ZjJD4vkoEQsidKBGfbs2oaZDWJWVXdLX
TdvLiGbohchuHD0SR9usJK1PFYVjpq9RRlMuDsQtpn4FXUEjvMG/S064G2gy
ZahK86hQBVog8U0ZChU3gu5klEqbWyi6qwXsPOs9cemtvpX+VPTN5LD3rYuh
nZX5KZkrhoCqKCIy62hujRdxRHJvJNg7Ht6ycBuNL99wO8VQMW/np7uPM4aM
+fp29/7x9uP+48ebYVyX/rexY2mKI+f9FWpP3y1hgDAc9uB+zTjTL/pBBi5d
LJmEqQ2QGob6Kv9+JdvdbbulhsMuGUt+tC3LsqxHUaqGtmEsaW11+40+bLOM
sVyLMxUtgGARKKHAmlniBf4aBAs1LqQ9YksqRHSbpPekAmuT+RmEtLy4YHKq
mYHEN0WXCSZw/9jJBb25FUIQLZZu0NHhu5rD/udP58qlaqC8v/JeJGzA1DuK
QsL8erAdNmwr6xjE7CBmwnc6qKTZDo1qHhY6ImTy/vcRI5S9nhz1dyPC2/N3
+Ee+O/7Y/0K/kIeX5x/7nyf/w+k53h9+7o6OT4wIQZqtZSBTLsqghP/nMhA5
JevEkQh7wqp2eFzgSfT69o92w3EoDHHZ1zAFzDLd4JNXSdkacpXiy4vFdlJF
LhdXlwwVaYQz7h1FgbeMWlTXveAMTw14tml5wQUFrZpQ71USGmWCuH2MK9lu
Z5k17+G88uJEG8h2+WXw86GSx2LkuS4VJZd1wkQGmUPJMGsLD4brt1CKwTkk
FTg7ncNo1jLflCLiM28ozS4w1jwt6GMijuNydhTYdPctI31sEIST5eSNwUIM
Ew47a7Kvk/3hSdneEbenOKL24WDQCYdDJryY0GnaVQEdoSUKo0BQ9hJRJl3l
ms53JoMEs3vnU0k+2f/anYy7vh/ttll09nXXFHRbTLg2LcaAJFuYnHQKquOw
rYBJEW3J0ik8wx5thrBVkUMVGwW+WuiUojHJz3RtYnhn/PDOvOHZHZ8DjFov
b9RfA+dqBj9ZTglVsyAUcMF1nKZjCQI5wBKaO3ydgMbmiK9KJFwk0fPXSwi4
5XtYJfWCg6H5BAsMmum4h8HBZUwm1ppHfoFkCkDosjVW123h5hlWBX22SB04
KxGkXZm6Xxp82GO5EwFEFzdV7KzGdZI13Q1lV6AhC68BnQDYYuVNwU2Jhp17
JJ5gTDUS39i6meXVnOT+4dG9Jya1IqjJptb5Lz9hUnLc35PtLevi6suXz84O
/1qkMrY0M3eA5Ci8okQP3vqdp4N4GhX1p0Q0n/LG69I6NACHI6YbqMvB8mYy
qdqx53X39v3l5Af1hWO+ULtg41pnqbL6tnbyOKvCEq7yqGGTcL+x7Edua7vJ
JisnP6lNuW7hKpIGNq4pUv3YFKT/cDSk0sHjFoeBNHCbcGgv4re4SHhYrLKQ
cNA1XxFAWhHMcIeYrxrMDIcHhZXIGFB93Yp6zZHWDPPLQETestwvm/n6kodd
59tzHlrNNQsLe8PBWr5aLtMpox7ulg3mHvLopgeqNsdNjb9vzlz4zZlLzqrs
3KY9KKEOZTyHLEWw+qlrWi1B08PbgTMMnSXB2nxtXpW2xZr63a1sy0UogPMc
y7pNFVzYnNYC1eWGscSus4ClPsnNfViydYpI8HuS5mn3cBVTvnvNn9/2o2aJ
QZ7wpU47D4eumlwAY8tHHGIxijoZ4eOsikyuhAMY22xEJWfbxIQWRJua0ROA
oI7UTTwVge1wpjdh3QZElbpIYRS1vtRMwRiuR8nPdrPjfTzKZsdfryT96SBw
VjCk2bptTg1oI6pMUIA4YfrCLf9lOduXPmbHH4PR4l9vxx/Lv2wImnWqw+v8
7NLZojbs8uySJmUHiYmf4CAtGRtND4lWPXlIH+ruAwNfMsEFPCRa3eUhfWTg
jLLXQ6JN6Tykj0wBkxPRQ6ItVR2kq7MPtHT1kQW+YnSLLtL5B8a0ZAKDIBLI
o8vlxVVHK3icZk4XHxk2YFGiPuKIOpTS3z/9AHjK6TH46egxeJrpMd6fCJ5a
egx+gXsMfj/1GPyqDfPx/secvv81jN8uomwKuezoV4QBTOtJENw2CU0yUTqN
SLbZHTAKz+P9w7865Vwv3FdwycTAdUkqVjXl6aTdCZRKmpZsc4wCrG6imA6l
ikPR0LoMjZi1ddOpIGDW9R69aVQTfy8+ny/HcxgzSMNBouLqjadYjgHpMUV1
UKSkskiFnnE9JNaxiOKq1j2zdTaYxc05a3V5vYYpImspPyG09EExsHU0XeiX
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
O8j8AAA=

--8323328-152093887-1245130225=:26673--
