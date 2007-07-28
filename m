Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbXG1Wrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbXG1Wrg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 18:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757601AbXG1Wr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 18:47:29 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:8144 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458AbXG1Wr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 18:47:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=H9i41sPtxsXEAQNj2ywxnWAlumHYO4THN931JWGZWWr1eRmLAVLl1ix1dVIFFBYoSQzODnlfayvhvezJJu4aDVLOo+uvdnHGOrmYmS5V5CZSsb52s4wN3efKthAYBtM8cBBd24h5D/Oge8Ryz+qOfN8WspcQBU5IvPtYxXPrB4w=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][ACPI] Let's not gamble that a possible double free will never happen in asus_hotk_get_info()
Date: Sun, 29 Jul 2007 00:45:59 +0200
User-Agent: KMail/1.9.7
Cc: Julien Lerouge <julien.lerouge@free.fr>,
       Karol Kozimor <sziwan@users.sourceforge.net>,
       Len Brown <len.brown@intel.com>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707290045.59698.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The Coverity checker points out (CID: 1500) that we can in some 
cases end up doing a double free of 'model' in asus_hotk_get_info().
I'm not 100% sure it is right, but better safe than sorry, 
especially since this is so simple to turn into a non-issue - simply 
set 'model' to NULL after the first kfree() and then the second 
kfree() is harmless (if it actually can happen, and if it cannot
happen then the cost is just a single extra assignment).

Here is the function with Coverity's annotations 
(proposed patch at the end of the mail)

