Return-Path: <linux-kernel-owner+w=401wt.eu-S1759252AbYHCSIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252AbYHCSIS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 14:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbYHCSII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 14:08:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:7585 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbYHCSIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 14:08:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ax/2OCd7vzUHJr2q3lggy/vJxsR0RGoR+X+ciZFWweJQtJgO3RzVKCNvtfz21E14vC
         zKGks6H35Ow3ZsWBsyYWCCNtblXmyeWbkH1Mu7VZ0Hv/xmRvm5eLn/r0ZubhEn9hamUn
         RzT/ZqWZHirvf7DCmX9zeM+9mcmApsFIncn2s=
Date: Sun, 3 Aug 2008 20:07:22 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Sven Wegener <sven.wegener@stealer.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@perex.cz>
Subject: Re: [PATCH] ALSA: pcm_native: remove unused label
Message-ID: <20080803180706.GA8691@joi>
References: <20080803164719.GA5414@joi> <alpine.LNX.1.10.0808031921280.7765@titan.stealer.net> <alpine.LNX.1.10.0808031931150.7765@titan.stealer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0808031931150.7765@titan.stealer.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 07:33:19PM +0200, Sven Wegener wrote:
> On Sun, 3 Aug 2008, Sven Wegener wrote:
> 
> > On Sun, 3 Aug 2008, Marcin Slusarz wrote:
> > 
> > > gcc warns about it:
> > > sound/core/pcm_native.c: In function 'snd_pcm_fasync':
> > > sound/core/pcm_native.c:3262: warning: label 'out' defined but not used
> > > 
> > > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > > Cc: Takashi Iwai <tiwai@suse.de>
> > > Cc: Jaroslav Kysela <perex@perex.cz>
> > > ---
> > >  sound/core/pcm_native.c |    1 -
> > >  1 files changed, 0 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
> > > index c49b9d9..333cff6 100644
> > > --- a/sound/core/pcm_native.c
> > > +++ b/sound/core/pcm_native.c
> > > @@ -3259,7 +3259,6 @@ static int snd_pcm_fasync(int fd, struct file * file, int on)
> > >  	runtime = substream->runtime;
> > >  
> > >  	err = fasync_helper(fd, file, on, &runtime->fasync);
> > > -out:
> > >  	unlock_kernel();
> > >  	if (err < 0)
> > >  		return err;
> > 
> > Uhm, no, there's
> > 
> > snd_assert(substream != NULL, goto out);
> > 
> > one line above your context.

Brown paper bag for me, please.
But for my defense, here's the code:

static int snd_pcm_fasync(int fd, struct file * file, int on)
{
	struct snd_pcm_file * pcm_file;
	struct snd_pcm_substream *substream;
	struct snd_pcm_runtime *runtime;
	int err = -ENXIO;

	lock_kernel();
	pcm_file = file->private_data;
	substream = pcm_file->substream;
	snd_assert(substream != NULL, goto out);
	runtime = substream->runtime;

	err = fasync_helper(fd, file, on, &runtime->fasync);
out:
	unlock_kernel();
	if (err < 0)
		return err;
	return 0;
}

It's a bit weird to have constructs like snd_assert which look
like function call, but actually changes program flow...

> And that is broken. That's not what an assert is for, we access 
> substream->runtime a line later and that will blow up. That should be a 
> simpe if, instead of an assert.

I would say this whole snd_assert macro is broken...

$ git grep snd_assert|wc -l
829
$ git grep snd_assert|grep return|wc -l
722
$ git grep snd_assert|grep return|grep NULL|wc -l
381

Marcin

