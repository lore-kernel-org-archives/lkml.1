Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbYICWsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbYICWsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 18:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYICWsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 18:48:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191AbYICWsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 18:48:46 -0400
Date: Wed, 3 Sep 2008 15:48:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nye Liu <nyet@nyet.org>
Cc: linux-kernel@vger.kernel.org, nyet@mrv.com
Subject: Re: [PATCH] INITRAMFS: Add option to preserve mtime from INITRAMFS
 cpio images
Message-Id: <20080903154840.69c049cf.akpm@linux-foundation.org>
In-Reply-To: <20080903224130.GA16630@curtisfong.org>
References: <20080805195232.GA5183@curtisfong.org>
	<20080903202938.GA9065@curtisfong.org>
	<20080903152231.6b82d9bf.akpm@linux-foundation.org>
	<20080903224130.GA16630@curtisfong.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008 15:41:31 -0700
Nye Liu <nyet@nyet.org> wrote:

> > >  	collected[N_ALIGN(name_len) + body_len] = '\0';
> > >  	clean_path(collected, 0);
> > >  	sys_symlink(collected + N_ALIGN(name_len), collected);
> > >  	sys_lchown(collected, uid, gid);
> > > +	do_lutime(collected, &mtime);
> > >  	state = SkipIt;
> > >  	next_state = Reset;
> > >  	return 0;
> > > @@ -466,6 +520,7 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len, int check_only)
> > >  		buf += inptr;
> > >  		len -= inptr;
> > >  	}
> > > +	dir_utime();
> > 
> > Perhaps this is the simplest implementation - I didn't check the fine
> > details.  What's your thinking here?  
> > 
> 
> The main problem is that i need to save off the entire list for later
> processing of the directory mtimes... if i process the directory mtimes
> in the same pass as the file/link mtimes, touching the directory inode
> when creating/modifying the file/links updates the directory mtime, and
> overwrites whatever mtime i set the directory to when i created it.
> 
> The only solution is to do a two pass, which is why the list is
> necessary. If there is a better way, i did not find it :(
> 
> It could be that i misunderstood your question though :)

I'm wondering whether this code need to use `struct utimbuf' at all. 
Or at least, as much as it does.  utimbuf is more a userspace-facing
thing whereas in-kernel timespecs and timevals are more common.

The code as you have it does a fair few conversions into utimbuf format
(both directly and via the existing functions which it calls).  Would
it be simpler if it dealt in terms of timespecs?

