Return-Path: <linux-kernel-owner+w=401wt.eu-S1759274AbYBUIxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbYBUIxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 03:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbYBUIxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 03:53:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:39818 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754336AbYBUIxo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 03:53:44 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: acpi: new sparse warnings in 2.6.25-rc2
Date: Thu, 21 Feb 2008 03:53:30 -0500
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>
References: <1203579134.20345.9.camel@brick>
In-Reply-To: <1203579134.20345.9.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802210353.30885.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 February 2008 02:32, Harvey Harrison wrote:
> Introduced between 2.6.25-rc1 and -rc2.
> 
> drivers/acpi/executer/exregion.c:369:8: warning: incorrect type in argument 3 (different type sizes)
> drivers/acpi/executer/exregion.c:369:8:    expected unsigned int [usertype] *value
> drivers/acpi/executer/exregion.c:369:8:    got unsigned long long [usertype] *value
> drivers/acpi/executer/exregion.c: In function ‘acpi_ex_pci_config_space_handler’:
> drivers/acpi/executer/exregion.c:369: warning: passing argument 3 of ‘acpi_os_read_pci_configuration’ from incompatible pointer type
> 

Subject: ACPI: fix build warning
From: Ming Lin <ming.m.lin@intel.com>

CC      drivers/acpi/executer/exregion.o
drivers/acpi/executer/exregion.c: In function
‘acpi_ex_pci_config_space_handler’:
drivers/acpi/executer/exregion.c:369: attention : passing argument 3 of
‘acpi_os_read_pci_configuration’ from incompatible pointer type

exposed by 10270d4838bdc493781f5a1cf2e90e9c34c9142f

http://bugzilla.kernel.org/show_bug.cgi?id=9989

Signed-off-by: Ming Lin <ming.m.lin@intel.com>
---
diff --git a/drivers/acpi/executer/exregion.c b/drivers/acpi/executer/exregion.c
index 2e9ce94..3f51b7e 100644
--- a/drivers/acpi/executer/exregion.c
+++ b/drivers/acpi/executer/exregion.c
@@ -338,6 +338,7 @@ acpi_ex_pci_config_space_handler(u32 function,
 	acpi_status status = AE_OK;
 	struct acpi_pci_id *pci_id;
 	u16 pci_register;
+	u32 value32;
 
 	ACPI_FUNCTION_TRACE(ex_pci_config_space_handler);
 
@@ -364,9 +365,9 @@ acpi_ex_pci_config_space_handler(u32 function,
 	switch (function) {
 	case ACPI_READ:
 
-		*value = 0;
 		status = acpi_os_read_pci_configuration(pci_id, pci_register,
-							value, bit_width);
+							&value32, bit_width);
+		*value = value32;
 		break;
 
 	case ACPI_WRITE:
