Return-Path: <linux-kernel-owner+w=401wt.eu-S1752256AbZL3GPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbZL3GPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 01:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbZL3GPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 01:15:13 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:50330 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbZL3GPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 01:15:12 -0500
Date: Wed, 30 Dec 2009 01:14:48 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Paul Rolland <rol@as2917.net>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Matthew Garrett <mjg@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, rol@witbe.net
Subject: Re: -tip: origin tree boot crash
In-reply-to: <20091228175301.4e89aa65@tux.DEF.witbe.net>
Message-id: <alpine.LFD.2.00.0912300110080.15839@localhost.localdomain>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
 <20091225102731.GA25513@elte.hu>
 <alpine.LFD.2.00.0912261504460.4089@localhost.localdomain>
 <alpine.LFD.2.00.0912262316530.14053@localhost.localdomain>
 <20091228094444.GG24690@elte.hu> <20091228120125.GA10911@elte.hu>
 <20091228160212.1f70d825@tux.DEF.witbe.net>
 <20091228175301.4e89aa65@tux.DEF.witbe.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the quick test/debug Paul,

> Fixed this completely with the following two patches on top of 2.6.33-rc2 :
> 
> --- wmi.c.orig  2009-12-28 17:27:15.000000000 +0100
> +++ wmi.c       2009-12-28 17:39:01.000000000 +0100
> @@ -488,12 +488,13 @@
>  {
>         struct wmi_block *block;
>         acpi_status status;
> +       bool err;
>  
>         if (!guid || !handler)
>                 return AE_BAD_PARAMETER;
>  
> -       find_guid(guid, &block);
> -       if (!block)
> +       err = find_guid(guid, &block);
> +       if (!err)

Unfortunately, find_guid() returns 1 for success
and 0 for failure, making this code look backwards.

I've applied this, but changed it to if (!find_guid())
to be consistent with the other callers.

>                 return AE_NOT_EXIST;
>  
>         if (block->handler)
> @@ -517,12 +518,13 @@
>  {
>         struct wmi_block *block;
>         acpi_status status;
> +       bool err;
>  
>         if (!guid)
>                 return AE_BAD_PARAMETER;
>  
> -       find_guid(guid, &block);
> -       if (!block)
> +       err = find_guid(guid, &block);
> +       if (!err)
>                 return AE_NOT_EXIST;
>  
>         if (!block->handler)
> 
> --- dell-wmi.c.orig     2009-12-28 17:49:09.000000000 +0100
> +++ dell-wmi.c  2009-12-28 17:41:36.000000000 +0100
> @@ -343,7 +343,7 @@
>                 printk(KERN_ERR
>                         "dell-wmi: Unable to register notify handler - %d\n",
>                         err);
> -               return err;
> +               return -err;

This change is not quite correct,
but the correct fix is already in the acpi-test tree in the patch
"dell-wmi: sys_init_module: 'dell_wmi'->init suspiciously returned 21,
it should follow 0/-E convention"

I'll reply with both of the patches in a sec.
Please let me know if they are sufficient to fix your system.

thanks,
-Len Brown, Intel Open Source Technology Center

>         }
>  
>         return 0;
> 
> 
> Signed-off-by: rol@as2917.net <Paul Rolland>
> 
> Paul
> 
