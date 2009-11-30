Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbZK3DSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbZK3DSJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 22:18:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZK3DSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 22:18:07 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:2708 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbZK3DSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 22:18:06 -0500
X-IronPort-AV: E=Sophos;i="4.47,310,1257138000"; 
   d="scan'208";a="9675186"
Message-ID: <4B13396E.508@analog.com>
Date: Mon, 30 Nov 2009 11:18:06 +0800
From: Jie Zhang <jie.zhang@analog.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091125 Shredder/3.0
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: David Howells <dhowells@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: avoiding duplicate icache flushing of shared maps on nommu
References: <8bd0f97a0911280740p24ad49bal64b924a427abfa39@mail.gmail.com>
In-Reply-To: <8bd0f97a0911280740p24ad49bal64b924a427abfa39@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Nov 2009 03:18:07.0108 (UTC) FILETIME=[BC7ABC40:01CA716B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2009 11:40 PM, Mike Frysinger wrote:
> when working with FDPIC, there are many shared maps of read only text
> regions (the C library, applet packages like busybox, ...) between
> applications.  but the current mm/nommu.c:do_mmap_pgoff() function
> will issue an icache flush whenever a vma is added to a mm instead of
> only doing it when the map is initially created.  am i missing
> something obvious here, or would a change like below be OK ?  this
> easily cuts the number of icache flushes during boot by 50% if not
> more.
>
> (yes, this now does the icache flush while holding the
> nommu_region_sem, but i'm interested if the _idea_ is OK)
>
I don't see any problem. But I'm not a kernel expert. I tried to take a 
look at the source code history. But I cannot find code older than 
2.6.12. In the CVS repository of uClinux, there is no similar code in 
kernel sub-directory. :-(


Jie


> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1409,14 +1409,14 @@ unsigned long do_mmap_pgoff(struct file *file,
>
>      current->mm->total_vm += len>>  PAGE_SHIFT;
>
> +   if (prot&  PROT_EXEC)
> +       flush_icache_range(result, result + len);
> +
>   share:
>      add_vma_to_mm(current->mm, vma);
>
>      up_write(&nommu_region_sem);
>
> -   if (prot&  PROT_EXEC)
> -       flush_icache_range(result, result + len);
> -
>      kleave(" = %lx", result);
>      return result;
>
> -mike

