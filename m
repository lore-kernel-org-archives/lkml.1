Return-Path: <linux-kernel-owner+w=401wt.eu-S934060AbZHEK0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934060AbZHEK0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 06:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933950AbZHEK0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 06:26:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53039 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933178AbZHEK0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 06:26:12 -0400
Date: Wed, 5 Aug 2009 11:26:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Takashi Iwai <tiwai@suse.de>
Cc: Colin Guthrie <cguthrie@mandriva.org>, Tejun Heo <teheo@suse.de>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] sound: make OSS device number claiming optional
Message-ID: <20090805112649.4a59ce70@lxorguk.ukuu.org.uk>
In-Reply-To: <s5h63d2o9ds.wl%tiwai@suse.de>
References: <4A79283E.7030202@kernel.org>
	<4A79296A.4090600@suse.de>
	<20090805101551.6ee053e5@lxorguk.ukuu.org.uk>
	<4A794FB9.30403@mandriva.org>
	<20090805105916.28f84a05@lxorguk.ukuu.org.uk>
	<s5h63d2o9ds.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As far as I understand, the current problem is that ALSA core becomes
> dependent when you build with CONFIG_SND_*_OSS config, even if you
> load no snd-*-oss modules and use only ALSA-native ones.  It's because
> the OSS device registration is done through the ALSA snd module.
> Thus, loading ALSA modules always results in loading soundcore
> module, too.

That isn't a bug, but a feature.

> So... instead of hacking around soundcore stuff, splitting off the OSS
> (soundcore) dependency from ALSA snd module could be another solution?
> Then soundcore doesn't have to be loaded unless you load snd-*-oss or
> any real OSS modules.

This makes it worse.

> One drawback is that this splits to yet another module.  Or, maybe it
> can be put into somewhere else...

Currently I can load bits of OSS driver, ALSA drivers and something else
at the same time and soundcore will properly share the major number
between devices and do allocations (Just as miscdevice does with its
major).

If people start hacking around the interface rather than using it
properly then the end user is left with

- obscure magical configuration Kconfig items
- a weird boot parameter/module option
- no ability to mix and match

Exactly why is that a forward step compared with teaching CUSE to behave
like a civilised kernel driver with regard to sound ?

If CUSE/Sound is fixed to use the sound APIs then lo and behold

- no weird options
- no weird boot parameters
- mix and match just works

no user intervention, no complexity to the end user, and more flexible
all around.

(Its also better for debug as you can load two different versions of the
CUSE/Sound stack at once ...)

Hence I still think this patch is an ugly pointless hack that is nothing
but private debug and quick hack stuff. Teach CUSE to behave and
everything works nicely. CUSE needs this sort of additional plug in
support anyway in order to do anything with it involving the other
multiplexed device interfaces (eg tty, video4linux, framebuffer, usb, ...)

