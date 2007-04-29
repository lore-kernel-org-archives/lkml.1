Return-Path: <linux-kernel-owner+w=401wt.eu-S1031001AbXD2SeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031001AbXD2SeN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 14:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031060AbXD2SeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 14:34:13 -0400
Received: from outbound-mail-06.bluehost.com ([69.89.17.206]:46341 "HELO
	outbound-mail-06.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031029AbXD2SeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 14:34:12 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PCI Express MMCONFIG and BIOS Bug messages..
Date: Sun, 29 Apr 2007 11:27:20 -0700
User-Agent: KMail/1.9.6
Cc: Andi Kleen <ak@suse.de>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
References: <4626C514.5010605@shaw.ca> <200704291212.03171.ak@suse.de> <4634E1F8.5000806@shaw.ca>
In-Reply-To: <4634E1F8.5000806@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704291127.21263.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.73.10 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, April 29, 2007, Robert Hancock wrote:
> Problem is that even if we read the MMCONFIG table location from the
> hardware registers, that doesn't mean we can trust the result. It could
> be that the BIOS hasn't lied about where it put the table, it just stuck
> it someplace completely unsuitable like on top of RAM or other
> registers. It seems that with some of those 965 chipsets the latter is
> what the BIOS is actually doing, and so when we think we're writing to
> the table we're really writing to random chipset registers and hosing
> things. (Jesse Barnes ran into this while trying to add chipset support
> for the 965).

Right, I've updated the BIOS since, but at least that version was totally 
buggy wrt MMconfig support.  I haven't yet looked at the new one to see if 
it properly reserves MCFG space in ACPI _CRS yet or properly programs it.

> Likely what we need to do is:
>
> -If chipset is known, take table address from registers, otherwise check
> the MCFG table
> -Take the resulting area (Ideally not just the first minimum part as we
> check now, but the full area based on the expected length) and make sure
> that the entire area is covered by a reservation in ACPI motherboard
> resources.
> -If that passes, then we still need to sanity check the result by making
> sure it hasn't been mapped over top of something else important. How to
> do this depends on exactly how they've set up the ACPI reservations on
> these broken boxes.. Does someone have a full dmesg from one on a recent
> kernel that shows all the pnpacpi resource reservation output?
> -If these checks fail, we don't use the table, and the chipset is known,
> we should likely try to disable decoding of the region so that it won't
> get in the way of anything else.

Yeah, that sounds like a good algorithm.

I'm not sure how to handle the fact that we don't have access to the _CRS 
until late in boot though...  Len?

Jesse
