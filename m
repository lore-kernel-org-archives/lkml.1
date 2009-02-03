Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbZBCRm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbZBCRm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbZBCRmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:42:47 -0500
Received: from cpsmtpo-eml06.KPNXCHANGE.COM ([213.75.38.155]:38353 "EHLO
	cpsmtpo-eml06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134AbZBCRmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:42:47 -0500
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [BUG] Suspend tries to suspend devices already in D3
Date: Tue, 3 Feb 2009 18:42:43 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200902030949.42342.elendil@planet.nl> <200902031034.12175.rjw@sisk.pl> <200902031833.12777.elendil@planet.nl>
In-Reply-To: <200902031833.12777.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902031842.44186.elendil@planet.nl>
X-OriginalArrivalTime: 03 Feb 2009 17:42:44.0532 (UTC) FILETIME=[D1E86F40:01C98626]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009, Frans Pop wrote:
> Looking at iwl-agn.c the cause could be that iwl_pci_suspend() depends
> on iwl_mac_stop() to call pci_save_state(). I added some debug
> statements in iwl_pci_suspend() that showed priv->is_open is false, so
> iwl_mac_stop does indeed *not* get called when the interface is down.

However, iwl_mac_stop() had been called when I ran ifdown just before
suspending the system:

# Here I run 'ifdown wlan0':
Feb  3 18:25:30 aragorn kernel: wlan0: deauthenticating by local choice (reason=3)
Feb  3 18:25:30 aragorn kernel: iwlagn: MAC is in deep sleep!
# The next debug statement is from iwl_mac_stop():
Feb  3 18:25:30 aragorn kernel: iwlagn FJP: state saved and device disabled
Feb  3 18:25:30 aragorn kernel: wlan0: deauthenticating by local choice (reason=3)
# Start of suspend:
Feb  3 18:25:54 aragorn kernel: PM: Syncing filesystems ... done.
Feb  3 18:25:54 aragorn kernel: Freezing user space processes ... (elapsed 0.00 seconds) done.
Feb  3 18:25:54 aragorn kernel: Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Feb  3 18:25:54 aragorn kernel: Suspending console(s) (use no_console_suspend to debug)
Feb  3 18:25:54 aragorn kernel: sd 0:0:0:0: [sda] Synchronizing SCSI cache
Feb  3 18:25:54 aragorn kernel: sd 0:0:0:0: [sda] Stopping disk
Feb  3 18:25:54 aragorn kernel: ACPI handle has no context!
Feb  3 18:25:54 aragorn kernel: ACPI handle has no context!
Feb  3 18:25:54 aragorn kernel: sdhci-pci 0000:02:06.2: PME# disabled
Feb  3 18:25:54 aragorn kernel: ACPI handle has no context!
Feb  3 18:25:54 aragorn acpid: client 4081[0:0] has disconnected
Feb  3 18:25:54 aragorn kernel: ACPI handle has no context!
# The next debug statement is from iwl_pci_suspend() and shows priv->is_open is false:
Feb  3 18:25:54 aragorn kernel: iwlagn FJP: not calling iwl_mac_stop
Feb  3 18:25:54 aragorn kernel: ------------[ cut here ]------------
Feb  3 18:25:54 aragorn kernel: WARNING: at drivers/pci/pci-driver.c:375 pci_legacy_suspend+0xd4/0x11a()
Feb  3 18:25:54 aragorn kernel: Hardware name: HP Compaq 2510p Notebook PC
Feb  3 18:25:54 aragorn kernel: PCI PM: Device state not saved by iwl_pci_suspend+0x0/0x6a [iwlagn], state is D3hot
[...]
