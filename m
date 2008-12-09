Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbYLIXoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbYLIXoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 18:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbYLIXnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 18:43:52 -0500
Received: from mail-bw0-f13.google.com ([209.85.218.13]:58022 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbYLIXnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 18:43:52 -0500
X-Greylist: delayed 13967 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2008 18:43:51 EST
Date: Wed, 10 Dec 2008 00:43:46 +0100
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: zdenek.kabelac@gmail.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "David S. Miller" <davem@davemloft.net>, stable@kernel.org
Subject: Re: BUG: bad unlock balance detected! e1000e
Message-ID: <20081209234346.GB7394@gambetta>
References: <c4e36d110812080324y68c0e453qcb68a040da7ac9a2@mail.gmail.com> <20081209110337.GJ4864@gambetta> <20081209150801.2aa76ac6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081209150801.2aa76ac6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2008 at 03:08:01PM -0800, Andrew Morton wrote:
> On Tue, 9 Dec 2008 12:03:37 +0100
> Frederik Deweerdt <frederik.deweerdt@xprog.eu> wrote:
> 
> > It some error checking is missing in e1000e: debug contention on NVM
> > SWFLAG
> > On Mon, Dec 08, 2008 at 12:24:09PM +0100, Zdenek Kabelac wrote:
> > > Hi
> > > 
> > > During occasional scan of message log - I've found out this BUG which
> > > happened on Dec3 with the -rc7 from that day.
> > > (So if it's now fixed in current git feel free to ignore :))
> > > 
> > > My machine T61 - C2D, 2GB, 64bit kernel - message appeared during
> > > shutdown and was actually not noticed by me...
> > > 
> > > 
> > > NetworkManager: <WARN>  nm_signal_handler(): Caught signal 15,
> > > shutting down normally.
> > > NetworkManager: <info>  (eth0): now unmanaged
> > > NetworkManager: <info>  (eth0): device state change: 3 -> 1
> > > NetworkManager: <info>  (eth0): cleaning up...
> > > NetworkManager: <info>  (eth0): taking down device.
> > > 
> > > =====================================
> > > [ BUG: bad unlock balance detected! ]
> > > -------------------------------------
> 
> (top-posting repaired.  Please don't do that!!!).
Yep, sorry.
> 
> > Hello Zdenek,
> > 
> > This could be due to 717d438d1fde94decef874b9808379d1f4523453
> >     "e1000e: debug contention on NVM SWFLAG"
> > Error handling is missing from e1000_reset_hw_ich8lan so it may happen
> > that we don't acquire the nvm_mutex if the card times out.
> > 
> > Adding Thomas to CC.
> 
> yup.  2.6.27 needs fixing also.
> 
> Like this?
I don't think so, e1000_acquire_swflag_ich8lan() locks and
e1000_release_swflag_ich8lan() unlocks. I think it is more along the
lines of:


diff --git a/drivers/net/e1000e/ich8lan.c b/drivers/net/e1000e/ich8lan.c
index 523b971..f971b83 100644
--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -1892,7 +1892,13 @@ static s32 e1000_reset_hw_ich8lan(struct e1000_hw *hw)
 		 */
 		ctrl |= E1000_CTRL_PHY_RST;
 	}
+
 	ret_val = e1000_acquire_swflag_ich8lan(hw);
+	if (ret_val) {
+		hw_dbg(hw, "Failed to acquire NVM swflag");
+		return ret_val;
+	}
+
 	hw_dbg(hw, "Issuing a global reset to ich8lan");
 	ew32(CTRL, (ctrl | E1000_CTRL_RST));
 	msleep(20);


But I'm not sure we should cancel the ongoing reset if the card times
out... 


Regards,
Frederik

> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> =====================================
> [ BUG: bad unlock balance detected! ]
> -------------------------------------
> 
> A regression added by 717d438d1fde94decef874b9808379d1f4523453 ("e1000e:
> debug contention on NVM SWFLAG").
> 
> Reported-by: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
> Cc: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: <stable@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/net/e1000e/ich8lan.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff -puN drivers/net/e1000e/ich8lan.c~drivers-net-e1000e-ich8lanc-fix-locking drivers/net/e1000e/ich8lan.c
> --- a/drivers/net/e1000e/ich8lan.c~drivers-net-e1000e-ich8lanc-fix-locking
> +++ a/drivers/net/e1000e/ich8lan.c
> @@ -400,6 +400,7 @@ static s32 e1000_acquire_swflag_ich8lan(
>  {
>  	u32 extcnf_ctrl;
>  	u32 timeout = PHY_CFG_TIMEOUT;
> +	s32 ret = 0;
>  
>  	might_sleep();
>  
> @@ -427,11 +428,11 @@ static s32 e1000_acquire_swflag_ich8lan(
>  		extcnf_ctrl &= ~E1000_EXTCNF_CTRL_SWFLAG;
>  		ew32(EXTCNF_CTRL, extcnf_ctrl);
>  		nvm_owner = -1;
> -		mutex_unlock(&nvm_mutex);
> -		return -E1000_ERR_CONFIG;
> +		ret = -E1000_ERR_CONFIG;
>  	}
>  
> -	return 0;
> +	mutex_unlock(&nvm_mutex);
> +	return ret;
>  }
>  
>  /**
> _
> 
