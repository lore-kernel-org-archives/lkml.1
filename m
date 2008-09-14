Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbYINIkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbYINIkj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 04:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYINIka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 04:40:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:5066 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbYINIk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 04:40:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r3RHOrMXpMPG2UMemYowm6wdVDw9KRHp6CVsA1AXE3rIwiVC6poMATwgthHeRmL7xp
         mrQKZRE+W8MOLGiuAgc5D0JpILNlKa1N/E4gWiWyUGGlK19eODDWrs0m7A8S96rO96sW
         EEbMCFUjC2vcV4AXauk8DBoa9sZm7AsQKxLDE=
Date: Sun, 14 Sep 2008 12:42:25 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] Fix "notes" kobject leak
Message-ID: <20080914084225.GA3133@x200.localdomain>
References: <20080830044246.GA26435@x200.localdomain> <20080830054343.GA16899@suse.de> <20080906054522.GA3191@x200.localdomain> <20080912155105.GA3526@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080912155105.GA3526@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 08:51:05AM -0700, Greg KH wrote:
> On Sat, Sep 06, 2008 at 09:45:22AM +0400, Alexey Dobriyan wrote:
> > On Fri, Aug 29, 2008 at 10:43:43PM -0700, Greg KH wrote:
> > > On Sat, Aug 30, 2008 at 08:42:46AM +0400, Alexey Dobriyan wrote:
> > > > 	size-32: 3511 kvasprintf+0x57/0x90
> > > > 	size-64: 3059 kobject_create+0x1c/0x40
> > > > 
> > > > These two buddies increase after every "modprobe; rmmod" sequence.
> > > 
> > > Do they also do so in mainline?
> > 
> > Yep, same bug in mainline.
> 
> Not good.  Does 2.6.26 show this as well?

Uh-oh, this was actually 10-minute exercise.



[PATCH] Fix "notes" kobject leak

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

 kernel/module.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1174,6 +1174,7 @@ static void free_notes_attrs(struct module_notes_attrs *notes_attrs,
 			sysfs_remove_bin_file(notes_attrs->dir,
 					      &notes_attrs->attrs[i]);
 		kobject_del(notes_attrs->dir);
+		kobject_put(notes_attrs->dir);
 	}
 	kfree(notes_attrs);
 }
