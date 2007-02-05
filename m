Return-Path: <linux-kernel-owner+w=401wt.eu-S1752289AbXBELc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbXBELc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 06:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbXBELc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 06:32:27 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:47982 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbXBELc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 06:32:26 -0500
Date: Mon, 5 Feb 2007 14:39:32 +0300
From: Alexey Dobriyan <adobriyan@openvz.org>
To: Duncan Sands <duncan.sands@math.u-psud.fr>
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: Re: remove_proc_entry and read_proc
Message-ID: <20070205113932.GA5968@localhost.sw.ru>
References: <20070201160904.GC6023@localhost.sw.ru> <200702020831.58229.duncan.sands@math.u-psud.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200702020831.58229.duncan.sands@math.u-psud.fr>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 08:31:57AM +0100, Duncan Sands wrote:
> > I believe, barriers not needed, not now.

> > This scheme relies on the fact that remove_proc_entry() will be the only
> > place that will clear ->proc_fops and, once cleared, ->proc_fops will
> > never be resurrected. Clearing of ->proc_fops will eventually propagate
> > to CPU doing first check, thus preveting refcount bumps from this CPU.
> > What can be missed is some "rogue" readers or writers¹. Big deal.
>
> I don't understand you.  Without memory barriers, remove_proc_entry will
> most of the time, but not all of the time, wait for all readers and writers
> to finish before exiting.  Since the whole point of your patch was to ensure
> that all readers and writers finish before remove_proc_entry exits, I don't
> understand why you don't just put the memory barriers in and make it correct.

Gee, thanks. I sat and wrote code side-by-side, and it looks like, even barriers
won't fix anything, because they don't affect other CPUs. There will be
new patch soon.

	->proc_fops is valid			->proc_fops is valid
	->pde_users is 0			->pde_users is 0
	------------------------------------------------------------


						if (!pde->proc_fops)
							goto out;

	->proc_fops = NULL;
	if (atomic_read(->pde_users) > 0)
		goto again;

		|
		|				atomic_inc(->pde_users);
		|
		|
		|
		V

> Also, I do consider it a big deal:
>
> > ¹ Sigh, modules should do removals of proc entries first. And I should
> > check for that.
>
> Modules should of course call remove_proc_entry before exiting.  However
> right now, even with your patch, a read or write method can still be
> running when remove_proc_entry returns [1], so could still be running when
> the module is removed (if they sleep; I guess this applies mostly to
> write methods).  This is very bad - why not put in memory barriers and
> fix it?  Also, plenty of proc read and write methods access private data
> that is allocated before calling create_proc_entry and freed after calling
> remove_proc_entry.  If a read or write method is still running after
> remove_proc_entry returns, then it can access freed memory - very bad.

> [1] proc_get_inode does a try_module_get, so it is possible that module
> unloading is not a problem - not sure.

Modules forget to set ->owner sometimes. Also, it's still racy, because
of the typical

	pde = create_proc_entry();
	/*
	 *
	 * ->owner is NULL here, effectively, PDE without ->owner.
	 *
	 */
	if (pde)
		pde->owner = THIS_MODULE;

