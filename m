Return-Path: <linux-kernel-owner+w=401wt.eu-S933506AbYFTUrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506AbYFTUrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765199AbYFTUe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:34:58 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:44061 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765180AbYFTUew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:34:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=b85LDsIJpi8ZrERfziR1KO+Zvl1fcKCkbdFNKgr37S6ZR23nYs3vq0hB2TP2AIBv2J
         kpr3j96G+yFz0Z/Vy1PNUcTd+UxqCpLBcq+B0SfxhphlKep4+x4vWbcvSdfaWlBrEYFO
         88TD/gM1+ku+zP/Th6moyRsoIGVy0eNJvLDCc=
Message-ID: <86802c440806201334s30cbc685se44326812841fdd2@mail.gmail.com>
Date: Fri, 20 Jun 2008 13:34:48 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bernhard Walle" <bwalle@suse.de>
Subject: Re: [PATCH 3/3] Limit E820 map when a user-defined memory map is specified
Cc: kexec@lists.infradead.org, x86@kernel.org, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com
In-Reply-To: <1213977420-1555-4-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213977420-1555-1-git-send-email-bwalle@suse.de>
	 <1213977420-1555-4-git-send-email-bwalle@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 8:57 AM, Bernhard Walle <bwalle@suse.de> wrote:
> This patch brings back limiting of the E820 map when a user-defined
> E820 map is specified. While the behaviour of i386 (32 bit) was to limit
> the E820 map (and /proc/iomem), the behaviour of x86-64 (64 bit) was not to
> limit.

then if you kexec new kernel, the second kernel will be have that
limitation too.

any problem that you encountered without this patch?

YH

>
> That patch limits the E820 map again for both x86 architectures.
>
> Code was tested for compilation and booting on a 32 bit and 64 bit system.
>
>
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> ---
>  arch/x86/kernel/e820.c |   30 ++++++++++++++++++++++++++++++
>  1 files changed, 30 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index f5b1736..2e7d385 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -934,6 +934,33 @@ static void early_panic(char *msg)
>        panic(msg);
>  }
>
> +void __init e820_limit_regions(unsigned long long size)
> +{
> +       unsigned long long current_addr;
> +       int i;
> +
> +       for (i = 0; i < e820.nr_map; i++) {
> +               current_addr = e820.map[i].addr + e820.map[i].size;
> +               if (current_addr < size)
> +                       continue;
> +
> +               if (e820.map[i].type != E820_RAM)
> +                       continue;
> +
> +               if (e820.map[i].addr >= size) {
> +                       /*
> +                        * This region starts past the end of the
> +                        * requested size, skip it completely.
> +                        */
> +                       e820.nr_map = i;
> +               } else {
> +                       e820.nr_map = i + 1;
> +                       e820.map[i].size -= current_addr - size;
> +               }
> +               return;
> +       }
> +}
> +
>  /* "mem=nopentium" disables the 4MB page tables. */
>  static int __init parse_memopt(char *p)
>  {
> @@ -951,6 +978,8 @@ static int __init parse_memopt(char *p)
>
>        mem_size = memparse(p, &p);
>        end_user_pfn = mem_size>>PAGE_SHIFT;
> +       e820_limit_regions(mem_size);
> +
>        return 0;
>  }
>  early_param("mem", parse_memopt);
> @@ -995,6 +1024,7 @@ static int __init parse_memmap_opt(char *p)
>                e820_add_region(start_at, mem_size, E820_RESERVED);
>        } else {
>                end_user_pfn = (mem_size >> PAGE_SHIFT);
> +               e820_limit_regions(mem_size);
>        }
>        return *p == '\0' ? 0 : -EINVAL;
>  }
> --
> 1.5.4.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
