Return-Path: <linux-kernel-owner+w=401wt.eu-S933945AbXGUBpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945AbXGUBpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 21:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbXGUBpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 21:45:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51772 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbXGUBpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 21:45:01 -0400
Date: Fri, 20 Jul 2007 18:44:19 -0700
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>, rdunlap@xenotime.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [broken-out-2007-07-20-00-22] kernel bug at kernel/params:570
Message-ID: <20070721014419.GA10761@suse.de>
References: <6bffcb0e0707200932p2b905e21g7970172ca7eb4da7@mail.gmail.com> <20070720225047.GA17520@suse.de> <20070720155912.079c5a27.akpm@linux-foundation.org> <20070720231052.GA19752@suse.de> <a781481a0707201643l17ea92fajfbc256a7a16a802f@mail.gmail.com> <a781481a0707201703h6318fe65td4c5c6f57bb7eb24@mail.gmail.com> <6bffcb0e0707201728u6deeccd1j453ff89d0767dccc@mail.gmail.com> <20070721010257.GA9561@suse.de> <20070720183733.c53b511b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720183733.c53b511b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 06:37:33PM -0700, Andrew Morton wrote:
> On Fri, 20 Jul 2007 18:02:57 -0700 Greg KH <gregkh@suse.de> wrote:
> 
> > --- a/kernel/params.c
> > +++ b/kernel/params.c
> > @@ -567,7 +567,11 @@ static void __init kernel_param_sysfs_se
> >  	kobject_set_name(&mk->kobj, name);
> >  	kobject_init(&mk->kobj);
> >  	ret = kobject_add(&mk->kobj);
> > -	BUG_ON(ret < 0);
> > +	if (ret) {
> > +		printk(KERN_ERR "module '%s' failed to be added to sysfs, "
> > +			"the system will be unstable now.\n", name);
> > +		return;
> > +	}
> 
> It would be nice to print the value of `ret' too.

Ok, how about this version:

---
 kernel/params.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/params.c
+++ b/kernel/params.c
@@ -567,7 +567,12 @@ static void __init kernel_param_sysfs_se
 	kobject_set_name(&mk->kobj, name);
 	kobject_init(&mk->kobj);
 	ret = kobject_add(&mk->kobj);
-	BUG_ON(ret < 0);
+	if (ret) {
+		printk(KERN_ERR "Module '%s' failed to be added to sysfs, "
+		      "error number %d\n", name, ret);
+		printk(KERN_ERR	"The system will be unstable now.\n");
+		return;
+	}
 	param_sysfs_setup(mk, kparam, num_params, name_skip);
 	kobject_uevent(&mk->kobj, KOBJ_ADD);
 }
