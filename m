Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbXLRVZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbXLRVZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbXLRVXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:23:22 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:51086 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095AbXLRVXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:23:20 -0500
Date: Wed, 19 Dec 2007 00:23:49 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>
Subject: Re: PCI resource problems caused by improper address rounding
Message-ID: <20071219002349.A12278@jurassic.park.msu.ru>
References: <47671377.6000405@redhat.com> <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org> <47680489.6040809@redhat.com> <alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org> <20071218202234.GA24525@twiddle.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <20071218202234.GA24525@twiddle.net>; from rth@twiddle.net on Tue, Dec 18, 2007 at 12:22:34PM -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 12:22:34PM -0800, Richard Henderson wrote:
> On Tue, Dec 18, 2007 at 10:21:50AM -0800, Linus Torvalds wrote:
> > ... and that would be an X server issue!).
> 
> Of course, fixing the X server to *handle* 64-bit BARs is the correct
> solution.  I've no idea how involved that is, but I have a sneeking
> suspicion that it uses that damned CARD32 datatype for everything.

Doh. Let's fix the kernel first...

Does this make any difference? (the patch is self explaining ;-)

Ivan.

--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -208,8 +208,9 @@ pci_setup_bridge(struct pci_bus *bus)
 	}
 	pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, l);
 
-	/* Clear out the upper 32 bits of PREF base. */
-	pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, 0);
+	/* Set up the upper 32 bits of PREF base. */
+	l = region.start >> 16 >> 16;
+	pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, l);
 
 	pci_write_config_word(bridge, PCI_BRIDGE_CONTROL, bus->bridge_ctl);
 }
