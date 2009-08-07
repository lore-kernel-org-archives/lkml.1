Return-Path: <linux-kernel-owner+w=401wt.eu-S933949AbZHGVnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949AbZHGVnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 17:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbZHGVnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 17:43:15 -0400
Received: from www84.your-server.de ([213.133.104.84]:49505 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539AbZHGVnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 17:43:14 -0400
Subject: Re: [PATCH] Fix proc_file_write missing ppos update
From: Stefani Seibold <stefani@seibold.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20090807135806.ffd068e9.akpm@linux-foundation.org>
References: <1249676830.27640.16.camel@wall-e>
	 <20090807135806.ffd068e9.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 23:43:07 +0200
Message-Id: <1249681387.17422.10.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 07.08.2009, 13:58 -0700 schrieb Andrew Morton: 
> On Fri, 07 Aug 2009 22:27:10 +0200
> Stefani Seibold <stefani@seibold.net> wrote:
> 
> > The following fix a long standing issue in the proc_file_write function,
> > which doesn't update the ppos file position pointer.
> > 
> > This prevent the usage of multiple sequently writes on an opened proc
> > file, because it is impossible to distinguish these due the offset is
> > always 0.
> > 
> > Signed-off-by: Stefani Seibold <stefani@seibold.net>
> > 
> >  generic.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > --- linux-2.6.31-rc4.orig/fs/proc/generic.c	2009-08-07 22:05:57.000000000 +0200
> > +++ linux-2.6.30-rc4/fs/proc/generic.c	2009-08-07 22:06:22.000000000 +0200
> > @@ -219,9 +219,10 @@
> >  		pde->pde_users++;
> >  		spin_unlock(&pde->pde_unload_lock);
> >  
> > -		/* FIXME: does this routine need ppos?  probably... */
> >  		rv = pde->write_proc(file, buffer, count, pde->data);
> >  		pde_users_dec(pde);
> > +		if (rv > 0)
> > +			*ppos += rv;
> >  	}
> >  	return rv;
> >  }
> 
> Yes, that's odd.
> 
> I worry that there might be procfs write handlers which are looking at
> *ppos and whose behaviour might be altered by this patch.
> 
> <searches a bit>
> 
> Look at arch/s390/appldata/appldata_base.c:appldata_timer_handler().
> 
> static int
> appldata_timer_handler(ctl_table *ctl, int write, struct file *filp,
> 			   void __user *buffer, size_t *lenp, loff_t *ppos)
> {
> 	int len;
> 	char buf[2];
> 
> 	if (!*lenp || *ppos) {
> 		*lenp = 0;
> 		return 0;
> 	}
> 
> 

This function will be handled IMHO by the proc_sys_call_handler which
has nothing to do with the proc_file_write.
/proc/sys/... file access should be not touched because there are
handled differently. 

> Prior to your change, an application which opened that proc file and
> repeatedly wrote to the fd would repeatedly start and stop the timer.
> 
> After your change, the second and successive writes would have no
> effect unless the application was changed to lseek back to the start of
> the "file".
> 
> And that was just the second file I looked at via
> 
> 	$EDITOR $(grep -l '[*]ppos' $(grep -rl _proc_ .))

Yes, i think you are right, i have forseen also that there maybe some
pitfalls. The question is: is there any appplication which will be
broken by this patch?

So what is your suggestion? Should we drop this patch or should we
analyze the users and fix it?

My opinion is to fix it, because it is wrong and it limits the usage of
the proc_write operation. Many embedded developers like me count on proc
support, because it is much simpler to use than the seqfile thing.


