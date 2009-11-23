Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbZKWD3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbZKWD3y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 22:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756126AbZKWD3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 22:29:53 -0500
Received: from ozlabs.org ([203.10.76.45]:53841 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbZKWD3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 22:29:52 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: MODULE_DEVICE_TABLE(isapnp, ...) does nothing
Date: Mon, 23 Nov 2009 13:59:53 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Greg KH <gregkh@suse.de>
References: <200911222201.59471.linux@rainbow-software.org>
In-Reply-To: <200911222201.59471.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911231359.54544.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009 07:31:57 am Ondrej Zary wrote:
> The problem is that 
> scripts/mod/file2alias.c simply ignores isapnp.

AFAICT it always has, and noone has complained until now.  Perhaps something
was still reading /lib/modules/`uname -r`/modules.isapnpmap?

Two things are required:
1) Modify file2alias to add aliases for isapnp.  This is pretty easy.
2) Expose the isapnp devices in sysfs where udev will match them up
   (/sys/bus/isa/devices/<dev>/modalias I guess?)

The first patches would look something like these.  We could mangle the
PNP names a-la ISAPNP_VENDOR/ISAPNP_DEVICE, but as long as the published
modalias matches the file2alias result, it doesn't matter.

Jaroslav?  Greg?  Patches for sysfs welcome...

Thanks,
Rusty.
PS.  Jon, perhaps the new decade is a good time to kill modules.*map?

isapnp: move definitions to mod_devicetable.h so file2alias can reach them.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/isapnp.h b/include/linux/isapnp.h
--- a/include/linux/isapnp.h
+++ b/include/linux/isapnp.h
@@ -43,10 +43,10 @@
  */
 
 #ifdef __KERNEL__
+#include <linux/mod_devicetable.h>
 
 #define DEVICE_COUNT_COMPATIBLE 4
 
-#define ISAPNP_ANY_ID		0xffff
 #define ISAPNP_CARD_DEVS	8
 
 #define ISAPNP_CARD_ID(_va, _vb, _vc, _device) \
@@ -74,12 +74,6 @@ struct isapnp_card_id {
 #define ISAPNP_DEVICE_SINGLE_END \
 		.card_vendor = 0, .card_device = 0
 
-struct isapnp_device_id {
-	unsigned short card_vendor, card_device;
-	unsigned short vendor, function;
-	unsigned long driver_data;	/* data private to the driver */
-};
-
 #if defined(CONFIG_ISAPNP) || (defined(CONFIG_ISAPNP_MODULE) && defined(MODULE))
 
 #define __ISAPNP__
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -474,4 +474,11 @@ struct platform_device_id {
 			__attribute__((aligned(sizeof(kernel_ulong_t))));
 };
 
+#define ISAPNP_ANY_ID		0xffff
+struct isapnp_device_id {
+	unsigned short card_vendor, card_device;
+	unsigned short vendor, function;
+	kernel_ulong_t driver_data;	/* data private to the driver */
+};
+
 #endif /* LINUX_MOD_DEVICETABLE_H */


isapnp: put aliases in .modinfo so modinfo can find them.

Once isa devices publish a modalias field, I think udev should "Just Work".

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -727,6 +727,19 @@ static int do_platform_entry(const char 
 	return 1;
 }
 
+/* Format is: isa:cvNcdNvNfN */
+static int do_isapnp_entry(const char *filename,
+			   struct isapnp_device_id *id, char *alias)
+{
+	strcpy(alias, "isa:");
+	ADD(alias, "cv", id->card_vendor != ISAPNP_ANY_ID, id->card_vendor);
+	ADD(alias, "cd", id->card_device != ISAPNP_ANY_ID, id->card_device);
+	ADD(alias, "v", id->vendor != ISAPNP_ANY_ID, id->vendor);
+	ADD(alias, "f", id->function, id->function);
+	add_wildcard(alias);
+	return 1;
+}
+
 /* Ignore any prefix, eg. some architectures prepend _ */
 static inline int sym_is(const char *symbol, const char *name)
 {
@@ -874,6 +887,10 @@ void handle_moddevtable(struct module *m
 		do_table(symval, sym->st_size,
 			 sizeof(struct platform_device_id), "platform",
 			 do_platform_entry, mod);
+	else if (sym_is(symname, "__mod_isapnp_device_table"))
+		do_table(symval, sym->st_size,
+			 sizeof(struct isapnp_device_id), "isa",
+			 do_isapnp_entry, mod);
 	free(zeros);
 }
 
