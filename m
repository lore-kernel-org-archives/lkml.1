Return-Path: <linux-kernel-owner+w=401wt.eu-S965041AbXAWNXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965041AbXAWNXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 08:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965050AbXAWNXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 08:23:14 -0500
Received: from wx-out-0506.google.com ([66.249.82.227]:36238 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965041AbXAWNXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 08:23:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OqN7himYaxZXvuKToJS2DcZwdSLrVqW1sAN+t0eLTjeXQlyWubkgF+9AI8zLJXuKkZU/qqSEyekRgPc6FLleR7LkMWtL3GVfH/ljU5LXFA17PSEw2Y5h5rOAUOVKsCGfz/GbUCH7pifxP0TT0PupTbJICKZ0IeQrXRa8Zn5OO70=
Message-ID: <5c8016cf0701230523j4fa7e03ejfc48c6e126a3547b@mail.gmail.com>
Date: Tue, 23 Jan 2007 13:23:11 +0000
From: "Giuliano Procida" <giuliano.procida@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH]: MTRR: fix 32-bit ioctls on x64_32
Cc: "Mikael Pettersson" <mikpe@it.uu.se>, rgooch@atnf.csiro.au,
       linux-kernel@vger.kernel.org
In-Reply-To: <45AD9D59.6010006@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200701161248.l0GCmG7O025771@harpo.it.uu.se>
	 <45AD9D59.6010006@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/01/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Adding a case can add substantially to the generated code, especially if
> it makes a compact set of case labels non-compact.

Is this one any better? It certainly makes for a slimmer object.

Compiled, but not yet tested. Caveat patcher.

Signed-off-by: Giuliano Procida <giuliano.procida@googlemail.com>

Giuliano.

