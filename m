Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbZBTVEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbZBTVEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 16:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbZBTVDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 16:03:54 -0500
Received: from 205.158.150.226.ptr.us.xo.net ([205.158.150.226]:1611 "EHLO
	mail.exegy.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752490AbZBTVDy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 16:03:54 -0500
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Feb 2009 16:03:53 EST
Thread-Index: AcmTnJz5qgQmHMclRO6+wkJQtarkVA==
X-Ninja-AntiSpoofing: spoofed
Message-ID: <499F1729.9010700@exegy.com>
Date: Fri, 20 Feb 2009 14:48:41 -0600
From: "Mr. Berkley Shands" <bshands@exegy.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090107)
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: AMD 8132 parity issue causes interrupt storms
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-class: urn:content-classes:message
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4325
Importance: normal
X-OriginalArrivalTime: 20 Feb 2009 20:48:41.0377 (UTC) FILETIME=[9CEDA110:01C9939C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that the 8132 should be blacklisted :-)

INT-A will be asserted forever if any channel sees a parity error.
This can be blocked by several means;

1) setpci -s <bus address of 8132> 5.b=05   /* disable interrupts from 
the bridge */
This is the I don't see you method.

Shouldn't the interrupt handler (is there one?) trap and clear this?
Shouldn't the kernel at least report this error and reset those bits?

All,

OK, here's what I know so far.  The interrupt storm is coming from the 
parity error detector in the 8132.  The parity error is reported in two 
locations using sticky bits:

0x1c bits 31 and 24
   Here there seems to be some differentiation between which party 
detected the parity error.  The 8132 spec is pretty vague here (see page 
75) but it looks like the 8132 is detecting a parity error from the HBA 
not the other way around.
0x80 bit 0
   Here it just states that someone asserted the PERR_L signal, no 
distinction on who did it.

All these bits are write-one-to-clear.  If 0x80 bit 0 is cleared, the 
storm stops.  Clearly the OS does not know how to handle these 
conditions and the error flag is left on while the interrupt is 
continuously handled.

One way to handle this is to set 0x48 bit 19 to 0.  This prevents the 
8132 from interrupting when 0x80 bit 0 is set.

A much better way to handle this is to have the interrupt handler 
actually check the error bits on the 8132 when it is called.  This would 
slow down the interrupt handler, but actually give us a much better 
visibility into this problem (when, where and how often this happens).  
The irritating thing here is that this is chipset dependent.  The 
interrupt handler would have to know what PCI-X chipset it was talking 
through to know how to handle this (way to go AMD).

The really odd thing is that the parity error is reported through INTB 
on the 8132.  The spec claims that fatal errors (the category they put 
PERR in) go to INTB while hot plug conditions trigger INTA.  Masking off 
fatal errors in the IOAPIC turns off the storm too.  I have no idea why 
this is showing up on INTA.

Berkley

-- 

// E. F. Berkley Shands, MSc//

** Exegy Inc.**

349 Marshall Road, Suite 100

St. Louis , MO  63119

Direct:  (314) 218-3600 X450

Cell:  (314) 303-2546

Office:  (314) 218-3600

Fax:  (314) 218-3601

 

The Usual Disclaimer follows...
 
This e-mail and any documents accompanying it may contain legally privileged and/or confidential information belonging to Exegy, Inc. Such information may be protected from disclosure by law. The information is intended for use by only the addressee. If you are not the intended recipient, you are hereby notified that any disclosure or use of the information is strictly prohibited. If you have received this e-mail in error, please immediately contact the sender by e-mail or phone regarding instructions for return or destruction and do not use or disclose the content to others.
