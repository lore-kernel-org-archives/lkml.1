Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbXKEUJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbXKEUJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 15:09:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbXKEUI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 15:08:59 -0500
Received: from ns2.suse.de ([195.135.220.15]:58479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbXKEUI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 15:08:59 -0500
Date: Mon, 5 Nov 2007 12:03:34 -0800
From: Greg KH <gregkh@suse.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 22/54] kset: convert /sys/devices/system to use
	kset_create
Message-ID: <20071105200334.GA25947@suse.de>
References: <20071102235758.GA9803@kroah.com> <1194047972-9850-22-git-send-email-gregkh@suse.de> <20071105191109.52c07ab4@gondolin.boeblingen.de.ibm.com> <20071105185828.GA31896@suse.de> <20071105201132.3a3e443b@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071105201132.3a3e443b@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 08:11:32PM +0100, Cornelia Huck wrote:
> On Mon, 5 Nov 2007 10:58:28 -0800,
> Greg KH <gregkh@suse.de> wrote:
> 
> > On Mon, Nov 05, 2007 at 07:11:09PM +0100, Cornelia Huck wrote:
> > > On Fri,  2 Nov 2007 16:59:00 -0700,
> > > Greg Kroah-Hartman <gregkh@suse.de> wrote:
> > > 
> > > > Dynamically create the kset instead of declaring it statically.
> > > > 
> > > > Cc: Kay Sievers <kay.sievers@vrfy.org>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > > > ---
> > > >  drivers/base/sys.c |   28 ++++++++++++----------------
> > > >  1 files changed, 12 insertions(+), 16 deletions(-)
> > > 
> > > Unfortunately, at that point in the patch series reipl breaks for me :(
> > > 
> > > I used the following silly debug patch:
> > 
> > What does reipl have to do with shutdown?
> 
> Before we reipl (reboot), device_shutdown() is called.

Ah, ok.

> > > <loads of sane shutdowns for the ccw and css busses>
> > >     <7>io_subchannel 0.0.095c: shutdown (bus css)
> > >     <7>io_subchannel 0.0.095b: shutdown (bus css)
> > >     <7>io_subchannel 0.0.095a: shutdown (bus css)
> > >     <7> : shutdown (bus )
> > >     <1>Unable to handle kernel pointer dereference at virtual kernel address 0000000500000000
> > >     <4>Oops: 003b [#1]
> > >     <4>Modules linked in: dm_multipath sunrpc qeth ccwgroup dm_mod
> > >     <4>CPU:    2    Not tainted
> > >     <4>Process reboot (pid: 2892, task: 0000000002cae048, ksp: 00000000045c39b8)
> > >     <4>Krnl PSW : 0704000180000000 0000000500000006 (0x500000006)
> > >     <4>           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
> > >     <4>Krnl GPRS: 0000000000019e75 0000000500000006 0000000002c42810 0000000002c429b0
> > >     <4>           00000000002a36ec 0000000000000000 000003ffffb76d48 0000000000000160
> > >     <4>           00000000001423a4 000002000015e390 00000000006e06b8 0000000000634638
> > >     <4>           0000000002c42810 000000000041f670 00000000002a36fe 00000000045c3d00
> > >     <4>Krnl Code: Bad PSW.
> > >     <4>Call Trace:
> > >     <4>([<00000000002a36ec>] device_shutdown+0x78/0x144)
> > >     <4> [<000000000013f18c>] kernel_restart_prepare+0x44/0x50
> > >     <4> [<000000000013f1be>] kernel_restart+0x26/0x6c
> > >     <4> [<0000000000142548>] sys_reboot+0x1a4/0x1f4
> > >     <4> [<0000000000111038>] sysc_noemu+0x10/0x16
> > >     <4> [<00000200001048e0>] 0x200001048e0
> > >     <4>
> > >     <4> 
> > > 
> > > Huh? We want to shutdown an unknown device on a bus that wishes to stay
> > > anonymous?
> > > 
> > > Any hints would be appreciated...
> > 
> > I'll look into this, I wonder if we are walking off the end of an
> > unterminated list...
> 
> Could well be. If I'm using lcrash's walk function correctly (which
> always manages to confuse me...), the list of devices_kset seems to be
> broken.

Alright, I can reproduce something like this at shutdown time myself
here, I'll try to figure it out...

thanks,

greg k-h
