Return-Path: <linux-kernel-owner+w=401wt.eu-S1751484AbZH0LDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbZH0LDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 07:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbZH0LDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 07:03:09 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:61608 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbZH0LDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 07:03:07 -0400
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>
Subject: Re: [ANNOUNCE] 2.6.31-rc7-rt8
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	<alpine.LFD.2.00.0904290036500.4529@localhost.localdomain>
	<alpine.LFD.2.00.0905012348200.3375@localhost.localdomain>
	<alpine.LFD.2.00.0905130122250.3561@localhost.localdomain>
	<alpine.LFD.2.00.0905221459030.3570@localhost.localdomain>
	<alpine.LFD.2.00.0906101803210.3367@localhost.localdomain>
	<alpine.LFD.2.00.0906121800590.3369@localhost.localdomain>
	<alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>
	<alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>
	<alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>
	<alpine.LFD.2.00.0907092020410.2768@localhost.localdomain>
	<alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
	<alpine.LFD.2.00.0908162207370.2782@localhost.localdomain>
	<alpine.LFD.2.00.0908182140340.3361@localhost.localdomain>
	<alpine.LFD.2.00.0908192344500.3361@localhost.localdomain>
	<alpine.LFD.2.00.0908212319370.1769@localhost.localdomain>
	<alpine.LFD.2.00.0908261910460.2888@localhost.localdomain>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 27 Aug 2009 14:03:05 +0300
In-Reply-To: <alpine.LFD.2.00.0908261910460.2888@localhost.localdomain> (Thomas Gleixner's message of "Wed\, 26 Aug 2009 19\:23\:46 +0200 \(CEST\)")
Message-ID: <878wh5friu.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> We are pleased to announce the next update to our new preempt-rt
> series.
>  
>     - update to Linus' latest
>  
>     - perf counter crash fix (peterz)
>     
>     - disabled MARKERS on RT. Code with no use(rs) which just causes
>       trouble.
>
>     - edge irq forced threading fix. Fixes the IDE "interrupt lost"
>       reports
>

Hi Thomas,

Here's one more atomic_spin_lock conversion for a driver update
that went in for -rc7.

Kevin

>From 4faf27a4c0ceaddd7cb13f5d11928babc9c4cddc Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Thu, 27 Aug 2009 13:51:47 +0300
Subject: [PATCH -rt] MFD: twl4030: convert irq_desc lock to atomic spinlock

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 drivers/mfd/twl4030-irq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 7d43083..c1bc157 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -458,12 +458,12 @@ static void twl4030_sih_do_edge(struct work_struct *work)
 
 		bytes[byte] &= ~(0x03 << off);
 
-		spin_lock_irq(&d->lock);
+		atomic_spin_lock_irq(&d->lock);
 		if (d->status & IRQ_TYPE_EDGE_RISING)
 			bytes[byte] |= BIT(off + 1);
 		if (d->status & IRQ_TYPE_EDGE_FALLING)
 			bytes[byte] |= BIT(off + 0);
-		spin_unlock_irq(&d->lock);
+		atomic_spin_unlock_irq(&d->lock);
 
 		edge_change &= ~BIT(i);
 	}
-- 
1.6.4

