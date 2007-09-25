Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260AbXIYXDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbXIYXDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbXIYXCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:02:53 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:58716 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbXIYXCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:02:52 -0400
To: greg@kroah.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <20070925225330.GA26235@kroah.com> (message from Greg KH on Tue,
	25 Sep 2007 15:53:30 -0700)
Subject: Re: subsystem_unregister() breakage in -mm
References: <E1IaIs6-00051t-00@dorka.pomaz.szeredi.hu> <20070925225330.GA26235@kroah.com>
Message-Id: <E1IaJQL-00053O-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 26 Sep 2007 01:02:37 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Sep 26, 2007 at 12:27:14AM +0200, Miklos Szeredi wrote:
> > I get "BUG: failure at mm/slab.c:591/page_get_cache()!" in latest -mm
> > when removing the fuse module.
> > 
> > This patch titled "kobject: remove the static array for the name"
> > looks like it's responsible.  Reverting it cures the problem.
> > 
> > The root of the problem seems to be, that decl_subsys() initializes
> > k_name with a string constant.  Then subsystem_unregister() will put
> > the kobject, which will free the k_name.
> > 
> > So, what's the right way to deal with this?
> 
> How is the static kobject created by decl_subsys() getting it's release
> function called when it is never really "released" as it is a static
> kobject?

Don't know.

This is the stack trace I get:

BUG: failure at mm/slab.c:591/page_get_cache()!
Kernel panic - not syncing: BUG!

EIP: 0023:[<400e7f84>] CPU: 0 Not tainted ESP: 002b:bf77e018 EFLAGS: 00000246
    Not tainted
EAX: ffffffda EBX: bf77e040 ECX: 00000880 EDX: bf780884
ESI: 00000003 EDI: bf77e040 EBP: bf7808d8 DS: 002b ES: 002b
08eefd2c:  [<0806ec8c>] show_regs+0x104/0x106
08eefd48:  [<0805b96a>] panic_exit+0x2c/0x4b
08eefd58:  [<0808fcab>] notifier_call_chain+0x36/0x61
08eefd78:  [<0808fd83>] __atomic_notifier_call_chain+0x30/0x32
08eefd94:  [<0808fdb4>] atomic_notifier_call_chain+0x2f/0x31
08eefdb0:  [<08075cf0>] panic+0x75/0x126
08eefdd4:  [<080bc3f5>] kfree+0xb1/0xc6
08eefdf8:  [<08137de9>] kobject_cleanup+0x37/0x6a
08eefe10:  [<08137e30>] kobject_release+0x14/0x16
08eefe1c:  [<08138711>] kref_put+0x30/0xaf
08eefe3c:  [<08137e52>] kobject_put+0x20/0x22
08eefe4c:  [<08137d8b>] kobject_unregister+0x2e/0x34
08eefe60:  [<08137fc9>] kset_unregister+0x18/0x1a
08eefe6c:  [<08138066>] subsystem_unregister+0x11/0x13
08eefe78:  [<0a88579f>] fuse_sysfs_cleanup+0x1e/0x47 [fuse]
08eefe84:  [<0a885d6c>] fuse_exit+0x1c/0x2c [fuse]
08eefe90:  [<080986ba>] sys_delete_module+0x17f/0x21e
08eefef4:  [<0805bd71>] handle_syscall+0x8d/0xac
08eeff48:  [<0806adc2>] handle_trap+0x27/0x135
08eeff70:  [<0806b5a2>] userspace+0x2cb/0x31b
08eeffe4:  [<08058ec2>] fork_handler+0x76/0x88
08eefffc:  [<00000000>] _sinittext+0xf7fb7000/0x14
