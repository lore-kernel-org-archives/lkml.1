Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbZETHZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbZETHZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbZETHZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:25:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:41865 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbZETHZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:25:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=qdgb9WGomJ4ec0/OIDdsLa+ZCGf+nKDJ9o2RTgjypabGRAGdOCO7vVw68Y186r4eKk
         ni0NRZ3IOaQtF/pI704ovPxv6vk939Ta5lQJaoF+cu5mRzY/04H+P5FL0ZTYwQ6XcSSS
         35njObWmekS1Tp4TazgOneqzwLq/35Zqu/Rig=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: EeePC 900 trackpad often not detected at boot in 2.6.30-rc4
Date: Wed, 20 May 2009 00:25:19 -0700
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc4; KDE/4.2.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, mingo@elte.hu
References: <20090511072135.GA4682@sucs.org> <20090520024658.GD17649@dtor-d630.eng.vmware.com> <20090520054739.GA31552@sucs.org>
In-Reply-To: <20090520054739.GA31552@sucs.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905200025.20280.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 May 2009 22:47:39 Sitsofe Wheeler wrote:
> On Tue, May 19, 2009 at 07:47:08PM -0700, Dmitry Torokhov wrote:
> > It is just unfortunate scheduling that messes us up:
>
> The really frustrating thing is that for a time this was happening quite
> consistently leading me to believe it was a kernel issue...
>

Well, it is a kernel issue... We really should not be waiting for over
1 sec for a process to be woken up.

> > > [    4.267050] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1,
> > > 12) [113] [    4.270440] drivers/input/serio/i8042.c: d4 -> i8042
> > > (command) [116] [    4.271016] drivers/input/serio/i8042.c: f2 -> i8042
> > > (parameter) [116] [    4.274883] ALSA device list:
> > > [    4.274963]   #0: HDA Intel at 0xf7eb8000 irq 16
> > > [    4.275258] TCP cubic registered
> > > [    4.276597] NET: Registered protocol family 17
> > > [    4.276802] Using IPI Shortcut mode
> > > [    4.279191]   Magic number: 9:810:70
> > > [    4.279548] rtc_cmos 00:03: setting system clock to 2009-05-18
> > > 09:03:27 UTC (1242637407) [    4.281412] drivers/input/serio/i8042.c:
> > > fa <- i8042 (interrupt, 1, 12) [127] [    4.283338]
> > > drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [129] [   
> > > 5.406620] libps2: errorneously fail 754 command
> >
> > As you can see the device responded to our command and interrupt fired
> > at 4.28 but for some reason the thread did not get woken up until 5.40,
> > second and a half later... Crazy if you ask me.
>
> It's worth noting that this kernel is stuffed full of debugging options
> as is running on an EeePC 900 with 900Mhz Celeron. I am also using the
> following boot parameters:
>
> root=/dev/sdb2 cfg80211.ieee80211_regdom=GB usb_storage.delay_use=0
> cfg80211 pcie_aspm=force pcie_aspm.policy=powersave fastboot ro
> rootfstype=ext2
>
> > In the meantime, the patch below should fix work around that delay.
>
> This one could be tough to test unless there is a way of forcing the
> awkward scheduling...

Umm.... you could try sticking

	if (timeout == 0)
		printk(KERN_INFO "libps2: BINGO!\n");


into the body of "if (psmouse->cmdcnt ...)" statement that was modified
by the patch I sent and see if it gets activated. If your mouse still
works with this message in the logs then the patch is working.
 
-- 
Dmitry
