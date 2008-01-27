Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbYA0Vu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbYA0Vu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 16:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYA0Vur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 16:50:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39316 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751777AbYA0Vuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 16:50:46 -0500
Date: Mon, 28 Jan 2008 08:50:24 +1100 (EST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@www.l.google.com
To: Avuton Olrich <avuton@gmail.com>
cc: Zhao Yakui <yakui.zhao@intel.com>, Li Shaohua <shaohua.li@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Thomas Renninger <trenn@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Linux-Kernel," <linux-kernel@vger.kernel.org>,
       Alsa-Devel <alsa-devel@alsa-project.org>
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0
 sound card
In-Reply-To: <3aa654a40801270640s59cfdcc4lfa3fb487e0d9b799@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0801280841440.4544@www.l.google.com>
References: <3aa654a40801270640s59cfdcc4lfa3fb487e0d9b799@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 27 Jan 2008, Avuton Olrich wrote:
>
> With v2.6.24 my second ALSA sound device stopped working.

Hmm. Why is PnP ACPI called before PCI probing? That seems to be the 
problem here - we should *never* have any firmware allocation block known 
hardware BARs, they should only be blocking new dynamic allocations.

Hmm. I wonder if the problem is that ACPIPnP marks the regions busy. That 
would be wrong. They shouldn't be busy, they should just "exist".

A busy region will stop a "request_region()" (incorrect for this case - 
thats' not what the PnP resurce allocation should be all about), but an 
*existing* resource will just stop a new resource being dynamically 
assigned to that address (not not stop a known resource from using it).

So maybe the ACPIPnP allocation is doen at the right moment, just doing 
the wrong thing..

		Linus
