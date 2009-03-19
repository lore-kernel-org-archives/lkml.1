Return-Path: <linux-kernel-owner+w=401wt.eu-S1761366AbZCSWWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761366AbZCSWWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 18:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758776AbZCSWWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 18:22:35 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:34788 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912AbZCSWWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 18:22:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=jdh+b1lxjADpLUvnIYwuZao3Qx/G7vBQj2NQtWnOqQB/CukSnC0vtwyk5EjhNlvqXg
         absfJSuA34g4q5bP2/h7aKwR8hpqfKyVtxvaqH4eZetyhEqlgCrk1Vn4dEE+O2HC4m0y
         7gW182q4aTCYYl0BTsuIKpXs2/1Vj4KJ0OcBE=
MIME-Version: 1.0
Date: Thu, 19 Mar 2009 23:22:31 +0100
Message-ID: <298610bb0903191522s66e3f559h31a05e4f282b92e0@mail.gmail.com>
Subject: [PATCH][RESEND] Fix state reporting in tc1100-wmi
From: =?UTF-8?Q?Krzysztof_Kosi=C5=84ski?= <tweenk.pl@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tc1100-wmi driver should print the current states of wireless LAN and
jogdial brightness control when "cat /sys/devices/platform/tc1100-wmi/wireless"
and "cat /sys/devices/platform/tc1100-wmi/jogdial" are executed, respectively.
What actually happens is that both of those commands print 0 regardless of the
hardware state. The cause is that wmi_query_block returns an ACPI_TYPE_INTEGER
rather than ACPI_TYPE_BUFFER as the driver assumes. Additionally, the driver
intends to return a jogdial state that is inverted with respect to the commands
required to set it (e.g. it intends to return 1 after the jogdial file was
written with 0).

This patch fixes both of those issues - the commands to query the
state now work,
and should return the same state that was written. Fixes bug #12286.

Resend as requested on Bugzilla.

Signed-off-by: Krzysztof Kosiński <tweenk.pl@gmail.com>

--- linux-2.6.27/drivers/misc/tc1100-wmi.c	2008-10-10 00:13:53.000000000 +0200
+++ linux/drivers/misc/tc1100-wmi.c	2008-12-25 02:58:48.000000000 +0100
@@ -95,9 +95,8 @@
 		return -ENODEV;

 	obj = (union acpi_object *) result.pointer;
-	if (obj && obj->type == ACPI_TYPE_BUFFER &&
-		obj->buffer.length == sizeof(u32)) {
-		tmp = *((u32 *) obj->buffer.pointer);
+	if (obj && obj->type == ACPI_TYPE_INTEGER) {
+		tmp = obj->integer.value;
 	} else {
 		tmp = 0;
 	}
@@ -110,7 +109,7 @@
 		*out = (tmp == 3) ? 1 : 0;
 		return 0;
 	case TC1100_INSTANCE_JOGDIAL:
-		*out = (tmp == 1) ? 1 : 0;
+		*out = (tmp == 1) ? 0 : 1;
 		return 0;
 	default:
 		return -ENODEV;
