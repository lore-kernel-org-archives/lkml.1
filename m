Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbYDBRKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbYDBRKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 13:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756369AbYDBRJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 13:09:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756204AbYDBRJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 13:09:56 -0400
Date: Wed, 2 Apr 2008 10:09:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Takashi Iwai <tiwai@suse.de>
cc: akpm@linux-foundation.org, perex@perex.cz, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ALSA post-2.6.25-rc3 fixes
In-Reply-To: <s5hy793q13x.wl%tiwai@suse.de>
Message-ID: <alpine.LFD.1.00.0804020952030.14670@woody.linux-foundation.org>
References: <s5hy793q13x.wl%tiwai@suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Takashi,
 I just tried to suspend my mac mini with sound running on my box that I 
test Fedora 9 on, and it all suspended and resumed ok, but on resume audio 
didn't work.

I could restart the X session, and audio was ok, so the actual driver was 
ok, but some state didn't restore well. 

I *think* the problem may be due to this message which happened right 
after the resume:

	Apr  2 09:50:47 macmini pulseaudio[2296]: module-alsa-sink.c: Got POLLERR from ALSA

and I wonder what ALSA does over a suspend. Yes, it can be a pulseaudio 
bug too (and even if it's not a pulseaudio bug I suspect pulseaudio could 
work aroun this by re-initializing when it gets POLLERR), but the thing 
is, suspend/resume *should* generally be invisible from user space!

So the POLLERR seems wrong, and I assume it is coming from 
snd_pcm_playback_poll() and the runtime->status->state has been scrogged 
by the suspend/resume cycle.

The PCM code seems to set the state to SNDRV_PCM_STATE_SUSPENDED on 
suspend and resume it from suspended_state, but maybe there's some path 
that misses this?

This is Intel HDA audio, in case it mattes (but none of the POLLERR code 
seems to have anything to do with the low-level drivers).

			Linus
