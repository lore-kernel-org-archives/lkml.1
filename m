Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbYKMVBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbYKMVBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 16:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYKMVB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 16:01:29 -0500
Received: from smtp1.Stanford.EDU ([171.67.219.81]:55634 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYKMVB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 16:01:27 -0500
Subject: Re: 2.6.26.[6|7]-rt11, alsa rawmidi, seq hang
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@elte.hu>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <49140683.9040008@ladisch.de>
References: <1226019485.3135.31.camel@localhost.localdomain>
	 <49140683.9040008@ladisch.de>
Content-Type: multipart/mixed; boundary="=-54ehgJSXKoe7Ahji+A6X"
Date: Thu, 13 Nov 2008 13:01:15 -0800
Message-Id: <1226610075.23485.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-54ehgJSXKoe7Ahji+A6X
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

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

Going back to this in the hope of a bit more data helping solve the
problem...

I don't understand what is going on (of course! :-)

Cards look like this:

$ cat /proc/asound/cards
 0 [Gina3G         ]: Echo_Echo3G - Gina3G
                      Gina3G rev.0 (DSP56361) at 0xfeb00000 irq 18
 1 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0xfe7f8000 irq 22
 2 [PCR            ]: USB-Audio - PCR
                      EDIROL PCR at usb-0000:00:1d.0-1, full speed

Here's what I do:
  - start aseqdump
  - aconnect 16:0 128:0
  - aseqdump receives one midi message (one byte active sensing msg)
  - aseqdump hangs forever (reboot needed)

This is what dmesg prints (patch attached which shows where the printk's
are located in the source for rawmidi.c and seq_midi.c):

== this starts happening as soon as I run aconnect:
rawmidi: before input ops trigger
rawmidi: after input ops trigger
rawmidi: before input ops trigger
rawmidi: after input ops trigger
== hmmm, after it is actually subscribed?
rawmidi: before receive spinlock
rawmidi: after receive spinlock
rawmidi: about to run receive tasklet
rawmidi: run receive tasklet
rawmidi: before receive spin unlock
rawmidi: after receive spin unlock
rawmidi: about to run input tasklet
seq: snd_midi_input_event called
seq: seq_midi_input_event loop begin
rawmidi: before input ops trigger
rawmidi: after input ops trigger
seq: snd_seq_kernel_client_dispatch called
seq: snd_seq_kernel_client_dispatch returned
seq: snd_midi_input_event exiting
rawmidi: after running input tasklet
rawmidi: before receive spinlock
rawmidi: after receive spinlock
rawmidi: about to run receive tasklet
rawmidi: run receive tasklet
rawmidi: before receive spin unlock
rawmidi: after receive spin unlock
rawmidi: before receive spinlock
rawmidi: after receive spinlock
rawmidi: about to run receive tasklet
rawmidi: run receive tasklet
rawmidi: before receive spin unlock
rawmidi: after receive spin unlock
rawmidi: before receive spinlock
rawmidi: after receive spinlock
rawmidi: about to run receive tasklet
rawmidi: run receive tasklet
rawmidi: before receive spin unlock
rawmidi: after receive spin unlock
rawmidi: before receive spinlock
rawmidi: after receive spinlock

So, snd_midi_input_event runs once but never gets called back. 

Something else is deadlocking, what can it be? (ie: where can I put more
printk's to try to see what is going on??)

This is where I think aseqdujmp hangs:

Nov 13 11:36:53 host kernel: =======================
Nov 13 11:36:53 host kernel: aseqdump      S [f3505170] f7960f30     0
5580   5515
Nov 13 11:36:53 host kernel:       f567bbd4 00200082 00000001 f7960f30
00200246 f3505170 f3505404 c485d700 
Nov 13 11:36:53 host kernel:       00000003 c485d700 9a5d89b4 000000bc
f567bba4 f567bba4 0007c8c8 00200246 
Nov 13 11:36:53 host kernel:       f35a7af4 00000000 00000000 00000000
ffffffff 00000000 7fffffff f567be98 
Nov 13 11:36:53 host kernel: Call Trace:
Nov 13 11:36:53 host kernel: [<c0643ba5>] schedule+0xbf/0xd8
Nov 13 11:36:53 host kernel: [<c0643c72>] schedule_timeout+0x17/0xbc
Nov 13 11:36:53 host kernel: [<c0496c8f>] ? __pollwait+0xad/0xb6
Nov 13 11:36:53 host kernel: [<f8968b34>] ? snd_seq_fifo_poll_wait
+0x18/0x25 [snd_seq]
Nov 13 11:36:53 host kernel: [<f8965fad>] ? snd_seq_poll+0x4d/0x9f
[snd_seq]
Nov 13 11:36:53 host kernel: [<c0495d92>] do_sys_poll+0x292/0x348
Nov 13 11:36:53 host kernel: [<c0496be2>] ? __pollwait+0x0/0xb6
Nov 13 11:36:53 host kernel: [<c0425c81>] ? default_wake_function
+0x0/0x12
Nov 13 11:36:53 host kernel: [<c0645736>] ? rt_spin_lock+0x38/0x3b
Nov 13 11:36:53 host kernel: [<c04752f7>] ? page_address+0x88/0xaa
Nov 13 11:36:53 host kernel: [<c047596d>] ? kmap_high+0x421/0x42a
Nov 13 11:36:53 host kernel: [<c04ff574>] ? radix_valid_always+0x0/0xa
Nov 13 11:36:53 host kernel: [<c046430b>] ? __rcu_read_unlock+0x6d/0x72
Nov 13 11:36:53 host kernel: [<c04699ec>] ? find_get_page+0xfa/0x120
Nov 13 11:36:53 host kernel: [<c06456c1>] ? __rt_spin_lock+0x24/0x61
Nov 13 11:36:53 host kernel: [<c0645736>] ? rt_spin_lock+0x38/0x3b
Nov 13 11:36:53 host kernel: [<c0420afc>] ? __enqueue_entity+0xe3/0xeb
Nov 13 11:36:53 host kernel: [<c041f87b>] ? task_rq_lock+0x44/0x6e
Nov 13 11:36:53 host kernel: [<c0425c76>] ? try_to_wake_up+0x212/0x21d
Nov 13 11:36:53 host kernel: [<c0425c91>] ? default_wake_function
+0x10/0x12
Nov 13 11:36:53 host kernel: [<c041ddd8>] ? __wake_up_common+0x35/0x5b
Nov 13 11:36:53 host kernel: [<c0423172>] ? __wake_up+0x28/0x32
Nov 13 11:36:53 host kernel: [<c0554f2e>] ? n_tty_receive_buf
+0xfa9/0xff7
Nov 13 11:36:53 host kernel: [<c0554f2e>] ? n_tty_receive_buf
+0xfa9/0xff7
Nov 13 11:36:53 host kernel: [<c0447cef>] ? rt_mutex_up_read+0x1b7/0x25d
Nov 13 11:36:53 host kernel: [<c0448f40>] ? rt_up_read+0x8/0xa
Nov 13 11:36:53 host kernel: [<c0647c26>] ? do_page_fault+0x45f/0x7d8
Nov 13 11:36:53 host kernel: [<c0502f6c>] ? copy_to_user+0x36/0x106
Nov 13 11:36:53 host kernel: [<c06456c1>] ? __rt_spin_lock+0x24/0x61
Nov 13 11:36:53 host kernel: [<c0645736>] ? rt_spin_lock+0x38/0x3b
Nov 13 11:36:53 host kernel: [<f8968c46>] ? snd_seq_fifo_cell_out
+0x47/0xee [snd_seq]
Nov 13 11:36:53 host kernel: [<c0425c81>] ? default_wake_function
+0x0/0x12
Nov 13 11:36:53 host kernel: [<f8966041>] ? snd_seq_read+0x0/0x1d8
[snd_seq]
Nov 13 11:36:53 host kernel: [<f896611e>] ? snd_seq_read+0xdd/0x1d8
[snd_seq]
Nov 13 11:36:53 host kernel: [<c04d73d3>] ? security_file_permission
+0xf/0x11
Nov 13 11:36:53 host kernel: [<c045e231>] ? audit_syscall_entry
+0xf9/0x123
Nov 13 11:36:53 host kernel: [<c049606a>] sys_poll+0x3a/0x6a
Nov 13 11:36:53 host kernel: [<c0404be6>] syscall_call+0x7/0xb
Nov 13 11:36:53 host kernel: =======================

Looks like it is a poll...

Then, when I try to actually kill aseqdump I get this in the log:

Nov 13 11:39:02 host kernel: rawmidi: about to kill input tasklet

And the trace:

Nov 13 11:39:13 host kernel: aseqdump      D [f3505170] f786c0b0     0
5580   5515
Nov 13 11:39:13 host kernel:       f567be0c 00200082 00000000 f786c0b0
00200246 f3505170 f3505404 c483c700 
Nov 13 11:39:13 host kernel:       00000000 c483c700 5618b41d 00000121
f567bdf4 000e6262 f567bdf4 c04320f3 
Nov 13 11:39:13 host kernel:       f567be1c f567be1c f567be14 c0432918
000e6263 000e6263 f567be1c f567be48 
Nov 13 11:39:13 host kernel: Call Trace:
Nov 13 11:39:13 host kernel: [<c04320f3>] ? internal_add_timer+0x88/0x8c
Nov 13 11:39:13 host kernel: [<c0432918>] ? __mod_timer+0xc8/0xd3
Nov 13 11:39:13 host kernel: [<c0643ba5>] schedule+0xbf/0xd8
Nov 13 11:39:13 host kernel: [<c0643cf8>] schedule_timeout+0x9d/0xbc
Nov 13 11:39:13 host kernel: [<c0431da2>] ? process_timeout+0x0/0xa
Nov 13 11:39:13 host kernel: [<c0643cf3>] ? schedule_timeout+0x98/0xbc
Nov 13 11:39:13 host kernel: [<c0643d2c>]
schedule_timeout_uninterruptible+0x15/0x17
Nov 13 11:39:13 host kernel: [<c0432a1b>] msleep+0x10/0x16
Nov 13 11:39:13 host kernel: [<c042eaef>] tasklet_kill+0x2e/0x58
Nov 13 11:39:13 host kernel: [<f89bb755>] snd_rawmidi_input_trigger
+0x31/0x44 [snd_rawmidi]
Nov 13 11:39:13 host kernel: [<f89bceeb>] snd_rawmidi_kernel_release
+0x37/0x105 [snd_rawmidi]
Nov 13 11:39:13 host kernel: [<f8f28633>] midisynth_unsubscribe+0xb/0xd
[snd_seq_midi]
Nov 13 11:39:13 host kernel: [<f8969cb9>] unsubscribe_port+0x3c/0x71
[snd_seq]
Nov 13 11:39:13 host kernel: [<f896a510>] clear_subscriber_list
+0xae/0xdb [snd_seq]
Nov 13 11:39:13 host kernel: [<f896a57e>] port_delete+0x41/0x65
[snd_seq]
Nov 13 11:39:13 host kernel: [<f896a63c>] snd_seq_delete_all_ports
+0x9a/0xba [snd_seq]
Nov 13 11:39:13 host kernel: [<f8965175>] seq_free_client1+0xb/0x90
[snd_seq]
Nov 13 11:39:13 host kernel: [<f8965232>] seq_free_client+0x38/0x6f
[snd_seq]
Nov 13 11:39:13 host kernel: [<f896527e>] snd_seq_release+0x15/0x35
[snd_seq]
Nov 13 11:39:13 host kernel: [<c048b5a2>] __fput+0xae/0x158
Nov 13 11:39:13 host kernel: [<c048b663>] fput+0x17/0x19
Nov 13 11:39:13 host kernel: [<c0488b95>] filp_close+0x50/0x5a
Nov 13 11:39:13 host kernel: [<c0488c12>] sys_close+0x73/0xad
Nov 13 11:39:13 host kernel: [<c0404be6>] syscall_call+0x7/0xb
Nov 13 11:39:13 host kernel: =======================

-- Fernando


--=-54ehgJSXKoe7Ahji+A6X
Content-Disposition: attachment; filename=patch
Content-Type: text/x-patch; name=patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- ./sound/core/rawmidi.c.orig	2008-11-06 15:26:03.000000000 -0800
+++ ./sound/core/rawmidi.c	2008-11-13 12:31:23.000000000 -0800
@@ -95,7 +95,10 @@
 static void snd_rawmidi_input_event_tasklet(unsigned long data)
 {
 	struct snd_rawmidi_substream *substream = (struct snd_rawmidi_substream *)data;
+	printk(KERN_ERR "rawmidi: about to run input tasklet\n");
 	substream->runtime->event(substream);
+	printk(KERN_ERR "rawmidi: after running input tasklet\n");
+
 }
 
 static void snd_rawmidi_output_trigger_tasklet(unsigned long data)
@@ -149,18 +152,28 @@
 static inline void snd_rawmidi_output_trigger(struct snd_rawmidi_substream *substream,int up)
 {
 	if (up) {
+	        printk(KERN_ERR "rawmidi: about to run output tasklet\n");
 		tasklet_hi_schedule(&substream->runtime->tasklet);
+	        printk(KERN_ERR "rawmidi: run output tasklet\n");
 	} else {
+	        printk(KERN_ERR "rawmidi: about to kill output tasklet\n");
 		tasklet_kill(&substream->runtime->tasklet);
 		substream->ops->trigger(substream, 0);
+		printk(KERN_ERR "rawmidi: killed output tasklet\n");
 	}
 }
 
 static void snd_rawmidi_input_trigger(struct snd_rawmidi_substream *substream, int up)
 {
+        printk(KERN_ERR "rawmidi: before input ops trigger\n");
 	substream->ops->trigger(substream, up);
-	if (!up && substream->runtime->event)
+        printk(KERN_ERR "rawmidi: after input ops trigger\n");
+	if (!up && substream->runtime->event) {
+
+	        printk(KERN_ERR "rawmidi: about to kill input tasklet\n");
 		tasklet_kill(&substream->runtime->tasklet);
+		printk(KERN_ERR "rawmidi: killed input tasklet\n");
+	}
 }
 
 int snd_rawmidi_drop_output(struct snd_rawmidi_substream *substream)
@@ -861,7 +874,9 @@
 		snd_printd("snd_rawmidi_receive: input is not active!!!\n");
 		return -EINVAL;
 	}
+	printk(KERN_ERR "rawmidi: before receive spinlock\n");
 	spin_lock_irqsave(&runtime->lock, flags);
+	printk(KERN_ERR "rawmidi: after receive spinlock\n");
 	if (count == 1) {	/* special case, faster code */
 		substream->bytes++;
 		if (runtime->avail < runtime->buffer_size) {
@@ -901,12 +916,17 @@
 		}
 	}
 	if (result > 0) {
-		if (runtime->event)
-			tasklet_hi_schedule(&runtime->tasklet);
+	  if (runtime->event) {
+	    printk(KERN_ERR "rawmidi: about to run receive tasklet\n");
+	    tasklet_hi_schedule(&runtime->tasklet);
+	    printk(KERN_ERR "rawmidi: run receive tasklet\n");
+	  }
 		else if (snd_rawmidi_ready(substream))
 			wake_up(&runtime->sleep);
 	}
+	printk(KERN_ERR "rawmidi: before receive spin unlock\n");
 	spin_unlock_irqrestore(&runtime->lock, flags);
+	printk(KERN_ERR "rawmidi: after receive spin unlock\n");
 	return result;
 }
 
