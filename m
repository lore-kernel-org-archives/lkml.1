Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbZBXHBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbZBXHBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 02:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbZBXHBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 02:01:12 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:41389 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbZBXHBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 02:01:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RPLnRZ5Bxd7ajRzeQ5UlipyGfkjTdcX7RIhbEErIz13TnZJ3zlfJmRUJbqx/cF81Us
         GpOXI2+FJTnKkHkTG/Hx7eqjW1wpSNSv5cUSdBvTXyv+K33SmKsCRoavliayJyjdul5N
         t2Yo0yMZKA8bb3FwMZQBYyaKBKmjpYsBJMjlM=
Date: Tue, 24 Feb 2009 10:07:45 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Krzysztof Sachanowicz <analyzer1@gmail.com>, linux-kernel@vger.kernel.org,
       marcin.pilipczuk@gmail.com, torvalds@linux-foundation.org
Subject: Re: [PATCH] proc: proc_get_inode should de_put when inode already
	initialized
Message-ID: <20090224070745.GB5162@x200.localdomain>
References: <200902232221.55714.analyzer1@gmail.com> <20090223152555.a499b76a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223152555.a499b76a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 03:25:55PM -0800, Andrew Morton wrote:
> On Mon, 23 Feb 2009 22:21:55 +0100
> Krzysztof Sachanowicz <analyzer1@gmail.com> wrote:
> 
> > de_get is called before every proc_get_inode, but corresponding de_put is 
> > called only when dropping last reference to an inode. This might cause 
> > something like
> > remove_proc_entry: /proc/stats busy, count=14496
> > to be printed to the syslog.
> > 
> > The fix is to call de_put in case of an already initialized inode in 
> > proc_get_inode.
> > 
> > Signed-off-by: Krzysztof Sachanowicz <analyzer1@gmail.com>
> > Tested-by: Marcin Pilipczuk <marcin.pilipczuk@gmail.com>
> > ---
> > --- linux-2.6.29-rc6.orig/fs/proc/inode.c	2009-02-23 20:43:32.000000000 +0100
> > +++ linux-2.6.29-rc6/fs/proc/inode.c	2009-02-23 20:46:37.000000000 +0100
> > @@ -485,8 +485,10 @@ struct inode *proc_get_inode(struct supe
> >  			}
> >  		}
> >  		unlock_new_inode(inode);
> > -	} else
> > +	} else {
> >  	       module_put(de->owner);
> > +	       de_put(de);
> > +	}
> >  	return inode;
> >  
> >  out_ino:
> 
> This code area looks quite different in linux-next, although the
> changes there are removing proc_dir_entry.owner altogether and aren't
> obviously targetted at fixing this bug.

->owner issue is independent of this leak, I'll rebase/edit patches as
needed.

> Also...
> 
> It's unpleasing to have the de_get() inside the caller and the de_put()
> inside the callee - it is better to have them both happening at the
> same level.  If it is the case that "de_get is called before every
> proc_get_inode", then perhaps that operation should simply be moved
> into proc_get_inode().

Well, yes, this sucks. But unlock_new_inode() will clear I_NEW state,
so after function returns, there is no way to distinguish.
