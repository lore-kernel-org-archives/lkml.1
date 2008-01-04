Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbYADKmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbYADKmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 05:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbYADKmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 05:42:18 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:47163 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbYADKmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 05:42:17 -0500
Date: Fri, 4 Jan 2008 11:42:28 +0100
From: Matthias Goebl <matthias@goebl.net>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, kkeil@suse.de, kai.germaschewski@gmx.de
Subject: Re: [PATCH] isdn/i4l: Fix DLE handling for i4l-audio
Message-ID: <20080104104228.GX19071@night.goebl.net>
References: <20080103220003.GU19071@night.goebl.net> <20080104.021437.238302886.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104.021437.238302886.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 02:14:37AM -0800, David Miller wrote:
> From: Matthias Goebl <matthias@goebl.net>
> Date: Thu, 3 Jan 2008 23:00:03 +0100
> 
> > --- linux-2.6.23.12.orig/drivers/isdn/i4l/isdn_tty.c	2007-12-22 21:13:49.000000000 +0100
> > +++ linux-2.6.23.12/drivers/isdn/i4l/isdn_tty.c	2007-12-26 11:37:18.000000000 +0100
> > @@ -85,6 +85,8 @@
> >  								tty_insert_flip_char(tty, DLE, 0);
> >  							tty_insert_flip_char(tty, *dp++, 0);
> >  						}
> > +						if (*dp == DLE)
> > +							tty_insert_flip_char(tty, DLE, 0);
> >  						last = *dp;
> >  					} else {
> >  #endif
> 
> I'm not sure this part is correct.
> 
> Here, *dp will be assigned to 'last'.

The while (--l) {...} pushes+adds DLE for len-1 characters.
( while (l--) would process all len characters)
The last charater is assigned to "last" and pushed after the else block:

> The rest of the code (after the else block) then reads:
> 
> 					if (info->emu.mdmreg[REG_CPPP] & BIT_CPPP)
> 						tty_insert_flip_char(tty, last, 0xFF);
> 					else
> 						tty_insert_flip_char(tty, last, TTY_NORMAL);
> 
> which should push that character out to the TTY.

But this does not care about a DLE and doesn't escape that with another DLE.

> With your change we will push a DLE out twice in such a case,
> and that doesn't seem right.

For an audio data stream we have to escape DLE (ascii 16) by another DLE,
otherwise it is interpreted as command, as in Documentation/isdn/README.audio:
...  escape sequences defined, all using DLE (0x10) as Escape char:...
    <DLE><DLE>              Escape sequence for DLE in data stream.
    <DLE>0                  Touchtone "0" received.
...
