Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbYBXCGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbYBXCGT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 21:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbYBXCGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 21:06:09 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:20830 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbYBXCGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 21:06:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=NFWumKkwrO07tm7WxLy3rumi9EcCwGUb2/b4b+Yp5RaL19SHGPBNZ5sYfFFgZu5LUMCoySPkX/uviB68NzAOyBBHDEWQECpokBlpniTYBmXZfaZoXn2+N0fOkvLLPP6T5A2i5Xyre53pTstoeZ9wn0sNKbLiRAGctnAzBJIceIc=
Message-ID: <e9c3a7c20802231806u15bbf0dbm7ee68b6620a4b418@mail.gmail.com>
Date: Sat, 23 Feb 2008 19:06:06 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Kumar Gala" <galak@kernel.crashing.org>
Subject: Re: dma engine drivers for 2.6.25?
Cc: "LKML Kernel" <linux-kernel@vger.kernel.org>,
       "Zhang Wei" <wei.zhang@freescale.com>
In-Reply-To: <e9c3a7c20802142129m51acf21amc48eaea5db45840b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <BEF96263-F31B-472E-B31F-0751F5ABFBDA@kernel.crashing.org>
	 <e9c3a7c20802141014k6018f6dfvc1a97bf81acb872e@mail.gmail.com>
	 <DC488215-D313-41E0-A98A-1C90D02A465D@kernel.crashing.org>
	 <e9c3a7c20802142129m51acf21amc48eaea5db45840b@mail.gmail.com>
X-Google-Sender-Auth: 3400d7c1182091a0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 10:29 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Thu, Feb 14, 2008 at 8:44 PM, Kumar Gala <galak@kernel.crashing.org> wrote:
>  >
>  >  On Feb 14, 2008, at 12:14 PM, Dan Williams wrote:
>  >
>  >  > On Wed, Feb 13, 2008 at 8:52 PM, Kumar Gala
>  >  > <galak@kernel.crashing.org> wrote:
>  >  >> Dan,
>  >  >>
>  >  >> What's going on with the dma engine drivers for 2.6.25?  We had a
>  >  >> Freescale dma driver from Zhang Wei queued up but seems to have been
>  >  >> lost.
>  >  >
>  >  > I pulled it into my tree and am holding it until Zhang has an
>  >  > opportunity to address the pending review comments [1].  I also did
>  >  > not feel comfortable pushing it to Linus without a PPC maintainer's
>  >  > Acked-by/Reviewed-by.
>  >  >
>  >  > I have attached the version I am carrying.
>  >
>  >  What issues are still open.  I was under the belief that Zhang had
>  >  resolved all the issues.
>  >
>
>  The high priority review item is that the driver performs operation
>  completion callbacks in hardirq context.  Clients of the API assume
>  that callbacks will happen in softirq context.  Of lesser concern is
>  the use of GFP_ATOMIC in fsl_dma_alloc_descriptor.  Other drivers
>  preallocate a small pool of descriptors.
>

Have not received a response, so let's try this the other way.  I took
a closer look and found that my concern should be addressed by the
following one-liner:

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 902e852..cc9a681 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -685,7 +685,6 @@ static irqreturn_t fsl_dma_chan_do_interrupt(int
irq, void *data)
                                "nlndar 0x%016llx\n", (u64)get_cdar(fsl_chan),
                                (u64)get_ndar(fsl_chan));
                stat &= ~FSL_DMA_SR_EOSI;
-               fsl_chan_ld_cleanup(fsl_chan);
        }

        /* If it current transfer is the end-of-transfer,

With your ack I'll push the driver plus this fixlet for the current kernel.

Regards,
Dan
