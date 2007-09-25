Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbXIYEjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbXIYEjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 00:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbXIYEjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 00:39:05 -0400
Received: from ozlabs.org ([203.10.76.45]:44689 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbXIYEjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 00:39:03 -0400
Subject: Re: [PATCH 1/4] module: implement module_inhibit_unload()
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <htejun@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, ebiederm@xmission.com,
       cornelia.huck@de.ibm.com, greg@kroah.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
In-Reply-To: <46F8822D.2010003@gmail.com>
References: <25380.1190671205@lwn.net>  <46F845B2.7030002@gmail.com>
	 <1190677332.27805.229.camel@localhost.localdomain>
	 <46F86727.4050004@gmail.com>
	 <1190686320.27805.258.camel@localhost.localdomain>
	 <46F874DB.5070205@gmail.com>
	 <1190690493.27805.263.camel@localhost.localdomain>
	 <46F8822D.2010003@gmail.com>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 14:38:38 +1000
Message-Id: <1190695118.27805.307.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-25 at 12:36 +0900, Tejun Heo wrote:
> Rusty Russell wrote:
> > As stated you cannot protect arbitrary code this way, as you are trying
> > to do.  I do not think you've broken any of the current code, but I
> > cannot tell.  You're certainly going to surprise unsuspecting future
> > authors.
> 
> Can you elaborate a bit?  Why can't it protect the code?

Because you don't know what that code does.  After all, it's assumed
that module code doesn't get called after exit and you're deliberately
violating that assumption.

> > Can you really not figure out the module owner of the sysfs entry to inc
> > its use count during this procedure?  (__module_get()).
> 
> I can but I don't think it's worth the effort.  It will involve passing
> @owner parameter down through kobject to sysfs but the path is pretty
> obscure and thus difficult to test.

Have you tested that *this* path works?  Let's take your first change as
an example:

+       mutex_lock(&gdev->reg_mutex);
+       __ccwgroup_remove_symlinks(gdev);
+       device_unregister(dev);
+       mutex_unlock(&gdev->reg_mutex);

Now, are you sure that calling cleanup_ccwgroup just after
device_unregister() works?

static void __exit
cleanup_ccwgroup (void)
{
	bus_unregister (&ccwgroup_bus_type);
}

> I think it's too much work for the
> users of the API and it will be easy to pass the wrong @owner and go
> unnoticed.

But your shortcut insists that all module authors be aware that
functions can be running after exit() is called.  That's a recipe for
instability and disaster.

Rusty.

