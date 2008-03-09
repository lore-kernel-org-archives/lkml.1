Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbYCIBQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbYCIBQV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 20:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYCIBQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 20:16:12 -0500
Received: from mail.queued.net ([207.210.101.209]:4904 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbYCIBQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 20:16:11 -0500
Date: Sat, 8 Mar 2008 20:19:43 -0500
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/4] gxfb: Replace FBSIZE config option with a kernel
 argument
Message-ID: <20080308201943.31cd89b3@ephemeral>
In-Reply-To: <20080227195839.1e86074e@ephemeral>
References: <20080223011045.48e6cb8e@ephemeral>
	<20080227163105.e1b96023.akpm@linux-foundation.org>
	<20080227195839.1e86074e@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008 19:58:39 -0500
Andres Salomon <dilinger@queued.net> wrote:

> On Wed, 27 Feb 2008 16:31:05 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Sat, 23 Feb 2008 01:10:45 -0500
> > Andres Salomon <dilinger@queued.net> wrote:
> > 
> > > @@ -425,7 +424,10 @@ static int __init gxfb_setup(char *options)
> > >  		if (!*opt)
> > >  			continue;
> > >  
> > > -		mode_option = opt;
> > > +		if (!strncmp(opt, "fbsize:", 7))
> > > +			fbsize = simple_strtoul(opt+7, NULL, 0);
> > > +		else
> > > +			mode_option = opt;
> > >  	}
> > 
> > The above shouldn't be necessary.
> 
> It looks like that's done in other drivers in case MODULE isn't defined.  I'm
> assuming this is historical at this point, and manual options parsing can
> be removed from all fb drivers at this point, or is there another reason
> why manual parsing would be necessary?
> 


Could I get an answer from the fbdevel folks about this?  It looks like
the fb_get_options stuff is there for backwards compatibility.
gxfb.fbsize=16777216 (for example) works regardless of whether or not
CONFIG_MODULES is set.  

It would appear that the only reason for fb_get_options() calling would
be to support video=gxfb:<options>.  Is this used any more?  Should it
be marked deprecated, and dropped from the geode fb drivers?


> 
> > 
> > And it should have been documented in Documentation/kernel-parameters.txt.
> 
> Yeah, I wasn't actually sure about that; I did check for other fb drivers
> documenting stuff in kernel-parameters.txt, and didn't see it.  It looks
> like they instead document stuff in Documentation/fb/.  Which is preferred?
> 


I'd also like an opinion about this.


> 
> 
> > 
> > And "fbsize=N" would be a lot more conventional than "fbsize:N"
> > 
> 
> I can certainly change that.  Regarding convention, I toyed with renaming
> it 'vram' (as most of the fb drivers use that), and will probably do
> that unless Jordan objects.
> 
> 
> > I suspect that the formulation you have here will not permit "fbsize:128k",
> > whereas "fbsize=128k" or "gxfb.fbsize=128k" should work.  Needs checking.
> > 
> > >  	return 0;
> > > @@ -456,5 +458,8 @@ module_exit(gxfb_cleanup);
> > >  module_param(mode_option, charp, 0);
> > >  MODULE_PARM_DESC(mode_option, "video mode (<x>x<y>[-<bpp>][@<refr>])");
> > >  
> > > +module_param(fbsize, int, 0);
> > > +MODULE_PARM_DESC(fbsize, "video memory size");
> > > +
> > 
> > Because the module_param() already makes fbsize available on the kernel
> > boot command line via gxfb.fbsize=42 (or something similar).
> > 
> > 