--- ./sound/core/seq/seq_midi.c.orig	2008-11-07 09:53:31.000000000 -0800
+++ ./sound/core/seq/seq_midi.c	2008-11-07 10:21:31.000000000 -0800
@@ -80,6 +80,8 @@
 	char buf[16], *pbuf;
 	long res, count;
 
+	printk(KERN_ERR "seq: snd_midi_input_event called\n");
+
 	if (substream == NULL)
 		return;
 	runtime = substream->runtime;
@@ -88,6 +90,9 @@
 		return;
 	memset(&ev, 0, sizeof(ev));
 	while (runtime->avail > 0) {
+
+	        printk(KERN_ERR "seq: seq_midi_input_event loop begin\n");
+
 		res = snd_rawmidi_kernel_read(substream, buf, sizeof(buf));
 		if (res <= 0)
 			continue;
@@ -115,6 +120,9 @@
 			}
 		}
 	}
+
+	printk(KERN_ERR "seq: snd_midi_input_event exiting\n");
+
 }
 
 static int dump_midi(struct snd_rawmidi_substream *substream, const char *buf, int count)
--- ./sound/core/rawmidi.c.orig	2008-11-06 15:26:03.000000000 -0800
+++ ./sound/core/rawmidi.c	2008-11-13 11:41:46.000000000 -0800
@@ -151,16 +151,22 @@
 	if (up) {
 		tasklet_hi_schedule(&substream->runtime->tasklet);
 	} else {
+	        printk(KERN_ERR "rawmidi: about to kill output tasklet\n");
 		tasklet_kill(&substream->runtime->tasklet);
 		substream->ops->trigger(substream, 0);
+		printk(KERN_ERR "rawmidi: killed output tasklet\n");
 	}
 }
 
 static void snd_rawmidi_input_trigger(struct snd_rawmidi_substream *substream, int up)
 {
 	substream->ops->trigger(substream, up);
-	if (!up && substream->runtime->event)
+	if (!up && substream->runtime->event) {
+
+	        printk(KERN_ERR "rawmidi: about to kill input tasklet\n");
 		tasklet_kill(&substream->runtime->tasklet);
+		printk(KERN_ERR "rawmidi: killed input tasklet\n");
+	}
 }
 
 int snd_rawmidi_drop_output(struct snd_rawmidi_substream *substream)
