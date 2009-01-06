Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbZAFPNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbZAFPNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 10:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbZAFPNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 10:13:31 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:51971 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbZAFPNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 10:13:30 -0500
X-IronPort-AV: E=Sophos;i="4.36,339,1228107600"; 
   d="scan'208";a="64838796"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Greg KH" <gregkh@suse.de>
Subject: Re: debugfs & vfs file permission issue?
Date: Tue, 6 Jan 2009 10:12:38 -0500
User-Agent: KMail/1.9.5
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
References: <200901052157.07306.rgetz@blackfin.uclinux.org> <8bd0f97a0901052232l22b60386pbcd9438cc752638f@mail.gmail.com> <200901060705.33294.rgetz@blackfin.uclinux.org>
In-Reply-To: <200901060705.33294.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901061012.38888.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 06 Jan 2009 15:12:27.0698 (UTC) FILETIME=[2FE3C120:01C97011]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 6 Jan 2009 07:05, Robin Getz suggested:
>
> adding a readonly, and writeonly, and ensuring that when you call 
> debugfs_create_*, the mode is checked, and the "correct" fops are set 
> doesn't seem like it would be a bad idea? This would enforce the
> kernel programmer's view on the world, and not allow pesky root users
> to override things....
> 
> Greg - would you take something like that?

How about this?

Feel free to nak it - we can do the same thing where we are calling the
debugfs_create_* functions - this just makes it cleaner in my opinion.

---

In many SOC implementations there are hardware registers can be read only, 
or write only. This extends the debugfs to enforce the file permissions for
these types of registers, by providing a set of fops which are read only
or write only. This assumes that the kernel developer knows more about the
hardware than the user (even root users) - which is normally true.


Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>

---

This fixes things, which use to crash (SPORT1_TX is a write only hardware
register).

root:/sys/kernel/debug/blackfin/SPORT> ls -l SPORT1_TX
--w-------    1 root     root            0 Jan  1  2007 SPORT1_TX
root:/sys/kernel/debug/blackfin/SPORT> cat SPORT1_TX
cat: read error: Permission denied
root:/sys/kernel/debug/blackfin/SPORT> chmod +r SPORT1_TX
root:/sys/kernel/debug/blackfin/SPORT> ls -l SPORT1_TX
-rw-r--r--    1 root     root            0 Jan  1  2007 SPORT1_TX
root:/sys/kernel/debug/blackfin/SPORT> cat SPORT1_TX
cat: read error: Permission denied

Without this patch, things crash - but as Greg suggested - the same thing can
be done other places.


 fs/debugfs/file.c |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)



Index: fs/debugfs/file.c
===================================================================
--- fs/debugfs/file.c	(revision 5943)
+++ fs/debugfs/file.c	(working copy)
@@ -67,6 +67,8 @@
 	return 0;
 }
 DEFINE_SIMPLE_ATTRIBUTE(fops_u8, debugfs_u8_get, debugfs_u8_set, "%llu\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_u8_ro, debugfs_u8_get, NULL, "%llu\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_u8_wo, NULL, debugfs_u8_set, "%llu\n");
 
 /**
  * debugfs_create_u8 - create a debugfs file that is used to read and write an unsigned 8-bit value
@@ -95,6 +97,13 @@
 struct dentry *debugfs_create_u8(const char *name, mode_t mode,
 				 struct dentry *parent, u8 *value)
 {
+	/*if there are no write bits set make read only */
+	if (!(mode & S_IWUGO))
+		return debugfs_create_file(name, mode, parent, value, &fops_u8_ro);
+	/* if there are no read bits set, make write only */
+	if (!(mode & S_IRUGO))
+		return debugfs_create_file(name, mode, parent, value, &fops_u8_wo);
+
 	return debugfs_create_file(name, mode, parent, value, &fops_u8);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u8);
@@ -110,6 +119,8 @@
 	return 0;
 }
 DEFINE_SIMPLE_ATTRIBUTE(fops_u16, debugfs_u16_get, debugfs_u16_set, "%llu\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_u16_ro, debugfs_u16_get, NULL, "%llu\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_u16_wo, NULL, debugfs_u16_set, "%llu\n");
 
 /**
  * debugfs_create_u16 - create a debugfs file that is used to read and write an unsigned 16-bit value
@@ -138,6 +149,13 @@
 struct dentry *debugfs_create_u16(const char *name, mode_t mode,
 				  struct dentry *parent, u16 *value)
 {
+	/*if there are no write bits set make read only */
+	if (!(mode & S_IWUGO))
+		return debugfs_create_file(name, mode, parent, value, &fops_u16_ro);
+	/* if there are no read bits set, make write only */
+	if (!(mode & S_IRUGO))
+		return debugfs_create_file(name, mode, parent, value, &fops_u16_wo);
+
 	return debugfs_create_file(name, mode, parent, value, &fops_u16);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u16);
