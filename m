Return-Path: <linux-kernel-owner+w=401wt.eu-S1764914AbXLRClt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764914AbXLRClt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 21:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763011AbXLRCjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 21:39:44 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:20263 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762399AbXLRCjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 21:39:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=DtKmSrD0aEZMVGQLndw7Xhufx6+/8wozEx/k78VEnSvNzRwIiYnqBvHhC41o8K90L+f+mdxkTCc4146Bd4KKqCvsoKzrlioWF0/GU7IEoGugJ4qLDpQO9BXzh9VJj1IiMMOc5OTDRl4FouP1+5NHFffzGpfhS0w3Ff8r5lKiIUs=
Message-ID: <9e4733910712171839h214e0bc3q179266c86e5987b1@mail.gmail.com>
Date: Mon, 17 Dec 2007 21:39:37 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] update module-init-tools to support the i2c subsystem
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow on to: "Series to add device tree naming to i2c"
Teach module-init-tools about the i2c subsystem.

diff --git a/depmod.c b/depmod.c
index 0281c79..209eb0c 100644
--- a/depmod.c
+++ b/depmod.c
@@ -793,6 +793,7 @@ static struct depfile depfiles[] = {
 	{ "modules.inputmap", output_input_table },
 	{ "modules.ofmap", output_of_table },
 	{ "modules.seriomap", output_serio_table },
+	{ "modules.i2cmap", output_i2c_table },
 	{ "modules.alias", output_aliases },
 	{ "modules.symbols", output_symbols },
 };
diff --git a/depmod.h b/depmod.h
index 6cea36e..1040214 100644
--- a/depmod.h
+++ b/depmod.h
@@ -55,6 +55,8 @@ struct module
 	unsigned int input_table_size;
 	unsigned int serio_size;
 	void *serio_table;
+	unsigned int i2c_size;
+	void *i2c_table;
 	unsigned int of_size;
 	void *of_table;

diff --git a/moduleops_core.c b/moduleops_core.c
index 56c85d3..a7ca350 100644
--- a/moduleops_core.c
+++ b/moduleops_core.c
@@ -230,6 +230,11 @@ static void PERBIT(fetch_tables)(struct module *module)
 					"__mod_serio_device_table",
 					NULL, module->conv);

+	module->i2c_size = PERBIT(I2C_DEVICE_SIZE);
+	module->i2c_table = PERBIT(deref_sym)(module->data,
+					"__mod_i2c_device_table",
+					NULL, module->conv);
+
 	module->of_size = PERBIT(OF_DEVICE_SIZE);
 	module->of_table = PERBIT(deref_sym)(module->data,
 					"__mod_of_device_table",
diff --git a/tables.c b/tables.c
index 6dfd165..82e162d 100644
--- a/tables.c
+++ b/tables.c
@@ -496,6 +496,35 @@ void output_serio_table(struct module *modules, FILE *out)
 }


+static void output_i2c_entry(struct i2c_device_id *i2c, char *name, FILE *out)
+{
+	fprintf(out,
+		"%-20s %-20s\n",
+		name,
+		i2c->name);
+}
+
+
+void output_i2c_table(struct module *modules, FILE *out)
+{
+	struct module *i;
+
+	fprintf(out, "# i2c module         name\n");
+
+	for (i = modules; i; i = i->next) {
+		struct i2c_device_id *e;
+		char shortname[strlen(i->pathname) + 1];
+
+		if (!i->i2c_table)
+			continue;
+
+		make_shortname(shortname, i->pathname);
+		for (e = i->i2c_table; e->name[0]; e = (void *)e + i->i2c_size)
+			output_i2c_entry(e, shortname, out);
+	}
+}
+
+
 static void
 strip_whitespace (char *str, char chr)
 {
diff --git a/tables.h b/tables.h
index e5f6f35..263369d 100644
--- a/tables.h
+++ b/tables.h
@@ -164,6 +164,12 @@ struct serio_device_id {
 #define SERIO_DEVICE_SIZE32 (4 * 1)
 #define SERIO_DEVICE_SIZE64 (4 * 1 + 4)

+struct i2c_device_id {
+	char name[48];
+};
+#define I2C_DEVICE_SIZE32 (48 + 4)
+#define I2C_DEVICE_SIZE64 (48 + 8)
+
 struct of_device_id {
 	char name[32];
 	char type[32];
@@ -182,6 +188,7 @@ void output_ccw_table(struct module *modules, FILE *out);
 void output_isapnp_table(struct module *modules, FILE *out);
 void output_input_table(struct module *modules, FILE *out);
 void output_serio_table(struct module *modules, FILE *out);
+void output_i2c_table(struct module *modules, FILE *out);
 void output_of_table(struct module *modules, FILE *out);

 #endif /* MODINITTOOLS_TABLES_H */

-- 
Jon Smirl
jonsmirl@gmail.com
