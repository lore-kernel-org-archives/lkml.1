Return-Path: <linux-kernel-owner+w=401wt.eu-S1752096AbYKNIa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbYKNIa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 03:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbYKNIaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 03:30:20 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:37351 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbYKNIaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 03:30:19 -0500
X-SourceIP: 213.46.9.244
Subject: Re: mmotm 2008-11-13-17-22 uploaded (pc-speaker)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Takashi Iwai <tiwai@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <s5hr65ek9fs.wl%tiwai@suse.de>
References: <200811140122.mAE1MeAG015836@imap1.linux-foundation.org>
	 <491D0A32.1020401@oracle.com> <s5hhc6alsop.wl%tiwai@suse.de>
	 <s5hej1els6i.wl%tiwai@suse.de> <1226649794.7685.6920.camel@twins>
	 <s5hr65ek9fs.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Fri, 14 Nov 2008 09:30:01 +0100
Message-Id: <1226651401.7685.6977.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 09:17 +0100, Takashi Iwai wrote:
> At Fri, 14 Nov 2008 09:03:14 +0100,
> Peter Zijlstra wrote:
> > 
> > On Fri, 2008-11-14 at 07:47 +0100, Takashi Iwai wrote:
> > > At Fri, 14 Nov 2008 07:36:54 +0100,
> > > I wrote:
> > > > 
> > > > At Thu, 13 Nov 2008 21:18:42 -0800,
> > > > Randy Dunlap wrote:
> > > > > 
> > > > > 
> > > > > mmotm-2008-1113-1722/sound/drivers/pcsp/pcsp.c: In function 'snd_card_pcsp_probe':
> > > > > mmotm-2008-1113-1722/sound/drivers/pcsp/pcsp.c:99: error: 'HRTIMER_CB_IRQSAFE' undeclared (first use in this function)
> > > > > 
> > > > > # CONFIG_SND_HRTIMER is not set
> > > > 
> > > > snd-pcsp and CONFIG_SND_HRTIMER are independent.
> > > > The snd-pcsp driver code isn't changed over weeks, thus it must be the
> > > > change in hrtimer side.
> > > 
> > > It's turned out to be the recent commint in the upstream:
> > > 
> > >   commit 621a0d5207c18012cb39932f2d9830a11a6cb03d
> > >   Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > >   Date:   Wed Nov 12 09:36:35 2008 +0100
> > > 
> > >     hrtimer: clean up unused callback modes
> > > 
> > >     Impact: cleanup
> > > 
> > >     git grep HRTIMER_CB_IRQSAFE revealed half the callback modes are actually
> > >     unused.
> > > 
> > >     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > 
> > > This hits on snd-pcsp driver on linux-next, since it was switched to
> > > use this dropped flag.  Now we get a build error.
> > > 
> > > Can this commit be reverted?
> > 
> > I think we determined the silly pc speaker driver should be using the
> > SOFTIRQ timer, why was this changed back again?
> 
> It uses a tasklet inside now.
> The background story is:   pcsp driver does register bit flips at each
> hrtimer callback.  This should be done as accurate as possible for the
> sound quality (heh, who matters?).  The register flip itself doesn't
> take time and no lock problem.  Thus, IRQSAFE is more appropriate just
> for this task.
> 
> The reason we used the softirq mode is the call of the ALSA core
> update part.  This is eventually called after the given samples have
> been processed.  And, this could cause a spin deadlock if called
> directly from hrtimer callback.
> 
> In the latest code, the call of ALSA PCM core is off-loaded via
> tasklet for avoiding both spin deadlock and too long hrtimer
> handling.

Aside from the fact that I think tasklets should die a horrible death
too, could you, for now, try to use HRTIMER_CB_IRQSAFE_UNLOCKED ?



