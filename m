Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbYF0KQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbYF0KQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 06:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbYF0KQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 06:16:38 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:42962 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751981AbYF0KQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 06:16:37 -0400
Subject: Re: [patch 09/15] ACPICA: Ignore ACPI table signature for Load()
	operator
From: nokos@gmx.net
To: linux-kernel@vger.kernel.org
In-Reply-To: <20080619213000.GJ20267@suse.de>
References: <20080619211313.834170620@mini.kroah.org>
	 <20080619213000.GJ20267@suse.de>
Content-Type: text/plain
Date: Fri, 27 Jun 2008 12:14:18 +0200
Message-Id: <1214561658.16521.2.camel@earth.gruber.myown>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

the upstream commit bc45b1d39a925b56796bebf8a397a0491489d85c 
introduces a small problem in the /sys filesystem: (can completely confuse 
which do a simple recursion through /sys since the filename is empty)

computer /sys/firmware/acpi/tables> ls -l
ls: cannot access : No such file or directory
total 0
-????????? ? ?    ?    ?            ? 
-r--r--r-- 1 root root 0 Jun 26 01:48 APIC
-r--r--r-- 1 root root 0 Jun 26 01:48 BOOT
-r--r--r-- 1 root root 0 Jun 26 01:48 DSDT
-r--r--r-- 1 root root 0 Jun 26 01:48 FACP
-r--r--r-- 1 root root 0 Jun 26 01:48 FACS
-r--r--r-- 1 root root 0 Jun 26 01:48 HPET
-r--r--r-- 1 root root 0 Jun 26 01:48 MCFG
-r--r--r-- 1 root root 0 Jun 26 01:48 SLIC
-r--r--r-- 1 root root 0 Jun 26 01:48 SSDT1
-r--r--r-- 1 root root 0 Jun 26 01:48 SSDT2
-r--r--r-- 1 root root 0 Jun 26 01:48 SSDT3
-r--r--r-- 1 root root 0 Jun 26 01:48 SSDT4
-r--r--r-- 1 root root 0 Jun 26 01:48 SSDT5

two possible solutions: (any thoughts?)

--- a/drivers/acpi/system.c
+++ b/drivers/acpi/system.c
@@ -94,7 +94,11 @@ static void acpi_table_attr_init(struct acpi_table_attr *table_attr,
        struct acpi_table_header *header = NULL;
        struct acpi_table_attr *attr = NULL;
 
-       memcpy(table_attr->name, table_header->signature, ACPI_NAME_SIZE);
+        if (table_header->signature[0] == '\0') {
+                strncpy(table_attr->name, "NULL", ACPI_NAME_SIZE);
+        } else {
+               memcpy(table_attr->name, table_header->signature, ACPI_NAME_SIZE);
+        }
 
        list_for_each_entry(attr, &acpi_table_attr_list, node) {
                if (!memcmp(table_header->signature, attr->name,
@@ -108,7 +112,7 @@ static void acpi_table_attr_init(struct acpi_table_attr *table_attr,
                                         !acpi_get_table(table_header->
                                                         signature, 2,
                                                         &header)))
-               sprintf(table_attr->name + 4, "%d", table_attr->instance);
+               sprintf(table_attr->name + ACPI_NAME_SIZE, "%d", table_attr->instance);
 
        table_attr->attr.size = 0;
        table_attr->attr.read = acpi_table_show;

--- a/drivers/acpi/tables/tbinstal.c
+++ b/drivers/acpi/tables/tbinstal.c
@@ -130,6 +130,11 @@ acpi_tb_add_table(struct acpi_table_desc *table_desc,
         * given up on validating the signature, since it seems to be a waste
         * of code. The original code was removed (05/2008).
         */
+        if (!strict_signature_check && table_desc->pointer->signature[0] == '\0') {
+                ACPI_DEBUG_PRINT((ACPI_DB_TABLES,
+                        "Table has empty signature, correcting"));
+                strncpy(table_desc->pointer->signature, "SSDT", 4);
+        }
 
        (void)acpi_ut_acquire_mutex(ACPI_MTX_TABLES);
 

Peter



Am Donnerstag, den 19.06.2008, 14:30 -0700 schrieb Greg KH:
> einfaches Textdokument-Anlage
> (acpica-ignore-acpi-table-signature-for-load-operator.patch)
> 2.6.25-stable review patch.  If anyone has any objections, please let us
> know.
> 
> ------------------
> From: Bob Moore <robert.moore@intel.com>
> 
> upstream bc45b1d39a925b56796bebf8a397a0491489d85c
> 
> Without this patch booting with acpi_osi="!Windows 2006" is required
> for several machines to function properly with cpufreq
> due to failure to load a Vista specific table with a bad signature.
> 
> Only "SSDT" is acceptable to the ACPI spec, but tables are
> seen with OEMx and null sigs. Therefore, signature validation
> is worthless.  Apparently MS ACPI accepts such signatures, ACPICA
> must be compatible.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=9919
> http://bugzilla.kernel.org/show_bug.cgi?id=10383
> http://bugzilla.kernel.org/show_bug.cgi?id=10454
> https://bugzilla.novell.com/show_bug.cgi?id=396311
> 
> Signed-off-by: Bob Moore <robert.moore@intel.com>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/acpi/tables/tbinstal.c |   18 +++++++-----------
>  1 file changed, 7 insertions(+), 11 deletions(-)
> 
> --- a/drivers/acpi/tables/tbinstal.c
> +++ b/drivers/acpi/tables/tbinstal.c
> @@ -123,17 +123,13 @@ acpi_tb_add_table(struct acpi_table_desc
>  		}
>  	}
>  
> -	/* The table must be either an SSDT or a PSDT or an OEMx */
> -
> -	if ((!ACPI_COMPARE_NAME(table_desc->pointer->signature, ACPI_SIG_PSDT))
> -	    &&
> -	    (!ACPI_COMPARE_NAME(table_desc->pointer->signature, ACPI_SIG_SSDT))
> -	    && (strncmp(table_desc->pointer->signature, "OEM", 3))) {
> -		ACPI_ERROR((AE_INFO,
> -			    "Table has invalid signature [%4.4s], must be SSDT, PSDT or OEMx",
> -			    table_desc->pointer->signature));
> -		return_ACPI_STATUS(AE_BAD_SIGNATURE);
> -	}
> +	/*
> +	 * Originally, we checked the table signature for "SSDT" or "PSDT" here.
> +	 * Next, we added support for OEMx tables, signature "OEM".
> +	 * Valid tables were encountered with a null signature, so we've just
> +	 * given up on validating the signature, since it seems to be a waste
> +	 * of code. The original code was removed (05/2008).
> +	 */
>  
>  	(void)acpi_ut_acquire_mutex(ACPI_MTX_TABLES);
>  
> 

