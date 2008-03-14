Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbYCNKeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbYCNKeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 06:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYCNKdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 06:33:55 -0400
Received: from www.tglx.de ([62.245.132.106]:32868 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbYCNKdy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 06:33:54 -0400
Date: Fri, 14 Mar 2008 11:33:36 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
Cc: "Jean-Samuel Chenard" <jsamch@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       grant.likely@secretlab.ca, Juergen Beisert <juergen127@kreuzholzen.de>
Subject: Re: Linux UIO driver cache problem in PowerPC (fix)
Message-ID: <20080314113336.63af1e7a@bluebox.local>
In-Reply-To: <20080313081932.4edee290@dilbert.local>
References: <169c03cb0803121222h5fca9cdal5af873cd2a700f4d@mail.gmail.com>
	<20080313081932.4edee290@dilbert.local>
Organization: Linutronix GmbH
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 13 Mar 2008 08:19:32 +0100
schrieb Hans-Jürgen Koch <hjk@linutronix.de>:

> Am Wed, 12 Mar 2008 15:22:59 -0400
> schrieb "Jean-Samuel Chenard" <jsamch@gmail.com>:
> 
> > Hi,

Hi Jean-Samuel,
I investigated a bit and found your patch to be correct. I cleaned it
up a bit and sent it to Greg and LKML. I added you as author and also
took the freedom to add your Signed-off-by.

Juergen, Thomas, Grant, if you can confirm this, please add your
signature as well.

Thanks,
Hans

> 
> Hi Jean-Samuel,
> thanks for your report. Please CC LKML if you find bugs like this. I
> also added Grant Likely (PPC Xilinx Virtex maintainer), as it seems to
> be a platform specific problem.
> 
> > 
> > Experimenting with your userspace I/O driver on a Xilinx FPGA
> > (PowerPC 405), I was having problems when reading hardware device
> > registers mapped on my platform using the user-space mmap() call.
> > 
> > After some investigation (looking at the driver/char/mspec.c file),
> > I found that preventing caching of the page in uio_mmap_physical
> > fixed my issues with userspace mmap() reading messed-up values.
> 
> Hm, we already mark the page with VM_IO. That's sufficient on x86 and
> arm. I'm not sure whether this is a bug in PPC memory handling. Why do
> they cache VM_IO pages? 
> 
> > 
> > This patch is against your initial commit of the UIO driver in the
> > mainline kernel tree.
> > 
> > ====
> > diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> > index 865f32b..36e1123 100644
> > --- a/drivers/uio/uio.c
> > +++ b/drivers/uio/uio.c
> > @@ -22,6 +22,7 @@
> >  #include <linux/string.h>
> >  #include <linux/kobject.h>
> >  #include <linux/uio_driver.h>
> > +#include <asm/pgtable.h>
> > 
> >  #define UIO_MAX_DEVICES 255
> > 
> > @@ -447,6 +448,8 @@ static int uio_mmap_physical(struct
> > vm_area_struct *vma)
> > 
> >         vma->vm_flags |= VM_IO | VM_RESERVED;
> > 
> > +       vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> > +
> >         return remap_pfn_range(vma,
> >                                vma->vm_start,
> >                                idev->info->mem[mi].addr >>
> > PAGE_SHIFT, ====
> > 
> > I am a bit unsure if this will break something in any of your uses
> > of the UIO driver (on other platforms than ppc), but it really fixes
> > things for me.  
> 
> It should be OK, but unneccesary on other platforms. I have no
> objections, but I fear in 6 months we'll see a patch removing that
> line again because it's not needed... 
> 
> > Let me know if you need more details on what was
> > happening on my platform before I added this statement.
> 
> I'd like to hear the opinion of people really involved in PPC memory
> handling.
> 
> > 
> > Thanks for the great driver for user-space I/O, it will save me lots
> > of time in my research.
> > 
> > Regards,
> > 
> > Jean-Samuel
> 
> Thanks,
> Hans
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
