Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbYLFB4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbYLFB4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 20:56:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbYLFBz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 20:55:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753636AbYLFBz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 20:55:56 -0500
Date: Fri, 5 Dec 2008 17:55:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <200812060218.13030.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812051750450.3425@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812060104.50050.rjw@sisk.pl> <alpine.LFD.2.00.0812051647130.3425@nehalem.linux-foundation.org> <200812060218.13030.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
>
> It only affects the legacy handling, but the non-legacy handling was left
> untouched.  IOW, the old "default" functions are still there and are being
> called by the "non-legacy" code (it's only used by USB at the moment, AFAICS).

Ok.

> Anyway, I did the test doing it only to the devices which don't have any
> non-default suspend-resume handling at all and _that_ apparently fixed the
> problem on my box. :-)

Which makes sense, btw. Because if you do the pci_save_state() on a device 
that _does_ have a suspend function, you'll be saving the post-suspend 
state - ie the device turned off.

So yeah, we really can only do the default suspend if the device has no 
pre-existing suspend function - or we'd need to make sure that all PCI 
drivers that do have suspend functions would only do the higher-level 
functionality.

Anyway, what I'm most interested in hearing is whether this actually 
improves your situation. I can _easily_ see that your resume problem could 
be due to interrupt timing. That's especially true if there are shared 
interrupts, but even in the absense of that, I'm not at all sure that the 
e1000e resume code is interrupt-safe, for example.

		Linus
