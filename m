Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbYGaJQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbYGaJQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 05:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYGaJQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 05:16:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554AbYGaJQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 05:16:48 -0400
Date: Thu, 31 Jul 2008 02:15:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: syrjala@sci.fi, adaplas@gmail.com, linux-fbdev-devel@lists.sourceforge.net,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] atyfb_base.c: fix warning
Message-Id: <20080731021552.2f5fe6d6.akpm@linux-foundation.org>
In-Reply-To: <20080730210352.GA29355@orion>
References: <20080730210352.GA29355@orion>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008 01:03:52 +0400 Alexander Beregalov <a.beregalov@gmail.com> wrote:

> From: Alexander Beregalov <a.beregalov@gmail.com>
> 
> atyfb_base.c: fix warning
> 
> drivers/video/aty/atyfb_base.c:2663: warning: 'aty_resume_chip' defined
> but not used
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> Cc: Ville Syrjala <syrjala@sci.fi>
> Cc: Antonino A. Daplas <adaplas@pol.net>
> ---
> 
>  drivers/video/aty/atyfb_base.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
> index 620ba81..9e5dfb1 100644
> --- a/drivers/video/aty/atyfb_base.c
> +++ b/drivers/video/aty/atyfb_base.c
> @@ -244,7 +244,9 @@ static int atyfb_sync(struct fb_info *info);
>       */
>  
>  static int aty_init(struct fb_info *info);
> +#if defined(CONFIG_PM) && defined(CONFIG_PCI)
>  static void aty_resume_chip(struct fb_info *info);
> +#endif
>  #ifdef CONFIG_ATARI
>  static int store_video_par(char *videopar, unsigned char m64_num);
>  #endif
> @@ -2659,6 +2661,7 @@ aty_init_exit:
>  	return ret;
>  }
>  
> +#if defined(CONFIG_PM) && defined(CONFIG_PCI)
>  static void aty_resume_chip(struct fb_info *info)
>  {
>  	struct atyfb_par *par = info->par;
> @@ -2671,6 +2674,7 @@ static void aty_resume_chip(struct fb_info *info)
>  	if (par->aux_start)
>  		aty_st_le32(BUS_CNTL, aty_ld_le32(BUS_CNTL, par) | BUS_APER_REG_DIS, par);
>  }
> +#endif /* defined(CONFIG_PM) && defined(CONFIG_PCI) */
>  
>  #ifdef CONFIG_ATARI
>  static int __devinit store_video_par(char *video_str, unsigned char m64_num)

OK...

We don't strictly need the first ifdef - it's OK to declare a
non-existent function, and ifdefs are ugly.

But we can reorganise the code a bit more and remove the forward
declaration altogether and remove a whole ifdef block too.

How does this look?

 drivers/video/aty/atyfb_base.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff -puN drivers/video/aty/atyfb_base.c~atyfb_basec-fix-warning drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb_basec-fix-warning
+++ a/drivers/video/aty/atyfb_base.c
@@ -244,7 +244,7 @@ static int atyfb_sync(struct fb_info *in
      */
 
 static int aty_init(struct fb_info *info);
-static void aty_resume_chip(struct fb_info *info);
+
 #ifdef CONFIG_ATARI
 static int store_video_par(char *videopar, unsigned char m64_num);
 #endif
@@ -2023,6 +2023,20 @@ static int atyfb_pci_suspend(struct pci_
 	return 0;
 }
 
+static void aty_resume_chip(struct fb_info *info)
+{
+	struct atyfb_par *par = info->par;
+
+	aty_st_le32(MEM_CNTL, par->mem_cntl, par);
+
+	if (par->pll_ops->resume_pll)
+		par->pll_ops->resume_pll(info, &par->pll);
+
+	if (par->aux_start)
+		aty_st_le32(BUS_CNTL,
+			aty_ld_le32(BUS_CNTL, par) | BUS_APER_REG_DIS, par);
+}
+
 static int atyfb_pci_resume(struct pci_dev *pdev)
 {
 	struct fb_info *info = pci_get_drvdata(pdev);
@@ -2659,19 +2673,6 @@ aty_init_exit:
 	return ret;
 }
 
-static void aty_resume_chip(struct fb_info *info)
-{
-	struct atyfb_par *par = info->par;
-
-	aty_st_le32(MEM_CNTL, par->mem_cntl, par);
-
-	if (par->pll_ops->resume_pll)
-		par->pll_ops->resume_pll(info, &par->pll);
-
-	if (par->aux_start)
-		aty_st_le32(BUS_CNTL, aty_ld_le32(BUS_CNTL, par) | BUS_APER_REG_DIS, par);
-}
-
 #ifdef CONFIG_ATARI
 static int __devinit store_video_par(char *video_str, unsigned char m64_num)
 {
_

