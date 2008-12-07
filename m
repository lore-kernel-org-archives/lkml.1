Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbYLGMFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbYLGMFP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 07:05:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYLGMFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 07:05:00 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:47574 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbYLGME7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 07:04:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GWaf0vj3NZnlc1Izhp8/ztuLn9LbbMjm3NISLVypoYsp2eaXK7cxkV/q9EEe78U4VC
         ErWhrMVyGYPe86ooXdsm6lzGgtR7Tv8S9rY/pF5XPxI1Ruf0lQBUn3czVw/ZZwAn68Fu
         NIbpAsEdO6IUnTvnUjuh75arCSznlp2NTgHkk=
Message-ID: <7b9198260812070404i6d4f25fpce4264c8ad518218@mail.gmail.com>
Date: Sun, 7 Dec 2008 12:04:58 +0000
From: "Tom Spink" <tspink@gmail.com>
To: "Anders Kaseorg" <andersk@mit.edu>
Subject: Re: [PATCH] Don't call sprintf() with overlapping input and output.
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0812070628001.13666@vinegar-pot.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.2.00.0812070628001.13666@vinegar-pot.mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/7 Anders Kaseorg <andersk@mit.edu>:
> The use of sprintf() to append to a buffer, as in
>  sprintf(buf, "%sEntry: %d\n", buf, i)
> is not valid according to C99 ("If copying takes place between objects
> that overlap, the behavior is undefined.").  It breaks at least in
> userspace under gcc -D_FORTIFY_SOURCE.  Replace this construct with
>  sprintf(buf + strlen(buf), "Entry: %d\n", i)
>
> Signed-off-by: Anders Kaseorg <andersk@mit.edu>
> ---
>  Documentation/ia64/err_inject.txt     |    2 +-
>  arch/ia64/sn/kernel/io_common.c       |    2 +-
>  arch/s390/kernel/early.c              |    6 +++---
>  arch/x86/kernel/cpu/intel_cacheinfo.c |    9 ++++-----
>  drivers/media/video/se401.c           |    2 +-
>  drivers/scsi/gdth_proc.c              |    2 +-
>  drivers/usb/atm/usbatm.c              |    2 +-
>  7 files changed, 12 insertions(+), 13 deletions(-)
>
> diff --git a/Documentation/ia64/err_inject.txt b/Documentation/ia64/err_inject.txt
> index 223e4f0..62d0028 100644
> --- a/Documentation/ia64/err_inject.txt
> +++ b/Documentation/ia64/err_inject.txt
> @@ -376,7 +376,7 @@ int create_sem(int cpu)
>        int sid;
>
>        sprintf(fn, PATH_FORMAT, cpu);
> -       sprintf(fn, "%s/%s", fn, "err_type_info");
> +       sprintf(fn + strlen(fn), "/%s", "err_type_info");
>        if ((key[cpu] = ftok(fn, 'e')) == -1) {
>                perror("ftok");
>                return -1;
> diff --git a/arch/ia64/sn/kernel/io_common.c b/arch/ia64/sn/kernel/io_common.c
> index 8a924a5..656e201 100644
> --- a/arch/ia64/sn/kernel/io_common.c
> +++ b/arch/ia64/sn/kernel/io_common.c
> @@ -441,7 +441,7 @@ void sn_generate_path(struct pci_bus *pci_bus, char *address)
>        bricktype = MODULE_GET_BTYPE(moduleid);
>        if ((bricktype == L1_BRICKTYPE_191010) ||
>            (bricktype == L1_BRICKTYPE_1932))
> -                       sprintf(address, "%s^%d", address, geo_slot(geoid));
> +               sprintf(address + strlen(address), "^%d", geo_slot(geoid));
>  }
>
>  void __devinit
> diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
> index 2a2ca26..addee93 100644
> --- a/arch/s390/kernel/early.c
> +++ b/arch/s390/kernel/early.c
> @@ -108,13 +108,13 @@ static noinline __init void create_kernel_nss(void)
>                sinitrd_pfn = PFN_DOWN(__pa(INITRD_START));
>                einitrd_pfn = PFN_UP(__pa(INITRD_START + INITRD_SIZE));
>                min_size = einitrd_pfn << 2;
> -               sprintf(defsys_cmd, "%s EW %.5X-%.5X", defsys_cmd,
> +               sprintf(defsys_cmd + strlen(defsys_cmd), " EW %.5X-%.5X",
>                sinitrd_pfn, einitrd_pfn);
>        }
>  #endif
>
> -       sprintf(defsys_cmd, "%s EW MINSIZE=%.7iK PARMREGS=0-13",
> -               defsys_cmd, min_size);
> +       sprintf(defsys_cmd + strlen(defsys_cmd),
> +               " EW MINSIZE=%.7iK PARMREGS=0-13", min_size);
>        sprintf(savesys_cmd, "SAVESYS %s \n IPL %s",
>                kernel_nss_name, kernel_nss_name);
>
> diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
> index 3f46afb..396b720 100644
> --- a/arch/x86/kernel/cpu/intel_cacheinfo.c
> +++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
> @@ -709,13 +709,12 @@ static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf)
>
>                pci_read_config_dword(dev, 0x1BC + i * 4, &reg);
>
> -               ret += sprintf(buf, "%sEntry: %d\n", buf, i);
> -               ret += sprintf(buf, "%sReads:  %s\tNew Entries: %s\n",
> -                       buf,
> +               ret += sprintf(buf + strlen(buf), "Entry: %d\n", i);
> +               ret += sprintf(buf + strlen(buf), "Reads:  %s\tNew Entries: %s\n",
>                        reg & 0x80000000 ? "Disabled" : "Allowed",
>                        reg & 0x40000000 ? "Disabled" : "Allowed");
> -               ret += sprintf(buf, "%sSubCache: %x\tIndex: %x\n",
> -                       buf, (reg & 0x30000) >> 16, reg & 0xfff);
> +               ret += sprintf(buf + strlen(buf), "SubCache: %x\tIndex: %x\n",
> +                       (reg & 0x30000) >> 16, reg & 0xfff);
>        }
>        return ret;
>  }
> diff --git a/drivers/media/video/se401.c b/drivers/media/video/se401.c
> index 044a2e9..b8d2f03 100644
> --- a/drivers/media/video/se401.c
> +++ b/drivers/media/video/se401.c
> @@ -1276,7 +1276,7 @@ static int se401_init(struct usb_se401 *se401, int button)
>        }
>        sprintf (temp, "%s Sizes:", temp);
>        for (i=0; i<se401->sizes; i++) {
> -               sprintf(temp, "%s %dx%d", temp, se401->width[i], se401->height[i]);
> +               sprintf(temp + strlen(temp), " %dx%d", se401->width[i], se401->height[i]);
>        }
>        dev_info(&se401->dev->dev, "%s\n", temp);
>        se401->maxframesize=se401->width[se401->sizes-1]*se401->height[se401->sizes-1]*3;
> diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
> index 59349a3..5748198 100644
> --- a/drivers/scsi/gdth_proc.c
> +++ b/drivers/scsi/gdth_proc.c
> @@ -196,7 +196,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
>         for (i = 1;  i < MAX_RES_ARGS; i++) {
>             if (reserve_list[i] == 0xff)
>                 break;
> -            sprintf(hrec,"%s,%d", hrec, reserve_list[i]);
> +            sprintf(hrec + strlen(hrec), ",%d", reserve_list[i]);
>         }
>     }
>     size = sprintf(buffer+len,
> diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
> index 06dd114..f52cfa5 100644
> --- a/drivers/usb/atm/usbatm.c
> +++ b/drivers/usb/atm/usbatm.c
> @@ -1393,7 +1393,7 @@ static int usbatm_print_packet(const unsigned char *data, int len)
>                buffer[0] = '\0';
>                sprintf(buffer, "%.3d :", i);
>                for (j = 0; (j < 16) && (i < len); j++, i++) {
> -                       sprintf(buffer, "%s %2.2x", buffer, data[i]);
> +                       sprintf(buffer + strlen(buffer), " %2.2x", data[i]);
>                }
>                dbg("%s", buffer);
>        }
> --
> 1.6.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Hi,

That to me looks like it's begging for 'strcatf'... :)

-- 
Tom Spink
Zsa Zsa Gabor  - "A man in love is incomplete until he has married.
Then he's finished."
