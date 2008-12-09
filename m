Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbYLIX5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbYLIX5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 18:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbYLIX5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 18:57:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753930AbYLIX5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 18:57:17 -0500
Date: Tue, 9 Dec 2008 15:56:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Cc: zdenek.kabelac@gmail.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       netdev@vger.kernel.org, jesse.brandeburg@intel.com, davem@davemloft.net,
       stable@kernel.org, e1000-devel@lists.sourceforge.net
Subject: Re: BUG: bad unlock balance detected! e1000e
Message-Id: <20081209155655.e82f9c24.akpm@linux-foundation.org>
In-Reply-To: <20081209234346.GB7394@gambetta>
References: <c4e36d110812080324y68c0e453qcb68a040da7ac9a2@mail.gmail.com>
	<20081209110337.GJ4864@gambetta>
	<20081209150801.2aa76ac6.akpm@linux-foundation.org>
	<20081209234346.GB7394@gambetta>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 00:43:46 +0100
Frederik Deweerdt <frederik.deweerdt@xprog.eu> wrote:

> On Tue, Dec 09, 2008 at 03:08:01PM -0800, Andrew Morton wrote:
> > On Tue, 9 Dec 2008 12:03:37 +0100
> > Frederik Deweerdt <frederik.deweerdt@xprog.eu> wrote:
> > 
> > > It some error checking is missing in e1000e: debug contention on NVM
> > > SWFLAG
> > > On Mon, Dec 08, 2008 at 12:24:09PM +0100, Zdenek Kabelac wrote:
> > > > Hi
> > > > 
> > > > During occasional scan of message log - I've found out this BUG which
> > > > happened on Dec3 with the -rc7 from that day.
> > > > (So if it's now fixed in current git feel free to ignore :))
> > > > 
> > > > My machine T61 - C2D, 2GB, 64bit kernel - message appeared during
> > > > shutdown and was actually not noticed by me...
> > > > 
> > > > 
> > > > NetworkManager: <WARN>  nm_signal_handler(): Caught signal 15,
> > > > shutting down normally.
> > > > NetworkManager: <info>  (eth0): now unmanaged
> > > > NetworkManager: <info>  (eth0): device state change: 3 -> 1
> > > > NetworkManager: <info>  (eth0): cleaning up...
> > > > NetworkManager: <info>  (eth0): taking down device.
> > > > 
> > > > =====================================
> > > > [ BUG: bad unlock balance detected! ]
> > > > -------------------------------------
> > 
> > (top-posting repaired.  Please don't do that!!!).
> Yep, sorry.
> > 
> > > Hello Zdenek,
> > > 
> > > This could be due to 717d438d1fde94decef874b9808379d1f4523453
> > >     "e1000e: debug contention on NVM SWFLAG"
> > > Error handling is missing from e1000_reset_hw_ich8lan so it may happen
> > > that we don't acquire the nvm_mutex if the card times out.
> > > 
> > > Adding Thomas to CC.
> > 
> > yup.  2.6.27 needs fixing also.
> > 
> > Like this?
> I don't think so, e1000_acquire_swflag_ich8lan() locks and
> e1000_release_swflag_ich8lan() unlocks.

urgh, OK, I made the mistake of reading the comments.

> I think it is more along the
> lines of:
> 
> 
> diff --git a/drivers/net/e1000e/ich8lan.c b/drivers/net/e1000e/ich8lan.c
> index 523b971..f971b83 100644
> --- a/drivers/net/e1000e/ich8lan.c
> +++ b/drivers/net/e1000e/ich8lan.c
> @@ -1892,7 +1892,13 @@ static s32 e1000_reset_hw_ich8lan(struct e1000_hw *hw)
>  		 */
>  		ctrl |= E1000_CTRL_PHY_RST;
>  	}
> +
>  	ret_val = e1000_acquire_swflag_ich8lan(hw);
> +	if (ret_val) {
> +		hw_dbg(hw, "Failed to acquire NVM swflag");
> +		return ret_val;
> +	}
> +
>  	hw_dbg(hw, "Issuing a global reset to ich8lan");
>  	ew32(CTRL, (ctrl | E1000_CTRL_RST));
>  	msleep(20);
> 
> 
> But I'm not sure we should cancel the ongoing reset if the card times
> out... 
> 

Yes, something like that.  Or something like

--- a/drivers/net/e1000e/ich8lan.c~a
+++ a/drivers/net/e1000e/ich8lan.c
@@ -1940,12 +1940,14 @@ static s32 e1000_reset_hw_ich8lan(struct
 		ctrl |= E1000_CTRL_PHY_RST;
 	}
 	ret_val = e1000_acquire_swflag_ich8lan(hw);
-	hw_dbg(hw, "Issuing a global reset to ich8lan\n");
-	ew32(CTRL, (ctrl | E1000_CTRL_RST));
-	msleep(20);
+	if (!ret_val) {
+		hw_dbg(hw, "Issuing a global reset to ich8lan\n");
+		ew32(CTRL, (ctrl | E1000_CTRL_RST));
+		msleep(20);
 
-	/* release the swflag because it is not reset by hardware reset */
-	e1000_release_swflag_ich8lan(hw);
+		/* release the swflag because it is not reset by hardware reset */
+		e1000_release_swflag_ich8lan(hw);
+	}
 
 	ret_val = e1000e_get_auto_rd_done(hw);
 	if (ret_val) {
_


Dunno. It's e1000-developer-summoning-dance time.
