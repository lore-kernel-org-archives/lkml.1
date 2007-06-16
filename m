Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbXFPVRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbXFPVRY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 17:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755621AbXFPVRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 17:17:18 -0400
Received: from smtp-106-saturday.nerim.net ([62.4.16.106]:52332 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752325AbXFPVRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 17:17:17 -0400
Date: Sat, 16 Jun 2007 23:17:45 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Rudolf Marek <r.marek@assembler.cz>
Subject: [PATCH] hwmon/coretemp: Fix a broken error path
Message-ID: <20070616231745.1b0f7bd9@hyperion.delvare>
In-Reply-To: <1182026585.4230.8.camel@localhost>
References: <1182026585.4230.8.camel@localhost>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Soeren,

On Sat, 16 Jun 2007 22:43:05 +0200, Soeren Sonnenburg wrote:
> this commit makes coretemp fail on my macbook pro.
> 
> 1) rmmod oopses (see below)
> 2) it breaks s2ram
> 
> Soeren
> 
> commit 67f363b1f6a31cf5027a97372f64bcced4f05ba6
> Author: Rudolf Marek <r.marek@assembler.cz>
> Date:   Sun May 27 22:17:43 2007 +0200
> 
>     hwmon/coretemp: Add more safety checks
> 
>     Add detection of AE18 Errata of Core processor and warns
>     users that the absolute readings might be wrong for Core2 processor.
> 
>     Signed-off-by: Rudolf Marek <r.marek@assembler.cz>Subject: hwmon/coretemp: Fix a broken error path
>     Signed-off-by: Jean Delvare <khali@linux-fr.org>


Thanks for reporting. Indeed this patch is broken, sorry for
overlooking it. I tested it but my hardware is such that the faulty
error path was never taken. Please test the following patch (on top of
git-current) and confirm it fixes your problem:

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Rudolf Marek <r.marek@assembler.cz>
---
 drivers/hwmon/coretemp.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.22-rc4.orig/drivers/hwmon/coretemp.c	2007-06-05 10:25:54.000000000 +0200
+++ linux-2.6.22-rc4/drivers/hwmon/coretemp.c	2007-06-16 23:14:06.000000000 +0200
@@ -185,6 +185,7 @@ static int __devinit coretemp_probe(stru
 		/* check for microcode update */
 		rdmsr_on_cpu(data->id, MSR_IA32_UCODE_REV, &eax, &edx);
 		if (edx < 0x39) {
+			err = -ENODEV;
 			dev_err(&pdev->dev,
 				"Errata AE18 not fixed, update BIOS or "
 				"microcode of the CPU!\n");


Thanks,
-- 
Jean Delvare