@@ -861,7 +867,9 @@
 		snd_printd("snd_rawmidi_receive: input is not active!!!\n");
 		return -EINVAL;
 	}
+	printk(KERN_ERR "rawmidi: before receive spinlock\n");
 	spin_lock_irqsave(&runtime->lock, flags);
+	printk(KERN_ERR "rawmidi: after receive spinlock\n");
 	if (count == 1) {	/* special case, faster code */
 		substream->bytes++;
 		if (runtime->avail < runtime->buffer_size) {
@@ -901,12 +909,17 @@
 		}
 	}
 	if (result > 0) {
-		if (runtime->event)
-			tasklet_hi_schedule(&runtime->tasklet);
+	  if (runtime->event) {
+	    printk(KERN_ERR "rawmidi: about to run tasklet\n");
+	    tasklet_hi_schedule(&runtime->tasklet);
+	    printk(KERN_ERR "rawmidi: run tasklet\n");
+	  }
 		else if (snd_rawmidi_ready(substream))
 			wake_up(&runtime->sleep);
 	}
+	printk(KERN_ERR "rawmidi: before receive spin unlock\n");
 	spin_unlock_irqrestore(&runtime->lock, flags);
+	printk(KERN_ERR "rawmidi: after receive spin unlock\n");
 	return result;
 }
 
