Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbYFUIfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbYFUIfl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 04:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYFUIfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 04:35:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48698 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbYFUIfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 04:35:32 -0400
Date: Sat, 21 Jun 2008 01:17:35 -0700
From: Greg KH <greg@kroah.com>
To: Jason Baron <jbaron@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, joe@perches.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: Re: [PATCH 2/8] dynamic debug - core infrastructure
Message-ID: <20080621081735.GA11929@kroah.com>
References: <20080613190039.GC8813@redhat.com> <20080618160812.GB9453@kroah.com> <20080620153822.GA10639@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620153822.GA10639@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 11:38:22AM -0400, Jason Baron wrote:
> On Wed, Jun 18, 2008 at 09:08:12AM -0700, Greg KH wrote:
> > On Fri, Jun 13, 2008 at 03:00:39PM -0400, Jason Baron wrote:
> > > --- a/include/linux/device.h
> > > +++ b/include/linux/device.h
> > > @@ -595,6 +595,22 @@ extern const char *dev_driver_string(struct device *dev);
> > >  #ifdef DEBUG
> > >  #define dev_dbg(dev, format, arg...)		\
> > >  	dev_printk(KERN_DEBUG , dev , format , ## arg)
> > > +#elif defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
> > > +#define dev_dbg(dev, format, ...) do {				    	     \
> > > +	static char mod_name[]						     \
> > > +	__attribute__((section("__verbose_strings")))			     \
> > > +	 = KBUILD_MODNAME;						     \
> > > +	static struct mod_debug foobar					     \
> > > +	__used								     \
> > > +	__attribute__((section("__verbose"), aligned(8))) =		     \
> > > +	{ mod_name, mod_name, "0", "0", NULL };				     \
> > 
> > Does the compiler merge all of these variables together into one within
> > the same file?
> > 
> 
> no.
> 
> > If not, should we have a new macro, one per file, for this information?
> > 
> 
> With this feature enabled, the above 'meta-data' added ~32K to the .init.data
> section. This memory is freed when the system boots because it is placed in the
> .init.data section. The same is true for modules, the 'meta-data' is freed when
> the module loads.
> 
> We could reduce the vmlinux by having 'register()' type calls for this
> infrastructure, or a new marco per file as you suggest, and i had something
> like that in an earlier iteration, but I think the memory savings is very
> small when compared to the increased complexity. The simplicity to just put a
> 'pr_debug()" anywhere and just have it do the right thing is nice.
> 
> Also, it should be noted that the total increase in the size of the 'vmlinux' 
> was 3%, or 2M, this is due to the above 'meta-data', the new code, and probably 
> most significantly, the strings, for the additinal printks. Thus, compressing
> the above meta-data, or eliminating it by some other means would only decrease
> the size of this infrastructure by 2% or so.

Ok, thanks for the good explaination.  As long as there is a way to turn
this off for the EMBEDDED people who do care about 2% at times, this
should be ok.

greg k-h
