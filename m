Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbYLFRIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbYLFRIL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 12:08:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYLFRH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 12:07:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752086AbYLFRH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 12:07:56 -0500
Date: Sat, 6 Dec 2008 09:07:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 1/3] PCI: Rework default handling of suspend and resume
In-Reply-To: <200812061507.06474.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812060855580.3425@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812061505.33815.rjw@sisk.pl> <200812061507.06474.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> 
> Rework the handling of suspend and resume of PCI devices which have
> no drivers or the drivers of which do not provide any suspend-resume
> callbacks in such a way that their standard PCI configuration
> registers will be saved and restored with interrupts disabled.

Ok, I think this is good, but I _also_ think that we should do one more 
fix:

 - if a device uses the new-format suspend/resume structure, we should do 
   the low-level save-restore _unconditionally_ in the PCI layer.

Because apparently there is only a single user of the new format, and that 
single user got it wrong. So wouldn't it be much nicer to just _remove_ 
the code from the USB host controllers that does the save/restore thing.

Quite frankly, the USB code really does look wrong. Not just in that it 
enables the BAR's before restoring them, but on the suspend side it 
actually puts the device into D3_hot _before_ it then does the whole 
"pci_enable_wake()", which I'm not at all sure will necessarily work. I'm 
pretty sure that you should enable wakeup events _before_ going to sleep.

If the generic PCI layer unconditionally did the suspend as the last thing 
it does (and the resume as the first thing), then drivers couldn't do 
insane things like that, even by mistake.

Hmm?

				Linus


