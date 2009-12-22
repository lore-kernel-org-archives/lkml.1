Return-Path: <linux-kernel-owner+w=401wt.eu-S1752903AbZLVOkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbZLVOkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 09:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZLVOky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 09:40:54 -0500
Received: from smtp.ispras.ru ([83.149.198.201]:53275 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbZLVOkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 09:40:53 -0500
From: Alexander Strakh <strakh@ispras.ru>
Organization: ISP RAS
Date: Tue, 22 Dec 2009 18:46:02 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>,
       Paul Diefenbaugh <paul.s.diefenbaugh@intel.com>,
       Andy Grover <andrew.grover@intel.com>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: BUG printk with not null-terminated string in driver /drivers/acpi/osl.c
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912221846.02318.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        In driver drivers/acpi/osl.c in function acpi_osi_setup:
1. If in line 555 *osi_additional_string == 0 then we goto line 1039
2. In line 1039: if length of str > OSI_STRING_LENGTH_MAX then 
osi_additional_string not have 0 at the end.
3. In line 1040 printk called with not null-terminated string.
1026 int __init acpi_osi_setup(char *str)
1027 {
1028         if (str == NULL || *str == '\0') {
1029                 printk(KERN_INFO PREFIX "_OSI method disabled\n");
1030                 acpi_gbl_create_osi_method = FALSE;
1031         } else if (!strcmp("!Linux", str)) {
1032                 acpi_cmdline_osi_linux(0);      /* !enable */
1033         } else if (*str == '!') {
1034                 if (acpi_osi_invalidate(++str) == AE_OK)
1035                         printk(KERN_INFO PREFIX "Deleted _OSI(%s)\n", 
str);
1036         } else if (!strcmp("Linux", str)) {
1037                 acpi_cmdline_osi_linux(1);      /* enable */
1038         } else if (*osi_additional_string == '\0') {
1039                 strncpy(osi_additional_string, str, 
OSI_STRING_LENGTH_MAX);
1040                 printk(KERN_INFO PREFIX "Added _OSI(%s)\n", str);
1041         }
1042
1043         return 1;
1044 }

Found by Linux Device Drivers Verification (Svace detector)

Add terminate symbol for string in any cases.

Signed-off-by: Alexander Strakh <strakh@ispras.ru>

---
diff --git a/./0000/drivers/acpi/osl.c b/./0001/drivers/acpi/osl.c
index 02e8464..9c759f8 100644
--- a/./0000/drivers/acpi/osl.c
+++ b/./0001/drivers/acpi/osl.c
@@ -1037,6 +1037,7 @@ int __init acpi_osi_setup(char *str)
 		acpi_cmdline_osi_linux(1);	/* enable */
 	} else if (*osi_additional_string == '\0') {
 		strncpy(osi_additional_string, str, OSI_STRING_LENGTH_MAX);
+		osi_additional_string[OSI_STRING_LENGTH_MAX - 1] = 0;
 		printk(KERN_INFO PREFIX "Added _OSI(%s)\n", str);
 	}
 
