Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbYIIIP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbYIIIP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 04:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbYIIIPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 04:15:40 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57137 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743AbYIIIPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 04:15:38 -0400
Date: Tue, 9 Sep 2008 09:15:36 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Andrew Morton <akpm@linux-foundation.org>
cc: Roberto Oppedisano <roppedisano@infracomspa.it>,
       LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net
Subject: Re: [PATCH] rate limit drm:radeon_cp_idle/reset errors
In-Reply-To: <20080909011211.e336d7c4.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.0.82.0809090914300.1221@skynet.skynet.ie>
References: <20080906091919.GA5021@infracomspa.it>
 <20080908210836.fc5df672.akpm@linux-foundation.org> <20080909073732.GA7563@infracomspa.it>
 <20080909011211.e336d7c4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > > Sep  6 10:24:31 poppero1 kernel: [  186.138774] [drm:radeon_cp_start] *ERROR* radeon_cp_start called without lock held, held  0 owner f726bc80 f68f6840
> > > > Sep  6 10:24:31 poppero1 kernel: [  186.138968] [drm:radeon_cp_idle] *ERROR* radeon_cp_idle called without lock held, held  0 owner f726bc80 f68f6840
> > > > Sep  6 10:24:31 poppero1 kernel: [  186.139214] [drm:radeon_cp_reset] *ERROR* radeon_cp_reset called without lock held, held  0 owner f726bc80 f68f6840
> > > > Sep  6 10:24:31 poppero1 kernel: [  186.139408] [drm:radeon_cp_start] *ERROR* radeon_cp_start called without lock held, held  0 owner f726bc80 f68f6840
> > > > Sep  6 10:24:31 poppero1 kernel: [  186.139601] [drm:radeon_cp_idle] *ERROR* radeon_cp_idle called without lock held, held  0 owner f726bc80 f68f6840
> > > > Sep  6 10:24:31 poppero1 kernel: [  186.139866] [drm:radeon_cp_reset] *ERROR* radeon_cp_reset called without lock held, held  0 owner f726bc80 f68f6840
> > > > Sep  6 10:24:31 poppero1 kernel: [  186.140072] [drm:radeon_cp_start] *ERROR* radeon_cp_start called without lock held, held  0 owner f726bc80 f68f6840
> > > > Sep  6 10:24:31 poppero1 kernel: [  186.140467] [drm:radeon_cp_idle] *ERROR* radeon_cp_idle called without lock held, held  0 owner f726bc80 f68f6840
> > > > Sep  6 10:24:36 poppero1 kernel: [  191.139019] __ratelimit: 253431 callbacks suppressed
> > > > Sep  6 10:24:36 poppero1 kernel: [  191.139030] [drm:radeon_cp_reset] *ERROR* radeon_cp_reset called without lock held, held  0 owner f726bc80 f68f6840
> > > > Sep  6 10:24:36 poppero1 kernel: [  191.139314] [drm:radeon_cp_start] *ERROR* radeon_cp_start called without lock held, held  0 owner f726bc80 f68f6840
> > > > 
> > > > Also if it doesn't solve a bug I think it may still be worth applying it. 
> > > > Patch is against current git.
> > > > 
> > > > Signed-off-by: Roberto Oppedisano <roberto.oppedisano@infracom.it>
> > > > 
> > > > diff --git a/include/drm/drmP.h b/include/drm/drmP.h
> > > > index 1c1b13e..1107361 100644
> > > > --- a/include/drm/drmP.h
> > > > +++ b/include/drm/drmP.h
> > > > @@ -162,7 +162,8 @@ struct drm_device;
> > > >   * \param arg arguments
> > > >   */
> > > >  #define DRM_ERROR(fmt, arg...) \
> > > > -	printk(KERN_ERR "[" DRM_NAME ":%s] *ERROR* " fmt , __func__ , ##arg)
> > > > +	if (printk_ratelimit()) \
> > > > +		printk(KERN_ERR "[" DRM_NAME ":%s] *ERROR* " fmt , __func__ , ##arg)
> > > >  
> > > >  /**
> > > >   * Memory error output.
> > > > 
> > > 
> > > Which kernel version(s)?
> > 
> > This is against vanilla current git. 
> > 
> > Linux poppero1 2.6.27-rc5-00000-g7686ad5-dirty #1 PREEMPT Sun Sep 7 08:47:08 CEST 2008 i686 GNU/Linux
> > 
> 
> Thanks.  I should have asked earlier: was 2.6.26 OK?  Any other kernels
> tested?

This looks like a userspace problem, some app is accessing the drm file 
descriptror without holding the drm lock, this is very illegal.

Its probably a race between the X server and the AIGLX driver.

Dave.
