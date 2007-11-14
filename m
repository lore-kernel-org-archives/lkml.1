Return-Path: <linux-kernel-owner+w=401wt.eu-S1761791AbXKNSUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761791AbXKNSUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbXKNSUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:20:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44764 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbXKNSUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:20:10 -0500
Date: Wed, 14 Nov 2007 10:19:48 -0800
From: Greg KH <greg@kroah.com>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2-mm1
Message-ID: <20071114181948.GA15240@kroah.com>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org> <Pine.LNX.4.64.0711141728290.15844@twin.jikos.cz> <20071114083906.178232cb.akpm@linux-foundation.org> <Pine.LNX.4.64.0711141740110.15844@twin.jikos.cz> <Pine.LNX.4.64.0711141758570.15844@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711141758570.15844@twin.jikos.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 06:02:07PM +0100, Jiri Kosina wrote:
> On Wed, 14 Nov 2007, Jiri Kosina wrote:
> 
> > > I'd suspect the driver tree.  I think I'll need to do a quick -mm2 
> > > without that tree present.
> > I am just verifying whether reverting kset changes fixes this, will let 
> > you know soon.
> 
> OK, so I reverted 
> gregkh-driver-kset-convert-block_subsys-to-use-kset_create (which made me 
> also revert gregkh-driver-kobject-remove-subsystem_register-functions and 
> gregkh-driver-kset-remove-decl_subsys-macro so that we compile). Both the 
> error message from lockdep and more importantly the spinlock lockup have 
> gone, and the system with these patches reverted boots for me fine.
> 
> Well not that fine, I still see (which is the same backtrace that caused 
> the lockup with plain -rc2-mm1, but doesn't make the machine hang):
> 
> floppy0: Floppy io-port 0x03f2 in use
> WARNING: at lib/kref.c:33 kref_get()
> 
> Call Trace:
>  [<ffffffff8035bd43>] kobject_add+0x9b/0x197
>  [<ffffffff8035c6e1>] kref_get+0x2f/0x36
>  [<ffffffff8035b82f>] kobject_get+0x12/0x17
>  [<ffffffff8035bd55>] kobject_add+0xad/0x197
>  [<ffffffff802c9a36>] register_disk+0x48/0x205
>  [<ffffffff80355cf3>] add_disk+0x34/0x3d
>  [<ffffffff8083cd99>] rd_init+0x172/0x1e1
>  [<ffffffff8082063a>] kernel_init+0x175/0x2e6
>  [<ffffffff8025193c>] trace_hardirqs_on+0x115/0x139
>  [<ffffffff80598769>] trace_hardirqs_on_thunk+0x35/0x3a
>  [<ffffffff8025193c>] trace_hardirqs_on+0x115/0x139
>  [<ffffffff8020c628>] child_rip+0xa/0x12
>  [<ffffffff8020bd3f>] restore_args+0x0/0x30
>  [<ffffffff808204c5>] kernel_init+0x0/0x2e6
>  [<ffffffff8020c61e>] child_rip+0x0/0x12

someone is trying to call kref_get on a kobject that has not been
initialized yet, which could be the reason the newer patches break
something, as the pointers are not set up properly with a call to
kobject_init() first.

But, alloc_disk() should have been called on this gendisk for it to work
properly at all, unless something is trashing that structure?

I'm way confused...

greg k-h
