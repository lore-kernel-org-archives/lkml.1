Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbZJZCy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbZJZCy1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 22:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbZJZCyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 22:54:25 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:33872
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754517AbZJZCyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 22:54:23 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz1432R98dNzz1202hzzz32i27bh6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KS3PEF-02-0NA-02
X-M-MSG: 
Date: Mon, 26 Oct 2009 10:54:06 +0800
From: Crane Cai <crane.cai@amd.com>
To: Jean Delvare <khali@linux-fr.org>
CC: djwong@us.ibm.com, Bjorn Helgaas <bjorn.helgaas@hp.com>, lenb@kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-i2c@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-scmi: support IBM SMBus CMI devices
Message-ID: <20091026025406.GC8086@crane-desktop>
Mail-Followup-To: Crane Cai <crane.cai@amd.com>,
	Jean Delvare <khali@linux-fr.org>, djwong@us.ibm.com,
	Bjorn Helgaas <bjorn.helgaas@hp.com>, lenb@kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20091020231149.GM26149@tux1.beaverton.ibm.com> <20091021023016.GC32413@crane-desktop> <200910210857.13978.bjorn.helgaas@hp.com> <20091021173733.GN26149@tux1.beaverton.ibm.com> <20091022071748.GA17917@crane-desktop> <20091022174304.GO26149@tux1.beaverton.ibm.com> <20091023044451.GB1367@crane-desktop> <20091023170306.GP26149@tux1.beaverton.ibm.com> <20091025103932.31ce9a6d@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20091025103932.31ce9a6d@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 26 Oct 2009 02:54:08.0989 (UTC) FILETIME=[96D5F0D0:01CA55E7]
X-Bypass-Agent: IPF-1;
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

I have modified the source as Jean suggested. Please apply.

---
>From 5b745774be8fe3f9670fe296b56a0c2964a362f8 Mon Sep 17 00:00:00 2001
From: Crane Cai <crane.cai@amd.com>
Date: Fri, 23 Oct 2009 10:13:58 +0800
Subject: [PATCH] i2c-scmi: support IBM SMBus CMI devices

*) add a new HID for IBM SMBus CMI devices
*) add methods for IBM SMBus CMI devices
*) hook different HID with different control methods set

Signed-off-by: Crane Cai <crane.cai@amd.com>
---
 drivers/i2c/busses/i2c-scmi.c |   31 +++++++++++++++++++++++--------
 1 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/i2c/busses/i2c-scmi.c b/drivers/i2c/busses/i2c-scmi.c
index b4a55d4..d68b44f 100644
--- a/drivers/i2c/busses/i2c-scmi.c
+++ b/drivers/i2c/busses/i2c-scmi.c
@@ -33,6 +33,7 @@ struct acpi_smbus_cmi {
 	u8 cap_info:1;
 	u8 cap_read:1;
 	u8 cap_write:1;
+	struct smbus_methods_t *methods;
 };
 
 static const struct smbus_methods_t smbus_methods = {
@@ -41,8 +42,16 @@ static const struct smbus_methods_t smbus_methods = {
 	.mt_sbw  = "_SBW",
 };
 
+/* Some IBM BIOSes omit the leading underscore */
+static const struct smbus_methods_t ibm_smbus_methods = {
+	.mt_info = "SBI_",
+	.mt_sbr  = "SBR_",
+	.mt_sbw  = "SBW_",
+};
+
 static const struct acpi_device_id acpi_smbus_cmi_ids[] = {
-	{"SMBUS01", 0},
+	{"SMBUS01", (kernel_ulong_t)&smbus_methods},
+	{"SMBUSIBM", (kernel_ulong_t)&ibm_smbus_methods},
 	{"", 0}
 };
 
@@ -150,11 +159,11 @@ acpi_smbus_cmi_access(struct i2c_adapter *adap, u16 addr, unsigned short flags,
 
 	if (read_write == I2C_SMBUS_READ) {
 		protocol |= ACPI_SMBUS_PRTCL_READ;
-		method = smbus_methods.mt_sbr;
+		method = smbus_cmi->methods->mt_sbr;
 		input.count = 3;
 	} else {
 		protocol |= ACPI_SMBUS_PRTCL_WRITE;
-		method = smbus_methods.mt_sbw;
+		method = smbus_cmi->methods->mt_sbw;
 		input.count = 5;
 	}
 
@@ -290,13 +299,13 @@ static int acpi_smbus_cmi_add_cap(struct acpi_smbus_cmi *smbus_cmi,
 	union acpi_object *obj;
 	acpi_status status;
 
-	if (!strcmp(name, smbus_methods.mt_info)) {
+	if (!strcmp(name, smbus_cmi->methods->mt_info)) {
 		status = acpi_evaluate_object(smbus_cmi->handle,
-					smbus_methods.mt_info,
+					smbus_cmi->methods->mt_info,
 					NULL, &buffer);
 		if (ACPI_FAILURE(status)) {
 			ACPI_ERROR((AE_INFO, "Evaluating %s: %i",
-				   smbus_methods.mt_info, status));
+				   smbus_cmi->methods->mt_info, status));
 			return -EIO;
 		}
 
@@ -319,9 +328,9 @@ static int acpi_smbus_cmi_add_cap(struct acpi_smbus_cmi *smbus_cmi,
 
 		kfree(buffer.pointer);
 		smbus_cmi->cap_info = 1;
-	} else if (!strcmp(name, smbus_methods.mt_sbr))
+	} else if (!strcmp(name, smbus_cmi->methods->mt_sbr))
 		smbus_cmi->cap_read = 1;
-	else if (!strcmp(name, smbus_methods.mt_sbw))
+	else if (!strcmp(name, smbus_cmi->methods->mt_sbw))
 		smbus_cmi->cap_write = 1;
 	else
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Unsupported CMI method: %s\n",
@@ -349,6 +358,7 @@ static acpi_status acpi_smbus_cmi_query_methods(acpi_handle handle, u32 level,
 static int acpi_smbus_cmi_add(struct acpi_device *device)
 {
 	struct acpi_smbus_cmi *smbus_cmi;
+	const struct acpi_device_id *id;
 
 	smbus_cmi = kzalloc(sizeof(struct acpi_smbus_cmi), GFP_KERNEL);
 	if (!smbus_cmi)
@@ -362,6 +372,11 @@ static int acpi_smbus_cmi_add(struct acpi_device *device)
 	smbus_cmi->cap_read = 0;
 	smbus_cmi->cap_write = 0;
 
+	for (id = acpi_smbus_cmi_ids; id->id[0]; id++)
+		if (!strcmp(id->id, acpi_device_hid(device)))
+			smbus_cmi->methods =
+				(struct smbus_methods_t *) id->driver_data;
+
 	acpi_walk_namespace(ACPI_TYPE_METHOD, smbus_cmi->handle, 1,
 			    acpi_smbus_cmi_query_methods, smbus_cmi, NULL);
 
-- 
1.6.0.4


On Sun, Oct 25, 2009 at 10:39:32AM +0100, Jean Delvare wrote:
> > +	for (id = (struct acpi_device_id *)acpi_smbus_cmi_ids; id->id[0]; id++)
> 
> This cast shouldn't be needed. The problem is that you should have
> declared "id" const in the first place.
> 
> > +		if (!strcmp((char *) id->id, acpi_device_hid(device)))
> 
> This cast doesn't seem needed either. At least I don't get any warning
> without it, do you?
> 

-- 
Best Regards,
- Crane

