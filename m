Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbYIWTtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbYIWTtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 15:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYIWTtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 15:49:01 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:22935 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbYIWTtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 15:49:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bshzE6fLO3kjC/Bsi9HP6kauu46g7hslu9t1v2dh5gbpzHd2GF9MHesg5ul5gkkDB5
         hoaiAFD+m0vxoJk3aQnGbrIiFAtN3N2Li6O+NU4xgNIUYFqJTIFHg4EcF1LoJIHiy5h5
         8klcaAagRn1sus6CNVKWI0qYpuUstBSzKv9N4=
Date: Tue, 23 Sep 2008 23:51:11 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH v2] Fix "notes" kobject leak
Message-ID: <20080923195111.GA22247@x200.localdomain>
References: <20080830044246.GA26435@x200.localdomain> <20080830054343.GA16899@suse.de> <20080906054522.GA3191@x200.localdomain> <20080912155105.GA3526@suse.de> <20080914084225.GA3133@x200.localdomain> <20080915225322.GA4504@suse.de> <20080915233504.GB21012@x200.localdomain> <20080915234050.GA10876@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080915234050.GA10876@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > --- a/kernel/module.c
> > > > +++ b/kernel/module.c
> > > > @@ -1174,6 +1174,7 @@ static void free_notes_attrs(struct module_notes_attrs *notes_attrs,
> > > >  			sysfs_remove_bin_file(notes_attrs->dir,
> > > >  					      &notes_attrs->attrs[i]);
> > > >  		kobject_del(notes_attrs->dir);
> > > > +		kobject_put(notes_attrs->dir);
> > > 
> > > Hm, no, that should just be a call to kobject_put() instead of
> > > kobject_del(), can you try that instead and see if that solves the issue
> > > (am at a conference and can't test that at the moment, sorry.)
> > 
> > Why?! kobject_del() puts parent kobject.
> 
> And that's about it (well, it also tears down the sysfs stuff.)
> 
> If you call kobject_put() instead, and it's the last put, it will also
> call kobject_del() and do everything else that it needs to do.
> 
> Try it and let me know if I'm right or not :)

OK, this works too.


[PATCH v2] Fix "notes" kobject leak

It happens every rmmod if KALLSYMS=y and SYSFS=y.

	# modprobe foo

kobject: 'foo' (ffffffffa00743d0): kobject_add_internal: parent: 'module', set: 'module'
kobject: 'holders' (ffff88017e7c5770): kobject_add_internal: parent: 'foo', set: '<NULL>'
kobject: 'foo' (ffffffffa00743d0): kobject_uevent_env
kobject: 'foo' (ffffffffa00743d0): fill_kobj_path: path = '/module/foo'
kobject: 'notes' (ffff88017fa9b668): kobject_add_internal: parent: 'foo', set: '<NULL>'
	  ^^^^^

	# rmmod foo

kobject: 'holders' (ffff88017e7c5770): kobject_cleanup
kobject: 'holders' (ffff88017e7c5770): auto cleanup kobject_del
kobject: 'holders' (ffff88017e7c5770): calling ktype release
kobject: (ffff88017e7c5770): dynamic_kobj_release
kobject: 'holders': free name
kobject: 'foo' (ffffffffa00743d0): kobject_cleanup
kobject: 'foo' (ffffffffa00743d0): does not have a release() function, it is broken and must be fixed.
kobject: 'foo' (ffffffffa00743d0): auto cleanup 'remove' event
kobject: 'foo' (ffffffffa00743d0): kobject_uevent_env
kobject: 'foo' (ffffffffa00743d0): fill_kobj_path: path = '/module/foo'
kobject: 'foo' (ffffffffa00743d0): auto cleanup kobject_del
kobject: 'foo': free name

	[whooops]

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 kernel/module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1173,7 +1173,7 @@ static void free_notes_attrs(struct module_notes_attrs *notes_attrs,
 		while (i-- > 0)
 			sysfs_remove_bin_file(notes_attrs->dir,
 					      &notes_attrs->attrs[i]);
-		kobject_del(notes_attrs->dir);
+		kobject_put(notes_attrs->dir);
 	}
 	kfree(notes_attrs);
 }
