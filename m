Return-Path: <linux-kernel-owner+w=401wt.eu-S932541AbYBUQbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541AbYBUQbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758537AbYBUQbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:31:07 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:11817 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbYBUQbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:31:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DHnjaPqreNKS9/Q7H5xy4ttiEaOW67S4zJdvZonGJo9ajeOhiQk1i8HA3qz+v3Q7k1DEutgPrPUOpYXaNa9x358QmAxjWEIHXjUCFU4mLgkawSKAUbLkAKSrkz5C6fz9IaKokPzWaPXIobsIQY1r5lvX0eIHVJcR62LYXLd4fSk=
Message-ID: <45a44e480802210830o1041e612sa532acde52e42748@mail.gmail.com>
Date: Fri, 22 Feb 2008 00:30:58 +0800
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Markus Armbruster" <armbru@redhat.com>
Subject: Re: [PATCH 1/2] fbdev: Make deferred I/O work as advertized
Cc: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@pol.net, linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       akpm@linux-foundation.org
In-Reply-To: <87ve4id4rb.fsf@pike.pond.sub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <871w76ejdg.fsf@pike.pond.sub.org>
	 <87ve4id4rb.fsf@pike.pond.sub.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 5:43 PM, Markus Armbruster <armbru@redhat.com> wrote:
>  Fix extracted from this linux-fbdev-devel message:

Hi Markus,

Yes, this was discussed back in November on linux-mm and hence my
patch. I didn't push for it to be merged by itself because I don't
think it makes sense to merge it separately from the full metronomefb
patch. As far as I can tell, only hecubafb and metronomefb seem to be
the consumers.

Out of curiosity, are you using defio or planning to use it? I would
love to hear back from people who are using it.

Thanks,
jaya

>
>     Subject: [PATCH 1/1 2.6.24] fbdev: defio and Metronomefb
>     From: Jaya Kumar <jayakumar.lkml@gmail.com>
>     Date: 2008-02-18 13:41:26
>
>  Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
>  Signed-off-by: Markus Armbruster <armbru@redhat.com>
>
>  ---
>
>   drivers/video/fb_defio.c |   22 ++++++++++++++++++++--
>   1 file changed, 20 insertions(+), 2 deletions(-)
>
>  diff --git a/drivers/video/fb_defio.c b/drivers/video/fb_defio.c
>  index 0f8cfb9..24843fd 100644
>  --- a/drivers/video/fb_defio.c
>  +++ b/drivers/video/fb_defio.c
>  @@ -4,7 +4,7 @@
>   *  Copyright (C) 2006 Jaya Kumar
>   *
>   * This file is subject to the terms and conditions of the GNU General Public
>  - * License.  See the file COPYING in the main directory of this archive
>  + * License. See the file COPYING in the main directory of this archive
>   * for more details.
>   */
>
>  @@ -31,7 +31,7 @@ static int fb_deferred_io_fault(struct vm_area_struct *vma,
>         unsigned long offset;
>         struct page *page;
>         struct fb_info *info = vma->vm_private_data;
>  -       /* info->screen_base is in System RAM */
>  +       /* info->screen_base is virtual memory */
>         void *screen_base = (void __force *) info->screen_base;
>
>         offset = vmf->pgoff << PAGE_SHIFT;
>  @@ -43,6 +43,15 @@ static int fb_deferred_io_fault(struct vm_area_struct *vma,
>                 return VM_FAULT_SIGBUS;
>
>         get_page(page);
>  +
>  +       if (vma->vm_file)
>  +               page->mapping = vma->vm_file->f_mapping;
>  +       else
>  +               printk(KERN_ERR "no mapping available\n");
>  +
>  +       BUG_ON(!page->mapping);
>  +       page->index = vmf->pgoff;
>  +
>         vmf->page = page;
>         return 0;
>   }
>  @@ -138,11 +147,20 @@ EXPORT_SYMBOL_GPL(fb_deferred_io_init);
>
>   void fb_deferred_io_cleanup(struct fb_info *info)
>   {
>  +       void *screen_base = (void __force *) info->screen_base;
>         struct fb_deferred_io *fbdefio = info->fbdefio;
>  +       struct page *page;
>  +       int i;
>
>         BUG_ON(!fbdefio);
>         cancel_delayed_work(&info->deferred_work);
>         flush_scheduled_work();
>  +
>  +       /* clear out the mapping that we setup */
>  +       for (i = 0 ; i < info->fix.smem_len; i += PAGE_SIZE) {
>  +               page = vmalloc_to_page(screen_base + i);
>  +               page->mapping = NULL;
>  +       }
>   }
>   EXPORT_SYMBOL_GPL(fb_deferred_io_cleanup);
>
>
