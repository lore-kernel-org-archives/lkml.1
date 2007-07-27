Return-Path: <linux-kernel-owner+w=401wt.eu-S933795AbXG0CIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795AbXG0CIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 22:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759927AbXG0CHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 22:07:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47482
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759319AbXG0CHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 22:07:52 -0400
Date: Thu, 26 Jul 2007 19:07:51 -0700 (PDT)
Message-Id: <20070726.190751.66179795.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
CC: adobriyan@sw.ru
Subject: /proc/bus/pci IOCTL breakage
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This change:

commit 786d7e1612f0b0adb6046f19b906609e4fe8b1ba
Author: Alexey Dobriyan <adobriyan@sw.ru>
Date:   Sun Jul 15 23:39:00 2007 -0700

    Fix rmmod/read/write races in /proc entries

Broke ioctl() on /proc/bus/pci/* files for COMPAT platforms.

proc_fops->ioctl() is defined for these PCI device files, and the
COMPAT ioctl is handled via fs/compat_ioctl.c's entries, which makes
it just call the ->ioctl() handler directly.

proc_fops->compat_ioctl is NULL for these files, it isn't needed.

This used to work because we used to jump right to the de->proc_fops,
but now we have these wrappers and proc_reg_compat_ioctl is what
gets called and since proc_fops->compat_ioctl is NULL we return
ENOTTY instead of calling proc_fops->ioctl().

Two ways to fix:

1) Make the PROC wrapper call ->unlocked_ioctl() or ->ioctl()
   as a fallback of ->compat_ioctl is NULL.

2) Make proc_bus_pci_operations provide a .compat_ioctl method,
   but then we'll need to audit the entire tree for cases like
   this and make the same fix.

Because it's easier to validate that all cases are covered,
I think #1 is the preferred fix.
