Return-Path: <linux-kernel-owner+w=401wt.eu-S1757716AbZLOHeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716AbZLOHeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 02:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757127AbZLOHeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 02:34:06 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:35484 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987AbZLOHeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 02:34:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gVvuyNEhYjkucHd1a0rHtk9rhap2kftAlfzfs16yPKub/ZNr8odh0Mebj/wMPMTexl
         rCZjzLMXxfhQwcj2by5UF9R1M4UXxC2Fef/uepUrh6w6Ic/YuLoYeZ8jsP/96ZHWDkmE
         KAIFoSYkCduuznppXnsRRU+5yPQ5lYKYnqj7g=
Date: Mon, 14 Dec 2009 23:33:58 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Alex Chiang <achiang@hp.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: synaptics touchpad doesn't click
Message-ID: <20091215073358.GC12669@core.coreip.homeip.net>
References: <20091214014828.GA28402@ldl.fc.hp.com> <20091214173450.GB2373@core.coreip.homeip.net> <20091215034127.GC587@ldl.fc.hp.com> <20091215062628.GA12669@core.coreip.homeip.net> <s5h1viwn3ig.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h1viwn3ig.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 07:40:55AM +0100, Takashi Iwai wrote:
> At Mon, 14 Dec 2009 22:26:28 -0800,
> Dmitry Torokhov wrote:
> > 
> > [1  <text/plain; us-ascii (7bit)>]
> > Hi Alex,
> > 
> > On Mon, Dec 14, 2009 at 08:41:27PM -0700, Alex Chiang wrote:
> > > 
> > > Thanks, I did grab Takashi's patches and verify that they work
> > > for me. I tested the separated patches, not the v2 combined
> > > patch, although it doesn't make any difference based on visual
> > > inspection of v2.
> > > 
> > > If you want, you can add my:
> > > 
> > > Tested-by: Alex Chiang <achiang@hp.com>
> > 
> > Thank you very much for testing, however could you please try a slightly
> > different patch below (I did not quite like that the original patch
> > mangled device's capability field and how it was reusing 'middle' field
> > for different things)? It should apply on top of patch that
> > I am attaching. I hope I did not screw it up too much,
> 
> I can't test the patch right now since I'm at home, but I'm afraid
> it's a bit different behavior.  Namely,
> 
> > @@ -330,20 +339,52 @@ static void synaptics_parse_new_hw(unsigned char buf[],
> >  				   struct synaptics_data *priv,
> >  				   struct synaptics_hw_state *hw)
> >  {
> > -	hw->x = (((buf[3] & 0x10) << 8) | ((buf[1] & 0x0f) << 8) | buf[4]);
> > -	hw->y = (((buf[3] & 0x20) << 7) | ((buf[1] & 0xf0) << 4) | buf[5]);
> > +	int x = (((buf[3] & 0x10) << 8) | ((buf[1] & 0x0f) << 8) | buf[4]);
> > +	int y = (((buf[3] & 0x20) << 7) | ((buf[1] & 0xf0) << 4) | buf[5]);
> >  
> >  	hw->z = buf[2];
> >  	hw->w = (((buf[0] & 0x30) >> 2) |
> >  		 ((buf[0] & 0x04) >> 1) |
> >  		 ((buf[3] & 0x04) >> 2));
> >  
> > -	hw->left  = buf[0] & 0x01;
> > -	hw->right = buf[0] & 0x02;
> > +	if (SYN_CAP_CLICKPAD(priv->ext_cap)) {
> > +		int click = (buf[0] ^ buf[3]) & 0x01;
> > +
> > +		if (click && y < YMIN_NOMINAL) {
> > +			/*
> > +			 * User pressed in ClickZone; report new button
> > +			 * state but use old coordinates and don't report
> > +			 * any pressure to prevent pointer movement.
> > +			 */
> > +			hw->left = x < CLICKPAD_LEFT_BTN_X;
> > +			hw->right = x > CLICKPAD_RIGHT_BTN_X;
> > +			hw->middle = x >= CLICKPAD_LEFT_BTN_X &&
> > +				     x <= CLICKPAD_RIGHT_BTN_X;
> > +			hw->z = 0;
> > +
> > +		} else {
> > +			/*
> > +			 * Finger is outside of the ClickZone - report
> > +			 * current coordinates.
> > +			 */
> > +			hw->x = x;
> > +			hw->y = y;
> > +
> > +			if (!click)
> > +				hw->left = hw->right = hw->middle = 0;
> > +		}
> 
> Here, when you touch outside the button area, left/right/middle are
> always zero because hw was initialized.  So the above code gives the
> click "released" state outside the button area.
> 

No, I got rid of resetting hw state to 0.

-- 
Dmitry