--- ./sound/core/seq/seq_midi.c.orig	2008-11-07 09:53:31.000000000 -0800
+++ ./sound/core/seq/seq_midi.c	2008-11-07 10:21:31.000000000 -0800
@@ -80,6 +80,8 @@
 	char buf[16], *pbuf;
 	long res, count;
 
+	printk(KERN_ERR "seq: snd_midi_input_event called\n");
+
 	if (substream == NULL)
 		return;
 	runtime = substream->runtime;
@@ -88,6 +90,9 @@
 		return;
 	memset(&ev, 0, sizeof(ev));
 	while (runtime->avail > 0) {
+
+	        printk(KERN_ERR "seq: seq_midi_input_event loop begin\n");
+
 		res = snd_rawmidi_kernel_read(substream, buf, sizeof(buf));
 		if (res <= 0)
 			continue;
@@ -115,6 +120,9 @@
 			}
 		}
 	}
+
+	printk(KERN_ERR "seq: snd_midi_input_event exiting\n");
+
 }
 
 static int dump_midi(struct snd_rawmidi_substream *substream, const char *buf, int count)

--- ./sound/core/rawmidi.c.orig	2008-11-06 15:26:03.000000000 -0800
+++ ./sound/core/rawmidi.c	2008-11-13 12:31:23.000000000 -0800
@@ -95,7 +95,10 @@
 static void snd_rawmidi_input_event_tasklet(unsigned long data)
 {
 	struct snd_rawmidi_substream *substream = (struct snd_rawmidi_substream *)data;
+	printk(KERN_ERR "rawmidi: about to run input tasklet\n");
 	substream->runtime->event(substream);
+	printk(KERN_ERR "rawmidi: after running input tasklet\n");
+
 }
 
 static void snd_rawmidi_output_trigger_tasklet(unsigned long data)
