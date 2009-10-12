Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbZJLJDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbZJLJDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755131AbZJLJDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:03:09 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:52622 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbZJLJDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:03:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DsXujPE+ILHrQUWvk8V7xhTFpvfW5MskHtXj5ct+i4CnII0O96NBNog0AFwm47dmKC
         akj6MKgPcKubHnbAonFayFth/tASnp/viPjF2MlzcXAPORTae5pBMKJ3+e2C0Ned3JEs
         YEynmXPZaiwf3VxUMfAoCDRlpl0mNLNR/z2Ic=
Date: Mon, 12 Oct 2009 02:02:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-input@vger.kernel.org
Subject: Re: [bisected regression] Touchpad "paste" stops working after
	suspend to RAM
Message-ID: <20091012090224.GB7403@core.coreip.homeip.net>
References: <20091011162155.GA4260@Pilar.aei.mpg.de> <20091011180134.GA5197@core.coreip.homeip.net> <20091011193100.GA4410@Pilar.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091011193100.GA4410@Pilar.aei.mpg.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 09:31:00PM +0200, Carlos R. Mafra wrote:
> On Sun 11.Oct'09 at 11:01:34 -0700, Dmitry Torokhov wrote:
> > Hi Carols,
> > 
> > On Sun, Oct 11, 2009 at 06:21:55PM +0200, Carlos R. Mafra wrote:
> > > Using the latest 2.6.32-rc3+ kernel, the "paste" operation via the 
> > > touchpad of my Vaio laptop does not work after suspend to RAM.
> > > 
> > > It works flawlessly before s2ram; I select the text with the touchpad
> > > and tap quickly its right corner to paste the selected text.
> > > After a plain 'echo mem > /sys/power/state' the "paste" does not work.
> > > 
> > > I bisected it to commit ffd0db97196c1057f09c2ab42dd5b30e94e511d9 ("Input: 
> > > add generic suspend and resume for input devices").
> > > 
> > > I haven't tested if reverting it from mainline fixes the issue, but 
> > > from the patch description I guess that bisection landed correctly
> > > on the culprit.
> > > 
> > 
> > Please verify that this is the real offending commit by reverting it - I
> > am surprised that it would give any trouble since it is supposed to
> > restore LED state and repeat rate and therefore should only be affecting
> > keyboards.
> 
> Reverting it fixes the issue, I've just tested it now.
> 
> [ I had to edit the resulting drivers/input/input.c because it did not 
>   revert cleanly. ]

Carols, I see in the dmesg you supplied earlier ALPS was redetected
successfully, so I guess the problem is that your synclient quirk did
not run after resume. The best way to handle it would be adding a HAL
rule, something like this:

<?xml version="1.0" encoding="ISO-8859-1"?>
<deviceinfo version="0.2">
        <device>
                <match key="input.x11_driver" contains="synaptics">
                        <merge key="input.x11_options.SHMConfig" type="string">On</merge>
                </match>
        </device>
</deviceinfo>

You'd need to add add the corner tapping command.

Still, I am curious to know why we can't simply reinitialize ALPS from
the get go, could you please send me a dmesg of resume done with
i8042.debug? Thanks!

-- 
Dmitry
