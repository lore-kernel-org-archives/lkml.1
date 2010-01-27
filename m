Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917Ab0A0GWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab0A0GWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 01:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827Ab0A0GV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 01:21:59 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:40468 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab0A0GV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 01:21:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=ExyFPXXAMI0nsMlh8GZESvtGUJfKPV5K0bHPLdMLGsWodLp0Tb1d7SX+VxgRoVDWNl
         m46nQQzuzdhLAPz9LMHnooEg3skSmOyX4Jwhk/FFu29w0OWEi2bbIs6uoe2UybrxxQzO
         KjO7OfIYms+W0DjWjRZ+gmUTGWHf2G5pFaG3U=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Feng Tang <feng.tang@intel.com>
Subject: Re: R: [Bug #14886] Asus P2B-DS not detected as SMP moterboard
Date: Wed, 27 Jan 2010 07:21:33 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.33-rc5-00237-g9a3cbe3; KDE/4.3.95; x86_64; ; )
Cc: Dmitry Artamonow <mad_soft@inbox.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "flinco@libero.it" <flinco@libero.it>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Brown, Len" <len.brown@intel.com>
References: <5550914.425471263201351807.JavaMail.defaultUser@defaultHost> <20100126155330.GA4231@rainbow> <20100127113520.596bd07c@feng-i7>
In-Reply-To: <20100127113520.596bd07c@feng-i7>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001270721.55739.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 of January 2010, Feng Tang wrote:
> On Tue, 26 Jan 2010 23:53:30 +0800
> 
> Dmitry Artamonow <mad_soft@inbox.ru> wrote:
> > Hi!
> > I'm also using P2B-DS and can confirm that starting with kernel 2.6.32
> > SMP stopped working (and don't work still - tested with current git
> > v2.6.33-rc5-238-g158c168) The issue seems to have something to do
> > with the fact that ACPI is blacklisted on P2B-DS. I used to
> > workaround this bug on newer kernels (>=2.6.32) by passing
> > "acpi=force" in kernel arguments. Finally, yesterday I found some
> > time to write simple automated bisection script and leaved it to run
> > on machine overnight. Here's result:
> > -------------------------------------------------------------------------
> > -- e5b8fc6ac158f65598f58dba2c0d52ba3b412f52 is the first bad commit
> > commit e5b8fc6ac158f65598f58dba2c0d52ba3b412f52 Author: Len Brown
> > <len.brown@intel.com> Date:   Tue Jul 7 23:22:58 2009 -0400
> > 
> >     ACPI: check acpi_disabled in acpi_table_parse() and
> > 
> > acpi_table_parse_entries()
> > 
> >     Allow consumers of the
> > 
> > acpi_table_parse()/acpi_table_parse_entries() API to gracefully
> > handle the acpi_disabled=1 case via return value rather than checking
> > the global flag themselves.
> > 
> >     Signed-off-by: Feng Tang <feng.tang@intel.com>
> >     Signed-off-by: Len Brown <len.brown@intel.com>
> > 
> > -------------------------------------------------------------------------
> > --
> 
> Hi Dmitry,
> 
> That commit is
> diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
> index 646d39c..f336bca 100644
> --- a/drivers/acpi/tables.c
> +++ b/drivers/acpi/tables.c
> @@ -213,6 +213,9 @@ acpi_table_parse_entries(char *id,
>         unsigned long table_end;
>         acpi_size tbl_size;
> 
> +       if (acpi_disabled)
> +               return -ENODEV;
> +
>         if (!handler)
>                 return -EINVAL;
> 
> @@ -277,6 +280,9 @@ int __init acpi_table_parse(char *id,
> acpi_table_handler handler) struct acpi_table_header *table = NULL;
>         acpi_size tbl_size;
> 
> +       if (acpi_disabled)
> +               return -ENODEV;
> +
>         if (!handler)
>                 return -EINVAL;
> 
> Which only enforces the "acpi_disabled" check and should have no
> logical problem.
> 
> And I guess your platform is blacklisted and acpi_disabled is set to 1,
> while it still need parse ACPI tables to get SMP info. So I would suggest
> to add a "acpi=force" for your case.

Is there a force ht-only option? acpi=ht doesn't work.

> Thanks,
> Feng


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
