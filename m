Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab0BBWKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 17:10:47 -0500
Received: from smtp-OUT05A.alice.it ([85.33.3.5]:4838 "EHLO
	smtp-OUT05A.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab0BBWKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 17:10:46 -0500
Date: Tue, 2 Feb 2010 23:09:11 +0100
From: Giuliano Pochini <pochini@shiny.it>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Frederick V Heitkamp <heitkamp@ameritech.net>,
       Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] Crash 2.6.32.x, Echo 3G, Alsa, SCSI
Message-ID: <20100202230911.71e8b600@Jay>
In-Reply-To: <4B684513.8090201@ladisch.de>
References: <73211.74714.qm@web180714.mail.sp1.yahoo.com>
 <4B684513.8090201@ladisch.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; powerpc-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Feb 2010 22:10:00.0874 (UTC) FILETIME=[76AD08A0:01CAA454]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Feb 2010 16:30:27 +0100
Clemens Ladisch <clemens@ladisch.de> wrote:

> Frederick V Heitkamp wrote:
> > Repeatable Hard Crash.
> > What else do I need to provide?
> > 
> > [ 5484.995249] WriteControlReg: not written, no change
> > [ 5485.069621] divide error: 0000 [#1] pcm_hw_params ok
> > [ 5485.070159] Prepare rate=44100 format=2 channels=2
> > [ 5485.070161] set_audio_format[14] = 5
> > [ 5485.070166] Prepare rate=44100 format=2 channels=2
> > [ 5485.070167] set_audio_format[14] = 5
> > [ 5485.070003] PREEMPT SMP 
> > ...
> > [ 5485.070003] EIP is at pcm_pointer+0x37/0x70 [snd_echo3g]
> > ...
> > [ 5485.965788]  [<c10041c0>] ? do_divide_error+0x0/0x90
> > [ 5485.980619]  [<f87aa037>] ? pcm_pointer+0x37/0x70 [snd_echo3g]
> > [ 5485.998047]  [<c104764e>] ? run_timer_softirq+0x17e/0x2e0
> > [ 5486.014175]  [<f87ac9bf>] ? snd_echo_interrupt+0x11f/0x240 [snd_echo3g]
> > [ 5486.033940]  [<c107a5d5>] ? handle_IRQ_event+0x45/0x190
> 
> bytes_to_frames() divides by runtime->frame_bits which is not set until
> after the hw_params callback has succeeded, but the corresponding
> chip->substream[] entry is set in that callback, by init_engine().  It
> should probably have been set in the prepare callback.

I've just had another look at my code. Although it never happened to me, it
is indeed possible when hw_params() completes if another substream is
already running. The reason is that the card delivers an irq when it
executes an irq instruction in any of the running s-g lists. The irq
handler cannot know which substream caused it, so it has to call the
pointer() function for each of the configured substreams (ie. the ones
which completed one of the pcm_*_hw_params() callbacks.

There is another possible fix. I tested it briefly. It looks ok wrt race
conditions because pipe->state is set only in the trigger callback. I hope
I didn't overlook anything again...


Signed-off-by: Giuliano Pochini <pochini@shiny.it>

--- alsa-driver-1.0.22.1/alsa-kernel/pci/echoaudio/echoaudio.c__orig	2010-02-02 22:37:33.000000000 +0100
+++ alsa-driver-1.0.22.1/alsa-kernel/pci/echoaudio/echoaudio.c	2010-02-02 22:44:03.000000000 +0100
@@ -1821,7 +1821,9 @@ static irqreturn_t snd_echo_interrupt(in
 	/* The hardware doesn't tell us which substream caused the irq,
 	thus we have to check all running substreams. */
 	for (ss = 0; ss < DSP_MAXPIPES; ss++) {
-		if ((substream = chip->substream[ss])) {
+		substream = chip->substream[ss];
+		if (substream && ((struct audiopipe *)substream->runtime->
+				private_data)->state == PIPE_STATE_STARTED) {
 			period = pcm_pointer(substream) /
 				substream->runtime->period_size;
 			if (period != chip->last_period[ss]) {


-- 
Giuliano.
