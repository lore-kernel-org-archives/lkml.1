Return-Path: <linux-kernel-owner+w=401wt.eu-S1761393AbXKPQLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761393AbXKPQLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 11:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbXKPQLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 11:11:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783AbXKPQLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 11:11:32 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071116134105.3823.66507.stgit@warthog.procyon.org.uk>
References: <20071116134105.3823.66507.stgit@warthog.procyon.org.uk> <20071116134100.3823.12894.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
Subject: Re: [PATCH 2/2] MN10300: Fix MTD JEDEC probe so that the ASB2303 bootprom can be detected
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 16 Nov 2007 16:11:23 +0000
Message-ID: <9004.1195229483@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Fix MTD JEDEC probe so that the ASB2303 bootprom can be accessed.  This is
> presumably required because the bootprom is normally write-protected and so
> the normal flash probes don't work as they require the ability to write to the
> flash to send it commands.

Actually, on re-checking the documentation, this particular board doesn't
appear to have a write-enable for the flash, but rather an access-enable
(which is obviously installed).  Furthermore, the probe does seem to manage to
work out that the chip is an MBM29LV800TA, so write is apparently possible.

So the problem appears to be something other than what I thought.

Without the patch, the kernel log shows:

| physmap platform flash device: 00200001 at a0000000
| physmap-flash physmap-flash.0: map_probe failed
| physmap platform flash device: 02000001 at a4000000
| physmap-flash.1: Found 4 x16 devices at 0x0 in 32-bit bank
|  Amd/Fujitsu Extended Query Table at 0x0040
| physmap-flash.1: Swapping erase regions for broken CFI table.
| number of CFI chips: 1
| cfi_cmdset_0002: Disabling erase-suspend-program due to code brokenness.
| cmdlinepart partition parsing not available
| Searching for RedBoot partition table in physmap-flash.1 at offset 0xfc0000
| 4 RedBoot partitions found on MTD device physmap-flash.1
| Creating 4 MTD partitions on "physmap-flash.1":
| 0x00000000-0x00040000 : "RedBoot"
| mtd: Giving out device 0 to RedBoot
| 0x00040000-0x00fc0000 : "unallocated"
| mtd: Giving out device 1 to unallocated
| 0x00fc0000-0x00fff000 : "FIS directory"
| mtd: partition "FIS directory" doesn't end on an erase block -- force read-only
| mtd: Giving out device 2 to FIS directory
| 0x00fff000-0x01000000 : "RedBoot config"
| mtd: partition "RedBoot config" doesn't start on an erase block boundary -- force read-only
| mtd: Giving out device 3 to RedBoot config
| 

With the patch, it shows:

| physmap platform flash device: 00200001 at a0000000
| CFI: Found no physmap-flash.0 device at location zero
| MTD: ASB2303: uaddr=1

(Note I added a printk to display uaddr if it reached this point.)

| Found: Fujitsu MBM29LV800TA
| MTD: ASB2303: uaddr=1
| physmap-flash.0: Found 1 x16 devices at 0x0 in 16-bit bank
| physmap-flash.0: Found an alias at 0x100000 for the chip at 0x0
| number of JEDEC chips: 1
| cfi_cmdset_0002: Disabling erase-suspend-program due to code brokenness.
| cmdlinepart partition parsing not available
| Searching for RedBoot partition table in physmap-flash.0 at offset 0xf0000
| 4 RedBoot partitions found on MTD device physmap-flash.0
| Creating 4 MTD partitions on "physmap-flash.0":
| 0x00000000-0x00040000 : "RedBoot"
| mtd: Giving out device 0 to RedBoot
| 0x00040000-0x000f0000 : "unallocated"
| mtd: Giving out device 1 to unallocated
| 0x000f0000-0x000ff000 : "FIS directory"
| mtd: partition "FIS directory" doesn't end on an erase block -- force read-only
| mtd: Giving out device 2 to FIS directory
| 0x000ff000-0x00100000 : "RedBoot config"
| mtd: partition "RedBoot config" doesn't start on an erase block boundary -- force read-only
| mtd: Giving out device 3 to RedBoot config
| physmap platform flash device: 02000001 at a4000000
| physmap-flash.1: Found 4 x16 devices at 0x0 in 32-bit bank
| physmap-flash.1: Found an alias at 0x1000000 for the chip at 0x0
|  Amd/Fujitsu Extended Query Table at 0x0040
| physmap-flash.1: Swapping erase regions for broken CFI table.
| number of CFI chips: 1
| cfi_cmdset_0002: Disabling erase-suspend-program due to code brokenness.
| cmdlinepart partition parsing not available
| Searching for RedBoot partition table in physmap-flash.1 at offset 0xfc0000
| 4 RedBoot partitions found on MTD device physmap-flash.1
| Creating 4 MTD partitions on "physmap-flash.1":
| 0x00000000-0x00040000 : "RedBoot"
| mtd: Giving out device 4 to RedBoot
| 0x00040000-0x00fc0000 : "unallocated"
| mtd: Giving out device 5 to unallocated
| 0x00fc0000-0x00fff000 : "FIS directory"
| mtd: partition "FIS directory" doesn't end on an erase block -- force read-only
| mtd: Giving out device 6 to FIS directory
| 0x00fff000-0x01000000 : "RedBoot config"
| mtd: partition "RedBoot config" doesn't start on an erase block boundary -- force read-only
| mtd: Giving out device 7 to RedBoot config

David
