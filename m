Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbYKNANQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbYKNANQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 19:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYKNANA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 19:13:00 -0500
Received: from smtp5.Stanford.EDU ([171.67.219.85]:54491 "EHLO
	smtp5.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbYKNAM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 19:12:58 -0500
Subject: Re: [alsa-devel] 2.6.26.[6|7]-rt11, alsa rawmidi, seq hang
	(tasklet_hi_schedule?)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@elte.hu>,
       alsa-devel@alsa-project.org, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1226616962.23485.28.camel@localhost.localdomain>
References: <1226019485.3135.31.camel@localhost.localdomain>
	 <49140683.9040008@ladisch.de>
	 <1226610075.23485.20.camel@localhost.localdomain>
	 <1226616962.23485.28.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 13 Nov 2008 16:12:49 -0800
Message-Id: <1226621569.23485.44.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-13 at 14:56 -0800, Fernando Lopez-Lezcano wrote:
> On Thu, 2008-11-13 at 13:01 -0800, Fernando Lopez-Lezcano wrote:
> > On Fri, 2008-11-07 at 10:12 +0100, Clemens Ladisch wrote:
> > > Fernando Lopez-Lezcano wrote:
> > > > I'm seeing a realtime patch related hard hang in the kernel alsa
> > > > subsystem (MIDI input/output). In a nutshell:
> > > >
> > > > - alsa rawmidi works (ie: "rawmidi -v -i hw:0" outputs a stream of
> > > > messages when pointed to a midi capable card that has an external
> > > > keyboard connected).
> > > >
> > > > - the alsa sequencer interface works (ie: aplaymidi connected to
> > > > aseqdump transfers data just fine).
> > > >
> > > > - BOTH combined do NOT work (ie: use aconnect to connect the port that
> > > > corresponds to the external midi interface to aseqdump: aseqdump hangs
> > > > forever after transferring the first message and the only way out is a
> > > > reboot).
> > > 
> > > > ... including the output of a "echo t >/proc/sysrq-trigger" that
> > > > should show where aseqdump currently hangs (or so I think).
> > > 
> > > It hangs in tasklet_kill(), which gets called while it tries to close
> > > the rawmidi port.
> > > 
> > > The rawmidi framework uses this tasklet to notify the sequencer that new
> > > MIDI data is available.  The handler function is
> > > snd_rawmidi_input_event_tasklet() in sound/core/rawmidi.c; the sequencer
> > > callback that gets called from there is snd_midi_input_event() in
> > > core/seq/seq_midi.c.
> > > 
> > > You say that the first event gets delivered, so it might be possible
> > > that the tasklet never finishes executing.  Please check whether the
> > > call to snd_seq_kernel_client_dispatch() in snd_midi_input_event()
> > > ever returns.
> > 
> > Going back to this in the hope of a bit more data helping solve the
> > problem...
> > 
> > I don't understand what is going on (of course! :-)
> > 
> > Cards look like this:
> > 
> > $ cat /proc/asound/cards
> >  0 [Gina3G         ]: Echo_Echo3G - Gina3G
> >                       Gina3G rev.0 (DSP56361) at 0xfeb00000 irq 18
> >  1 [Intel          ]: HDA-Intel - HDA Intel
> >                       HDA Intel at 0xfe7f8000 irq 22
> >  2 [PCR            ]: USB-Audio - PCR
> >                       EDIROL PCR at usb-0000:00:1d.0-1, full speed
> > 
> > Here's what I do:
> >   - start aseqdump
> >   - aconnect 16:0 128:0
> >   - aseqdump receives one midi message (one byte active sensing msg)
> >   - aseqdump hangs forever (reboot needed)
> > 
> > This is what dmesg prints (patch attached which shows where the printk's
> > are located in the source for rawmidi.c and seq_midi.c):
> 
> More info with some more printk's (see attached patch for location):

I've been trying to follow the printk crumbs without much success.
AFAICT it all points to tasklet_hi_schedule ... the handling code is
being scheduled but never executes, right? (well, it executes _once_ and
then never again). And that leads to tasklet_common_schedule - as
Clemens pointed at the beginning of the thread this is eerily similar to
what happened before in 2006:

  http://lkml.org/lkml/2006/3/7/256

So, is tasklet_common_schedule just going through the "goto again;" loop
forever?:

   tasklet_trylock(t) is true
again:
-> test_bit(TASKLET_STATE_SCHED, &t->state) is false
-> !tasklet_tryunlock(t) is true
-> goto again

I don't know what it all _means_, I'm just trying to point a finger to
something in the hope that somebody will understand and say "aha!" (and
email a nice patch! :-)

As the code says, "this is subtle"...

-- Fernando

> after aseqdump startup:
> 
> snd_seq_fifo: before init
> snd_seq_fifo: after init
> snd_seq_fifo_poll_wait: before poll_wait
> snd_seq_fifo_poll_wait: after poll_wait
> 
> after aconnect:
> 
> snd_seq_fifo: before init
> snd_seq_fifo: after init
> rawmidi: before input ops trigger
> rawmidi: after input ops trigger
> rawmidi: before input ops trigger
> rawmidi: after input ops trigger
> snd_seq_fifo_event_in: before wake_up
> snd_seq_fifo_event_in: after wake_up
> snd_seq_fifo_poll_wait: before poll_wait
> snd_seq_fifo_poll_wait: after poll_wait
> snd_seq_fifo_cell_out: before spin_unlock
> snd_seq_fifo_cell_out: after spin_unlock
> snd_seq_fifo_poll_wait: before poll_wait
> snd_seq_fifo_poll_wait: after poll_wait
> rawmidi: before receive spinlock
> rawmidi: after receive spinlock
> rawmidi: about to run receive tasklet
> rawmidi: run receive tasklet
> rawmidi: before receive spin unlock
> rawmidi: after receive spin unlock
> rawmidi: about to run input tasklet
> seq: snd_midi_input_event called
> seq: seq_midi_input_event loop begin
> rawmidi: before input ops trigger
> rawmidi: after input ops trigger
> seq: snd_seq_kernel_client_dispatch called
> snd_seq_fifo_event_in: before wake_up
> snd_seq_fifo_event_in: after wake_up
> seq: snd_seq_kernel_client_dispatch returned
> snd_seq_fifo_poll_wait: before poll_wait
> snd_seq_fifo_poll_wait: after poll_wait
> seq: snd_midi_input_event exiting
> rawmidi: after running input tasklet
> snd_seq_fifo_cell_out: before spin_unlock
> snd_seq_fifo_cell_out: after spin_unlock
> snd_seq_fifo_poll_wait: before poll_wait
> snd_seq_fifo_poll_wait: after poll_wait
> rawmidi: before receive spinlock
> rawmidi: after receive spinlock
> rawmidi: about to run receive tasklet
> rawmidi: run receive tasklet
> rawmidi: before receive spin unlock
> rawmidi: after receive spin unlock
> rawmidi: before receive spinlock
> rawmidi: after receive spinlock
> rawmidi: about to run receive tasklet
> rawmidi: run receive tasklet
> rawmidi: before receive spin unlock
> rawmidi: after receive spin unlock
> rawmidi: before receive spinlock
> rawmidi: after receive spinlock
> rawmidi: about to run receive tasklet
> 
> Hangs here:
> 
> Nov 13 14:39:57 host kernel: aseqdump      S [f55762f0] f714dbe0     0
> 5360   5318
> Nov 13 14:39:57 host kernel:       f714dbd4 00200082 f628edc0 f714dbe0
> c042ab6d f55762f0 f5576584 c4847700 
> Nov 13 14:39:57 host kernel:       00000001 c4847700 098b418d 0000003d
> 00000000 00000000 00200246 f63980f4 
> Nov 13 14:39:57 host kernel:       f714dbc0 c06456c1 f63980f4 f714dc5c
> f714dbcc 00000000 7fffffff f714de98 
> Nov 13 14:39:57 host kernel: Call Trace:
> Nov 13 14:39:57 host kernel: [<c042ab6d>] ? vprintk+0x30e/0x331
> Nov 13 14:39:57 host kernel: [<c06456c1>] ? __rt_spin_lock+0x24/0x61
> Nov 13 14:39:57 host kernel: [<c0643ba5>] schedule+0xbf/0xd8
> Nov 13 14:39:57 host kernel: [<c0643c72>] schedule_timeout+0x17/0xbc
> Nov 13 14:39:57 host kernel: [<c0642de5>] ? printk+0xf/0x12
> Nov 13 14:39:57 host kernel: [<f8967c0c>] ? snd_seq_fifo_poll_wait
> +0x32/0x44 [snd_seq]
> Nov 13 14:39:57 host kernel: [<f8964fad>] ? snd_seq_poll+0x4d/0x9f
> [snd_seq]
> Nov 13 14:39:57 host kernel: [<c0495d92>] do_sys_poll+0x292/0x348
> Nov 13 14:39:57 host kernel: [<c0496be2>] ? __pollwait+0x0/0xb6
> Nov 13 14:39:57 host kernel: [<c0425c81>] ? default_wake_function
> +0x0/0x12
> Nov 13 14:39:57 host kernel: [<c0645736>] ? rt_spin_lock+0x38/0x3b
> Nov 13 14:39:57 host kernel: [<c04752f7>] ? page_address+0x88/0xaa
> Nov 13 14:39:57 host kernel: [<c047596d>] ? kmap_high+0x421/0x42a
> Nov 13 14:39:57 host kernel: [<c04ff574>] ? radix_valid_always+0x0/0xa
> Nov 13 14:39:57 host kernel: [<c046430b>] ? __rcu_read_unlock+0x6d/0x72
> Nov 13 14:39:57 host kernel: [<c04699ec>] ? find_get_page+0xfa/0x120
> Nov 13 14:39:57 host kernel: [<c0440314>] ? getnstimeofday+0x3c/0xd6
> Nov 13 14:39:57 host kernel: [<c043e653>] ? ktime_get_ts+0x4a/0x4e
> Nov 13 14:39:57 host kernel: [<c043e66a>] ? ktime_get+0x13/0x2f
> Nov 13 14:39:57 host kernel: [<c0424060>] ? hrtick_start_fair
> +0x140/0x148
> Nov 13 14:39:57 host kernel: [<c041f87b>] ? task_rq_lock+0x44/0x6e
> Nov 13 14:39:57 host kernel: [<c0425c76>] ? try_to_wake_up+0x212/0x21d
> Nov 13 14:39:57 host kernel: [<c0425c91>] ? default_wake_function
> +0x10/0x12
> Nov 13 14:39:57 host kernel: [<c041ddd8>] ? __wake_up_common+0x35/0x5b
> Nov 13 14:39:57 host kernel: [<c0423172>] ? __wake_up+0x28/0x32
> Nov 13 14:39:57 host kernel: [<c0554f2e>] ? n_tty_receive_buf
> +0xfa9/0xff7
> Nov 13 14:39:57 host kernel: [<c0554f2e>] ? n_tty_receive_buf
> +0xfa9/0xff7
> Nov 13 14:39:57 host kernel: [<c05009a6>] ? rb_insert_color+0x56/0xc0
> Nov 13 14:39:57 host kernel: [<c043dbab>] ? enqueue_hrtimer+0x112/0x11e
> Nov 13 14:39:57 host kernel: [<c043e441>] ? hrtimer_start+0x133/0x162
> Nov 13 14:39:57 host kernel: [<c04249d0>] ? hrtick_set+0x97/0xe5
> Nov 13 14:39:57 host kernel: [<c06456c1>] ? __rt_spin_lock+0x24/0x61
> Nov 13 14:39:57 host kernel: [<c0645736>] ? rt_spin_lock+0x38/0x3b
> Nov 13 14:39:57 host kernel: [<f8967c68>] ? snd_seq_fifo_cell_out
> +0x4a/0x146 [snd_seq]
> Nov 13 14:39:57 host kernel: [<c0425c81>] ? default_wake_function
> +0x0/0x12
> Nov 13 14:39:57 host kernel: [<f8965041>] ? snd_seq_read+0x0/0x1d8
> [snd_seq]
> Nov 13 14:39:57 host kernel: [<f896511e>] ? snd_seq_read+0xdd/0x1d8
> [snd_seq]
> Nov 13 14:39:57 host kernel: [<c04d73d3>] ? security_file_permission
> +0xf/0x11
> Nov 13 14:39:57 host kernel: [<c045e231>] ? audit_syscall_entry
> +0xf9/0x123
> Nov 13 14:39:57 host kernel: [<c049606a>] sys_poll+0x3a/0x6a
> Nov 13 14:39:57 host kernel: [<c0404be6>] syscall_call+0x7/0xb
> Nov 13 14:39:57 host kernel: =======================
> 
> After I try to kill aseqdump:
> 
> snd_seq_fifo_poll_wait: before poll_wait
> snd_seq_fifo_poll_wait: after poll_wait
> rawmidi: before input ops trigger
> rawmidi: after input ops trigger
> rawmidi: about to kill input tasklet
> (definitely hangs there as well, never kills tasklet)
> 
> Help!
> What can I try next??
> -- Fernando
> 
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel

