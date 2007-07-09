Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbXGIPxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbXGIPxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 11:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbXGIPw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 11:52:57 -0400
Received: from andromeda.dapyr.net ([69.45.6.100]:37397 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbXGIPw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 11:52:56 -0400
From: darnok@68k.org
Date: Mon, 9 Jul 2007 11:53:02 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Inhibit NMI watchdog when Alt-SysRq-T operation is underway.
Message-ID: <20070709155302.GB26570@andromeda.dapyr.net>
References: <20070709140242.GA18098@andromeda.dapyr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070709140242.GA18098@andromeda.dapyr.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 10:02:42AM -0400, Konrad Rzeszutek wrote:
> On large memory configuration with not so fast CPUs the NMI watchdog 
> is triggered when memory addresses are being gathered and printed. 
> The code paths for Alt-SysRq-t are sprinkled with touch_nmi_watchdog 
> in various places but not in this routine (or in the loop that utilizes
> this function). The patch has been tested for regression on large CPU+memory 
> configuration (128 logical CPUs + 224 GB) and 1,2,4,16-CPU sockets with various 
> memory sizes (1,2,4,6,20). 

And the patch:

diff --git a/arch/x86_64/kernel/traps.c b/arch/x86_64/kernel/traps.c
index aac1c0b..b6e7d67 100644
--- a/arch/x86_64/kernel/traps.c
+++ b/arch/x86_64/kernel/traps.c
@@ -330,6 +330,10 @@ static int print_trace_stack(void *data,
 
 static void print_trace_address(void *data, unsigned long addr)
 {
+	static int i = 0;		
+	if (i && ((i % 8) == 0)) 
+		touch_nmi_watchdog();
+	i++;
 	printk_address(addr);
 }
 
