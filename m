Return-Path: <linux-kernel-owner+w=401wt.eu-S933453AbYBWKOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453AbYBWKOe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 05:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbYBWKOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 05:14:25 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:11520 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbYBWKOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 05:14:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QAkz/R+ptcnrJxCK6BgLbtcuUPDocwgX2Nz+lKXI8XaZIKx1/jB9RWnt1Ij8sWPzIpSgIjBJr/eW5x50FauY0vd8Zb71XSIlT3w9BmVgREZA/Fn4WM9SLOaWIeEBtmHdDwXJZQfymNqQf0xgmbIm7Ftq2thJmL6mR/5/YDfN0Qo=
Message-ID: <97a0a9ac0802230214w6e6fe469q8e8a5597833aac33@mail.gmail.com>
Date: Sat, 23 Feb 2008 03:14:23 -0700
From: "Gordon Farquharson" <gordonfarquharson@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Cc: "Sam Ravnborg" <sam@ravnborg.org>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       stefano.brivio@polimi.it, "Linus Torvalds" <torvalds@osdl.org>,
       "Andrew Morton" <akpm@osdl.org>, viro@ftp.linux.org.uk
In-Reply-To: <200802230651.10376.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com>
	 <200802221507.15871.mb@bu3sch.de>
	 <97a0a9ac0802222034m125b43c1hda1e24f04ab0ebd3@mail.gmail.com>
	 <200802230651.10376.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 10:51 PM, Michael Buesch <mb@bu3sch.de> wrote:
>  A big fat comment is something like that:
>
>  /* Explicit padding to support a broken sanity check in file2alias.c.
>   * The check will compare the size of the structure in the kernel
>   * object file to the userspace the kernel is compiled on.
>   * This breaks on cross-compilation. This padding is a workaround
>   * for this. */

---

Align the members of the SSB device structure to a 32 bit boundary so
that the b43 driver can be built for arm using a cross compiler. This
alignment is required so that the test in scripts/mod/file2alias.c
that checks that the size of the device ID type against the size of
the section in the object file succeeds (see comment and
http://lkml.org/lkml/2008/2/18/481 for explanation).

Signed-off-by: Gordon Farquharson <gordonfarquharson@gmail.com>

---

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 139d49d..208d49a 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -351,7 +351,13 @@ struct sdio_device_id {
 struct ssb_device_id {
 	__u16	vendor;
 	__u16	coreid;
-	__u8	revision;
+	/* Explicit padding to support a broken sanity check in file2alias.c.
+	 * The check compares the size of the structure in the kernel
+	 * object file to the size of the structure reported in userspace for
+	 * the system on which the kernel is compiled. The check breaks on
+	 * cross-compilation, and the padding is a workaround for this. */
+	__u8	revision
+		__attribute__((aligned(sizeof(__u32))));
 };
 #define SSB_DEVICE(_vendor, _coreid, _revision)  \
 	{ .vendor = _vendor, .coreid = _coreid, .revision = _revision, }

-- 
Gordon Farquharson
GnuPG Key ID: 32D6D676
