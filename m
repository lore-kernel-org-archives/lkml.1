Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbZBWX4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbZBWX4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 18:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbZBWX4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 18:56:34 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:44256 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbZBWX4d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 18:56:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=rzHihZpLDx4fUEhC733FEJMLWXJbkb6HvrtvZQ0/Hu3B/QIkRTzdgmnHZ7heaWtn9B
         rdiFyR2dn6n22TBFjKmfdRcD9GkeKAwparXPTMRPIb3ROMk0jLd3gCZHmAYPWnykfmWL
         gOOoeJVK0beeYSDGUiayYkcd+F9sqvD2PnG9w=
From: Krzysztof Sachanowicz <analyzer1@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] proc: proc_get_inode should de_put when inode already initialized
Date: Tue, 24 Feb 2009 00:56:25 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, marcin.pilipczuk@gmail.com,
       torvalds@linux-foundation.org, Alexey Dobriyan <adobriyan@gmail.com>
References: <200902232221.55714.analyzer1@gmail.com> <20090223152555.a499b76a.akpm@linux-foundation.org>
In-Reply-To: <20090223152555.a499b76a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902240056.26462.analyzer1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tuesday 24 February 2009 00:25:55 Andrew Morton napisa³(a):
> On Mon, 23 Feb 2009 22:21:55 +0100
>
> Krzysztof Sachanowicz <analyzer1@gmail.com> wrote:
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
> > --- linux-2.6.29-rc6.orig/fs/proc/inode.c	2009-02-23 20:43:32.000000000
> > +0100 +++ linux-2.6.29-rc6/fs/proc/inode.c	2009-02-23 20:46:37.000000000
> > +0100 @@ -485,8 +485,10 @@ struct inode *proc_get_inode(struct supe
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
>
> Also...
>
> It's unpleasing to have the de_get() inside the caller and the de_put()
> inside the callee - it is better to have them both happening at the
> same level.  If it is the case that "de_get is called before every
> proc_get_inode", then perhaps that operation should simply be moved
> into proc_get_inode().

Yes, but unfortunately in proc_lookup_de() (fs/proc/generic.c) we have:
 391                        de_get(de);
 392                        spin_unlock(&proc_subdir_lock);
 393                        error = -EINVAL;
 394                        inode = proc_get_inode(dir->i_sb, ino, de);

So if we move de_get() into proc_get_inode(), we will also have to move 
spin_unlock there. Then we will have spin_lock in proc_lookup_de but 
spin_unlock in proc_get_inode...

Maybe my solution is not that bad, because usually de_put is called from 
proc_delete_inode(). Only if iget_locked() returns an already initialized 
inode we want de_put to be called in proc_get_inode. So the callee need not 
care about who will eventually call de_put.
