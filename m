Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbXKVIto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbXKVIto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 03:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbXKVItg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 03:49:36 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:3461 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbXKVItf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 03:49:35 -0500
Date: Thu, 22 Nov 2007 11:49:23 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] proc: use BUG_ON() in de_put()
Message-ID: <20071122084923.GA6240@localhost.sw.ru>
References: <20071115161249.GE6216@localhost.sw.ru> <20071116134642.2dda1600.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071116134642.2dda1600.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 01:46:42PM -0800, Andrew Morton wrote:
> On Thu, 15 Nov 2007 19:12:49 +0300
> Alexey Dobriyan <adobriyan@sw.ru> wrote:
> 
> > It's much more visible that some printk. I still has an unexplained oops
> > in proc, so let's leave it for a while.

> > --- a/fs/proc/inode.c
> > +++ b/fs/proc/inode.c
> > @@ -37,12 +37,7 @@ void de_put(struct proc_dir_entry *de)
> >  {
> >  	if (de) {	
> >  		lock_kernel();		
> > -		if (!atomic_read(&de->count)) {
> > -			printk("de_put: entry %s already free!\n", de->name);
> > -			unlock_kernel();
> > -			return;
> > -		}
> > -
> > +		BUG_ON(atomic_read(&de->count) == 0);
> >  		if (atomic_dec_and_test(&de->count)) {
> >  			if (de->deleted) {
> >  				printk("de_put: deferred delete of %s\n",
> 
> I don't see that an error in here _requires_ that we nuke the machine. 
> Surely we can emit a warning and then recover in some fashion?

Hmm... atomic_dec_and_test() in -mm already has diagnostics¹ when doing
0 => -1 transition, google says this check triggered only once. I think
we should just drop it.

¹ i386 only :^)

