Return-Path: <linux-kernel-owner+w=401wt.eu-S938073AbXGSOTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938073AbXGSOTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762242AbXGSOSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:18:48 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:53490 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbXGSOSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:18:46 -0400
Date: Thu, 19 Jul 2007 09:18:30 -0500
From: Corey Minyard <minyard@acm.org>
Subject: Re: [PATCH][IPMI] Fix mem leak in try_init_dmi() code
In-reply-to: <200707190057.16051.jesper.juhl@gmail.com>
To: Jesper Juhl <jesper.juhl@gmail.com>, Andrew Morton <akpm@osdl.org>
Cc: Corey Minyard <minyard@mvista.com>, Christian Krafft <krafft@de.ibm.com>,
       openipmi-developer@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: minyard@acm.org
Message-id: <20070719141830.GA4757@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
References: <200707190057.16051.jesper.juhl@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Indeed this is a problem, please merge.  This is only called at init
time and only happens if the BIOS screws something up, so the leak is
slight and it is probably not worth sending to 2.6.22.x.  The driver
would not initialize the interface in the case, and I have no reports
of this happening.  I have booted and run tests on a system with this
patch.  Note that the original patch was munged by the mailer, here's
a new one.


If we ever hit the "default:" case in the switch in try_init_dmi(), 
then we'll leak the storage allocated with kzalloc() and assigned 
to 'info'. 

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---

 drivers/char/ipmi/ipmi_si_intf.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c 
b/drivers/char/ipmi/ipmi_si_intf.c
index 4edfdda..96d2f9e 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2050,6 +2050,7 @@ static __devinit void try_init_dmi(struct dmi_ipmi_data *ipmi_data)
 		info->si_type = SI_BT;
 		break;
 	default:
+		kfree(info);
 		return;
 	}
 
