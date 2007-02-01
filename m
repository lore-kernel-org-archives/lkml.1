Return-Path: <linux-kernel-owner+w=401wt.eu-S1751868AbXBAQCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbXBAQCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 11:02:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbXBAQCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 11:02:08 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:44444 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbXBAQCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 11:02:06 -0500
Date: Thu, 1 Feb 2007 19:09:04 +0300
From: Alexey Dobriyan <adobriyan@openvz.org>
To: Duncan Sands <duncan.sands@math.u-psud.fr>
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: Re: remove_proc_entry and read_proc
Message-ID: <20070201160904.GC6023@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Duncan Sands wrote:
> On Wednesday 31 January 2007 19:42:51 Alexey Dobriyan wrote:
> > On Wed, Jan 31, 2007 at 11:54:35AM +0100, Duncan Sands wrote:
> > > Can read_proc still be executing when remove_proc_entry returns?
> > >
> > > In my driver [*] I allocate some data and create a proc entry using
> > > create_proc_entry.  My read method reads from my allocated data.  When
> > > shutting down, I call remove_proc_entry and immediately free the data.
> > > If some call to read_proc is still executing at this point then it will
> > > be accessing freed memory.  Can this happen?  I've been rummaging around
> > > in fs/proc to see what prevents it, but didn't find anything yet.
> >
> > This should be fixed by the following patch (in -mm currently):
> > http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/fix-rmmod-read-write-races-in-proc-entries.patch
> >
> > Tell me if you're unsure it will.
>
> Excellent!  But tell me,
>
> +	atomic_inc(&dp->pde_users);
> +	if (!dp->proc_fops)
>
> don't you need a memory barrier between these two?  Also a corresponding
> one where proc_fops is set to NULL.

I believe, barriers not needed, not now.

This scheme relies on the fact that remove_proc_entry() will be the only
place that will clear ->proc_fops and, once cleared, ->proc_fops will
never be resurrected. Clearing of ->proc_fops will eventually propagate
to CPU doing first check, thus preveting refcount bumps from this CPU.
What can be missed is some "rogue" readers or writers¹. Big deal.

> +		/*
> +		 * Stop accepting new readers/writers. If you're dynamically
> +		 * allocating ->proc_fops, save a pointer somewhere.
> +		 */
> +		de->proc_fops = NULL;
> +		/* Wait until all readers/writers are done. */
> +		if (atomic_read(&de->pde_users) > 0) {
> +			spin_unlock(&proc_subdir_lock);
> +			msleep(1);
> +			goto again;
> +		}
>
> I don't understand how this is supposed to work.  Consider
>
> CPU1					CPU2
>
> atomic_inc(&dp->pde_users);
> if (dp->proc_fops)
> 					de->proc_fops = NULL;
> 	use_proc_fops <= BOOM
> 					if (atomic_read(&de->pde_users) > 0) {
>
> what prevents dereference of a NULL proc_fops value?

¹ Sigh, modules should do removals of proc entries first. And I should check
  for that.

