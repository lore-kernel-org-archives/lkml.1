Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621AbZLMPVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbZLMPVY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 10:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbZLMPVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 10:21:23 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:43928 "HELO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753426AbZLMPVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 10:21:22 -0500
Date: Sun, 13 Dec 2009 16:21:19 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: walter harms <wharms@bfs.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 9/9] sound/soc/codecs: Correct code taking the size of
 a pointer
In-Reply-To: <4B24F58C.4050502@bfs.de>
Message-ID: <Pine.LNX.4.64.0912131613380.27767@ask.diku.dk>
References: <Pine.LNX.4.64.0912131242570.24267@ask.diku.dk> <4B24F58C.4050502@bfs.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Dec 2009, walter harms wrote:

> 
> 
> Julia Lawall schrieb:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > sizeof(codec->reg_cache) is just the size of the pointer.  Elsewhere in the
> > file, codec->reg_cache is used with sizeof(wm8900_reg_defaults), so the
> > code is changed to do the same here.
> > 
> > A simplified version of the semantic patch that finds this problem is as
> > follows: (http://coccinelle.lip6.fr/)
> > 
> > // <smpl>
> > @@
> > expression *x;
> > expression f;
> > type T;
> > @@
> > 
> > *f(...,(T)x,...)
> > // </smpl>
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> > 
> > ---
> >  sound/soc/codecs/wm8900.c           |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/sound/soc/codecs/wm8900.c b/sound/soc/codecs/wm8900.c
> > index c9438dd..dbc368c 100644
> > --- a/sound/soc/codecs/wm8900.c
> > +++ b/sound/soc/codecs/wm8900.c
> > @@ -199,7 +199,7 @@ static void wm8900_reset(struct snd_soc_codec *codec)
> >  	snd_soc_write(codec, WM8900_REG_RESET, 0);
> >  
> >  	memcpy(codec->reg_cache, wm8900_reg_defaults,
> > -	       sizeof(codec->reg_cache));
> > +	       sizeof(wm8900_reg_defaults));
> >  }
> 
> I do not think that this was the intention of the original author,
> I guess the idea behind sizeof(*codec->reg_cache) was to protect
> the area behind it (in case wm8900_reg_defaults are badly defined).

sizeof(codec->reg_cache) is the size of a pointer (void *).  
sizeof(*codec->reg_cache) is then the size of void.  wm8900_reg_defaults 
is a static constant array defined a few lines before this code:

static const u16 wm8900_reg_defaults[WM8900_MAXREG] = { ... };

Later in the same file there is:

 cache = kmemdup(codec->reg_cache, sizeof(wm8900_reg_defaults),
                       GFP_KERNEL);

and codec->reg_cache is initialized as follows:

  codec->reg_cache = &wm8900->reg_cache[0];

The reg_cache field in wm8900 is declared as u16 reg_cache[WM8900_MAXREG];

julia
