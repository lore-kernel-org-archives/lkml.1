Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbYCMNu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbYCMNu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 09:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYCMNuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 09:50:16 -0400
Received: from mx1.suse.de ([195.135.220.2]:50331 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbYCMNuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 09:50:15 -0400
Subject: Re: [GIT PATCH] ACPI patches for 2.6.25-rc5
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: "Zhang, Rui" <rui.zhang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080313125541.GA7365@v2.random>
References: <200803130214.36861.lenb@kernel.org>
	 <20080312234516.bb079cc5.akpm@linux-foundation.org>
	 <1205391105.2240.68.camel@acpi-hp-zz.sh.intel.com>
	 <20080313125541.GA7365@v2.random>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Thu, 13 Mar 2008 14:50:12 +0100
Message-Id: <1205416212.21619.2.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-13 at 13:55 +0100, Andrea Arcangeli wrote:
> On Thu, Mar 13, 2008 at 02:51:45PM +0800, Zhang, Rui wrote:
> > Well, the patch looks good, this may be caused by a BIOS problem.
> > anyway, I wish to get the response from Andrea so that I can do some
> > investigation ASAP.
> 
> Here attached again. syslog isn't available because by the time it
> crash netconsole isn't up yet, but I try to compile it as module and
> see if it crashes by loading it manually later after netconsole
> started. (you didn't ask for syslog until today)
> 
> Hardware is ASUS M2A-VM ACPI BIOS Revision 1604.

If you want to give them a try..., these are the patches which should
fix this BIOS issue (from Len's release branch):

commit c8d16e27a3601d1cbcdfe657eb4ff5e762019e8d
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Fri Feb 29 07:38:54 2008 +0800

    ACPI: fix boot oops regression in thermal
    
    Fix a memory overflow bug when copying
    NULL internal package element object to external.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=10132
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

diff --git a/drivers/acpi/utilities/utobject.c b/drivers/acpi/utilities/utobject.c
index 76ee766..e08b3fa 100644
--- a/drivers/acpi/utilities/utobject.c
+++ b/drivers/acpi/utilities/utobject.c
@@ -432,7 +432,7 @@ acpi_ut_get_simple_object_size(union acpi_operand_object *internal_object,
 	 * element -- which is legal)
 	 */
 	if (!internal_object) {
-		*obj_length = 0;
+		*obj_length = sizeof(union acpi_object);
 		return_ACPI_STATUS(AE_OK);
 	}
 

commit b6a163875935ce8e8e85901a7f2b68f7a314d914
Author: Thomas Renninger <trenn@suse.de>
Date:   Wed Mar 12 01:06:24 2008 +0100

    ACPICA: Warn if packages with invalid references are evaluated
    
    And return an error to avoid NULL pointer access by the caller
    Lin Ming's patch avoids corrupted mem access when
    BIOS has invalid references included, the handle is now zero
    instead of corrupted.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index eba55b7..44ea60c 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -407,6 +407,12 @@ acpi_evaluate_reference(acpi_handle handle,
 			break;
 		}
 
+		if (!element->reference.handle) {
+			printk(KERN_WARNING PREFIX "Invalid reference in"
+			       " package %s\n", pathname);
+			status = AE_NULL_ENTRY;
+			break;
+		}
 		/* Get the  acpi_handle. */
 
 		list->handles[i] = element->reference.handle;


