Return-Path: <linux-kernel-owner+w=401wt.eu-S1031650AbXHMNtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031650AbXHMNtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937489AbXHMKWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:22:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:54944 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937293AbXHMKWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:22:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=rlcYI5jdGcmPSprRctaj6nNkjpHdd7zSoYz8yt9kUZAPMp3Q9SQ3+fRkiDtd2FKGIx9LuD9BtR1Fog0+kiZqsfS6+IBsnZyh1NAbIC+7Qwv3HeADwoGm2zQMuNYyhBslBiNW3J2DKZ3P5WZ/1SlcyFmwtFmka7qgGODVl4PccFg=
Message-ID: <46C030CE.2000406@gmail.com>
Date: Mon, 13 Aug 2007 14:22:06 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: regression from 2.6.23-rc2 to -rc3 BAT missing
References: <20070813094354.GA4881@gamma.logic.tuwien.ac.at> <46C02D52.40002@gmail.com> <20070813101009.GB4881@gamma.logic.tuwien.ac.at>
In-Reply-To: <20070813101009.GB4881@gamma.logic.tuwien.ac.at>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------060405030204070506080107"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060405030204070506080107
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Please check if the attached patch helps.

Thanks,
Alex.

Norbert Preining wrote:
> On Mon, 13 Aug 2007, Alexey Starikovskiy wrote:
>> Do you know if you have SBS or CM battery? 
>> What driver do you use: sbs.ko or battery.ko?
> 
> I am quite sure that it is a CM battery, not a SBS:
> 
> CONFIG_ACPI_BATTERY=y
> 
> did normal work, and CONFIG_ACPI_SBS=m but module not loaded. Same
> setting as always.
> 
> I also loaded sbs.ko without any change.
> 
> Best wishes
> 
> Norbert
> 
> -------------------------------------------------------------------------------
> Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
> Debian Developer <preining@debian.org>                         Debian TeX Group
> gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> -------------------------------------------------------------------------------
> SCREMBY (n.)
> The dehydrated felt-tip pen attached by a string to the 'Don't Forget'
> board in the kitchen which has never worked in living memory but which
> no one can be bothered to throw away.
> 			--- Douglas Adams, The Meaning of Liff
> 


--------------060405030204070506080107
Content-Type: text/x-patch;
 name="dont_use_acpi_extract_package.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dont_use_acpi_extract_package.patch"

ACPI: Battery: don't use acpi_extract_package()

From: Alexey Starikovskiy <astarikivskiy@suse.de>

acpi_extract_package() creates more problems with memory management than
solves as helper for package handling.

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 drivers/acpi/battery.c |  309 +++++++++++++++++++-----------------------------
 1 files changed, 123 insertions(+), 186 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index d7b499f..14bdfad 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -36,9 +36,6 @@
 
 #define ACPI_BATTERY_VALUE_UNKNOWN 0xFFFFFFFF
 
-#define ACPI_BATTERY_FORMAT_BIF	"NNNNNNNNNSSSS"
-#define ACPI_BATTERY_FORMAT_BST	"NNNN"
-
 #define ACPI_BATTERY_COMPONENT		0x00040000
 #define ACPI_BATTERY_CLASS		"battery"
 #define ACPI_BATTERY_DEVICE_NAME	"Battery"
@@ -90,29 +87,6 @@ static struct acpi_driver acpi_battery_driver = {
 		},
 };
 
