Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbXKVW0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbXKVW0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 17:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbXKVW0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 17:26:34 -0500
Received: from thunk.org ([69.25.196.29]:44367 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbXKVW0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 17:26:33 -0500
Date: Thu, 22 Nov 2007 12:42:42 -0500
From: Theodore Tso <tytso@mit.edu>
To: Takashi Iwai <tiwai@suse.de>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org
Subject: Re: snd_hda_intel 2.6.24-rc2 bug: interrupts don't always work on
	Lenovo X60s
Message-ID: <20071122174242.GB17181@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Takashi Iwai <tiwai@suse.de>, Roland Dreier <rdreier@cisco.com>,
	linux-kernel@vger.kernel.org
References: <ada1wb05p6n.fsf@cisco.com> <s5hbq9zyktm.wl%tiwai@suse.de> <adak5on2yd6.fsf@cisco.com> <s5hwssnvaw1.wl%tiwai@suse.de> <adafxzb2tf3.fsf@cisco.com> <s5hhcjqhkty.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hhcjqhkty.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 04:43:05AM +0100, Takashi Iwai wrote:
> > By the way, the "polling mode" seems to work OK: I still get normal
> > playback of music etc.
> 
> Yes, the polling mode should work in most cases, too.

Out of curiosity, how many wakeups/interrupts are involved with the
sound going into polling mode?  Is it going to make a difference as
far as battery life is concerned?

I'm seeing the message:

hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x005f000c

on my X61s laptop as well, where the last_cmd varies quite a bit.
Over the past two weeks, I've seen last cmd be:

0x003f000c, 0x004f000c, 0x005f000c, 0x006f000c, 0x00db8000,
0x011b8000, 0x011ba000, 0x012ba000, 0x012f000c, 0x013f000c,
0x014f000d, 0x019f000c, 0x020b0001, 0x020b0003, 0x020b2000,
0x020b2001, 0x020b2002, 0x025f0012

Interestingly, when I was using a post 2.6.24-rc1 and -rc2 kernel, I
was getting a lot of these "switching polling to mode messages",
usually within a minute of the machine booting.  Now that I have
switched to a recent rc3 kernel, they seem to have largely gone away.

Looking at my kernel, it looks like the patch you suggested to Roland
was *not* applied, and "git log sound/pci/hda" shows that the only
change to that directory was a patch from Ingo Molnar that I had
cherry picked from LKML.  Given that we were doing a
schedule_timeout_uninterruptible for a full second, that certainly
seems to be a likely candidate for why we were getting the response
timeout message!  Does this analysis make sense to you?

Regards,

						- Ted

commit 2f7e58208e0d59ca6e4ad1561f47391d4efa19fa
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Nov 16 11:35:05 2007 -0500

    snd hda suspend latency: shorten codec read
    
    not sleeping for every codec read/write but doing a short udelay and
    a conditional reschedule has cut suspend+resume latency by about 1
    second on my T60.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 3fa0f97..62b9fb3 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -555,7 +555,8 @@ static unsigned int azx_rirb_get_response(struct hda_codec *codec)
 		}
 		if (!chip->rirb.cmds)
 			return chip->rirb.res; /* the last value */
-		schedule_timeout_uninterruptible(1);
+		udelay(10);
+		cond_resched();
 	} while (time_after_eq(timeout, jiffies));
 
 	if (chip->msi) {
