Return-Path: <linux-kernel-owner+w=401wt.eu-S1751848AbXA0B0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbXA0B0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 20:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbXA0B0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 20:26:40 -0500
Received: from cavan.codon.org.uk ([217.147.92.49]:39618 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbXA0B0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 20:26:39 -0500
Date: Sat, 27 Jan 2007 01:26:23 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, David Brownell <david-b@pacbell.net>,
       linux-kernel@vger.kernel.org
Message-ID: <20070127012623.GB13534@srcf.ucam.org>
References: <20061219185223.GA13256@srcf.ucam.org> <200612201318.06976.david-b@pacbell.net> <20061221012924.GC32625@srcf.ucam.org> <200612201904.28681.david-b@pacbell.net> <20061221040648.GA1499@srcf.ucam.org> <20070125050009.GA8672@srcf.ucam.org> <20070126115905.66940ac9.akpm@osdl.org> <20070126204226.GB8407@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070126204226.GB8407@suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 12:42:26PM -0800, Greg KH wrote:

> No, it's not stable material, as drivers would have to be modified to
> support it, and that is adding new stuff.  See my other comment about
> why this was changed because it was broken...

Which drivers? The current code simply bails if the bus (not the device) 
supports the late_suspend method. In the PCI core, that function simply 
calls the device's late_suspend method and does nothing else. My patch 
simply alters the check so that the bus can veto the request if the 
driver has such a method, and allow it to pass if it doesn't. To 
summarise:

2.6.18 situation:

/sys/devices/.../power/state call will succeed for all PCI devices, even 
if the device suspend method must be called with interrupts disabled

2.6.19 situation:

/sys/devices/.../power/state call will fail for all PCI devices, even if 
the PCI bus's suspend_late function is effectively a noop for that 
device

2.6.19+my patch situation:

/sys/devices/.../power/state call will fail for PCI devices that 
implement a suspend_late method, and succeed for other PCI devices

Surely the latter of these is the closest to the expected behaviour?
-- 
Matthew Garrett | mjg59@srcf.ucam.org