-struct acpi_battery_state {
-	acpi_integer state;
-	acpi_integer present_rate;
-	acpi_integer remaining_capacity;
-	acpi_integer present_voltage;
-};
-
-struct acpi_battery_info {
-	acpi_integer power_unit;
-	acpi_integer design_capacity;
-	acpi_integer last_full_capacity;
-	acpi_integer battery_technology;
-	acpi_integer design_voltage;
-	acpi_integer design_capacity_warning;
-	acpi_integer design_capacity_low;
-	acpi_integer battery_capacity_granularity_1;
-	acpi_integer battery_capacity_granularity_2;
-	acpi_string model_number;
-	acpi_string serial_number;
-	acpi_string battery_type;
-	acpi_string oem_info;
-};
-
 enum acpi_battery_files {
 	ACPI_BATTERY_INFO = 0,
 	ACPI_BATTERY_STATE,
@@ -120,32 +94,42 @@ enum acpi_battery_files {
 	ACPI_BATTERY_NUMFILES,
 };
 
-struct acpi_battery_flags {
-	u8 battery_present_prev;
-	u8 alarm_present;
-	u8 init_update;
-	u8 update[ACPI_BATTERY_NUMFILES];
-	u8 power_unit;
-};
-
 struct acpi_battery {
 	struct acpi_device *device;
-	struct acpi_battery_flags flags;
-	struct acpi_buffer bif_data;
-	struct acpi_buffer bst_data;
 	struct mutex lock;
 	unsigned long alarm;
 	unsigned long update_time[ACPI_BATTERY_NUMFILES];
-
+	int state;
+	int present_rate;
+	int remaining_capacity;
+	int present_voltage;
+	int power_unit;
+	int design_capacity;
+	int last_full_capacity;
+	int technology;
+	int design_voltage;
+	int design_capacity_warning;
+	int design_capacity_low;
+	int capacity_granularity_1;
+	int capacity_granularity_2;
+	char model_number[32];
+	char serial_number[32];
+	char type[32];
+	char oem_info[32];
+	u8 present_prev;
+	u8 alarm_present;
+	u8 init_update;
+	u8 update[ACPI_BATTERY_NUMFILES];
 };
 
 inline int acpi_battery_present(struct acpi_battery *battery)
 {
 	return battery->device->status.battery_present;
 }
+
 inline char *acpi_battery_power_units(struct acpi_battery *battery)
 {
-	if (battery->flags.power_unit)
+	if (battery->power_unit)
 		return ACPI_BATTERY_UNITS_AMPS;
 	else
 		return ACPI_BATTERY_UNITS_WATTS;
@@ -166,43 +150,63 @@ static void acpi_battery_check_result(struct acpi_battery *battery, int result)
 		return;
 
 	if (result) {
-		battery->flags.init_update = 1;
+		battery->init_update = 1;
 	}
 }
 
-static int acpi_battery_extract_package(struct acpi_battery *battery,
-					union acpi_object *package,
-					struct acpi_buffer *format,
-					struct acpi_buffer *data,
-					char *package_name)
-{
-	acpi_status status = AE_OK;
-	struct acpi_buffer data_null = { 0, NULL };
+struct acpi_offsets {
+	size_t offset;		/* offset inside struct acpi_sbs_battery */
+	u8 mode;		/* int or string? */
+};
 
-	status = acpi_extract_package(package, format, &data_null);
-	if (status != AE_BUFFER_OVERFLOW) {
-		ACPI_EXCEPTION((AE_INFO, status, "Extracting size %s",
-				package_name));
-		return -ENODEV;
-	}
+static struct acpi_offsets state_offsets[] = {
+	{offsetof(struct acpi_battery, state), 0},
+	{offsetof(struct acpi_battery, present_rate), 0},
+	{offsetof(struct acpi_battery, remaining_capacity), 0},
+	{offsetof(struct acpi_battery, present_voltage), 0},
+};
 
-	if (data_null.length != data->length) {
-		kfree(data->pointer);
-		data->pointer = kzalloc(data_null.length, GFP_KERNEL);
-		if (!data->pointer) {
-			ACPI_EXCEPTION((AE_INFO, AE_NO_MEMORY, "kzalloc()"));
-			return -ENOMEM;
-		}
-		data->length = data_null.length;
-	}
+static struct acpi_offsets info_offsets[] = {
+	{offsetof(struct acpi_battery, power_unit), 0},
+	{offsetof(struct acpi_battery, design_capacity), 0},
+	{offsetof(struct acpi_battery, last_full_capacity), 0},
+	{offsetof(struct acpi_battery, technology), 0},
+	{offsetof(struct acpi_battery, design_voltage), 0},
+	{offsetof(struct acpi_battery, design_capacity_warning), 0},
+	{offsetof(struct acpi_battery, design_capacity_low), 0},
+	{offsetof(struct acpi_battery, capacity_granularity_1), 0},
+	{offsetof(struct acpi_battery, capacity_granularity_2), 0},
+	{offsetof(struct acpi_battery, model_number), 1},
+	{offsetof(struct acpi_battery, serial_number), 1},
+	{offsetof(struct acpi_battery, type), 1},
+	{offsetof(struct acpi_battery, oem_info), 1},
+};
 
-	status = acpi_extract_package(package, format, data);
-	if (ACPI_FAILURE(status)) {
-		ACPI_EXCEPTION((AE_INFO, status, "Extracting %s",
-				package_name));
-		return -ENODEV;
+static int extract_package(struct acpi_battery *battery,
+			   union acpi_object *package,
+			   struct acpi_offsets *offsets, int num)
+{
+	int i, *x;
+	union acpi_object *element;
+	if (package->type != ACPI_TYPE_PACKAGE)
+		return -EFAULT;
+	for (i = 0; i < num; ++i) {
+		if (package->package.count <= i)
+			return -EFAULT;
+		element = &package->package.elements[i];
+		if (offsets[i].mode) {
+			if (element->type != ACPI_TYPE_STRING &&
+			    element->type != ACPI_TYPE_BUFFER)
+				return -EFAULT;
+			strncpy((u8 *)battery + offsets[i].offset,
+				element->string.pointer, 32);
+		} else {
+			if (element->type != ACPI_TYPE_INTEGER)
+				return -EFAULT;
+			x = (int *)((u8 *)battery + offsets[i].offset);
+			*x = element->integer.value;
+		}
 	}
-
 	return 0;
 }
 
@@ -223,19 +227,10 @@ static int acpi_battery_get_info(struct acpi_battery *battery)
 	int result = 0;
 	acpi_status status = 0;
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
-	struct acpi_buffer format = { sizeof(ACPI_BATTERY_FORMAT_BIF),
-		ACPI_BATTERY_FORMAT_BIF
-	};
-	union acpi_object *package = NULL;
-	struct acpi_buffer *data = NULL;
-	struct acpi_battery_info *bif = NULL;
 
 	battery->update_time[ACPI_BATTERY_INFO] = get_seconds();
-
 	if (!acpi_battery_present(battery))
 		return 0;
-
-	/* Evaluate _BIF */
 	mutex_lock(&battery->lock);
 	status = acpi_evaluate_object(acpi_battery_handle(battery), "_BIF",
 				      NULL, &buffer);
@@ -244,28 +239,9 @@ static int acpi_battery_get_info(struct acpi_battery *battery)
 		ACPI_EXCEPTION((AE_INFO, status, "Evaluating _BIF"));
 		return -ENODEV;
 	}
-
-	package = buffer.pointer;
-
-	data = &battery->bif_data;
-
-	/* Extract Package Data */
-
-	result =
-	    acpi_battery_extract_package(battery, package, &format, data,
-					 "_BIF");
-	if (result)
-		goto end;
-
-      end:
-
+	result = extract_package(battery, buffer.pointer,
+				 info_offsets, ARRAY_SIZE(info_offsets));
 	kfree(buffer.pointer);
-
-	if (!result) {
-		bif = data->pointer;
-		battery->flags.power_unit = bif->power_unit;
-	}
-
 	return result;
 }
 
@@ -274,11 +250,6 @@ static int acpi_battery_get_state(struct acpi_battery *battery)
 	int result = 0;
 	acpi_status status = 0;
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
-	struct acpi_buffer format = { sizeof(ACPI_BATTERY_FORMAT_BST),
-		ACPI_BATTERY_FORMAT_BST
-	};
-	union acpi_object *package = NULL;
-	struct acpi_buffer *data = NULL;
 
 	battery->update_time[ACPI_BATTERY_STATE] = get_seconds();
 
@@ -294,22 +265,9 @@ static int acpi_battery_get_state(struct acpi_battery *battery)
 		ACPI_EXCEPTION((AE_INFO, status, "Evaluating _BST"));
 		return -ENODEV;
 	}
