Return-Path: <linux-kernel-owner+w=401wt.eu-S964873AbXCPLvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964873AbXCPLvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 07:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964923AbXCPLvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 07:51:40 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42951 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964873AbXCPLvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 07:51:39 -0400
Date: Fri, 16 Mar 2007 03:50:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org, devel@openvz.org,
       adobriyan@gmail.com
Subject: Re: [PATCH v5] Fix rmmod/read/write races in /proc entries
Message-Id: <20070316035030.92b647d0.akpm@linux-foundation.org>
In-Reply-To: <20070316091613.GA6810@localhost.sw.ru>
References: <20070311170456.GA6808@localhost.sw.ru>
	<20070315175304.55b3486a.akpm@linux-foundation.org>
	<20070316091613.GA6810@localhost.sw.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007 12:16:13 +0300 Alexey Dobriyan <adobriyan@sw.ru> wrote:

> On Thu, Mar 15, 2007 at 05:53:04PM -0800, Andrew Morton wrote:
> > My, what a lot of code you have here.  I note that nobody can be assed even
> > reviewing it.  Now why is that?
> 
> I hope, Al could find some time again.
> 
> > On Sun, 11 Mar 2007 20:04:56 +0300 Alexey Dobriyan <adobriyan@sw.ru> wrote:
> > > Fix following races:
> > > ===========================================
> > > 1. Write via ->write_proc sleeps in copy_from_user(). Module disappears
> > >    meanwhile. Or, more generically, system call done on /proc file, method
> > >    supplied by module is called, module dissapeares meanwhile.
> > >
> > >    pde = create_proc_entry()
> > >    if (!pde)
> > > 	return -ENOMEM;
> > >    pde->write_proc = ...
> > > 				open
> > > 				write
> > > 				copy_from_user
> > >    pde = create_proc_entry();
> > >    if (!pde) {
> > > 	remove_proc_entry();
> > > 	return -ENOMEM;
> > > 	/* module unloaded */
> > >    }
> >
> > We usually fix that race by pinning the module: make whoever registered the
> > proc entries also register their THIS_MODULE, do a try_module_get() on it
> > before we start to play with data structures which the module owns.
> >
> > Can we do that here?
> 
> We can, but it will be unreliable:
> 
> Typical proc entry creation sequence is
> 
> 	pde = create_proc_entry(...);
> 	if (pde)
> 		pde->owner = THIS_MODULE;
> 
> Right after create_proc_entry() ->owner is NULL, so try_module_get()
> won't do anything, but proc_delete_inode() could put module which was
> never getted.
> 
> This should fixable by always setting ->owner before proc entry is
> glued to proc entries tree. Something like this:
> 
> 	#define create_proc_entry(...) __create_proc_entry(..., THIS_MODULE)

Yes, I was thinking of something like that.

> However, I think it's not enough: delete_module(2) first waits for
> refcount becoming zero, only then calls modules's exit function which
> starts removing proc entries. In between, proc entries are accessible
> and fully-functional, so try_module_get() can again get module and
> module_put(pde->owner) can happen AFTER module dissapears.
> What will it put?
> 
> And how can you fix that? The only way I know is to REMOVE ->owner
> completely, once we agree on this pde_users/pde_unload_lock stuff.

I think the rmmod code will take care of that.

Once delete_module() has called try_stop_module(), no following
try_module_get() will succeed.  And see that wait_for_zero_refcount() call
in there which waits for any present users of the module to go away.


