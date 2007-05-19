Return-Path: <linux-kernel-owner+w=401wt.eu-S1764606AbXESSXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764606AbXESSXs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 14:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758687AbXESSXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 14:23:40 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:1277 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758228AbXESSXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 14:23:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=s1GZNQF6ELKOh4SBkd1BywjLKxaycoxgSk99/dt0Mu8QaThGK8mqqIVdH3APXivP6rtQNfl7tBB+1aUfRXITOIIPwFF0rmpiHl0AAR6aAR+H4u/2C8+uhn7Fggq2QJk4yKuku6b4VJrzoFSLxLxfihIvpeGpTWjt7GcgWYSelkY=
Message-ID: <464F409D.9030408@gmail.com>
Date: Sat, 19 May 2007 20:23:25 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: Paul Mundt <lethal@linux-sh.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       garyhade@us.ibm.com
Subject: Re: [PATCH] libata: implement ata_wait_after_reset()
References: <20070510072005.GA27316@linux-sh.org>    <464301D3.5060306@gmail.com> <464307CC.40701@gmail.com>    <20070510124645.GA18534@linux-sh.org> <4643196B.7070806@gmail.com>    <20070511005217.GA23186@li <464B3505.20004@gmail.com> <1800.81.207.0.53.1179590050.squirrel@secure.samage.net>
In-Reply-To: <1800.81.207.0.53.1179590050.squirrel@secure.samage.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Indan Zupancic wrote:
> Using sata_sil (SiI 3512) with a ST3120827AS disk here.
> 
> For me the COMRESET happens after resume (s2ram):
> 
> [    2.174342] sd 0:0:0:0: [sda] Starting disk
> [    2.476407] ata1: device not ready (errno=-19), forcing hardreset
> [    2.476429] ata2: SATA link down (SStatus 0 SControl 310)
> [    2.931793] ata1: COMRESET failed (errno=-19)
> [    2.931797] ata1: reset failed (errno=-19), retrying in 10 secs
> [   12.918421] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> [   12.921957] ata1.00: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 234441648
> [   12.925908] ata1.00: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 234441648
> 
> With your patch applied the output is:
> 
> [    2.173369] sd 0:0:0:0: [sda] Starting disk
> [    2.475431] ata1: device not ready (errno=-19), forcing hardreset
> [    2.475453] ata2: SATA link down (SStatus 0 SControl 310)
> [    3.592930] ata1: COMRESET failed (errno=-19)
> [    3.592934] ata1: reset failed (errno=-19), retrying in 9 secs
> [   12.917446] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> [   12.920969] ata1.00: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 234441648
> [   12.924945] ata1.00: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 234441648
> 
> Resume takes now ten seconds or more, while it used to take only a few seconds,
> what changed? A few kernel versions ago (2.6.21-rc or so?) it retried in 5 seconds
> instead of 10, but even that is too long.

There are two different things at play here...

1. We dropped libata specific suspend/resume implementation in favor of
sd driven one.  Unfortunately, the new implementation currently can't do
background spinup, so that's probably why you can feel the delay.  We
need to figure out how to do background spinup with the new implementation.

2. To make reset finish in defined time, each reset try now has defined
deadlines.  I was trying to be conservative so I chose 10sec for the
first try.  It's driven by timing table near the top of libata-eh.c, so
adjusting the table is easy and maybe we can be a bit more aggressive
with the first two tries.  But if we solve #1, this shouldn't matter too
much.

So, it's the unfortunate combination of the above two.

> Maybe a silly question, but why do we wait for the harddisk to show up? Maybe that
> makes a little bit of sense at bootup, but for resume from ram, where nothing is
> supposed to have changed, it seems a bit strange. Why not wait when something tries
> to access the harddisk or something?

I hope it's explained now.

> I wonder if sil_pci_device_resume() and sd_resume() know about each other...
> I'll disable sd_resume() and see how that goes.

Yeap, that should work.  In most configurations, devices spin up
immediately after power is restored.  sd_resume() just waits for the
device to be revalidated in such cases.

-- 
tejun
