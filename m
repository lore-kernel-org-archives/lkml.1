Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZAZWNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZAZWNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 17:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbZAZWNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 17:13:36 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:28607 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbZAZWNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 17:13:35 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Krzysztof Helt" <krzysztof.h1@wp.pl>, Adam Belay <abelay@mit.edu>
Subject: Re: How should I handle device with two PNP-BIOS ids?
Date: Mon, 26 Jan 2009 15:13:31 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <497d80991ef709.35340258@wp.pl>
In-Reply-To: <497d80991ef709.35340258@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901261513.32348.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added Adam and linux-acpi]

On Monday 26 January 2009 02:21:29 am Krzysztof Helt wrote:
> There is brain-damaged sound chip which is identified by two separate 
> PNP ids. This was done probably to keep backward compatibility (the 
> first id is for the old type of chip, the second id gives only one 
> additional io range required for newer chips).
> 
> How to does properly detect such a device using the PNP framework?
> Is there any way to specify two PNP ids as one device?
> 
> Is it better to iterate over a pnpbios protocol of the first device to 
> find out if there is the second id? This way has an advantage that I can 
> distinguish between old chip (no the second id found) and newer chips 
> (the second id found).

Hi Krzysztof,

Systems with the old chip probably report the device with a single
PNP ID.  For PNPBIOS, that would be the "device product identifier."
For ACPI, it would be the _HID.

Systems with the new chip should report both PNP IDs.  The PNPBIOS
device product identifier or the ACPI _HID should be the new ID, and
the older ID for backward compatibility should be reported in the
PNPBIOS "compatible device identifiers" list or the ACPI _CID.

The driver would list both IDs in the pnp_device_id table, and it
looks like the driver probe routine gets called with the ID that
matched.

I don't see any drivers that actually do this, but I think the
probe routine should be able to look at the ID that matched and
determine whether the additional I/O range is present.

Oops, looking at match_device() in drivers/pnp/driver.c, I think
we look at all the device IDs supported by the driver, but we only
look at the first ID associated with the device.  That means an old
driver that only knows about the old device ID would fail to claim
a new device (the new device will have the new ID first and old IDs
in the compatibility list).  That looks like a bug in the PNP core --
the old driver should be able to claim any new compatible devices.

Let me know if you think you're seeing this bug, and I'll look into
it some more.

Bjorn
