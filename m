Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbXLTVyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbXLTVyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762655AbXLTVyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:54:19 -0500
Received: from are.twiddle.net ([64.81.246.98]:40746 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762631AbXLTVyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:54:15 -0500
Date: Thu, 20 Dec 2007 13:52:04 -0800
From: Richard Henderson <rth@twiddle.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
       Keith Packard <keithp@keithp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: PCI resource problems caused by improper address rounding
Message-ID: <20071220215204.GA5636@twiddle.net>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
	Keith Packard <keithp@keithp.com>,
	Bjorn Helgaas <bjorn.helgaas@hp.com>
References: <47671377.6000405@redhat.com> <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org> <47680489.6040809@redhat.com> <alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org> <20071218202234.GA24525@twiddle.net> <alpine.LFD.0.9999.0712181240280.21557@woody.linux-foundation.org> <20071218215143.GA24769@twiddle.net> <alpine.LFD.0.9999.0712181412530.21557@woody.linux-foundation.org> <alpine.LFD.0.9999.0712181722260.21557@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712181722260.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 05:38:58PM -0800, Linus Torvalds wrote:
> That
> 
> 	PCI: Cannot allocate resource region 9 of bridge 0000:00:01.0
> 	PCI: Cannot allocate resource region 1 of device 0000:01:00.0
> 
> thing is really starting to bug me.
> 
> I bet that is the real problem here, but it's not printing out enough 
> information about the resource to actually give us much of a clue about 
> what is wrong.
> 
> I suspect that it had a bridge mapping (device 0:01.0) that included the 
> range from 0xc0000000 to 0xcfffffff, but there was something stupid wrong 
> with it (eg the BIOS had allocated overlapping regions), so we disabled 
> it. That, in turn, then caused us to also refuse the existing 0xc0000000 
> mapping for the graphics card (device 01:00.0), because now there was no 
> valid resource for it.

That is exactly it.  The relevant section of the debug info is

PCI: Bridge 0000:00:01.0
PCI: Bridge resource 7 00008000-00008fff (%f=100)
PCI: Bridge resource 8 f7d00000-fddfffff (%f=200)
PCI: Bridge resource 9 bdf00000-ddefffff (%f=1201)

The bridge was assigned to a piece of the end of physical memory.  



r~
