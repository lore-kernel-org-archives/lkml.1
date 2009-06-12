Return-Path: <linux-kernel-owner+w=401wt.eu-S933347AbZFLJaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347AbZFLJaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759104AbZFLJaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:30:10 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:41895 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140AbZFLJaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:30:09 -0400
Date: Fri, 12 Jun 2009 17:27:37 +0800
From: Harald Welte <HaraldWelte@viatech.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: Add driver for VIA CPU core
	temperature
Message-ID: <20090612092737.GD30843@prithivi.gnumonks.org>
References: <20090609083406.GE25316@prithivi.gnumonks.org> <loom.20090610T172830-164@post.gmane.org> <20090611153255.ba8d6c54.akpm@linux-foundation.org> <20090612101200.3fe6d494@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612101200.3fe6d494@hyperion.delvare>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean and Tomaz,

On Fri, Jun 12, 2009 at 10:12:00AM +0200, Jean Delvare wrote:
> > > Harald,
> > 
> > You carefully removed Harald from Cc: so he probably didn't read your
> > email.

That was indeed true, thanks for noticing this.

> > > via-cputemp-isa-0000
> 
> Harald, dashes in hwmon chip names are _prohibited_. Please change to
> via_cputemp or similar.

done.

> Temperature values are supposed to be expressed in millidegrees C, not
> degrees C as it seems to be doing 

> (although 25 degrees C seems pretty low for a CPU temperature?) 

It's really low, though the VIA Nano on my desk has 30 degrees C and doesn't
need a fan.  Only during kernel compiles it goes to something like 40
centigrade.

Some older C7 (Model A) had an errata where the temperature sensors had a
really high error on low temperatures.

There is also another errata with that C7 Model A, where if you underclock
the FSB of the CPU, the temperature reading would be wrong (but much too
high in that case).

Since there really is nothing we can do in software to fix this, I didn't
put any of this in the driver.  What I could do though is some bits to
add a printk() message once you load the driver on such a system.

> The drivers needs to multiply values by 1000 before exporting them to sysfs.
> Then "sensors" will report the correct temperature value.

done.  Please find an incremental patch right here:
=============
diff --git a/drivers/hwmon/via-cputemp.c b/drivers/hwmon/via-cputemp.c
index 1032355..2abe516 100644
--- a/drivers/hwmon/via-cputemp.c
+++ b/drivers/hwmon/via-cputemp.c
@@ -37,7 +37,7 @@
 #include <asm/msr.h>
 #include <asm/processor.h>
 
-#define DRVNAME	"via-cputemp"
+#define DRVNAME	"via_cputemp"
 
 typedef enum { SHOW_TEMP, SHOW_LABEL, SHOW_NAME } SHOW;
 
@@ -81,7 +81,7 @@ static ssize_t show_temp(struct device *dev,
 	if (err)
 		return -EAGAIN;
 
-	err = sprintf(buf, "%d\n", eax & 0xffffff);
+	err = sprintf(buf, "%d\n", (eax & 0xffffff) * 1000);
 
 	return err;
 }
=============

I'll re-submit the full driver after adding the above-mentioned printk.

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
