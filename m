Return-Path: <linux-kernel-owner+w=401wt.eu-S1759150AbXK0Qwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150AbXK0Qwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 11:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbXK0QwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 11:52:25 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:39224 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353AbXK0QwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 11:52:24 -0500
Message-ID: <474C4B38.6030609@keyaccess.nl>
Date: Tue, 27 Nov 2007 17:52:08 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: trenn@suse.de
CC: ALSA devel <alsa-devel@alsa-project.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "yakui.zhao" <yakui.zhao@intel.com>,
       "Li, Shaohua" <shaohua.li@intel.com>, akpm <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [alsa-devel] [PATCH 2/3] PNP cleanups - Unify the pnp macros
 to access	resources in the pnp resource table
References: <1195552283.23700.166.camel@queen.suse.de>	 <20071120123102.03bdaa67@the-village.bc.nu>	 <1195568360.23700.202.camel@queen.suse.de> <4742EFBE.6030407@keyaccess.nl>	 <s5hejejj559.wl%tiwai@suse.de> <1196181292.23251.53.camel@queen.suse.de>
In-Reply-To: <1196181292.23251.53.camel@queen.suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27-11-07 17:34, Thomas Renninger wrote:

> On Wed, 2007-11-21 at 10:53 +0100, Takashi Iwai wrote:
>> At Tue, 20 Nov 2007 15:31:26 +0100, Rene Herman wrote:
>>> On 20-11-07 15:19, Thomas Renninger wrote:
>>> 
>>>> At the end is some example code how things could get even more
>>>> cleaned up. It shows how I think pnp layer and one example driver
>>>> would get adjusted. There are not that much drivers making use of 
>>>> pnp_resource_change...
>>> 
>>> The ALSA ISA-PnP drivers do in what I personally consider a bad
>>> layering violation. Brought up not doing that a while ago on
>>> alsa-devel, but no discussion ensued. If the PnP maintainer(s) agree
>>> with me though, I'd be more than happy to rip all of that out of
>>> ALSA.
> 
> Rene: Could you do that, pls.

Yes, I will do this, In fact, I've done a few already but ofcourse a few 
other things intervened again...

>> I'm fine with removal of that stuff now.  It was implemented in that
>> way because there was no proper way to re-assign ISA PnP resources on
>> 2.4 kernel time.  On 2.6, it makes no longer any sense (except for
>> compatibility, but this is almost no problem for PnP boards).
> 
> I wasted some time on thinking about how this pnp_resource_change and
> pnp_manual_config_dev could get workarounded..., but it's impossible
> without changing the (more a workaround than an) interface.
> 
> If you worked on this already, would you mind ripping these out?
> 
> If I understand Takashi correctly, the driver code using
> pnp_resource_change and pnp_manual_config_dev can simply be removed and
> devices could get resources assigned via sysfs "set" interface.

Exactly. ISA-PnP is with respect to the interface it provides exactly as PCI 
and other sane busses. You just ask the system what resources to use -- it 
provides a method for actually changing them as well, but doing so belongs 
isolated in the PnP layer, not anywhere else IMHYUO (*).

Wasn't aware of the original reason for this setup, but yes, in 2.6 it 
certainly isn't needed for anything anymore and in fact just makes for 
inconsistency, especially for the mixed legacy/isapnp drivers where module 
parameters change meaning from "this is where it's at to "_put_ it there" 
between the two card types.

Jaroslav Kysela will have to ack any patches as well, but sound/isa is the 
only user of

- pnp_init_resource_table()
- pnp_resource_change()
- pnp_manual_config_dev()

which eventually then might also want to be unexported and/or deleted.

Rene.

(*) In My Humble Yet Unwavering Opinion...
