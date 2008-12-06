Return-Path: <linux-kernel-owner+w=401wt.eu-S1753192AbYLFRXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbYLFRXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 12:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYLFRXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 12:23:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60152 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbYLFRXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 12:23:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/3] PCI: Rework default handling of suspend and resume
Date: Sat, 6 Dec 2008 18:22:35 +0100
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812061507.06474.rjw@sisk.pl> <alpine.LFD.2.00.0812060855580.3425@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812060855580.3425@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812061822.35763.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 6 of December 2008, Linus Torvalds wrote:
> 
> On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> > 
> > Rework the handling of suspend and resume of PCI devices which have
> > no drivers or the drivers of which do not provide any suspend-resume
> > callbacks in such a way that their standard PCI configuration
> > registers will be saved and restored with interrupts disabled.
> 
> Ok, I think this is good, but I _also_ think that we should do one more 
> fix:
> 
>  - if a device uses the new-format suspend/resume structure, we should do 
>    the low-level save-restore _unconditionally_ in the PCI layer.
> 
> Because apparently there is only a single user of the new format, and that 
> single user got it wrong. So wouldn't it be much nicer to just _remove_ 
> the code from the USB host controllers that does the save/restore thing.

USB doesn't use that for PCI suspend-resume, it uses it for suspend-resume of
USB devices behind the controller.

> Quite frankly, the USB code really does look wrong. Not just in that it 
> enables the BAR's before restoring them, but on the suspend side it 
> actually puts the device into D3_hot _before_ it then does the whole 
> "pci_enable_wake()", which I'm not at all sure will necessarily work. I'm 
> pretty sure that you should enable wakeup events _before_ going to sleep.

Yeah.  Or simply use pci_prepare_to_sleep() and be done with it.

> If the generic PCI layer unconditionally did the suspend as the last thing 
> it does (and the resume as the first thing), then drivers couldn't do 
> insane things like that, even by mistake.
> 
> Hmm?

OK

But then we will save the device's registers in the "sleeping" state.  Is this
going to be entirely correct in all possible cases?  [pci_save_state() doesn't
save the PM registers, so that _should_ be correct, but I don't have _that_
much experience with these things.]

Rafael