@@ -153,6 +171,8 @@
 	return 0;
 }
 DEFINE_SIMPLE_ATTRIBUTE(fops_u32, debugfs_u32_get, debugfs_u32_set, "%llu\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_u32_ro, debugfs_u32_get, NULL, "%llu\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_u32_wo, NULL, debugfs_u32_set, "%llu\n");
 
 /**
  * debugfs_create_u32 - create a debugfs file that is used to read and write an unsigned 32-bit value
@@ -181,6 +201,13 @@
 struct dentry *debugfs_create_u32(const char *name, mode_t mode,
 				 struct dentry *parent, u32 *value)
 {
+	/*if there are no write bits set make read only */
+	if (!(mode & S_IWUGO))
+		return debugfs_create_file(name, mode, parent, value, &fops_u32_ro);
+	/* if there are no read bits set, make write only */
+	if (!(mode & S_IRUGO))
+		return debugfs_create_file(name, mode, parent, value, &fops_u32_wo);
+
 	return debugfs_create_file(name, mode, parent, value, &fops_u32);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u32);
@@ -197,6 +224,8 @@
 	return 0;
 }
 DEFINE_SIMPLE_ATTRIBUTE(fops_u64, debugfs_u64_get, debugfs_u64_set, "%llu\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_u64_ro, debugfs_u64_get, NULL, "%llu\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_u64_wo, NULL, debugfs_u64_set, "%llu\n");
 
 /**
  * debugfs_create_u64 - create a debugfs file that is used to read and write an unsigned 64-bit value
@@ -225,15 +254,28 @@
 struct dentry *debugfs_create_u64(const char *name, mode_t mode,
 				 struct dentry *parent, u64 *value)
 {
+	/*if there are no write bits set make read only */
+	if (!(mode & S_IWUGO))
+		return debugfs_create_file(name, mode, parent, value, &fops_u64_ro);
+	/* if there are no read bits set, make write only */
+	if (!(mode & S_IRUGO))
+		return debugfs_create_file(name, mode, parent, value, &fops_u64_wo);
+
 	return debugfs_create_file(name, mode, parent, value, &fops_u64);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u64);
 
 DEFINE_SIMPLE_ATTRIBUTE(fops_x8, debugfs_u8_get, debugfs_u8_set, "0x%02llx\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_x8_ro, debugfs_u8_get, NULL, "0x%02llx\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_x8_wo, NULL, debugfs_u8_set, "0x%02llx\n");
 
 DEFINE_SIMPLE_ATTRIBUTE(fops_x16, debugfs_u16_get, debugfs_u16_set, "0x%04llx\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_x16_ro, debugfs_u16_get, NULL, "0x%04llx\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_x16_wo, NULL, debugfs_u16_set, "0x%04llx\n");
 
 DEFINE_SIMPLE_ATTRIBUTE(fops_x32, debugfs_u32_get, debugfs_u32_set, "0x%08llx\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_x32_ro, debugfs_u32_get, NULL, "0x%08llx\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_x32_wo, NULL, debugfs_u32_set, "0x%08llx\n");
 
 /*
  * debugfs_create_x{8,16,32} - create a debugfs file that is used to read and write an unsigned {8,16,32}-bit value
@@ -256,6 +298,13 @@
 struct dentry *debugfs_create_x8(const char *name, mode_t mode,
 				 struct dentry *parent, u8 *value)
 {
+	/*if there are no write bits set make read only */
+	if (!(mode & S_IWUGO))
+		return debugfs_create_file(name, mode, parent, value, &fops_x8_ro);
+	/* if there are no read bits set, make write only */
+	if (!(mode & S_IRUGO))
+		return debugfs_create_file(name, mode, parent, value, &fops_x8_wo);
+
 	return debugfs_create_file(name, mode, parent, value, &fops_x8);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_x8);
@@ -273,6 +322,13 @@
 struct dentry *debugfs_create_x16(const char *name, mode_t mode,
 				 struct dentry *parent, u16 *value)
 {
+	/*if there are no write bits set make read only */
+	if (!(mode & S_IWUGO))
+		return debugfs_create_file(name, mode, parent, value, &fops_x16_ro);
+	/* if there are no read bits set, make write only */
+	if (!(mode & S_IRUGO))
+		return debugfs_create_file(name, mode, parent, value, &fops_x16_wo);
+
 	return debugfs_create_file(name, mode, parent, value, &fops_x16);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_x16);
@@ -290,6 +346,13 @@
 struct dentry *debugfs_create_x32(const char *name, mode_t mode,
 				 struct dentry *parent, u32 *value)
 {
+	/*if there are no write bits set make read only */
+	if (!(mode & S_IWUGO))
+		return debugfs_create_file(name, mode, parent, value, &fops_x32_ro);
+	/* if there are no read bits set, make write only */
+	if (!(mode & S_IRUGO))
+		return debugfs_create_file(name, mode, parent, value, &fops_x32_wo);
+
 	return debugfs_create_file(name, mode, parent, value, &fops_x32);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_x32);
