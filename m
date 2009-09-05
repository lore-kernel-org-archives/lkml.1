Return-Path: <linux-kernel-owner+w=401wt.eu-S934588AbZIEAcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934588AbZIEAcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933914AbZIEAcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:32:48 -0400
Received: from kroah.org ([198.145.64.141]:42106 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934574AbZIEAUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:42 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:50 2009
Message-Id: <20090905001449.996253548@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:13:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Costantino Leandro <lcostantino@gmail.com>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Len Brown <len.brown@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch 16/71] wmi: fix kernel panic when stack protection enabled.
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=wmi-fix-kernel-panic-when-stack-protection-enabled.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Costantino Leandro <lcostantino@gmail.com>

commit f3d83e2415445e5b157bef404d38674e9e8de169 upstream.

Summary:
Kernel panic arise when stack protection is enabled, since strncat will
add a null terminating byte '\0'; So in functions
like this one (wmi_query_block):
        char wc[4]="WC";
	....
	strncat(method, block->object_id, 2);
        ...
the length of wc should be n+1 (wc[5]) or stack protection
fault will arise. This is not noticeable when stack protection is
disabled,but , isn't good either.
Config used: [CONFIG_CC_STACKPROTECTOR_ALL=y,
	      CONFIG_CC_STACKPROTECTOR=y]

Panic Trace
------------
       .... stack-protector: kernel stack corrupted in : fa7b182c
       2.6.30-rc8-obelisco-generic
       call_trace:
           [<c04a6c40>] ? panic+0x45/0xd9
	   [<c012925d>] ? __stack_chk_fail+0x1c/0x40
	   [<fa7b182c>] ? wmi_query_block+0x15a/0x162 [wmi]
	   [<fa7b182c>] ? wmi_query_block+0x15a/0x162 [wmi]
	   [<fa7e7000>] ? acer_wmi_init+0x00/0x61a [acer_wmi]
	   [<fa7e7135>] ? acer_wmi_init+0x135/0x61a [acer_wmi]
	   [<c0101159>] ? do_one_initcall+0x50+0x126

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13514

Signed-off-by: Costantino Leandro <lcostantino@gmail.com>
Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Len Brown <len.brown@intel.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/wmi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -270,7 +270,7 @@ u32 method_id, const struct acpi_buffer 
 	acpi_status status;
 	struct acpi_object_list input;
 	union acpi_object params[3];
-	char method[4] = "WM";
+	char method[5] = "WM";
 
 	if (!find_guid(guid_string, &wblock))
 		return AE_ERROR;
@@ -328,8 +328,8 @@ struct acpi_buffer *out)
 	acpi_status status, wc_status = AE_ERROR;
 	struct acpi_object_list input, wc_input;
 	union acpi_object wc_params[1], wq_params[1];
-	char method[4];
-	char wc_method[4] = "WC";
+	char method[5];
+	char wc_method[5] = "WC";
 
 	if (!guid_string || !out)
 		return AE_BAD_PARAMETER;
@@ -410,7 +410,7 @@ const struct acpi_buffer *in)
 	acpi_handle handle;
 	struct acpi_object_list input;
 	union acpi_object params[2];
-	char method[4] = "WS";
+	char method[5] = "WS";
 
 	if (!guid_string || !in)
 		return AE_BAD_DATA;


