Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbZHPBDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbZHPBDF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 21:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbZHPBDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 21:03:05 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50877 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbZHPBDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 21:03:04 -0400
Date: Sun, 16 Aug 2009 02:03:03 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Zeev Tarantov <zeev.tarantov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] [hwmon] linux 2.6.31-rc6 regression
Message-ID: <20090816010303.GA9588@srcf.ucam.org>
References: <12d7e64c0908150329k1bf123der18e74112c5b9cd97@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12d7e64c0908150329k1bf123der18e74112c5b9cd97@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 15, 2009 at 01:29:48PM +0300, Zeev Tarantov wrote:

> [    3.276720] w83627ehf: Found W83627DHG chip at 0x290
> [    3.276894] ACPI: I/O resource w83627ehf [0x295-0x296] conflicts
> with ACPI region HWRE [0x290-0x299]
> [    3.277171] ACPI: Device needs an ACPI driver

The hwmon driver is attempting to allocate a region that's also used by 
your ACPI firmware. There's no way to synchronise access between the 
kernel and the firmware, so allowing both is potentially racy - we've 
seen numerous cases where the combination results in the system 
incorrectly generating critical temperatuer shutdowns, for instance, 
when some other indexed access gets interpreted as the temperature or 
when the hwmon chip's state machine is confused. The failure of hwmon to 
bind is a feature here, not a bug. You can override it with 
acpi_enforce_resources=no on the kernel command line.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
