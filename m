Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967959Ab0B0ILs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 03:11:48 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59556 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967911Ab0B0ILq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 03:11:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=a3E4xpeLLHOV4tUc8ztF+/ogcKmDNKFy6SSd4MIRPv8rwEWkqLrc/R3P1Yp2GXll3m
         wMqGZUYWrd2DNa9hD5x7GQAyPxeRXmQ3WNH4MCUNOVTjTGvZUox1iXOrjqaW+D8ivZJP
         bUU1x1Sxgvj9cvvCOadA5IWLPbVvMzn2fCVtY=
Date: Sat, 27 Feb 2010 00:11:42 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Stuart Hayes <stuart_hayes@dell.com>
Subject: Re: [PATCH 09/14] dell-laptop: Use buffer with 32-bit physical
 address
Message-ID: <20100227081141.GF793@core.coreip.homeip.net>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
 <1267197527-18062-10-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267197527-18062-10-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 10:18:42AM -0500, Matthew Garrett wrote:
> From: Stuart Hayes <stuart_hayes@dell.com>
> 
> Calls to communicate with system firmware via a SMI (using dcdbas)
> need to use a buffer that has a physical address of 4GB or less.
> Currently the dell-laptop driver does not guarantee this, and when the
> buffer address is higher than 4GB, the address is truncated to 32 bits
> and the SMI handler writes to the wrong memory address.
> 
> Signed-off-by: Stuart Hayes <stuart_hayes@dell.com>
> Acked-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/platform/x86/dell-laptop.c |  122 ++++++++++++++++++++++++-----------
>  1 files changed, 83 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
> index d8b1b39..1a0bfd4 100644
> --- a/drivers/platform/x86/dell-laptop.c
> +++ b/drivers/platform/x86/dell-laptop.c
> @@ -22,6 +22,7 @@
>  #include <linux/rfkill.h>
>  #include <linux/power_supply.h>
>  #include <linux/acpi.h>
> +#include <linux/mm.h>
>  #include <linux/i8042.h>
>  #include "../../firmware/dcdbas.h"
>  
> @@ -123,6 +124,21 @@ static struct dmi_system_id __devinitdata dell_blacklist[] = {
>  	{}
>  };
>  
> +static struct calling_interface_buffer *buffer;
> +struct page *bufferpage;

static ?

> +DEFINE_MUTEX(buffer_mutex);

static?

-- 
Dmitry
