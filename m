Return-Path: <linux-kernel-owner+w=401wt.eu-S1946889AbXD3X07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946889AbXD3X07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 19:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946890AbXD3X06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 19:26:58 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:46520 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946889AbXD3X05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 19:26:57 -0400
Date: Mon, 30 Apr 2007 17:26:48 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
In-reply-to: <20070430225916.GA39223@dspnet.fr.eu.org>
To: Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Message-id: <46367B38.6080508@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <4635510D.4060103@shaw.ca> <20070430225916.GA39223@dspnet.fr.eu.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olivier Galibert wrote:
> On Sun, Apr 29, 2007 at 08:14:37PM -0600, Robert Hancock wrote:
>> -Validate that the area is reserved even if we read it from the
>> chipset directly and not from the MCFG table. This catches the case
>> where the BIOS didn't set the location properly in the chipset and
>> has mapped it over other things it shouldn't have.  This might be
>> overly pessimistic - we might be able to instead verify that no
>> other reserved resources (like chipset registers) are inside this
>> memory range.
> 
> I have a fundamental problem with that: you don't validate a higher
> reliability information against a lower one.  The chipset registers
> are high reliability.  Modulo unknown hardware erratas and bugs in the
> code (and accepting f0000000 is in practice a bug in the code, the
> docs are starting to catch up with it too), the chipset *will* decode
> mmconfig at the looked up address no matter what.  On the other side,
> the ACPI data is bios generated, and that is well known to be horribly
> unreliable.  Hell, if it was reliable we could just use the MFCG ACPI
> table without questions.
> 
> So you can check the ACPI stuff for coherency (MFCG vs. the rest), you
> can validate the ACPI stuff against the results of the lookup if you
> want, but validating the lookup against ACPI is nonsensical.

The problem is that in the event the MMCONFIG table is assigned to an 
address range that conflicts with other devices, there's no guarantee 
that MMCONFIG will have the higher decode priority. Apparently this is 
exactly the case on some boards, the MMCONFIG is mapped on top of 
chipset registers, and when we think we're accessing the MMCONFIG table 
we're really scrambling random chipset registers and hosing things. So 
we can't just blindly trust the values as being usable even when they 
come directly from the chipset.

As I mentioned, though, really what we want to verify in this case is 
that no other reserved resources fall inside the range being decoded by 
the chipset. I may see if I can code something to do this. Essentially, 
though, the existing patch effectively does this, on the assumption that 
the board won't have conflicting reserved resources in the ACPI tables, 
which is probably a safe assumption as Windows would likely be terribly 
unhappy with that..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


