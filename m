Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbYKGXOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbYKGXOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:14:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYKGXNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:13:54 -0500
Received: from smtp1.Stanford.EDU ([171.67.219.81]:55082 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYKGXNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:13:53 -0500
Subject: Re: [alsa-devel] 2.6.26.[6|7]-rt11, alsa rawmidi, seq hang
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@elte.hu>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
In-Reply-To: <1226081557.20569.5.camel@localhost.localdomain>
References: <1226019485.3135.31.camel@localhost.localdomain>
	 <49140683.9040008@ladisch.de>
	 <1226081557.20569.5.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 15:12:29 -0800
Message-Id: <1226099549.7647.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-07 at 10:12 -0800, Fernando Lopez-Lezcano wrote:
> On Fri, 2008-11-07 at 10:12 +0100, Clemens Ladisch wrote:
> > Fernando Lopez-Lezcano wrote:
> > > I'm seeing a realtime patch related hard hang in the kernel alsa
> > > subsystem (MIDI input/output). In a nutshell:
> > >
> > > - alsa rawmidi works (ie: "rawmidi -v -i hw:0" outputs a stream of
> > > messages when pointed to a midi capable card that has an external
> > > keyboard connected).
> > >
> > > - the alsa sequencer interface works (ie: aplaymidi connected to
> > > aseqdump transfers data just fine).
> > >
> > > - BOTH combined do NOT work (ie: use aconnect to connect the port that
> > > corresponds to the external midi interface to aseqdump: aseqdump hangs
> > > forever after transferring the first message and the only way out is a
> > > reboot).
> > 
> > Please try the snd-virmidi driver, then we'd have a test case that does
> > not require MIDI hardware.
> > 
> > > ... including the output of a "echo t >/proc/sysrq-trigger" that
> > > should show where aseqdump currently hangs (or so I think).
> > 
> > It hangs in tasklet_kill(), which gets called while it tries to close
> > the rawmidi port.
> > 
> > The rawmidi framework uses this tasklet to notify the sequencer that new
> > MIDI data is available.  The handler function is
> > snd_rawmidi_input_event_tasklet() in sound/core/rawmidi.c; the sequencer
> > callback that gets called from there is snd_midi_input_event() in
> > core/seq/seq_midi.c.
> > 
> > You say that the first event gets delivered, so it might be possible
> > that the tasklet never finishes executing.  Please check whether the
> > call to snd_seq_kernel_client_dispatch() in snd_midi_input_event()
> > ever returns.
> 
> I added a printk before and after the call, it looks like it gets called
> and it returns (but only _once_... aseqdump hangs in an unkillable state
> as before).

Just in case, the tasklet keeps getting called as long as midi bytes are
received. So the tasklet runs once, snd_midi_input_event gets called
once and the tasklet keeps running again and again, but nobody runs
snd_midi_input_event. Who should?

-- Fernando


