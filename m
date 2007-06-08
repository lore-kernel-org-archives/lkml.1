Return-Path: <linux-kernel-owner+w=401wt.eu-S1031551AbXFHSrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031551AbXFHSrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbXFHSqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:46:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:36706 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760027AbXFHSqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:46:53 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19o+dMt9gJopY4OsUfzaSICqzKk3sHzdjKxWRpfXl
	+CmFpUiP/oDPV+
Date: Fri, 8 Jun 2007 20:46:50 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ak@suse.de
Subject: Re: [PATCH 1/2] i386: Fix NMI watchdog not reserving its MSRs
Message-ID: <20070608184650.GB2204@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	"Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, ak@suse.de
References: <465C2225.2000100@googlemail.com> <20070603150246.5151dda6@laptop.hypervisor.org> <20070608060244.GA2369@atjola.homenet> <20070607234153.09c32b49.akpm@linux-foundation.org> <20070608105808.GA10190@elte.hu> <20070608184422.GA2204@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070608184422.GA2204@atjola.homenet>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

At system boot time, the NMI watchdog no longer reserved its MSRs,
allowing other subsystems to mess with them. Fix that.

Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
---
diff --git a/arch/i386/kernel/cpu/perfctr-watchdog.c b/arch/i386/kernel/cpu/perfctr-watchdog.c
index 2b04c8f..f0b6763 100644
--- a/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ b/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -614,6 +614,12 @@ int lapic_watchdog_init(unsigned nmi_hz)
 		probe_nmi_watchdog();
 		if (!wd_ops)
 			return -1;
+
+		if (!wd_ops->reserve()) {
+			printk(KERN_ERR
+				"NMI watchdog: cannot reserve perfctrs\n");
+			return -1;
+		}
 	}
 
 	if (!(wd_ops->setup(nmi_hz))) {
