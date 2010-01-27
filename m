Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019Ab0A0Df2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab0A0Df2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 22:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901Ab0A0Df1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 22:35:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:33883 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178Ab0A0Df0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 22:35:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,350,1262592000"; 
   d="scan'208";a="590720850"
Date: Wed, 27 Jan 2010 11:35:20 +0800
From: Feng Tang <feng.tang@intel.com>
To: Dmitry Artamonow <mad_soft@inbox.ru>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "flinco@libero.it" <flinco@libero.it>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Arkadiusz Miskiewicz <arekm@maven.pl>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Brown, Len" <len.brown@intel.com>
Subject: Re: R: [Bug #14886] Asus P2B-DS not detected as SMP moterboard
Message-ID: <20100127113520.596bd07c@feng-i7>
In-Reply-To: <20100126155330.GA4231@rainbow>
References: <5550914.425471263201351807.JavaMail.defaultUser@defaultHost>
	<201001112040.45514.rjw@sisk.pl>
	<20100126155330.GA4231@rainbow>
Organization: intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010 23:53:30 +0800
Dmitry Artamonow <mad_soft@inbox.ru> wrote:


> Hi!
> I'm also using P2B-DS and can confirm that starting with kernel 2.6.32
> SMP stopped working (and don't work still - tested with current git
> v2.6.33-rc5-238-g158c168) The issue seems to have something to do
> with the fact that ACPI is blacklisted on P2B-DS. I used to
> workaround this bug on newer kernels (>=2.6.32) by passing
> "acpi=force" in kernel arguments. Finally, yesterday I found some
> time to write simple automated bisection script and leaved it to run
> on machine overnight. Here's result:
> ---------------------------------------------------------------------------
> e5b8fc6ac158f65598f58dba2c0d52ba3b412f52 is the first bad commit
> commit e5b8fc6ac158f65598f58dba2c0d52ba3b412f52 Author: Len Brown
> <len.brown@intel.com> Date:   Tue Jul 7 23:22:58 2009 -0400
> 
>     ACPI: check acpi_disabled in acpi_table_parse() and
> acpi_table_parse_entries() 
>     Allow consumers of the
> acpi_table_parse()/acpi_table_parse_entries() API to gracefully
> handle the acpi_disabled=1 case via return value rather than checking
> the global flag themselves. 
>     Signed-off-by: Feng Tang <feng.tang@intel.com>
>     Signed-off-by: Len Brown <len.brown@intel.com>
> ---------------------------------------------------------------------------
Hi Dmitry,

That commit is 
diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index 646d39c..f336bca 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -213,6 +213,9 @@ acpi_table_parse_entries(char *id,
        unsigned long table_end;
        acpi_size tbl_size;
 
+       if (acpi_disabled)
+               return -ENODEV;
+
        if (!handler)
                return -EINVAL;
 
@@ -277,6 +280,9 @@ int __init acpi_table_parse(char *id, acpi_table_handler handler)
        struct acpi_table_header *table = NULL;
        acpi_size tbl_size;
 
+       if (acpi_disabled)
+               return -ENODEV;
+
        if (!handler)
                return -EINVAL;

Which only enforces the "acpi_disabled" check and should have no
logical problem.

And I guess your platform is blacklisted and acpi_disabled is set to 1,
while it still need parse ACPI tables to get SMP info. So I would suggest
to add a "acpi=force" for your case.

Thanks,
Feng


