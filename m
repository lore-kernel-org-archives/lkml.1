Return-Path: <linux-kernel-owner+w=401wt.eu-S932737AbZGPQZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737AbZGPQZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932722AbZGPQZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:25:41 -0400
Received: from outbound-mail-145.bluehost.com ([67.222.38.35]:39335 "HELO
	outbound-mail-145.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932712AbZGPQZk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:25:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=NzLHU/GxOI47kOJhRhGhSPF8bob+iofKhs6FJrawLCxKVC+rjlHuDUL47tx0Q30Y3jiYt5E5c8kbncqGGgSZT7wzwdc5+BQKoUG63yCZ/2c64y2W91XeK/2f9AMbvrRH;
Date: Thu, 16 Jul 2009 09:25:36 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Tiago Vignatti <tiago.vignatti@nokia.com>,
       Dave Airlie <airlied@redhat.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vga: implements VGA arbitration on Linux
Message-ID: <20090716092536.134e8bd2@jbarnes-g45>
In-Reply-To: <21d7e9970907160338o50ede093pbef32f2d7d351f41@mail.gmail.com>
References: <1247576250-16274-1-git-send-email-tiago.vignatti@nokia.com>
	<1247576250-16274-2-git-send-email-tiago.vignatti@nokia.com>
	<20090714153509.51bbec27@lxorguk.ukuu.org.uk>
	<21d7e9970907152125i52dc3f4dqd540f7d65667cfb5@mail.gmail.com>
	<20090716094855.455c3f77@lxorguk.ukuu.org.uk>
	<21d7e9970907160338o50ede093pbef32f2d7d351f41@mail.gmail.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009 20:38:44 +1000
Dave Airlie <airlied@gmail.com> wrote:

> On Thu, Jul 16, 2009 at 6:48 PM, Alan Cox<alan@lxorguk.ukuu.org.uk>
> wrote:
> >> >> +     pci_read_config_word(pdev, PCI_COMMAND, &cmd);
> >> >> +     if (rsrc & (VGA_RSRC_LEGACY_IO | VGA_RSRC_NORMAL_IO))
> >> >> +             cmd |= PCI_COMMAND_IO;
> >> >> +     if (rsrc & (VGA_RSRC_LEGACY_MEM | VGA_RSRC_NORMAL_MEM))
> >> >> +             cmd |= PCI_COMMAND_MEMORY;
> >> >> +     pci_write_config_word(pdev, PCI_COMMAND, cmd);
> >> >
> >> > Locking question - what locks this lot against hotplug also
> >> > touching bridge settings ?
> >>
> >> well here we just bang on device config space registers which
> >> means we can probably
> >> race against lots of other things that rmw the PCI_COMMAND not
> >> just hotplug.
> >>
> >> Perhaps we need some sort per device PCI command space lock,
> >> granted this still means we race against anyone directly hacking it
> >> behind our backs.
> >
> > I suspect the right thing to do is to move that function into the
> > drivers/pci code and lock it properly there. That would keep all the
> > locking detail internal and private (and someone else's problem ;))
> 
> I'll have a look, Jesse any ideas? the hotplug bridge bashing looks
> unfun.
> 
> I noticed a fair few drivers seem to bash these things, and really
> pci_enable_device
> could possible race with hotplug.

Oh hm, yeah moving that sort of thing into the PCI core probably makes
sense.  Hotplug interactions would be good to get right here, since it
might be possible to implement switchable graphics machines that way...

-- 
Jesse Barnes, Intel Open Source Technology Center
