Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbZDPKCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbZDPKCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbZDPKBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:01:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:56377 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737AbZDPKBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:01:17 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: djwong@us.ibm.com
Subject: Re: [PATCH v2] acpi: Fix regression where _PPC is not read at boot even when ignore_ppc=0
Date: Thu, 16 Apr 2009 12:01:11 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.19-3.2-default; KDE/4.1.3; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       cpufreq@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20090415225348.GW8311@plum> <20090416002712.GX8311@plum>
In-Reply-To: <20090416002712.GX8311@plum>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904161201.13409.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

be careful, this could break the T60 again.
Can you and Ingo place acpidump of your machines somewhere, please.

On Thursday 16 April 2009 02:27:12 Darrick J. Wong wrote:
> Earlier, Ingo Molnar posted a patch to make it so that the kernel would avoid
> reading _PPC on his broken T60.  Unfortunately, it seems that with Thomas
> Renninger's patch last July to eliminate _PPC evaluations when the processor
> driver loads, the kernel never actually reads _PPC at all!
This is wrong. _PPC is only evaluated when a cpufreq driver got registered.
> This is problematic
> if you happen to boot your non-T60 computer in a state where the BIOS _wants_
> _PPC to be something other than zero.
Your machine should suffer from that since Ingo's T60 patch?

Reading the _PPC part of the ACPI spec again:
---
In order to support dynamic changes of _PPC object, Notify events on
the processor object. Notify events of type 0x80 will cause OSPM to
reevaluate any _PPC objects residing under the particular processor object
notified.
---
The *reevaluate* implies that the _PPC value has been evaluated/initialized
by the OS already and Ingo's patch would be wrong then.
I'd like to have a look at the T60's ACPI parts and find out what exactly
(or if at all) makes _PPC to return sane values, I expect it's _PDC.

Hmm, I could also imagine that Ingo's T60 patch is not needed anymore since
Yakui's patch (0ac3c571315a53c14d2733564f14ebdb911fe903).
This one could make sure that _PDC is evaluated first making the internal
ACPI _PPC state initialize and makes sure _PPC gets only called afterwards.

If this patch does not break Ingo's T60, I think this should go in.
Due to Yakui's reordering/cleanup of ACPI function calls, I think also
the notifier chain I introduced is not needed anymore and I can clean this
up if I find some time.

> So, put the _PPC evaluation back into acpi_processor_get_performance_info if
> ignore_ppc isn't 1.
> 
> This second version restores the correct function call, which simplifies
> the patch.  I apologize for the churn and the poor eyesight.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/acpi/processor_perflib.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
> index cafb410..85af717 100644
> --- a/drivers/acpi/processor_perflib.c
> +++ b/drivers/acpi/processor_perflib.c
> @@ -348,7 +348,11 @@ static int acpi_processor_get_performance_info(struct acpi_processor *pr)
>  	if (result)
>  		goto update_bios;
>  
> -	return 0;
> +	/* We need to call _PPC once when cpufreq starts */
> +	if (ignore_ppc != 1)
> +		result = acpi_processor_get_platform_limit(pr);
> +
> +	return result;
>  
>  	/*
>  	 * Having _PPC but missing frequencies (_PSS, _PCT) is a very good hint that

You are more or less reverting Ingo's patch (e4233dec749a3519069d9390561b5636a75c7579):
diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 5207f9e..cbb6f08 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -322,10 +322,6 @@ static int acpi_processor_get_performance_info(struct acpi_processor *pr)
        if (result)
                return result;

-       result = acpi_processor_get_platform_limit(pr);
-       if (result)
-               return result;
-
        return 0;
 }


      Thomas

