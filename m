Return-Path: <linux-kernel-owner+w=401wt.eu-S933947AbYDWCpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933947AbYDWCpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 22:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758416AbYDWCpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 22:45:21 -0400
Received: from rv-out-0708.google.com ([209.85.198.241]:63865 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759082AbYDWCpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 22:45:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=aoYLFZrZDu9Y89ss+YHo6KO4ShiS6DoOiaSUUvCApkBxzpa7gtn/UJsJg7uhUiIxcERUCOUOE+w/SIpcYCgBzQVCyBGP+cTpAcoPKBiJODX08MYW8/cQFRz+wIY1fV8ErXf80YydhRLJ6e0MBonrwccFxaWwjxLija8XMd8BAjs=
Reply-To: yhlu.kernel@gmail.com
To: akpm@linux-foundation.org,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: [PATCH] mptsas: add mptsas_shutdown to call pci_disable_msi
Date: Tue, 22 Apr 2008 19:44:33 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Prakash@mpk12-office-77-204, Sathya <sathya.prakash@lsi.com>,
       "Moore, Eric" <Eric.Moore@lsi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804221944.33775.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


this change

| commit 23a274c8a5adafc74a66f16988776fc7dd6f6e51
| Author: Prakash, Sathya <sathya.prakash@lsi.com>
| Date:   Fri Mar 7 15:53:21 2008 +0530
|
|     [SCSI] mpt fusion: Enable MSI by default for SAS controllers
|
|     This patch modifies the driver to enable MSI by default for all SAS chips.
|
cause kexec RHEL 5.1 kernel fail.

root casue: the rhel 5.1 kernel still use INTx emulation.
and mptscsih_shutdown doesn't call pci_disable_msi to reenable INTx on kexec path

so try to call mptsas_remove in mptsas_shutdown.
then pci_disable_msi will be called via mptsas_remove==>mptscih_remove==>
mpt_detach.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Prakash, Sathya <sathya.prakash@lsi.com>
CC: "Moore, Eric" <Eric.Moore@lsi.com>

Index: linux-2.6/drivers/message/fusion/mptsas.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptsas.c
+++ linux-2.6/drivers/message/fusion/mptsas.c
@@ -3327,6 +3327,11 @@ static void __devexit mptsas_remove(stru
 	mptscsih_remove(pdev);
 }
 
+static void mptsas_shutdown(struct pci_dev *pdev)
+{
+	mptsas_remove(pdev);
+}
+
 static struct pci_device_id mptsas_pci_table[] = {
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1064,
 		PCI_ANY_ID, PCI_ANY_ID },
@@ -3348,7 +3353,7 @@ static struct pci_driver mptsas_driver =
 	.id_table	= mptsas_pci_table,
 	.probe		= mptsas_probe,
 	.remove		= __devexit_p(mptsas_remove),
-	.shutdown	= mptscsih_shutdown,
+	.shutdown	= mptsas_shutdown,
 #ifdef CONFIG_PM
 	.suspend	= mptscsih_suspend,
 	.resume		= mptscsih_resume,