@@ -149,18 +152,28 @@
 static inline void snd_rawmidi_output_trigger(struct snd_rawmidi_substream *substream,int up)
 {
 	if (up) {
+	        printk(KERN_ERR "rawmidi: about to run output tasklet\n");
 		tasklet_hi_schedule(&substream->runtime->tasklet);
+	        printk(KERN_ERR "rawmidi: run output tasklet\n");
 	} else {
+	        printk(KERN_ERR "rawmidi: about to kill output tasklet\n");
 		tasklet_kill(&substream->runtime->tasklet);
 		substream->ops->trigger(substream, 0);
+		printk(KERN_ERR "rawmidi: killed output tasklet\n");
 	}
 }
 
 static void snd_rawmidi_input_trigger(struct snd_rawmidi_substream *substream, int up)
 {
+        printk(KERN_ERR "rawmidi: before input ops trigger\n");
 	substream->ops->trigger(substream, up);
-	if (!up && substream->runtime->event)
+        printk(KERN_ERR "rawmidi: after input ops trigger\n");
+	if (!up && substream->runtime->event) {
+
+	        printk(KERN_ERR "rawmidi: about to kill input tasklet\n");
 		tasklet_kill(&substream->runtime->tasklet);
+		printk(KERN_ERR "rawmidi: killed input tasklet\n");
+	}
 }
 
 int snd_rawmidi_drop_output(struct snd_rawmidi_substream *substream)
@@ -861,7 +874,9 @@
 		snd_printd("snd_rawmidi_receive: input is not active!!!\n");
 		return -EINVAL;
 	}
+	printk(KERN_ERR "rawmidi: before receive spinlock\n");
 	spin_lock_irqsave(&runtime->lock, flags);
+	printk(KERN_ERR "rawmidi: after receive spinlock\n");
 	if (count == 1) {	/* special case, faster code */
 		substream->bytes++;
 		if (runtime->avail < runtime->buffer_size) {
@@ -901,12 +916,17 @@
 		}
 	}
 	if (result > 0) {
-		if (runtime->event)
-			tasklet_hi_schedule(&runtime->tasklet);
+	  if (runtime->event) {
+	    printk(KERN_ERR "rawmidi: about to run receive tasklet\n");
+	    tasklet_hi_schedule(&runtime->tasklet);
+	    printk(KERN_ERR "rawmidi: run receive tasklet\n");
+	  }
 		else if (snd_rawmidi_ready(substream))
 			wake_up(&runtime->sleep);
 	}
+	printk(KERN_ERR "rawmidi: before receive spin unlock\n");
 	spin_unlock_irqrestore(&runtime->lock, flags);
+	printk(KERN_ERR "rawmidi: after receive spin unlock\n");
 	return result;
 }
 
--- ./sound/core/seq/seq_midi.c.orig	2008-11-07 09:53:31.000000000 -0800
+++ ./sound/core/seq/seq_midi.c	2008-11-07 10:21:31.000000000 -0800
@@ -80,6 +80,8 @@
 	char buf[16], *pbuf;
 	long res, count;
 
+	printk(KERN_ERR "seq: snd_midi_input_event called\n");
+
 	if (substream == NULL)
 		return;
 	runtime = substream->runtime;
@@ -88,6 +90,9 @@
 		return;
 	memset(&ev, 0, sizeof(ev));
 	while (runtime->avail > 0) {
+
+	        printk(KERN_ERR "seq: seq_midi_input_event loop begin\n");
+
 		res = snd_rawmidi_kernel_read(substream, buf, sizeof(buf));
 		if (res <= 0)
 			continue;
@@ -115,6 +120,9 @@
 			}
 		}
 	}
+
+	printk(KERN_ERR "seq: snd_midi_input_event exiting\n");
+
 }
 
 static int dump_midi(struct snd_rawmidi_substream *substream, const char *buf, int count)

--=-54ehgJSXKoe7Ahji+A6X--

