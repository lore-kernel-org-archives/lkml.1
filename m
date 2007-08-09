Return-Path: <linux-kernel-owner+w=401wt.eu-S939452AbXHIMeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939452AbXHIMeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934550AbXHIMeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:34:00 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:30312 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933912AbXHIMd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:33:59 -0400
Date: Thu, 9 Aug 2007 08:26:19 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Joerg Sommrey <jo@sommrey.de>, LKML <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [PATCH] bad temperature values from w83781d in 2.6.22
Message-ID: <20070809122619.GF3584@jupiter.solarsys.private>
References: <20070805183219.0d54802b.akpm@linux-foundation.org> <20070808010316.GB3584@jupiter.solarsys.private> <20070808151716.GA6053@sommrey.de> <20070809035642.GE3584@jupiter.solarsys.private> <20070809070915.GA24252@sommrey.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070809070915.GA24252@sommrey.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg:

> On Wed, Aug 08, 2007 at 11:56:42PM -0400, Mark M. Hoffman wrote:
> > Thanks for sending all that.  I see one bug clearly, and I'm pretty close to
> > seeing the other one.  But for tonight, I need sleep.

There's just one bug after all.  The second was a figment of my sleep-deprived
imagination.

> > In the meantime, please try this command as root, against the newer kernel,
> > *after* you've done 'sensors -s':
> > 
> > 	# i2cset -f 0 0x2d 0x5d 0x0e b
> > 
> > Wait > 2 seconds for the hardware to update itself, then run 'sensors' again.
> > I'm pretty sure you'll see the correct temps.

* Joerg Sommrey <jo@sommrey.de> [2007-08-09 09:09:15 +0200]:
> The displayed temperatures changed to 67.5°C / 66.0°C.  Still, this seems to
> be too high.  The power supply's fan runs too slow for such CPU
> temperatures. In older kernels it becomes noisy above 50°C.
> 
> Under load the temperatures shown are around 95°C, way too high.

My bad, there's a second i2cset command that would have done it.  Please try
this patch against v2.6.22.

* * * * *

commit a3333f720da3a173153b00cebc129c48cd3a40af
Author: Mark M. Hoffman <mhoffman@lightlink.com>
Date:   Thu Aug 9 08:12:46 2007 -0400

    hwmon: fix w83781d temp sensor type setting
    
    Commit 348753379a7704087603dad403603e825422fd9a introduced a regression that
    caused temp2 and temp3 sensor type settings to be written to temp1 instead.
    The result is that temp sensor readings could be way off.
    
    Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>

diff --git a/drivers/hwmon/w83781d.c b/drivers/hwmon/w83781d.c
index f85b48f..c95909c 100644
--- a/drivers/hwmon/w83781d.c
+++ b/drivers/hwmon/w83781d.c
@@ -740,9 +740,9 @@ store_sensor(struct device *dev, struct device_attribute *da,
 static SENSOR_DEVICE_ATTR(temp1_type, S_IRUGO | S_IWUSR,
 	show_sensor, store_sensor, 0);
 static SENSOR_DEVICE_ATTR(temp2_type, S_IRUGO | S_IWUSR,
-	show_sensor, store_sensor, 0);
+	show_sensor, store_sensor, 1);
 static SENSOR_DEVICE_ATTR(temp3_type, S_IRUGO | S_IWUSR,
-	show_sensor, store_sensor, 0);
+	show_sensor, store_sensor, 2);
 
 /* I2C devices get this name attribute automatically, but for ISA devices
    we must create it by ourselves. */


-- 
Mark M. Hoffman
mhoffman@lightlink.com

