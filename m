Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbYAMB4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbYAMB4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 20:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYAMB4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 20:56:07 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:51252 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbYAMB4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 20:56:05 -0500
Date: Sat, 12 Jan 2008 19:56:01 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
In-reply-to: <fa.O9WUKjAu+MfGg712w8Y4HkQ7GIo@ifi.uio.no>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Greg KH <gregkh@suse.de>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>
Message-id: <47896FB1.2070707@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.2KorSXroIUtdRjFJWJwy49QuIYk@ifi.uio.no>
 <fa.KgDY4hzBogAL+o607R+LHzW+HTc@ifi.uio.no>
 <fa.xzH/eH5b6vCHpOD31Cq2nyq6z/k@ifi.uio.no>
 <fa.EPUIDYIoxtDNcRrL9p3fAkr80Lo@ifi.uio.no>
 <fa.uPoC9dcdekzy7g8QYFyuwelukiQ@ifi.uio.no>
 <fa.O9WUKjAu+MfGg712w8Y4HkQ7GIo@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 11 Jan 2008, Matthew Wilcox wrote:
>> Did I miss a bug report?  The only problems I'm currently aware of are
>> the ones where using MMCONFIG during BAR probing causes a hard lockup on
>> some Intel machines, and the ones where we get bad config data on some
>> AMD machines due to the configuration retry status being mishandled.
> 
> Hmm. Were all those reports root-caused to just that BAR probing? If so, 
> we may be in better shape than I worried.

As far as I'm aware, the known MMCONFIG-related issues that I'm aware of 
are or have been:

-Some devices built into the AMD K8 integrated northbridge can't be 
reached by MMCONFIG - already handled

-Overlap of device BAR and MMCONFIG aperature during BAR sizing causing 
lockup - can be avoided by disabling device decode during BAR sizing.

-PCI Express CRS-related issues - already handled by disabling CRS by 
default

-Devices behind certain host bridges (some AMD HT to PCI-X bridges, 
others?) can't be reached by MMCONFIG - can be handled by Tony Camuso's 
patch or something similar (note that this is really a BIOS bug, it 
should not list those buses in the MCFG table if MMCONFIG cannot access 
them, and if it didn't I think we could already handle that)

-Some issue with some AMD CPUs needing MMCONFIG accesses to use a 
certain register I believe? already handled?

Of these, I think the PCI BAR/MMCONFIG overlap problem is responsible 
for by far the most cases of machines thought to have "broken MMCONFIG", 
when in fact they were nothing of the sort. I don't recall hearing of a 
single machine where MMCONFIG really just didn't work at all.

As I've mentioned before, all of these issues (well, I suppose not the 
BAR overlap one) need to be resolved whether we have Arjan's patch or 
not, otherwise if a driver does opt in and tries to use extended config 
space it will still break. And if they are resolved, the patch seems 
quite pointless.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

