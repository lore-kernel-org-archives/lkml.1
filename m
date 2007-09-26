Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbXIZAmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbXIZAmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 20:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbXIZAmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 20:42:08 -0400
Received: from canuck.infradead.org ([209.217.80.40]:59818 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbXIZAmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 20:42:07 -0400
Date: Tue, 25 Sep 2007 17:36:52 -0700
From: Greg KH <greg@kroah.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: subsystem_unregister() breakage in -mm
Message-ID: <20070926003652.GA26781@kroah.com>
References: <E1IaIs6-00051t-00@dorka.pomaz.szeredi.hu> <20070925225330.GA26235@kroah.com> <E1IaJQL-00053O-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IaJQL-00053O-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 01:02:37AM +0200, Miklos Szeredi wrote:
> > On Wed, Sep 26, 2007 at 12:27:14AM +0200, Miklos Szeredi wrote:
> > > I get "BUG: failure at mm/slab.c:591/page_get_cache()!" in latest -mm
> > > when removing the fuse module.
> > > 
> > > This patch titled "kobject: remove the static array for the name"
> > > looks like it's responsible.  Reverting it cures the problem.
> > > 
> > > The root of the problem seems to be, that decl_subsys() initializes
> > > k_name with a string constant.  Then subsystem_unregister() will put
> > > the kobject, which will free the k_name.
> > > 
> > > So, what's the right way to deal with this?
> > 
> > How is the static kobject created by decl_subsys() getting it's release
> > function called when it is never really "released" as it is a static
> > kobject?
> 
> Don't know.
> 
> This is the stack trace I get:
> 
> BUG: failure at mm/slab.c:591/page_get_cache()!
> Kernel panic - not syncing: BUG!
> 
> EIP: 0023:[<400e7f84>] CPU: 0 Not tainted ESP: 002b:bf77e018 EFLAGS: 00000246
>     Not tainted
> EAX: ffffffda EBX: bf77e040 ECX: 00000880 EDX: bf780884
> ESI: 00000003 EDI: bf77e040 EBP: bf7808d8 DS: 002b ES: 002b
> 08eefd2c:  [<0806ec8c>] show_regs+0x104/0x106
> 08eefd48:  [<0805b96a>] panic_exit+0x2c/0x4b
> 08eefd58:  [<0808fcab>] notifier_call_chain+0x36/0x61
> 08eefd78:  [<0808fd83>] __atomic_notifier_call_chain+0x30/0x32
> 08eefd94:  [<0808fdb4>] atomic_notifier_call_chain+0x2f/0x31
> 08eefdb0:  [<08075cf0>] panic+0x75/0x126
> 08eefdd4:  [<080bc3f5>] kfree+0xb1/0xc6
> 08eefdf8:  [<08137de9>] kobject_cleanup+0x37/0x6a
> 08eefe10:  [<08137e30>] kobject_release+0x14/0x16
> 08eefe1c:  [<08138711>] kref_put+0x30/0xaf
> 08eefe3c:  [<08137e52>] kobject_put+0x20/0x22
> 08eefe4c:  [<08137d8b>] kobject_unregister+0x2e/0x34

Hm, this make sense from an object lifecycle type of thing, and it makes
sense why it is dying.  I think I know how to fix it up, give me a few
hours (dinner time here...)

thanks,

greg k-h
