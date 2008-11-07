Return-Path: <linux-kernel-owner+w=401wt.eu-S1751708AbYKGJ0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbYKGJ0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 04:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbYKGJZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 04:25:53 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:57029 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754217AbYKGJZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 04:25:49 -0500
X-Greylist: delayed 789 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Nov 2008 04:25:48 EST
X-Sasl-enc: xpXVPLW6oZ4cJR7gDmAyPtNq6+9zYCP4U/yKfErgjZT7 1226049157
Message-ID: <49140683.9040008@ladisch.de>
Date: Fri, 07 Nov 2008 10:12:35 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
CC: Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@elte.hu>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26.[6|7]-rt11, alsa rawmidi, seq hang
References: <1226019485.3135.31.camel@localhost.localdomain>
In-Reply-To: <1226019485.3135.31.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fernando Lopez-Lezcano wrote:
> I'm seeing a realtime patch related hard hang in the kernel alsa
> subsystem (MIDI input/output). In a nutshell:
>
> - alsa rawmidi works (ie: "rawmidi -v -i hw:0" outputs a stream of
> messages when pointed to a midi capable card that has an external
> keyboard connected).
>
> - the alsa sequencer interface works (ie: aplaymidi connected to
> aseqdump transfers data just fine).
>
> - BOTH combined do NOT work (ie: use aconnect to connect the port that
> corresponds to the external midi interface to aseqdump: aseqdump hangs
> forever after transferring the first message and the only way out is a
> reboot).

Please try the snd-virmidi driver, then we'd have a test case that does
not require MIDI hardware.

> ... including the output of a "echo t >/proc/sysrq-trigger" that
> should show where aseqdump currently hangs (or so I think).

It hangs in tasklet_kill(), which gets called while it tries to close
the rawmidi port.

The rawmidi framework uses this tasklet to notify the sequencer that new
MIDI data is available.  The handler function is
snd_rawmidi_input_event_tasklet() in sound/core/rawmidi.c; the sequencer
callback that gets called from there is snd_midi_input_event() in
core/seq/seq_midi.c.

You say that the first event gets delivered, so it might be possible
that the tasklet never finishes executing.  Please check whether the
call to snd_seq_kernel_client_dispatch() in snd_midi_input_event()
ever returns.


I vaguely remember that we had exactly the same problem (hangs when
using sequencer on RT kernel) some time ago, and that it was somehow
related to tasklets.


Regards,
Clemens
