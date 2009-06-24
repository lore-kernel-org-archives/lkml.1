Return-Path: <linux-kernel-owner+w=401wt.eu-S1759855AbZFXAV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855AbZFXAV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 20:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZFXAVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 20:21:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45181 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbZFXAVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 20:21:19 -0400
Message-ID: <4A417176.40008@jp.fujitsu.com>
Date: Wed, 24 Jun 2009 09:21:10 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Maciej Rutecki <maciej.rutecki@gmail.com>, Andi Kleen <ak@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend
 to 	disk, mce related?
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>	 <4A3E7F38.7030300@linux.intel.com> <8db1092f0906211313x73ac9340n9af5775b56cfd189@mail.gmail.com> <4A3EE668.5090400@jp.fujitsu.com>
In-Reply-To: <4A3EE668.5090400@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, could you put this patch into urgent too? 

Thanks,
H.Seto

===

[PATCH] x86, mce: percpu mcheck_timer should be pinned

Maciej Rutecki wrote:
> > After normal boot I try:
> > 
> > echo 1 > /sys/devices/system/machinecheck/machinecheck0/check_interval
> > 
> > I found this in dmesg:
> > 
> > [  141.704025] ------------[ cut here ]------------
> > [  141.704039] WARNING: at arch/x86/kernel/cpu/mcheck/mce.c:1102
> > mcheck_timer+0xf5/0x100()

If CONFIG_NO_HZ + CONFIG_SMP, timer added via add_timer() might
be migrated on other cpu.  Use add_timer_on() instead.

Reported-by: Maciej Rutecki <maciej.rutecki@gmail.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Tested-by Maciej Rutecki <maciej.rutecki@gmail.com>
CC: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 7da8fec..8e1794a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1117,7 +1117,7 @@ static void mcheck_timer(unsigned long data)
 		*n = min(*n*2, (int)round_jiffies_relative(check_interval*HZ));
 
 	t->expires = jiffies + *n;
-	add_timer(t);
+	add_timer_on(t, smp_processor_id());
 }
 
 static void mce_do_trigger(struct work_struct *work)
@@ -1321,7 +1321,7 @@ static void mce_init_timer(void)
 		return;
 	setup_timer(t, mcheck_timer, smp_processor_id());
 	t->expires = round_jiffies(jiffies + *n);
-	add_timer(t);
+	add_timer_on(t, smp_processor_id());
 }
 
 /*
--
1.6.3

