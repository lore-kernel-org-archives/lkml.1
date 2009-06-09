Return-Path: <linux-kernel-owner+w=401wt.eu-S1760507AbZFIMNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760507AbZFIMNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbZFIMNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:13:33 -0400
Received: from smtp.nokia.com ([192.100.122.230]:39322 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbZFIMNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:13:32 -0400
Subject: Re: [PATCH] MTD: Add UBI reboot notifier
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Kevin Cernekee <kpc.mtd@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <018abcd2d98090bda0f75d3c95c9ec85@localhost>
References: <018abcd2d98090bda0f75d3c95c9ec85@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Jun 2009 15:13:19 +0300
Message-Id: <1244549599.5847.381.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Jun 2009 12:13:19.0765 (UTC) FILETIME=[AD3CD450:01C9E8FB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-08 at 22:14 -0700, Kevin Cernekee wrote:
> ubifs_sync_fs() may queue up a new UBI erase transaction, which is
> processed in the background:
> 
> bash# sync
> ubifs_sync_fs: enter
> schedule_erase: enter
> schedule_erase: exit
> ubi_sync: enter
> ubi_sync: exit
> ubifs_sync_fs: exit
> cfi_amdstd_erase_varsize: enter
> bash# cfi_amdstd_erase_varsize: exit
> 
> Normally this is not a big deal.  However, during the final sync before
> rebooting, it initiates an erase operation that is potentially still
> active when Linux restarts the machine:
> 
> bash# reboot -f
> ubifs_sync_fs: enter
> schedule_erase: enter
> schedule_erase: exit
> ubi_sync: enter
> ubi_sync: exit
> ubifs_sync_fs: exit
> cfi_amdstd_erase_varsize: enter
> Restarting system.
> <Flash is stuck in FL_ERASE mode - system hangs>
> 
> This is easiest to observe on a NOR flash.  One factor is the long erase
> time.  The other reason is because getting a NOR flash stuck in FL_ERASE
> mode will prevent the bootloader from running, unless the board provides
> a way for the processor to automatically reset the flash.  In my
> experience, many boards do not.
> 
> My proposal is to add a reboot notifier to let the UBI background thread
> terminate gracefully.  The new ordering looks like this:
> 
> bash# reboot -f
> ubifs_sync_fs: enter
> schedule_erase: enter
> schedule_erase: exit
> ubifs_sync_fs: exit
> cfi_amdstd_erase_varsize: enter
> ubi_reboot_notifier: enter
> cfi_amdstd_erase_varsize: exit
> ubi_reboot_notifier: exit
> cfi_amdstd_reboot: enter
> cfi_amdstd_reboot: exit
> 
> cfi_amdstd_reboot doesn't really exist, but I added a dummy notifier to
> make sure that the ordering would be correct when using drivers that do
> have this feature.

The idea looks OK. So you basically make sure that if UBI bgt thread
started an erase operation, it finishes it (and only it) before we
reboot. Do I read the patch correctly?

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

