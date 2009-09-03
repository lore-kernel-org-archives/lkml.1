Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbZICOdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbZICOdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 10:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZICOdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 10:33:40 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:51313 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752012AbZICOdk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 10:33:40 -0400
From: Frans Pop <elendil@planet.nl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 4/6,v2] thermal: add sanity check for the passive attribute
Date: Thu, 3 Sep 2009 16:33:38 +0200
User-Agent: KMail/1.9.9
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1251303445-25317-1-git-send-email-elendil@planet.nl> <200908311230.32021.elendil@planet.nl> <1251958205.3483.290.camel@rzhang-dt>
In-Reply-To: <1251958205.3483.290.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200909031633.39415.elendil@planet.nl>
X-OriginalArrivalTime: 03 Sep 2009 14:33:40.0123 (UTC) FILETIME=[87AFFEB0:01CA2CA3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 September 2009, Zhang Rui wrote:
> > > > Would 1000 (1 °C) perhaps be more acceptable as a limit? I doubt
> > > > there are valid use-cases for below 0 temps :-)
> >
> > I'd prefer this option. Do you see any downside to this?
>
> I see many laptops with a passive trip point higher than 90C, so a
> passive trip point higher than 100C may be meaningful.
> I think we should use a higher value, say 2000?

I think you misunderstand. I want to return -EINVAL if state < 1000, which
means that they entered a value smaller than 1 degree C. This will prevent
users from entering for example "90" in the expectation that that sets the
trip point to 90 degrees C. See the new patch below.

When they see the error, it will be straightforward to discover that they
should enter 90000 instead, for example because temp is also in
millidegrees.

I don't think there is any reason to test for an upper limit.

Cheers,
FJP


From: Frans Pop <elendil@planet.nl>
Subject: thermal: add sanity check for the passive attribute

Values below 1000 milli-celsius don't make sense and can cause the
system to go into a thermal heart attack: the actual temperature
will always be lower and thus the system will be throttled down to
its lowest setting.

An additional problem is that values below 1000 will show as 0 in
/proc/acpi/thermal/TZx/trip_points:passive.

cat passive
0
echo -n 90 >passive
bash: echo: write error: Invalid argument
echo -n 90000 >passive
cat passive
90000

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Zhang Rui <rui.zhang@intel.com>

diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
index a87dc27..cb3d15b 100644
--- a/Documentation/thermal/sysfs-api.txt
+++ b/Documentation/thermal/sysfs-api.txt
@@ -206,6 +206,7 @@ passive
 	passive trip point for the zone. Activation is done by polling with
 	an interval of 1 second.
 	Unit: millidegrees Celsius
+	Valid values: 0 (disabled) or greater than 1000
 	RW, Optional
 
 *****************************
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 4e83c29..74d2eb5 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -225,6 +225,12 @@ passive_store(struct device *dev, struct device_attribute *attr,
 	if (!sscanf(buf, "%d\n", &state))
 		return -EINVAL;
 
+	/* sanity check: values below 1000 millicelcius don't make sense
+	 * and can cause the system to go into a thermal heart attack
+	 */
+	if (state && state < 1000)
+		return -EINVAL;
+
 	if (state && !tz->forced_passive) {
 		mutex_lock(&thermal_list_lock);
 		list_for_each_entry(cdev, &thermal_cdev_list, node) {
