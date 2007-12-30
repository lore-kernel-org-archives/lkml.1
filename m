Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbXL3Hu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbXL3Hu2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbXL3HuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:50:15 -0500
Received: from mail.gmx.net ([213.165.64.20]:53303 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751389AbXL3HuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:50:14 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/UO6cubovUO6cNlOgGW+QgygA0d2/Xy9xQv/KOUU
	OSSH4T5sa/stO1
Subject: Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so
	far
From: Mike Galbraith <efault@gmx.de>
To: tglx@linutronix.de
Cc: Maxim <maximlevitsky@gmail.com>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1174174374.13341.448.camel@localhost.localdomain>
References: <200703161230.03712.maximlevitsky@gmail.com>
	 <200703161919.44458.lenb@kernel.org>
	 <200703180100.01889.maximlevitsky@gmail.com>
	 <1174174374.13341.448.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 30 Dec 2007 08:50:10 +0100
Message-Id: <1199001010.5452.30.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(hm, google says i'm not the only one seeing this, so...)

On Sun, 2007-03-18 at 00:32 +0100, Thomas Gleixner wrote:
> Maxim,
> 
> On Sun, 2007-03-18 at 01:00 +0200, Maxim wrote:
> > >Mar 14 00:22:23 MAIN kernel: [    2.072931] checking TSC synchronization [CPU#0 -> CPU#1]:
> > >Mar 14 00:22:23 MAIN kernel: [    2.092922] Measured 72051818872 cycles TSC warp between CPUs, turning off
> > 
> > ^ This one I don't think is related to NO_HZ, maybe it is hardware
> > problem, but it exist without NO_HZ
> 
> The TSC is checked for synchronization between the CPUs. It's nothing to
> worry about. We switch off the TSC and use a different clocksource.
> 
> Is this after resume ? If yes, then something (probably BIOS) is
> fiddling with the TSC of one CPU when the resume happens.

My P4 box has the same "problem", which is remedied by..

diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 9125efe..7b74969 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -46,7 +46,7 @@ static __cpuinit void check_tsc_warp(void)
 	cycles_t start, now, prev, end;
 	int i;
 
-	start = get_cycles_sync();
+	start = last_tsc = get_cycles_sync();
 	/*
 	 * The measurement runs for 20 msecs:
 	 */

..whacking the ancient last_tsc before entering test loop.  Question is,
is there a good reason to disable the TSC once it's been stepped upon by
BIOS?  Are there any ill effects to be awaited by ignoring this BIOS
artifact?  All seems just fine here.

	-Mike

