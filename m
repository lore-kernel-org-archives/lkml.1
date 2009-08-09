Return-Path: <linux-kernel-owner+w=401wt.eu-S1753652AbZHIJhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbZHIJhY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 05:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbZHIJhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 05:37:20 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47110 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628AbZHIJhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 05:37:16 -0400
Date: Sun, 9 Aug 2009 11:33:07 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [Linux-fbdev-devel] [PATCH 3/3] drivers/video: Correct use of 
 request_region/request_mem_region
In-Reply-To: <10f740e80908090224p13d2119do9e4f4d7730ed001e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0908091132160.13271@ask.diku.dk>
References: <Pine.LNX.4.64.0908090943560.13271@ask.diku.dk>
 <10f740e80908090224p13d2119do9e4f4d7730ed001e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-511516320-771632445-1249810387=:13271"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---511516320-771632445-1249810387=:13271
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

Thanks forthe information. I will fix the occurrences in gbefb.c and then 
submit a revised vesion of the complete patch.

julia


On Sun, 9 Aug 2009, Geert Uytterhoeven wrote:

> On Sun, Aug 9, 2009 at 09:44, Julia Lawall<julia@diku.dk> wrote:
> > From: Julia Lawall <julia@diku.dk>
> >
> > request_region should be used with release_region, not request_mem_region.
> >
> > The semantic patch that fixes this problem is as follows:
> > (http://coccinelle.lip6.fr/)
> >
> > // <smpl>
> > @r1@
> > expression start;
> > @@
> >
> > request_region(start,...)
> >
> > @b1@
> > expression r1.start;
> > @@
> >
> > request_mem_region(start,...)
> >
> > @depends on !b1@
> > expression r1.start;
> > expression E;
> > @@
> >
> > - release_mem_region
> > + release_region
> >  (start,E)
> > // </smpl>
> >
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> >
> > ---
> >  drivers/video/gbefb.c  |    4 ++--
> >  drivers/video/tdfxfb.c |    4 ++--
> >  2 files changed, 4 insertions(+), 4 deletions(-)
> >
> > diff -u -p a/drivers/video/gbefb.c b/drivers/video/gbefb.c
> > --- a/drivers/video/gbefb.c
> > +++ b/drivers/video/gbefb.c
> > @@ -1246,7 +1246,7 @@ out_tiles_free:
> >  out_unmap:
> >        iounmap(gbe);
> >  out_release_mem_region:
> > -       release_mem_region(GBE_BASE, sizeof(struct sgi_gbe));
> > +       release_region(GBE_BASE, sizeof(struct sgi_gbe));
> 
> GBE_BASE seems to be MMIO (it's mapped using ioremap()), so it looks like the
> release_mem_region() is actually correct, while the request_region() should be
> request_mem_region() instead
> 
> >  out_release_framebuffer:
> >        framebuffer_release(info);
> >
> > @@ -1265,7 +1265,7 @@ static int __devexit gbefb_remove(struct
> >                iounmap(gbe_mem);
> >        dma_free_coherent(NULL, GBE_TLB_SIZE * sizeof(uint16_t),
> >                          (void *)gbe_tiles.cpu, gbe_tiles.dma);
> > -       release_mem_region(GBE_BASE, sizeof(struct sgi_gbe));
> > +       release_region(GBE_BASE, sizeof(struct sgi_gbe));
> 
> Ditto.
> 
> > diff -u -p a/drivers/video/tdfxfb.c b/drivers/video/tdfxfb.c
> > --- a/drivers/video/tdfxfb.c
> > +++ b/drivers/video/tdfxfb.c
> > @@ -1571,8 +1571,8 @@ out_err_iobase:
> >        if (default_par->mtrr_handle >= 0)
> >                mtrr_del(default_par->mtrr_handle, info->fix.smem_start,
> >                         info->fix.smem_len);
> > -       release_mem_region(pci_resource_start(pdev, 2),
> > -                          pci_resource_len(pdev, 2));
> > +       release_region(pci_resource_start(pdev, 2),
> > +                      pci_resource_len(pdev, 2));
> >  out_err_screenbase:
> >        if (info->screen_base)
> >                iounmap(info->screen_base);
> 
> This one looks OK.
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
---511516320-771632445-1249810387=:13271--
