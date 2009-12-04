Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbZLDAeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbZLDAeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 19:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZLDAeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 19:34:06 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:60411 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbZLDAeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 19:34:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f3+oaLPA7C4zkHzJvmFPdMPWL0dn+Iwrp0PM3s0pDu1/0I+UWgU0rZP+R/3JcgsTKv
         IZH6OfiNwsU8R6FYtUDn5ll5VBKhFyHmParvXzrdPRDxQaDa95965OrcjXpWZ8X/4A3p
         2cJq4+wgQkErnBRiq+NYRGs2zup2jstmPt5lA=
MIME-Version: 1.0
In-Reply-To: <1259854318-16907-2-git-send-email-konrad.wilk@oracle.com>
References: <1259854318-16907-1-git-send-email-konrad.wilk@oracle.com>
	 <1259854318-16907-2-git-send-email-konrad.wilk@oracle.com>
Date: Fri, 4 Dec 2009 08:34:10 +0800
Message-ID: <45a44e480912031634q7967f039j961dacaa8f741307@mail.gmail.com>
Subject: Re: [PATCH 1/3] fb-defio: If FBINFO_VIRTFB is defined, do not set 
	VM_IO flag.
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: damm@opensource.se, linux-kernel@vger.kernel.org, armbru@redhat.com,
       jeremy@goop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 3, 2009 at 11:31 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> Most users (except sh_mobile_lcdcfb.c) get their framebuffer from
> vmalloc. Setting VM_IO is not necessary as the memory obtained
> from vmalloc is System RAM type and is not susceptible to PCI memory
> constraints.
> ---
>  drivers/video/fb_defio.c |    4 +++-
>  include/linux/fb.h       |    1 +
>  2 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/video/fb_defio.c b/drivers/video/fb_defio.c
> index c27ab1e..94414fc 100644
> --- a/drivers/video/fb_defio.c
> +++ b/drivers/video/fb_defio.c
> @@ -144,7 +144,9 @@ static const struct address_space_operations fb_deferred_io_aops = {
>  static int fb_deferred_io_mmap(struct fb_info *info, struct vm_area_struct *vma)
>  {
>        vma->vm_ops = &fb_deferred_io_vm_ops;
> -       vma->vm_flags |= ( VM_IO | VM_RESERVED | VM_DONTEXPAND );
> +       vma->vm_flags |= ( VM_RESERVED | VM_DONTEXPAND );
> +       if (!(info->flags & FBINFO_VIRTFB))
> +               vma->vm_flags |= VM_IO;
>        vma->vm_private_data = info;
>        return 0;
>  }
> diff --git a/include/linux/fb.h b/include/linux/fb.h
> index de9c722..369767b 100644
> --- a/include/linux/fb.h
> +++ b/include/linux/fb.h
> @@ -763,6 +763,7 @@ struct fb_tile_ops {
>         *  takes over; acceleration engine should be in a quiescent state */
>
>  /* hints */
> +#define FBINFO_VIRTFB          0x0004 /* FB is System RAM, not device. */
>  #define FBINFO_PARTIAL_PAN_OK  0x0040 /* otw use pan only for double-buffering */
>  #define FBINFO_READS_FAST      0x0080 /* soft-copy faster than rendering */
>
> --
> 1.6.2.5
>
>

Looks good to me. Thanks.

Acked-by: Jaya Kumar <jayakumar.lkml@gmail.com>
