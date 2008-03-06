Return-Path: <linux-kernel-owner+w=401wt.eu-S1760230AbYCFFJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230AbYCFFJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 00:09:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbYCFFJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 00:09:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43548 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbYCFFJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 00:09:18 -0500
Date: Wed, 5 Mar 2008 21:13:37 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: PATCH [1/1]: Don't return symbol lables in init sections after
	they have been freed
Message-ID: <20080306051337.GH16166@kroah.com>
References: <200803041847.15884.rgetz@blackfin.uclinux.org> <20080304160501.17d992f0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304160501.17d992f0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 04:05:01PM -0800, Andrew Morton wrote:
> On Tue, 4 Mar 2008 18:47:15 -0500
> Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> 
> > From: Robin Getz <rgetz@blackfin.uclinux.org>
> > 
> > Today, when module names are looked up, we do not qualify them (check to see 
> > if the init section is still active or not). This can lead to problems when 
> > kernel modules get loaded into the same address that the kernel init section 
> > (or other module's init section was at). We sometimes return the old / no 
> > lomnger there 
> > 
> > This leads to bogus OOPS messages, and developers wasting their time looking 
> > for problems (in the kernel init section) where there are none (since it was 
> > a module).
> > 
> > This patch qualifies the addresses, to make sure the addresses are still valid 
> > before label/offset.
> > 
> > Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>
> > 
> > ---
> > 
> >  linux-2.6.x/kernel/kallsyms.c |    3 ++-
> >  linux-2.6.x/kernel/module.c   |    3 ++-
> >  2 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > Index: linux-2.6.x/kernel/kallsyms.c
> > ===================================================================
> > --- linux-2.6.x/kernel/kallsyms.c	(revision 4212)
> > +++ linux-2.6.x/kernel/kallsyms.c	(working copy)
> > @@ -42,7 +42,8 @@
> >  
> >  static inline int is_kernel_inittext(unsigned long addr)
> >  {
> > -	if (addr >= (unsigned long)_sinittext
> > +	if (system_state == SYSTEM_BOOTING
> > +	    && addr >= (unsigned long)_sinittext
> >  	    && addr <= (unsigned long)_einittext)
> >  		return 1;
> >  	return 0;
> > Index: linux-2.6.x/kernel/module.c
> > ===================================================================
> > --- linux-2.6.x/kernel/module.c	(revision 4212)
> > +++ linux-2.6.x/kernel/module.c	(working copy)
> > @@ -2121,7 +2121,8 @@
> >  	struct module *mod;
> >  
> >  	list_for_each_entry(mod, &modules, list) {
> > -		if (within(addr, mod->module_init, mod->init_size)
> > +		if ((within(addr, mod->module_init, mod->init_size)
> > +		     && mod->state == MODULE_STATE_COMING)
> >  		    || within(addr, mod->module_core, mod->core_size)) {
> >  			if (modname)
> >  				*modname = mod->name;
> 
> Both of the above additions could do with a comment explaining what's going
> on.
> 
> The first one perhaps should use the more specific initmem_now_dynamic
> which is added by
> gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch from
> Greg's driver tree.  If the intent is to merge that - if not perhaps it can
> be split up.

The intent wasn't to merge that, as it seemed like a big hack.  But if
people don't mind, I have no objection to it going in.

thanks,

greg k-h
