Return-Path: <linux-kernel-owner+w=401wt.eu-S1757855AbZHQLnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbZHQLnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 07:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757838AbZHQLni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 07:43:38 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:25945 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831AbZHQLnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 07:43:37 -0400
Date: Mon, 17 Aug 2009 14:43:32 +0300
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/3] MFD: TWL4030: print warning for out-of-order
 script loading
Message-ID: <20090817114332.GC5007@everest>
Mail-Followup-To: Samuel Ortiz <sameo@linux.intel.com>,
	dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-omap@vger.kernel.org
References: <1247050175-31163-1-git-send-email-amit.kucheria@verdurent.com>
 <20090804180044.GH8601@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090804180044.GH8601@sortiz.org>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09 Aug 04, Samuel Ortiz wrote:
> Hi Amit,
> 
> On Wed, Jul 08, 2009 at 01:49:35PM +0300, Amit Kucheria wrote:
> > When the sleep script is loaded before the wakeup script, there is a
> > chance that the system might go to sleep before the wakeup script
> > loading is completed. This will lead to a system that does not wakeup
> > and has been observed to cause non-booting boards.
> > 
> > Various options were considered to solve this problem, including
> > modification of the core twl4030 power code to be smart enough to
> > reorder the loading of the scripts. But it felt too over-engineered.
> > 
> > Hence this patch just warns the DPS script developer so that they may be
> > reordered in the board-code itself.
> > 
> > Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
> > ---
> >  drivers/mfd/twl4030-power.c |   11 +++++++++--
> >  1 files changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
> > index bb9e45f..ef4cc4e 100644
> > --- a/drivers/mfd/twl4030-power.c
> > +++ b/drivers/mfd/twl4030-power.c
> > @@ -315,6 +315,7 @@ static int __init load_triton_script(struct twl4030_script *tscript)
> >  {
> >  	u8 address = triton_next_free_address;
> >  	int err;
> > +	static u8 mask = 0;
> >  
> >  	/* Make sure the script isn't going beyond last valid address */
> >  	if ((address + tscript->size) > (END_OF_SCRIPT-1)) {
> > @@ -331,14 +332,20 @@ static int __init load_triton_script(struct twl4030_script *tscript)
> >  	if (tscript->flags & TRITON_WRST_SCRIPT)
> >  		err |= config_warmreset_sequence(address);
> >  
> > -	if (tscript->flags & TRITON_WAKEUP12_SCRIPT)
> > +	if (tscript->flags & TRITON_WAKEUP12_SCRIPT) {
> >  		err |= config_wakeup12_sequence(address);
> > +		mask |= TRITON_WAKEUP12_SCRIPT;
> > +	}
> >  
> >  	if (tscript->flags & TRITON_WAKEUP3_SCRIPT)
> >  		err |= config_wakeup3_sequence(address);
> >  
> > -	if (tscript->flags & TRITON_SLEEP_SCRIPT)
> > +	if (tscript->flags & TRITON_SLEEP_SCRIPT) {
> Wouldnt something like:
> 
>      if (tscript->flags & (TRITON_SLEEP_SCRIPT | TRITON_WAKEUP12_SCRIPT)) {
> 
> save us from using an additional mask variable and simplify this patch ?
> 

I don't see how this will save the mask variable. What I need to detect
that the SLEEP script is loaded before the WAKEUP script. That should
trigger a warning.

-- 
-------------------------------------------------------------------------
Amit Kucheria,				 Kernel Developer, Verdurent
-------------------------------------------------------------------------
