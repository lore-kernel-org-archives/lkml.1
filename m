Return-Path: <linux-kernel-owner+w=401wt.eu-S1031053AbXDSB0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031053AbXDSB0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 21:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031054AbXDSB0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 21:26:08 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:13411 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031053AbXDSB0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 21:26:04 -0400
Date: Wed, 18 Apr 2007 19:25:40 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: PCI Express MMCONFIG and BIOS Bug messages..
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@suse.de>
Message-id: <4626C514.5010605@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 8BIT
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've seen a lot of systems (including brand new Xeon-based servers from 
IBM and HP) that output messages on boot like:

PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved
PCI: Not using MMCONFIG.

As I understand it, this is sort of a sanity check mechanism to make 
sure the MCFG address reported is remotely reasonable and intended to be 
used as such. Problem is, I doubt the BIOS authors would agree that this 
constitutes a bug. Microsoft is providing a lot of the direction for 
BIOS writers, and have a look at this presentation "PCI Express, 
Windows, And The Legacy Transition" from back in 2004:

http://download.microsoft.com/download/1/8/f/18f8cee2-0b64-41f2-893d-a6f2295b40c8/TW04047_WINHEC2004.ppt

On page 14, "Existing Windows - Reserve MMCONFIG":

Existing Windows versions won’t understand MCFG table
* Backwards-compatible range reservation must be used
Report range in ACPI "Motherboard Resources"
*_CRS of PNP0C02 node
* PNP0C02 must be at \_SB scope
* Range must be marked as consumed
Do not include range in _CRS of PCI root bus
* If included, OS will assume that this range can be allocated to devices
E820 table/EFI memory map
  * Not necessary to describe MMConfig here
  * For Windows, these are used to describe RAM
  * No harm in including range as reserved either

So Microsoft is explicitly telling the BIOS developers that there is no 
need to reserve the MMCONFIG space in the E820 table because Windows 
doesn't care. On that basis it doesn't seem like a valid check to 
require it to be so reserved, then.

Really, I think we should be basing this check on whether the 
corresponding memory range is reserved in the ACPI resources, like 
Windows expects. This does require putting more fingers into ACPI from 
this early boot stage, though..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

