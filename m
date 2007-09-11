Return-Path: <linux-kernel-owner+w=401wt.eu-S1763263AbXIKIg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763263AbXIKIg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 04:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763075AbXIKIgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 04:36:14 -0400
Received: from smtp.nokia.com ([131.228.20.171]:22654 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762761AbXIKIgL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 04:36:11 -0400
Subject: Re: [PATCH try #2] Blackfin on-chip NAND Flash Controller driver
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: bryan.wu@analog.com
Cc: David Woodhouse <dwmw2@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mike Frysinger <vapier.adi@gmail.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <1189417837.28956.9.camel@roc-desktop>
References: <1188885450.7074.7.camel@roc-laptop>
	 <1189144341.14370.77.camel@sauron>  <1189417837.28956.9.camel@roc-desktop>
Content-Type: text/plain; charset=utf-8
Date: Tue, 11 Sep 2007 11:35:07 +0300
Message-Id: <1189499707.14370.107.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 11 Sep 2007 08:35:08.0504 (UTC) FILETIME=[A91A2D80:01C7F44E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2007-09-10 at 17:50 +0800, Bryan Wu wrote:
> Here is the test log, only 2 errors in oobtest. After digging into the
> mtd-nand driver code, it should be no relation to my bf5xx_nand driver.
> Maybe somethings wrong in the mtd-nand code. I intend to get some help
> from you, please see my test log below:

> oobtest: Attempting to read past end of device
> oobtest: An error is expected...
> oobtest: error: read past end of device

This means that MTD did not return an error when the test tried to read
the last NAND page's OOB. Here is the code:

/* Attempt to write off end of device */
ops.mode      = MTD_OOB_AUTO;
ops.ooblen    = mtd->ecclayout->oobavail + 1;
ops.oobbuf    = writebuf;
printk(PRINT_PREF "Attempting to write past end of device\n");
printk(PRINT_PREF "An error is expected...\n");
err = mtd->write_oob(mtd, mtd->size - mtd->writesize, &ops);

So we read OOB size + 1 byte from the last NAND page and get no error.

This test passes for nandsim, so I'm not sure the problem is in the
generic code. On the other hand, it is generic code which should check
rages.

> oobtest: Attempting to write past end of device
> oobtest: An error is expected...
> nand_write_oob: Attempt to write past end of page
> oobtest: Error occurred as expected
> oobtest: Attempting to read past end of device
> oobtest: An error is expected...
> oobtest: error: read past end of device

Similar.

> I plan to do the torture test after this oobtest passed. And this
> nand_test suites are intended to integrated into our Blackfin
> uClinux-dist testsuites.

We are planning to clean up the tests and submit them for kernel
inclusion some day, when we have time.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