-
-	package = buffer.pointer;
-
-	data = &battery->bst_data;
-
-	/* Extract Package Data */
-
-	result =
-	    acpi_battery_extract_package(battery, package, &format, data,
-					 "_BST");
-	if (result)
-		goto end;
-
-      end:
+	result = extract_package(battery, buffer.pointer,
+				 state_offsets, ARRAY_SIZE(state_offsets));
 	kfree(buffer.pointer);
-
 	return result;
 }
 
@@ -332,7 +290,7 @@ static int acpi_battery_set_alarm(struct acpi_battery *battery,
 	if (!acpi_battery_present(battery))
 		return -ENODEV;
 
-	if (!battery->flags.alarm_present)
+	if (!battery->alarm_present)
 		return -ENODEV;
 
 	arg0.integer.value = alarm;
@@ -356,22 +314,21 @@ static int acpi_battery_init_alarm(struct acpi_battery *battery)
 	int result = 0;
 	acpi_status status = AE_OK;
 	acpi_handle handle = NULL;
-	struct acpi_battery_info *bif = battery->bif_data.pointer;
 	unsigned long alarm = battery->alarm;
 
 	/* See if alarms are supported, and if so, set default */
 
 	status = acpi_get_handle(acpi_battery_handle(battery), "_BTP", &handle);
 	if (ACPI_SUCCESS(status)) {
-		battery->flags.alarm_present = 1;
-		if (!alarm && bif) {
-			alarm = bif->design_capacity_warning;
+		battery->alarm_present = 1;
+		if (!alarm) {
+			alarm = battery->design_capacity_warning;
 		}
 		result = acpi_battery_set_alarm(battery, alarm);
 		if (result)
 			goto end;
 	} else {
-		battery->flags.alarm_present = 0;
+		battery->alarm_present = 0;
 	}
 
       end:
@@ -387,7 +344,7 @@ static int acpi_battery_init_update(struct acpi_battery *battery)
 	if (result)
 		return result;
 
-	battery->flags.battery_present_prev = acpi_battery_present(battery);
+	battery->present_prev = acpi_battery_present(battery);
 
 	if (acpi_battery_present(battery)) {
 		result = acpi_battery_get_info(battery);
@@ -413,7 +370,7 @@ static int acpi_battery_update(struct acpi_battery *battery,
 		update = 1;
 	}
 
-	if (battery->flags.init_update) {
+	if (battery->init_update) {
 		result = acpi_battery_init_update(battery);
 		if (result)
 			goto end;
@@ -422,8 +379,8 @@ static int acpi_battery_update(struct acpi_battery *battery,
 		result = acpi_battery_get_status(battery);
 		if (result)
 			goto end;
-		if ((!battery->flags.battery_present_prev & acpi_battery_present(battery))
-		    || (battery->flags.battery_present_prev & !acpi_battery_present(battery))) {
+		if ((!battery->present_prev & acpi_battery_present(battery))
+		    || (battery->present_prev & !acpi_battery_present(battery))) {
 			result = acpi_battery_init_update(battery);
 			if (result)
 				goto end;
@@ -435,7 +392,7 @@ static int acpi_battery_update(struct acpi_battery *battery,
 
       end:
 
-	battery->flags.init_update = (result != 0);
+	battery->init_update = (result != 0);
 
 	*update_result_ptr = update_result;
 
@@ -446,19 +403,19 @@ static void acpi_battery_notify_update(struct acpi_battery *battery)
 {
 	acpi_battery_get_status(battery);
 
-	if (battery->flags.init_update) {
+	if (battery->init_update) {
 		return;
 	}
 
-	if ((!battery->flags.battery_present_prev &
+	if ((!battery->present_prev &
 	     acpi_battery_present(battery)) ||
-	    (battery->flags.battery_present_prev &
+	    (battery->present_prev &
 	     !acpi_battery_present(battery))) {
-		battery->flags.init_update = 1;
+		battery->init_update = 1;
 	} else {
-		battery->flags.update[ACPI_BATTERY_INFO] = 1;
-		battery->flags.update[ACPI_BATTERY_STATE] = 1;
-		battery->flags.update[ACPI_BATTERY_ALARM] = 1;
+		battery->update[ACPI_BATTERY_INFO] = 1;
+		battery->update[ACPI_BATTERY_STATE] = 1;
+		battery->update[ACPI_BATTERY_ALARM] = 1;
 	}
 }
 
@@ -471,7 +428,6 @@ static struct proc_dir_entry *acpi_battery_dir;
 static int acpi_battery_print_info(struct seq_file *seq, int result)
 {
 	struct acpi_battery *battery = seq->private;
-	struct acpi_battery_info *bif = NULL;
 	char *units = "?";
 
 	if (result)
@@ -484,30 +440,23 @@ static int acpi_battery_print_info(struct seq_file *seq, int result)
 		goto end;
 	}
 
-	bif = battery->bif_data.pointer;
-	if (!bif) {
-		ACPI_EXCEPTION((AE_INFO, AE_ERROR, "BIF buffer is NULL"));
-		result = -ENODEV;
-		goto end;
-	}
-
 	/* Battery Units */
 
 	units = acpi_battery_power_units(battery);
 
-	if (bif->design_capacity == ACPI_BATTERY_VALUE_UNKNOWN)
+	if (battery->design_capacity == ACPI_BATTERY_VALUE_UNKNOWN)
 		seq_printf(seq, "design capacity:         unknown\n");
 	else
 		seq_printf(seq, "design capacity:         %d %sh\n",
-			   (u32) bif->design_capacity, units);
+			   (u32) battery->design_capacity, units);
 
-	if (bif->last_full_capacity == ACPI_BATTERY_VALUE_UNKNOWN)
+	if (battery->last_full_capacity == ACPI_BATTERY_VALUE_UNKNOWN)
 		seq_printf(seq, "last full capacity:      unknown\n");
 	else
 		seq_printf(seq, "last full capacity:      %d %sh\n",
-			   (u32) bif->last_full_capacity, units);
+			   (u32) battery->last_full_capacity, units);
 
-	switch ((u32) bif->battery_technology) {
+	switch ((u32) battery->technology) {
 	case 0:
 		seq_printf(seq, "battery technology:      non-rechargeable\n");
 		break;
@@ -519,23 +468,23 @@ static int acpi_battery_print_info(struct seq_file *seq, int result)
 		break;
 	}
 
-	if (bif->design_voltage == ACPI_BATTERY_VALUE_UNKNOWN)
+	if (battery->design_voltage == ACPI_BATTERY_VALUE_UNKNOWN)
 		seq_printf(seq, "design voltage:          unknown\n");
 	else
 		seq_printf(seq, "design voltage:          %d mV\n",
-			   (u32) bif->design_voltage);
+			   (u32) battery->design_voltage);
 	seq_printf(seq, "design capacity warning: %d %sh\n",
-		   (u32) bif->design_capacity_warning, units);
+		   (u32) battery->design_capacity_warning, units);
 	seq_printf(seq, "design capacity low:     %d %sh\n",
-		   (u32) bif->design_capacity_low, units);
+		   (u32) battery->design_capacity_low, units);
 	seq_printf(seq, "capacity granularity 1:  %d %sh\n",
-		   (u32) bif->battery_capacity_granularity_1, units);
+		   (u32) battery->capacity_granularity_1, units);
 	seq_printf(seq, "capacity granularity 2:  %d %sh\n",
-		   (u32) bif->battery_capacity_granularity_2, units);
-	seq_printf(seq, "model number:            %s\n", bif->model_number);
-	seq_printf(seq, "serial number:           %s\n", bif->serial_number);
-	seq_printf(seq, "battery type:            %s\n", bif->battery_type);
-	seq_printf(seq, "OEM info:                %s\n", bif->oem_info);
+		   (u32) battery->capacity_granularity_2, units);
+	seq_printf(seq, "model number:            %s\n", battery->model_number);
+	seq_printf(seq, "serial number:           %s\n", battery->serial_number);
+	seq_printf(seq, "battery type:            %s\n", battery->type);
+	seq_printf(seq, "OEM info:                %s\n", battery->oem_info);
 
       end:
 
@@ -548,7 +497,6 @@ static int acpi_battery_print_info(struct seq_file *seq, int result)
 static int acpi_battery_print_state(struct seq_file *seq, int result)
 {
 	struct acpi_battery *battery = seq->private;
-	struct acpi_battery_state *bst = NULL;
 	char *units = "?";
 
 	if (result)
@@ -561,50 +509,43 @@ static int acpi_battery_print_state(struct seq_file *seq, int result)
 		goto end;
 	}
 
-	bst = battery->bst_data.pointer;
-	if (!bst) {
-		ACPI_EXCEPTION((AE_INFO, AE_ERROR, "BST buffer is NULL"));
-		result = -ENODEV;
-		goto end;
-	}
-
 	/* Battery Units */
 
 	units = acpi_battery_power_units(battery);
 
-	if (!(bst->state & 0x04))
+	if (!(battery->state & 0x04))
 		seq_printf(seq, "capacity state:          ok\n");
 	else
 		seq_printf(seq, "capacity state:          critical\n");
 
-	if ((bst->state & 0x01) && (bst->state & 0x02)) {
+	if ((battery->state & 0x01) && (battery->state & 0x02)) {
 		seq_printf(seq,
 			   "charging state:          charging/discharging\n");
-	} else if (bst->state & 0x01)
+	} else if (battery->state & 0x01)
 		seq_printf(seq, "charging state:          discharging\n");
-	else if (bst->state & 0x02)
+	else if (battery->state & 0x02)
 		seq_printf(seq, "charging state:          charging\n");
 	else {
 		seq_printf(seq, "charging state:          charged\n");
 	}
 
-	if (bst->present_rate == ACPI_BATTERY_VALUE_UNKNOWN)
+	if (battery->present_rate == ACPI_BATTERY_VALUE_UNKNOWN)
 		seq_printf(seq, "present rate:            unknown\n");
 	else
 		seq_printf(seq, "present rate:            %d %s\n",
-			   (u32) bst->present_rate, units);
+			   (u32) battery->present_rate, units);
 
-	if (bst->remaining_capacity == ACPI_BATTERY_VALUE_UNKNOWN)
+	if (battery->remaining_capacity == ACPI_BATTERY_VALUE_UNKNOWN)
 		seq_printf(seq, "remaining capacity:      unknown\n");
 	else
 		seq_printf(seq, "remaining capacity:      %d %sh\n",
-			   (u32) bst->remaining_capacity, units);
+			   (u32) battery->remaining_capacity, units);
 
-	if (bst->present_voltage == ACPI_BATTERY_VALUE_UNKNOWN)
+	if (battery->present_voltage == ACPI_BATTERY_VALUE_UNKNOWN)
 		seq_printf(seq, "present voltage:         unknown\n");
 	else
 		seq_printf(seq, "present voltage:         %d mV\n",
-			   (u32) bst->present_voltage);
+			   (u32) battery->present_voltage);
 
       end:
 
@@ -713,7 +654,7 @@ static int acpi_battery_read(int fid, struct seq_file *seq)
 	int update = 0;
 
 	update = (get_seconds() - battery->update_time[fid] >= update_time);
-	update = (update | battery->flags.update[fid]);
+	update = (update | battery->update[fid]);
 
 	result = acpi_battery_update(battery, update, &update_result);
 	if (result)
@@ -728,7 +669,7 @@ static int acpi_battery_read(int fid, struct seq_file *seq)
       end:
 	result = acpi_read_funcs[fid].print(seq, result);
 	acpi_battery_check_result(battery, result);
-	battery->flags.update[fid] = result;
+	battery->update[fid] = result;
 	return result;
 }
 
@@ -902,7 +843,7 @@ static int acpi_battery_add(struct acpi_device *device)
 	if (result)
 		goto end;
 
-	battery->flags.init_update = 1;
+	battery->init_update = 1;
 
 	result = acpi_battery_add_fs(device);
 	if (result)
@@ -948,10 +889,6 @@ static int acpi_battery_remove(struct acpi_device *device, int type)
 
 	acpi_battery_remove_fs(device);
 
-	kfree(battery->bif_data.pointer);
-
-	kfree(battery->bst_data.pointer);
-
 	mutex_destroy(&battery->lock);
 
 	kfree(battery);
@@ -969,7 +906,7 @@ static int acpi_battery_resume(struct acpi_device *device)
 
 	battery = device->driver_data;
 
-	battery->flags.init_update = 1;
+	battery->init_update = 1;
 
 	return 0;
 }

--------------060405030204070506080107--
