Return-Path: <linux-kernel-owner+w=401wt.eu-S932351AbZHMUGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351AbZHMUGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932233AbZHMT7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:52 -0400
Received: from kroah.org ([198.145.64.141]:41844 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227AbZHMT7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:50 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:31 2009
Message-Id: <20090813195131.386899357@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Luca Tettamanti <kronos.it@gmail.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: [patch 46/74] hwmon: (asus_atk0110) Fix upper limit readings
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=hwmon-fix-upper-limit-readings.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luca Tettamanti <kronos.it@gmail.com>

commit 8d282497cbf8124d6814d51a74fb13d69531c669 upstream.

On newer Asus boards the "upper" limit of a sensor is encoded as
delta from the "lower" limit. Fix the driver to correctly handle
this case.

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
Tested-by: Alex Macfarlane Smith <nospam@archifishal.co.uk>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/asus_atk0110.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/asus_atk0110.c
+++ b/drivers/hwmon/asus_atk0110.c
@@ -593,7 +593,11 @@ static int atk_add_sensor(struct atk_dat
 	sensor->data = data;
 	sensor->id = flags->integer.value;
 	sensor->limit1 = limit1->integer.value;
-	sensor->limit2 = limit2->integer.value;
+	if (data->old_interface)
+		sensor->limit2 = limit2->integer.value;
+	else
+		/* The upper limit is expressed as delta from lower limit */
+		sensor->limit2 = sensor->limit1 + limit2->integer.value;
 
 	snprintf(sensor->input_attr_name, ATTR_NAME_SIZE,
 			"%s%d_input", base_name, start + *num);


