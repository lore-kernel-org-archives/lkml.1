Return-Path: <linux-kernel-owner+w=401wt.eu-S1756476AbYCVW3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbYCVW3y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 18:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbYCVW3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 18:29:45 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56436 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbYCVW3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 18:29:44 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47E587E8.4050103@s5r6.in-berlin.de>
Date: Sat, 22 Mar 2008 23:27:52 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Thomas Meyer <thomas@m3y3r.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
 regressions from 2.6.24) [Bug 10080]
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org> <47E5815B.4080002@kernel.org>
In-Reply-To: <47E5815B.4080002@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote at 
http://bugzilla.kernel.org/show_bug.cgi?id=10080#c9 :
> I'm confused about this.  I looked at the original threads, and what really
> stands out to me is that the original reporter had two drivers loaded for the
> same hardware (firewire-ohci and ohci1394.)  *In the best case* there is a
> fundamental race condition there, meaning unpredictable behaviour would be the
> norm.


Hmm, right -- I didn't see this until now.  Today's dmesg:
http://bugzilla.kernel.org/attachment.cgi?id=15397&action=view
[    1.236587] firewire_ohci: Failed to remap registers
[  243.640549] ohci1394: fw-host0: Get PHY Reg timeout
(etc.)

However, the two drivers for the same device don't seem to be the 
problem.  Looks like firewire-ohci was attempted to be bound to the 
controller much earlier than ohci1394.  The error message means that 
firewire-ohci's pci_request_region() succeeded but pci_iomap() failed, 
hence the pci_driver.probe failed, hence firewire-ohci wasn't bound to 
the device, hence subsequent loading of ohci1394 (manually, I presume) 
was a valid action.

IOW firewire-ohci was indeed already loaded, but not bound to the device 
because of the .probe failure; and ohci1394 was loaded much later.

Same thing in the report in February:
http://lkml.org/lkml/2008/2/23/244
[    1.326958] firewire_ohci: Failed to remap registers
[  856.943807] ohci1394: fw-host0: Get PHY Reg timeout
(here: ohci1394 manually loaded by insmod)

(Let's see if bugme-daemon captures this...)
-- 
Stefan Richter
-=====-==--- --== =-==-
http://arcgraph.de/sr/
