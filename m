Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbYKGSOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbYKGSOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYKGSOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:14:03 -0500
Received: from smtp5.Stanford.EDU ([171.67.219.85]:40826 "EHLO
	smtp5.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbYKGSOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:14:00 -0500
Subject: Re: [alsa-devel] 2.6.26.[6|7]-rt11, alsa rawmidi, seq hang
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@elte.hu>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
In-Reply-To: <49140683.9040008@ladisch.de>
References: <1226019485.3135.31.camel@localhost.localdomain>
	 <49140683.9040008@ladisch.de>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 10:12:37 -0800
Message-Id: <1226081557.20569.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-07 at 10:12 +0100, Clemens Ladisch wrote:
> Fernando Lopez-Lezcano wrote:
> > I'm seeing a realtime patch related hard hang in the kernel alsa
> > subsystem (MIDI input/output). In a nutshell:
> >
> > - alsa rawmidi works (ie: "rawmidi -v -i hw:0" outputs a stream of
> > messages when pointed to a midi capable card that has an external
> > keyboard connected).
> >
> > - the alsa sequencer interface works (ie: aplaymidi connected to
> > aseqdump transfers data just fine).
> >
> > - BOTH combined do NOT work (ie: use aconnect to connect the port that
> > corresponds to the external midi interface to aseqdump: aseqdump hangs
> > forever after transferring the first message and the only way out is a
> > reboot).
> 
> Please try the snd-virmidi driver, then we'd have a test case that does
> not require MIDI hardware.
> 
> > ... including the output of a "echo t >/proc/sysrq-trigger" that
> > should show where aseqdump currently hangs (or so I think).
> 
> It hangs in tasklet_kill(), which gets called while it tries to close
> the rawmidi port.
> 
> The rawmidi framework uses this tasklet to notify the sequencer that new
> MIDI data is available.  The handler function is
> snd_rawmidi_input_event_tasklet() in sound/core/rawmidi.c; the sequencer
> callback that gets called from there is snd_midi_input_event() in
> core/seq/seq_midi.c.
> 
> You say that the first event gets delivered, so it might be possible
> that the tasklet never finishes executing.  Please check whether the
> call to snd_seq_kernel_client_dispatch() in snd_midi_input_event()
> ever returns.

I added a printk before and after the call, it looks like it gets called
and it returns (but only _once_... aseqdump hangs in an unkillable state
as before).

But the hang is different, I'll reboot and retry to see if it is
repeatable:

--------
Nov  7 10:05:36 host kernel: =======================
Nov  7 10:05:36 host kernel: aseqdump      S [f2e5c330] f78df0f0     0
5256   5185
Nov  7 10:05:36 host kernel:       f2cffbd4 00000086 f2cffb88 f78df0f0
00000003 f2e5c330 f2e5c5c4 c4847700 
Nov  7 10:05:36 host kernel:       00000001 c4847700 ef1ba352 0000002c
c4844054 00000000 fffe5e91 00000246 
Nov  7 10:05:36 host kernel:       f57fc274 00000000 00000000 00000000
ffffffff 00000000 7fffffff f2cffe98 
Nov  7 10:05:36 host kernel: Call Trace:
Nov  7 10:05:36 host kernel: [<c0643ba5>] schedule+0xbf/0xd8
Nov  7 10:05:36 host kernel: [<c0643c72>] schedule_timeout+0x17/0xbc
Nov  7 10:05:36 host kernel: [<c0496c8f>] ? __pollwait+0xad/0xb6
Nov  7 10:05:36 host kernel: [<f8971b34>] ? snd_seq_fifo_poll_wait
+0x18/0x25 [snd_seq]
Nov  7 10:05:36 host kernel: [<f896efad>] ? snd_seq_poll+0x4d/0x9f
[snd_seq]
Nov  7 10:05:36 host kernel: [<c0495d92>] do_sys_poll+0x292/0x348
Nov  7 10:05:36 host kernel: [<c0496be2>] ? __pollwait+0x0/0xb6
Nov  7 10:05:36 host kernel: [<c0425c81>] ? default_wake_function
+0x0/0x12
Nov  7 10:05:36 host kernel: [<c0645736>] ? rt_spin_lock+0x38/0x3b
Nov  7 10:05:36 host kernel: [<c04752f7>] ? page_address+0x88/0xaa
Nov  7 10:05:36 host kernel: [<c047596d>] ? kmap_high+0x421/0x42a
Nov  7 10:05:36 host kernel: [<c04ff574>] ? radix_valid_always+0x0/0xa
Nov  7 10:05:36 host kernel: [<c046430b>] ? __rcu_read_unlock+0x6d/0x72
Nov  7 10:05:36 host kernel: [<c04699ec>] ? find_get_page+0xfa/0x120
Nov  7 10:05:36 host kernel: [<c06456c1>] ? __rt_spin_lock+0x24/0x61
Nov  7 10:05:36 host kernel: [<c0645736>] ? rt_spin_lock+0x38/0x3b
Nov  7 10:05:36 host kernel: [<c0420afc>] ? __enqueue_entity+0xe3/0xeb
Nov  7 10:05:36 host kernel: [<c041f87b>] ? task_rq_lock+0x44/0x6e
Nov  7 10:05:36 host kernel: [<c0425c76>] ? try_to_wake_up+0x212/0x21d
Nov  7 10:05:36 host kernel: [<c0425c91>] ? default_wake_function
+0x10/0x12
Nov  7 10:05:36 host kernel: [<c041ddd8>] ? __wake_up_common+0x35/0x5b
Nov  7 10:05:36 host kernel: [<c0423172>] ? __wake_up+0x28/0x32
Nov  7 10:05:36 host kernel: [<c0554f2e>] ? n_tty_receive_buf
+0xfa9/0xff7
Nov  7 10:05:36 host kernel: [<c0554f2e>] ? n_tty_receive_buf
+0xfa9/0xff7
Nov  7 10:05:36 host kernel: [<c0447cef>] ? rt_mutex_up_read+0x1b7/0x25d
Nov  7 10:05:36 host kernel: [<c0448f40>] ? rt_up_read+0x8/0xa
Nov  7 10:05:36 host kernel: [<c0647c26>] ? do_page_fault+0x45f/0x7d8
Nov  7 10:05:36 host kernel: [<c0502f6c>] ? copy_to_user+0x36/0x106
Nov  7 10:05:36 host kernel: [<c0644770>] ? rt_spin_lock_slowlock
+0x1bd/0x1d8
Nov  7 10:05:36 host kernel: [<c06456c1>] ? __rt_spin_lock+0x24/0x61
Nov  7 10:05:36 host kernel: [<c0645736>] ? rt_spin_lock+0x38/0x3b
Nov  7 10:05:36 host kernel: [<f8971c46>] ? snd_seq_fifo_cell_out
+0x47/0xee [snd_seq]
Nov  7 10:05:36 host kernel: [<c0425c81>] ? default_wake_function
+0x0/0x12
Nov  7 10:05:36 host kernel: [<f896f041>] ? snd_seq_read+0x0/0x1d8
[snd_seq]
Nov  7 10:05:36 host kernel: [<f896f11e>] ? snd_seq_read+0xdd/0x1d8
[snd_seq]
Nov  7 10:05:36 host kernel: [<c04d73d3>] ? security_file_permission
+0xf/0x11
Nov  7 10:05:36 host kernel: [<c045e231>] ? audit_syscall_entry
+0xf9/0x123
Nov  7 10:05:36 host kernel: [<c049606a>] sys_poll+0x3a/0x6a
Nov  7 10:05:36 host kernel: [<c0404be6>] syscall_call+0x7/0xb
Nov  7 10:05:36 host kernel: =======================
--------

# cat /proc/5256/status
Name:	aseqdump
State:	D (disk sleep)
Tgid:	5256
Pid:	5256
PPid:	5185
TracerPid:	0
Uid:	743	743	743	743
Gid:	10	10	10	10
FDSize:	32
Groups:	10 11 30 31 400 
VmPeak:	    3104 kB
VmSize:	    3048 kB
VmLck:	       0 kB
VmHWM:	     884 kB
VmRSS:	     884 kB
VmData:	     172 kB
VmStk:	      84 kB
VmExe:	      12 kB
VmLib:	    2700 kB
VmPTE:	      20 kB
Threads:	1
SigQ:	1/32768
SigPnd:	0000000000000000
ShdPnd:	0000000000004000
SigBlk:	0000000000000000
SigIgn:	0000000000000000
SigCgt:	0000000180004002
CapInh:	0000000000000000
CapPrm:	0000000000000000
CapEff:	0000000000000000
CapBnd:	ffffffffffffffff
Cpus_allowed:	0000000f
Cpus_allowed_list:	0-3
Mems_allowed:	1
Mems_allowed_list:	0
voluntary_ctxt_switches:	66283
nonvoluntary_ctxt_switches:	4

# cat /proc/5256/wchan 
msleep

-- Fernando


