Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbZLCIaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbZLCIaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 03:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbZLCIaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 03:30:08 -0500
Received: from poutre.nerim.net ([62.4.16.124]:64375 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239AbZLCIaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 03:30:07 -0500
Date: Thu, 3 Dec 2009 09:30:09 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jgarzik@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] DMI: allow omitting ident strings in DMI tables
Message-ID: <20091203093009.059197a6@hyperion.delvare>
In-Reply-To: <20091203031240.GB9121@core.coreip.homeip.net>
References: <20091203031240.GB9121@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Wed, 2 Dec 2009 19:12:40 -0800, Dmitry Torokhov wrote:
> The purpose of dmi->ident is twofold - it may be used by DMI callback
> functions when composing log messages; it is also used to determine
> end of DMI table in dmi_check_system() and dmi_first_match(). However,
> in case when callbacks are not interested in using ident at all it just
> wastes memory. Let's consider entries with empty ident but initialized
> first match slot as a valid entry and not as end-of-table marker.

You are free to use an empty string ("") as the ident. This will use
1 byte of memory, I'm sure you can afford it. struct dmi_system_id is
332 bytes large on 32-bit systems (344 on 64-bit systems), and we use
such an empty structure as the list terminator. So I really doubt we
care about the extra few bytes used by the ident strings.

> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
> 
> CCed a few random people since they touched dmi code in the last few
> months...
> 
>  drivers/firmware/dmi_scan.c |   13 +++++++++++--
>  1 files changed, 11 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> index 938100f..9116aa7 100644
> --- a/drivers/firmware/dmi_scan.c
> +++ b/drivers/firmware/dmi_scan.c
> @@ -440,6 +440,15 @@ static bool dmi_matches(const struct dmi_system_id *dmi)
>  }
>  
>  /**
> + *	dmi_is_end_of_table - check for end-of-table marker
> + *	@dmi: pointer to the dmi_system_id structure to check
> + */
> +static bool dmi_is_end_of_table(const struct dmi_system_id *dmi)
> +{
> +	return dmi->ident == NULL && dmi->matches[0].slot == DMI_NONE;

If you really want to allow for dmi->ident == NULL, then I guess you can
_only_ check for dmi->matches[0].slot == DMI_NONE. I can't think of any
legitimate use of DMI_NONE for a used slot. The only thing you have to
do then is to ensure that DMI_NONE = 0 in <linux/mod_devicetable.h>
(I'm not sure if any C standard guarantees that enums starts at 0.)

There's a possible optimization in dmi_matches(), BTW: DMI_NONE should
break, not continue.

-- 
Jean Delvare