...
1141 	/*
1142 	 * This function is used to initialize the hotk with right values. In this
1143 	 * method, we can make all the detection we want, and modify the hotk struct
1144 	 */
1145 	static int asus_hotk_get_info(void)
1146 	{
1147 		struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
1148 		union acpi_object *model = NULL;
1149 		int bsts_result;
1150 		char *string = NULL;
1151 		acpi_status status;
1152 	
1153 		/*
1154 		 * Get DSDT headers early enough to allow for differentiating between 
1155 		 * models, but late enough to allow acpi_bus_register_driver() to fail 
1156 		 * before doing anything ACPI-specific. Should we encounter a machine,
1157 		 * which needs special handling (i.e. its hotkey device has a different
1158 		 * HID), this bit will be moved. A global variable asus_info contains
1159 		 * the DSDT header.
1160 		 */
1161 		status = acpi_get_table(ACPI_SIG_DSDT, 1, &asus_info);
1162 		if (ACPI_FAILURE(status))
1163 			printk(KERN_WARNING "  Couldn't get the DSDT table header\n");
1164 	
1165 		/* We have to write 0 on init this far for all ASUS models */
1166 		if (!write_acpi_int(hotk->handle, "INIT", 0, &buffer)) {
1167 			printk(KERN_ERR "  Hotkey initialization failed\n");
1168 			return -ENODEV;
1169 		}
1170 	
1171 		/* This needs to be called for some laptops to init properly */
1172 		if (!read_acpi_int(hotk->handle, "BSTS", &bsts_result))
1173 			printk(KERN_WARNING "  Error calling BSTS\n");
1174 		else if (bsts_result)
1175 			printk(KERN_NOTICE "  BSTS called, 0x%02x returned\n",
1176 			       bsts_result);
1177 	
1178 		/*
1179 		 * Try to match the object returned by INIT to the specific model.
1180 		 * Handle every possible object (or the lack of thereof) the DSDT 
1181 		 * writers might throw at us. When in trouble, we pass NULL to 
1182 		 * asus_model_match() and try something completely different.
1183 		 */
1184 		if (buffer.pointer) {

Event alias: aliasing "(buffer).pointer" with "model"
Also see events: [freed_arg][double_free]

1185 			model = buffer.pointer;
1186 			switch (model->type) {
1187 			case ACPI_TYPE_STRING:
1188 				string = model->string.pointer;
1189 				break;
1190 			case ACPI_TYPE_BUFFER:
1191 				string = model->buffer.pointer;
1192 				break;

At conditional (1): "default" taking true path

1193 			default:

Event freed_arg: Pointer "model" freed by function "kfree"
Also see events: [alias][double_free]

1194 				kfree(model);
1195 				break;
1196 			}
1197 		}
1198 		hotk->model = asus_model_match(string);

At conditional (2): "(hotk)->model == 23" taking false path

1199 		if (hotk->model == END_MODEL) {	/* match failed */
1200 			if (asus_info &&
1201 			    strncmp(asus_info->oem_table_id, "ODEM", 4) == 0) {
1202 				hotk->model = P30;
1203 				printk(KERN_NOTICE
1204 				       "  Samsung P30 detected, supported\n");
1205 			} else {
1206 				hotk->model = M2E;
1207 				printk(KERN_NOTICE "  unsupported model %s, trying "
1208 				       "default values\n", string);
1209 				printk(KERN_NOTICE
1210 				       "  send /proc/acpi/dsdt to the developers\n");
1211 			}
1212 			hotk->methods = &model_conf[hotk->model];
1213 			return AE_OK;
1214 		}
1215 		hotk->methods = &model_conf[hotk->model];
1216 		printk(KERN_NOTICE "  %s model detected, supported\n", string);
1217 	
1218 		/* Sort of per-model blacklist */

At conditional (3): "strncmp == 0" taking false path

1219 		if (strncmp(string, "L2B", 3) == 0)
1220 			hotk->methods->lcd_status = NULL;
1221 		/* L2B is similar enough to L3C to use its settings, with this only 
1222 		   exception */

At conditional (4): "strncmp == 0" taking false path

1223 		else if (strncmp(string, "A3G", 3) == 0)
1224 			hotk->methods->lcd_status = "\\BLFG";
1225 		/* A3G is like M6R */

At conditional (5): "strncmp == 0" taking false path
At conditional (6): "strncmp == 0" taking false path
At conditional (7): "strncmp == 0" taking false path

1226 		else if (strncmp(string, "S5N", 3) == 0 ||
1227 			 strncmp(string, "M5N", 3) == 0 ||
1228 			 strncmp(string, "W3N", 3) == 0)
1229 			hotk->methods->mt_mled = NULL;
1230 		/* S5N, M5N and W3N have no MLED */

At conditional (8): "strncmp == 0" taking false path

1231 		else if (strncmp(string, "L5D", 3) == 0)
1232 			hotk->methods->mt_wled = NULL;
1233 		/* L5D's WLED is not controlled by ACPI */

At conditional (9): "strncmp == 0" taking false path
At conditional (10): "strncmp == 0" taking false path
At conditional (11): "strncmp == 0" taking false path

1234 		else if (strncmp(string, "M2N", 3) == 0 ||
1235 			 strncmp(string, "W3V", 3) == 0 ||
1236 			 strncmp(string, "S1N", 3) == 0)
1237 			hotk->methods->mt_wled = "WLED";
1238 		/* M2N, S1N and W3V have a usable WLED */

At conditional (12): "asus_info != 0" taking true path

1239 		else if (asus_info) {

At conditional (13): "strncmp == 0" taking false path

1240 			if (strncmp(asus_info->oem_table_id, "L1", 2) == 0)
1241 				hotk->methods->mled_status = NULL;
1242 			/* S1300A reports L84F, but L1400B too, account for that */
1243 		}
1244 	

Event double_free: Double free of pointer "model" in call to "kfree"
Also see events: [alias][freed_arg]

1245 		kfree(model);
1246 	
1247 		return AE_OK;
1248 	}
...




Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/acpi/asus_acpi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/asus_acpi.c b/drivers/acpi/asus_acpi.c
index 9c4bd22..86fd142 100644
--- a/drivers/acpi/asus_acpi.c
+++ b/drivers/acpi/asus_acpi.c
@@ -1192,6 +1192,7 @@ static int asus_hotk_get_info(void)
 			break;
 		default:
 			kfree(model);
+			model = NULL;
 			break;
 		}
 	}




Please Cc me on replies...


