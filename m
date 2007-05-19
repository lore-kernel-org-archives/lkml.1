Return-Path: <linux-kernel-owner+w=401wt.eu-S1763094AbXESPy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763094AbXESPy1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 11:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755971AbXESPyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 11:54:20 -0400
Received: from neon.samage.net ([85.17.153.66]:43601 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154AbXESPyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 11:54:19 -0400
Message-ID: <1800.81.207.0.53.1179590050.squirrel@secure.samage.net>
In-Reply-To: <464B3505.20004@gmail.com>
References: <20070510072005.GA27316@linux-sh.org>
    <464301D3.5060306@gmail.com> <464307CC.40701@gmail.com>
    <20070510124645.GA18534@linux-sh.org> <4643196B.7070806@gmail.com>
    <20070511005217.GA23186@li <464B3505.20004@gmail.com>
Date: Sat, 19 May 2007 17:54:10 +0200 (CEST)
Subject: Re: [PATCH] libata: implement ata_wait_after_reset()
From: "Indan Zupancic" <indan@nul.nu>
To: "Tejun Heo" <htejun@gmail.com>
Cc: "Paul Mundt" <lethal@linux-sh.org>, "Tejun Heo" <htejun@gmail.com>,
       jeff@garzik.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, garyhade@us.ibm.com
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 488b5a33f748713be529de57fa847022
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 18:44, Tejun Heo wrote:
> On certain device/controller combination, 0xff status is asserted
> after reset and doesn't get cleared during 150ms post-reset wait.  As
> 0xff status is interpreted as no device (for good reasons), this can
> lead to misdetection on such cases.
>
> This patch implements ata_wait_after_reset() which replaces the 150ms
> sleep and waits upto ATA_TMOUT_FF_WAIT if status is 0xff.
> ATA_TMOUT_FF_WAIT is currently 800ms which is enough for
> HHD424020F7SV00 to get detected but not enough for Quantum GoVault
> drive which is known to take upto 2s.
>
> Without parallel probing, spending 2s on 0xff port would incur too
> much delay on ata_piix's which use 0xff to indicate empty port and
> doesn't have SCR register, so GoVault needs to wait till parallel
> probing.

Using sata_sil (SiI 3512) with a ST3120827AS disk here.

For me the COMRESET happens after resume (s2ram):

[    2.174342] sd 0:0:0:0: [sda] Starting disk
[    2.476407] ata1: device not ready (errno=-19), forcing hardreset
[    2.476429] ata2: SATA link down (SStatus 0 SControl 310)
[    2.931793] ata1: COMRESET failed (errno=-19)
[    2.931797] ata1: reset failed (errno=-19), retrying in 10 secs
[   12.918421] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   12.921957] ata1.00: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 234441648
[   12.925908] ata1.00: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 234441648

With your patch applied the output is:

[    2.173369] sd 0:0:0:0: [sda] Starting disk
[    2.475431] ata1: device not ready (errno=-19), forcing hardreset
[    2.475453] ata2: SATA link down (SStatus 0 SControl 310)
[    3.592930] ata1: COMRESET failed (errno=-19)
[    3.592934] ata1: reset failed (errno=-19), retrying in 9 secs
[   12.917446] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   12.920969] ata1.00: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 234441648
[   12.924945] ata1.00: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 234441648

Resume takes now ten seconds or more, while it used to take only a few seconds,
what changed? A few kernel versions ago (2.6.21-rc or so?) it retried in 5 seconds
instead of 10, but even that is too long.

Maybe a silly question, but why do we wait for the harddisk to show up? Maybe that
makes a little bit of sense at bootup, but for resume from ram, where nothing is
supposed to have changed, it seems a bit strange. Why not wait when something tries
to access the harddisk or something?

I wonder if sil_pci_device_resume() and sd_resume() know about each other...
I'll disable sd_resume() and see how that goes.

Greetings,

Indan


