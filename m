Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbZBPIak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbZBPIak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 03:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbZBPIaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 03:30:10 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:48360 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbZBPIaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 03:30:08 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Mike Murphy <mamurph@cs.clemson.edu>, linux-usb@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [PATCH] input: xpad.c - Xbox 360 wireless and sysfs support
Date: Mon, 16 Feb 2009 09:31:33 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <5aa163d00902142008g138826br80d3ea989e7af691@mail.gmail.com>
In-Reply-To: <5aa163d00902142008g138826br80d3ea989e7af691@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902160931.34771.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sunday 15 February 2009 05:08:46 schrieb Mike Murphy:
> Greetings,
> 
> The attached patch is a result of a few days of hacking to get better
> Linux support for Xbox 360 wireless controllers. Major functional
> improvements include support for the LEDs on the wireless controllers
> (which are auto-set to the controller number as they are on the
> official console), added support for rumble effects on wireless
> controllers, added support for dead zones on all supported
> controllers, and added support for a square axis mapping for the left
> stick on all supported controllers. A large amount of the bulk in this
> patch is from the addition of a sysfs interface to retrieve
> information and adjust the dead zone/square axis settings.
[..]
> Patch generated against 2.6.28.2 (no changes in relevant in-kernel
> driver from 2.6.28.2 to 2.6.28.5, so should apply against latest
> stable).
> 
> Comments are appreciated. I am _NOT_ subscribed to the LKML, so please
> CC me directly.

1. You need to check the returns of sscanf
2. This is very ugly:

+/* read-only attrs */
+static ssize_t xpad_show_int(struct xpad_data *xd, struct xpad_attribute *attr,
+	char *buf)
+{
+	int value;
+	if (!strcmp(attr->attr.name, "controller_number"))
+		value = xd->controller_number;
+	else if (!strcmp(attr->attr.name, "pad_present"))
+		value = xd->pad_present;
+	else if (!strcmp(attr->attr.name, "controller_type"))
+		value = xd->controller_type;
+	else
+		value = 0;
+	return sprintf(buf, "%d\n", value);
+}

3. Possible memory leak in error case:

+static struct xpad_data *xpad_create_data(const char *name, struct kobject *parent) {
+	struct xpad_data *data = NULL;
+	int check;
+	
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return NULL;
+	
+	check = kobject_init_and_add(&data->kobj, &xpad_ktype, parent, "%s", name);
+	if (check) {
+		kobject_put(&data->kobj);
+		return NULL;
+	}

4. Why the cpup variety?

+	coords[0] = (__s16) le16_to_cpup((__le16 *)(data + x_offset));

5. What happens if this work is already scheduled?

 	if (data[0] & 0x08) {
+		padnum = xpad->controller_data->controller_number;
 		if (data[1] & 0x80) {
-			xpad->pad_present = 1;
-			usb_submit_urb(xpad->bulk_out, GFP_ATOMIC);
-		} else
-			xpad->pad_present = 0;
+			printk(KERN_INFO "Wireless Xbox 360 pad #%d present\n", padnum);
+			xpad->controller_data->pad_present = 1;
+			
+			INIT_WORK(&xpad->work, &xpad_work_controller);
+			schedule_work(&xpad->work);

6. No GFP_ATOMIC. If you can take a mutex you can sleep.
+		usb_submit_urb(xpad->irq_out, GFP_ATOMIC);

	Regards
		Oliver

