Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188AbYJSXjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbYJSXjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 19:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYJSXjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 19:39:09 -0400
Received: from ozlabs.org ([203.10.76.45]:48347 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbYJSXjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 19:39:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: lguest@ozlabs.org
Subject: Re: [Lguest] lguest: unhandled trap
Date: Mon, 20 Oct 2008 10:39:06 +1100
User-Agent: KMail/1.9.10
Cc: Tiago Maluta <maluta_tiago@yahoo.com.br>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
References: <559519.75404.qm@web50707.mail.re2.yahoo.com>
In-Reply-To: <559519.75404.qm@web50707.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810201039.06581.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 October 2008 10:36:51 Tiago Maluta wrote:
> Hi,
>
> I'm using 2.6.27-05323-g26e9a39 and when I try to use lguest:
>
> ~#Documentation/lguest/lguest 128 vmlinux
> lguest: unhandled trap 14 at 0xc0594f6a (0xff900000)

Yes, I found the same issue.  Does this fix it for you?

Subject: lguest: don't try DMI

dmi_scan_machine breaks under lguest; this is the simplest fix (though
ugly).  Perhaps this hurts Xen too?

Error:
	lguest: unhandled trap 14 at 0xc04edeae (0xffa00000)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 47449cd8e3d8 drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c	Fri Oct 17 12:14:40 2008 +1100
+++ b/drivers/firmware/dmi_scan.c	Fri Oct 17 20:54:30 2008 +1100
@@ -369,6 +369,11 @@ void __init dmi_scan_machine(void)
 	char __iomem *p, *q;
 	int rc;
 
+#ifdef CONFIG_PARAVIRT
+	if (strcmp(pv_info.name, "lguest") == 0)
+		goto error;
+#endif
+
 	if (efi_enabled) {
 		if (efi.smbios == EFI_INVALID_TABLE_ADDR)
 			goto error;



