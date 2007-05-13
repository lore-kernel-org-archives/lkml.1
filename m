Return-Path: <linux-kernel-owner+w=401wt.eu-S1760062AbXEMTAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062AbXEMTAh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 15:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758105AbXEMTAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 15:00:10 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757924AbXEMTAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 15:00:08 -0400
Date: Sun, 13 May 2007 11:59:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Workaround for a PCI restoring bug
Message-Id: <20070513115947.105fb1ba.akpm@linux-foundation.org>
In-Reply-To: <20070513122113.GA3632@ics.muni.cz>
References: <20070512201237.GB3569@ics.muni.cz>
	<20070512234743.0a8a915f.akpm@linux-foundation.org>
	<20070513085718.GD3580@ics.muni.cz>
	<20070513021119.c4f14bd3.akpm@linux-foundation.org>
	<20070513122113.GA3632@ics.muni.cz>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007 14:21:14 +0200 Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:

> On Sun, May 13, 2007 at 02:11:19AM -0700, Andrew Morton wrote:
> > > I've also noticed that someone pointed out that for some reason, PCI config
> > > space is saved twice, the first is OK, the second saves already disabled
> > > devices. Unfortunately, I'm unable to find this discussion in LKM.
> > 
> > Yeah, that sounds risky.
> > 
> > Can you put a dump_stack() call into the PCI saving function?  That way
> > we'll see what the two call paths are.
> 
> I did it, but it seems to be OK. PCI saves only once each device. So the issue
> was not related to this.
> 
> So what should I try next?
> 

So.... we don't know 0xffffffff's are getting into dev->saved_config_space[]?


Possibly we're saving the device's state when it is already partway or
fully through the suspend process, dunno.

What if you were to put code into pci_save_state() to detect when it reads
an oxffffffff?  Do a dump_stack() and print pci_dev->current_state and
->enable_cnt and various other things in there?


Or maybe we've done something in the wrong order which has affected our
ability to access this device.  Print the order in which devices are
getting suspended, let's see if we're taking down the bridge(s) in the
correct order.

