Return-Path: <linux-kernel-owner+w=401wt.eu-S1752044AbXA2RiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbXA2RiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 12:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbXA2RiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 12:38:00 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45892 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbXA2RiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 12:38:00 -0500
Date: Mon, 29 Jan 2007 09:37:51 -0800
From: Andrew Morton <akpm@osdl.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, dmonakhov@openvz.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: + mm-search_binary_handler-mem-limit-fix.patch added to -mm
 tree
Message-Id: <20070129093751.a1637a68.akpm@osdl.org>
In-Reply-To: <20070129135958.GB9941@osiris.boeblingen.de.ibm.com>
References: <200701240909.l0O99IwK013495@shell0.pdx.osdl.net>
	<20070129113328.GA9941@osiris.boeblingen.de.ibm.com>
	<20070129135958.GB9941@osiris.boeblingen.de.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007 14:59:58 +0100
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Mon, Jan 29, 2007 at 12:33:28PM +0100, Heiko Carstens wrote:
> > On Wed, Jan 24, 2007 at 01:09:18AM -0800, akpm@osdl.org wrote:
> > >      mm-search_binary_handler-mem-limit-fix.patch
> > > From: Dmitriy Monakhov <dmonakhov@openvz.org>
> > > 
> > > The function changes mem limit to USER_DS before possible modprobe, but
> > > never restored it again.
> > > 
> > > Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
> > > Signed-off-by: Andrew Morton <akpm@osdl.org>
> > >  fs/exec.c |   10 +++++++---
> > >  1 file changed, 7 insertions(+), 3 deletions(-)
> > > 
> > > diff -puN fs/exec.c~mm-search_binary_handler-mem-limit-fix fs/exec.c
> > > --- a/fs/exec.c~mm-search_binary_handler-mem-limit-fix
> > > +++ a/fs/exec.c
> > > @@ -1018,6 +1018,7 @@ int search_binary_handler(struct linux_b
> > >  {
> > >  	int try,retval;
> > >  	struct linux_binfmt *fmt;
> > > +	mm_segment_t oldfs;
> > >  #ifdef __alpha__
> > >  	/* handle /sbin/loader.. */
> > >  	{
> > > @@ -1059,11 +1060,12 @@ int search_binary_handler(struct linux_b
> > > 
> > >  	/* kernel module loader fixup */
> > >  	/* so we don't try to load run modprobe in kernel space. */
> > > +	oldfs = get_fs();
> > >  	set_fs(USER_DS);
> > > 
> > >  	retval = audit_bprm(bprm);
> > >  	if (retval)
> > > -		return retval;
> > > +		goto out;
> > > 
> > >  	retval = -ENOENT;
> > >  	for (try=0; try<2; try++) {
> > > @@ -1084,7 +1086,7 @@ int search_binary_handler(struct linux_b
> > >  				bprm->file = NULL;
> > >  				current->did_exec = 1;
> > >  				proc_exec_connector(current);
> > > -				return retval;
> > > +				goto out;
> > >  			}
> > >  			read_lock(&binfmt_lock);
> > >  			put_binfmt(fmt);
> > > @@ -1092,7 +1094,7 @@ int search_binary_handler(struct linux_b
> > >  				break;
> > >  			if (!bprm->file) {
> > >  				read_unlock(&binfmt_lock);
> > > -				return retval;
> > > +				goto out;
> > >  			}
> > >  		}
> > >  		read_unlock(&binfmt_lock);
> > > @@ -1110,6 +1112,8 @@ int search_binary_handler(struct linux_b
> > >  #endif
> > >  		}
> > >  	}
> > > +out:
> > > +	set_fs(oldfs);
> > >  	return retval;
> > >  }
> 
> This is broken. This is the only place in kernel that sets fs to USER_DS
> for a new process. With this patch we could as well get rid of USER_DS and
> all the address space checkings.
> Besides that it breaks architectures with distinct physical address spaces.

hm, thanks for testing - I'll drop it.

I don't really understand what's wrong with it though.  Maybe it's settng
USER_DS on kernel threads?