--- linux-source-2.6.19.1.orig/arch/i386/kernel/cpu/mtrr/if.c	2006-12-11
19:32:53.000000000 +0000
+++ linux-source-2.6.19.1/arch/i386/kernel/cpu/mtrr/if.c	2007-01-22
23:34:48.000000000 +0000
@@ -154,150 +154,166 @@
 mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 {
 	int err = 0;
+	unsigned ioctl_dir;
+	unsigned ioctl_nr;
+	unsigned ioctl_size;
 	mtrr_type type;
-	struct mtrr_sentry sentry;
-	struct mtrr_gentry gentry;
+	union mtrr_data {
+		struct mtrr_sentry sentry;
+		struct mtrr_gentry gentry;
+#ifdef CONFIG_COMPAT
+		struct mtrr_sentry32 sentry32;
+		struct mtrr_gentry32 gentry32;
+#endif
+	};
+	union mtrr_data u;
 	void __user *arg = (void __user *) __arg;

-	switch (cmd) {
-	case MTRRIOC_ADD_ENTRY:
-	case MTRRIOC_SET_ENTRY:
-	case MTRRIOC_DEL_ENTRY:
-	case MTRRIOC_KILL_ENTRY:
-	case MTRRIOC_ADD_PAGE_ENTRY:
-	case MTRRIOC_SET_PAGE_ENTRY:
-	case MTRRIOC_DEL_PAGE_ENTRY:
-	case MTRRIOC_KILL_PAGE_ENTRY:
-		if (copy_from_user(&sentry, arg, sizeof sentry))
-			return -EFAULT;
-		break;
-	case MTRRIOC_GET_ENTRY:
-	case MTRRIOC_GET_PAGE_ENTRY:
-		if (copy_from_user(&gentry, arg, sizeof gentry))
-			return -EFAULT;
+	/* check type and max size */
+	ioctl_size = _IOC_SIZE(cmd);
+	if (_IOC_TYPE(cmd) != MTRR_IOCTL_BASE || ioctl_size > sizeof(u))
+		return -ENOTTY;
+
+	/* copy from user */
+	ioctl_dir = _IOC_DIR(cmd);
+	if (ioctl_dir & _IOC_WRITE && copy_from_user(&u, arg, ioctl_size))
+		return -EFAULT;
+
+	/* check number, direction, size and permission */
+	ioctl_nr = _IOC_NR(cmd);
+	ioctl_size = _IOC_SIZE(cmd);
+	switch (_IOC_NR(cmd)) {
+	case _IOC_NR(MTRRIOC_ADD_ENTRY):
+	case _IOC_NR(MTRRIOC_SET_ENTRY):
+	case _IOC_NR(MTRRIOC_DEL_ENTRY):
+	case _IOC_NR(MTRRIOC_KILL_ENTRY):
+	case _IOC_NR(MTRRIOC_ADD_PAGE_ENTRY):
+	case _IOC_NR(MTRRIOC_SET_PAGE_ENTRY):
+	case _IOC_NR(MTRRIOC_DEL_PAGE_ENTRY):
+	case _IOC_NR(MTRRIOC_KILL_PAGE_ENTRY):
+		if (_IOC_DIR(cmd) != _IOC_WRITE)
+			return -ENOTTY;
+		switch (ioctl_size) {
+		case sizeof(struct mtrr_sentry):
 		break;
 #ifdef CONFIG_COMPAT
-	case MTRRIOC32_ADD_ENTRY:
-	case MTRRIOC32_SET_ENTRY:
-	case MTRRIOC32_DEL_ENTRY:
-	case MTRRIOC32_KILL_ENTRY:
-	case MTRRIOC32_ADD_PAGE_ENTRY:
-	case MTRRIOC32_SET_PAGE_ENTRY:
-	case MTRRIOC32_DEL_PAGE_ENTRY:
-	case MTRRIOC32_KILL_PAGE_ENTRY: {
-		struct mtrr_sentry32 __user *s32 = (struct mtrr_sentry32 __user *)__arg;
-		err = get_user(sentry.base, &s32->base);
-		err |= get_user(sentry.size, &s32->size);
-		err |= get_user(sentry.type, &s32->type);
-		if (err)
-			return err;
-		break;
-	}
-	case MTRRIOC32_GET_ENTRY:
-	case MTRRIOC32_GET_PAGE_ENTRY: {
-		struct mtrr_gentry32 __user *g32 = (struct mtrr_gentry32 __user *)__arg;
-		err = get_user(gentry.regnum, &g32->regnum);
-		err |= get_user(gentry.base, &g32->base);
-		err |= get_user(gentry.size, &g32->size);
-		err |= get_user(gentry.type, &g32->type);
-		if (err)
-			return err;
+		case sizeof(struct mtrr_sentry32):
+		{
+			struct mtrr_sentry32 s32 = u.sentry32;
+			u.sentry.base = s32.base;
+			u.sentry.size = s32.size;
+			u.sentry.type = s32.type;
+		}
 		break;
-	}
 #endif
+		default:
+			return -ENOTTY;
+		}
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+		break;
+	case _IOC_NR(MTRRIOC_GET_ENTRY):
+	case _IOC_NR(MTRRIOC_GET_PAGE_ENTRY):
+		if (_IOC_DIR(cmd) != (_IOC_READ|_IOC_WRITE))
+			return -ENOTTY;
+		switch (ioctl_size) {
+		case sizeof(struct mtrr_gentry):
+		break;
+#ifdef CONFIG_COMPAT
+		case sizeof(struct mtrr_gentry32):
+		{
+			struct mtrr_gentry32 g32 = u.gentry32;
+			u.gentry.base = g32.base;
+			u.gentry.size = g32.size;
+			u.gentry.regnum = g32.regnum;
+			u.gentry.type = g32.type;
+		}
+		break;
+#endif
+		default:
+			return -ENOTTY;
+		}
+		break;
+	default:
+		return -ENOTTY;
 	}

-	switch (cmd) {
+	switch (ioctl_nr) {
 	default:
 		return -ENOTTY;
-	case MTRRIOC_ADD_ENTRY:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
+	case _IOC_NR(MTRRIOC_ADD_ENTRY):
 		err =
-		    mtrr_file_add(sentry.base, sentry.size, sentry.type, 1,
+		    mtrr_file_add(u.sentry.base, u.sentry.size, u.sentry.type, 1,
 				  file, 0);
 		break;
-	case MTRRIOC_SET_ENTRY:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-		err = mtrr_add(sentry.base, sentry.size, sentry.type, 0);
+	case _IOC_NR(MTRRIOC_SET_ENTRY):
+		err = mtrr_add(u.sentry.base, u.sentry.size, u.sentry.type, 0);
 		break;
-	case MTRRIOC_DEL_ENTRY:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-		err = mtrr_file_del(sentry.base, sentry.size, file, 0);
+	case _IOC_NR(MTRRIOC_DEL_ENTRY):
+		err = mtrr_file_del(u.sentry.base, u.sentry.size, file, 0);
 		break;
-	case MTRRIOC_KILL_ENTRY:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-		err = mtrr_del(-1, sentry.base, sentry.size);
+	case _IOC_NR(MTRRIOC_KILL_ENTRY):
+		err = mtrr_del(-1, u.sentry.base, u.sentry.size);
 		break;
-	case MTRRIOC_GET_ENTRY:
-		if (gentry.regnum >= num_var_ranges)
+	case _IOC_NR(MTRRIOC_GET_ENTRY):
+		if (u.gentry.regnum >= num_var_ranges)
 			return -EINVAL;
-		mtrr_if->get(gentry.regnum, &gentry.base, &gentry.size, &type);
+		mtrr_if->get(u.gentry.regnum, &u.gentry.base, &u.gentry.size, &type);

 		/* Hide entries that go above 4GB */
-		if (gentry.base + gentry.size > 0x100000
-		    || gentry.size == 0x100000)
-			gentry.base = gentry.size = gentry.type = 0;
+		if (u.gentry.base + u.gentry.size > 0x100000
+		    || u.gentry.size == 0x100000)
+			u.gentry.base = u.gentry.size = u.gentry.type = 0;
 		else {
-			gentry.base <<= PAGE_SHIFT;
-			gentry.size <<= PAGE_SHIFT;
-			gentry.type = type;
+			u.gentry.base <<= PAGE_SHIFT;
+			u.gentry.size <<= PAGE_SHIFT;
+			u.gentry.type = type;
 		}

 		break;
-	case MTRRIOC_ADD_PAGE_ENTRY:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
+	case _IOC_NR(MTRRIOC_ADD_PAGE_ENTRY):
 		err =
-		    mtrr_file_add(sentry.base, sentry.size, sentry.type, 1,
+		    mtrr_file_add(u.sentry.base, u.sentry.size, u.sentry.type, 1,
 				  file, 1);
 		break;
-	case MTRRIOC_SET_PAGE_ENTRY:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-		err = mtrr_add_page(sentry.base, sentry.size, sentry.type, 0);
+	case _IOC_NR(MTRRIOC_SET_PAGE_ENTRY):
+		err = mtrr_add_page(u.sentry.base, u.sentry.size, u.sentry.type, 0);
 		break;
-	case MTRRIOC_DEL_PAGE_ENTRY:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-		err = mtrr_file_del(sentry.base, sentry.size, file, 1);
+	case _IOC_NR(MTRRIOC_DEL_PAGE_ENTRY):
+		err = mtrr_file_del(u.sentry.base, u.sentry.size, file, 1);
 		break;
-	case MTRRIOC_KILL_PAGE_ENTRY:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-		err = mtrr_del_page(-1, sentry.base, sentry.size);
+	case _IOC_NR(MTRRIOC_KILL_PAGE_ENTRY):
+		err = mtrr_del_page(-1, u.sentry.base, u.sentry.size);
 		break;
-	case MTRRIOC_GET_PAGE_ENTRY:
-		if (gentry.regnum >= num_var_ranges)
+	case _IOC_NR(MTRRIOC_GET_PAGE_ENTRY):
+		if (u.gentry.regnum >= num_var_ranges)
 			return -EINVAL;
-		mtrr_if->get(gentry.regnum, &gentry.base, &gentry.size, &type);
-		gentry.type = type;
+		mtrr_if->get(u.gentry.regnum, &u.gentry.base, &u.gentry.size, &type);
+		u.gentry.type = type;
 		break;
 	}

 	if (err)
 		return err;

-	switch(cmd) {
-	case MTRRIOC_GET_ENTRY:
-	case MTRRIOC_GET_PAGE_ENTRY:
-		if (copy_to_user(arg, &gentry, sizeof gentry))
-			err = -EFAULT;
-		break;
+	if (ioctl_dir & _IOC_READ) {
+		switch (ioctl_size) {
 #ifdef CONFIG_COMPAT
-	case MTRRIOC32_GET_ENTRY:
-	case MTRRIOC32_GET_PAGE_ENTRY: {
-		struct mtrr_gentry32 __user *g32 = (struct mtrr_gentry32 __user *)__arg;
-		err = put_user(gentry.base, &g32->base);
-		err |= put_user(gentry.size, &g32->size);
-		err |= put_user(gentry.regnum, &g32->regnum);
-		err |= put_user(gentry.type, &g32->type);
+		case sizeof(struct mtrr_gentry32):
+		{
+			struct mtrr_gentry g64 = u.gentry;
+			u.gentry32.base = g64.base;
+			u.gentry32.size = g64.size;
+			u.gentry32.regnum = g64.regnum;
+			u.gentry32.type = g64.type;
+		}
 		break;
-	}
 #endif
+		default:
+		break;
+		}
+		if (copy_to_user(arg, &u, ioctl_size))
+			err = -EFAULT;
 	}
 	return err;
 }
