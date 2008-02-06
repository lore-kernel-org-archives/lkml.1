Return-Path: <linux-kernel-owner+w=401wt.eu-S1763586AbYBFC0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763586AbYBFC0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 21:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759455AbYBFC0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 21:26:10 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:51171 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756993AbYBFC0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 21:26:09 -0500
Date: Tue, 5 Feb 2008 21:25:17 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Felipe Balbi <felipebalbi@users.sourceforge.net>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>,
       "Klaus S. Madsen" <ksm@hjernemadsen.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: T61P sound issue
Message-ID: <20080206022517.GB27119@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jiri Kosina <jikos@jikos.cz>,
	Felipe Balbi <felipebalbi@users.sourceforge.net>, tiwai@suse.de,
	Andrew Morton <akpm@linux-foundation.org>,
	"Klaus S. Madsen" <ksm@hjernemadsen.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <31e679430801270549u49e1c549qf602b36b07aabc2b@mail.gmail.com> <20080204194038.d8851b8d.akpm@linux-foundation.org> <20080205113633.GI27738@hjernemadsen.org> <20080205102219.83fe459d.akpm@linux-foundation.org> <31e679430802051304l7c1d68d8r153c753a5b96087a@mail.gmail.com> <Pine.LNX.4.64.0802052207330.30873@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802052207330.30873@twin.jikos.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 10:16:08PM +0100, Jiri Kosina wrote:
> [ added Takashi ]
> 
> On Tue, 5 Feb 2008, Felipe Balbi wrote:
> 
> > > > > > Could anyone make T61P's ICH8 sound controller to work properly?
> > Good that there's a lot of people using T61p, it's a good machine.
> > I'll upgrade my BIOS and try again the crappy sound.
> 
> I have just bought X61s, and it seems to have the very same soundcard as 
> your T61p does:
>
> The sound also doesn't work with 2.6.24 (tried modprobing the 
> snd-hda-intel with 'model=thinkpad', didn't make any difference). The 
> mixer settings seem to be correct, but there is no sound.
> 

Hmm.. sound works just fine for me on my X61s (model #7668-CTO)
running 2.6.24.  

I do have this private patch applied --- maybe it makes a difference
for you?  I don't think it should make a difference, but....

						- Ted


commit c9001b03378048cad0f5c4f87dbb97fff1f80c51
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed Jan 9 05:14:14 2008 -0500

    hda_intel suspend latency: shorten codec read
    
    not sleeping for every codec read/write but doing a short udelay and
    a conditional reschedule has cut suspend+resume latency by about 1
    second on my T60.
    
    The patch also fixes the unexpected codec-connection errors that
    happen more often in the new power-save mode:
        http://lkml.org/lkml/2007/11/8/255
        http://bugzilla.kernel.org/show_bug.cgi?id=9332
    
    This had been applied, and then reverted due to problems.  See commit
    d238998fbfa49f30b02f0a5de5294ca53c58348c
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Acked-by: Takashi Iwai <tiwai@suse.de>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

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
