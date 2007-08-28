Return-Path: <linux-kernel-owner+w=401wt.eu-S1759070AbXH1Uf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070AbXH1Uf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 16:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbXH1UfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 16:35:13 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:43961 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbXH1UfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 16:35:11 -0400
Subject: Re: nmi_watchdog=2 regression in 2.6.21
From: Daniel Walker <dwalker@mvista.com>
To: eranian@hpl.hp.com
Cc: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>, ak@suse.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20070828194636.GB2814@frankl.hpl.hp.com>
References: <1186531609.22044.50.camel@imap.mvista.com>
	 <20070808142059.GF30805@atjola.homenet>
	 <20070827175431.GD784@frankl.hpl.hp.com>
	 <1188237331.2435.255.camel@dhcp193.mvista.com>
	 <20070827225555.GI784@frankl.hpl.hp.com>
	 <1188256074.2435.272.camel@dhcp193.mvista.com>
	 <20070828091217.GA1645@frankl.hpl.hp.com>
	 <1188311684.2435.288.camel@dhcp193.mvista.com>
	 <20070828170556.GI1645@frankl.hpl.hp.com>
	 <1188325835.2435.317.camel@dhcp193.mvista.com>
	 <20070828194636.GB2814@frankl.hpl.hp.com>
Content-Type: text/plain
Date: Tue, 28 Aug 2007 13:26:42 -0700
Message-Id: <1188332802.2435.332.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Here's a simpler patch that fixes the boot hang ..

We have to call off the IPI looping regardless of the check_nmi_watchdog
outcome..

Signed-off-by: Daniel Walker <dwalker@mvista.com>

Index: linux-2.6.22/arch/i386/kernel/nmi.c
===================================================================
--- linux-2.6.22.orig/arch/i386/kernel/nmi.c	2007-08-15 00:51:12.000000000 +0000
+++ linux-2.6.22/arch/i386/kernel/nmi.c	2007-08-28 20:27:56.000000000 +0000
@@ -122,12 +122,12 @@ static int __init check_nmi_watchdog(voi
 			atomic_dec(&nmi_active);
 		}
 	}
+	endflag = 1;
 	if (!atomic_read(&nmi_active)) {
 		kfree(prev_nmi_count);
 		atomic_set(&nmi_active, -1);
 		return -1;
 	}
-	endflag = 1;
 	printk("OK.\n");
 
 	/* now that we know it works we can reduce NMI frequency to




