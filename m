Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbYIOXdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbYIOXdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 19:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYIOXdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 19:33:07 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:65154 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYIOXdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 19:33:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NXGIgn3gxCv3pMxFbw4Q8hDpoI2vmNLzacPEaE7hWzTVJmqibV0y0NBNfiG0vL/y8/
         EyA+4fqZw1xkEqTA/3hoKck9vQJgGmKybHl/o2PqTOu6PLTcvZcgHxui+TnSX95dd2zf
         n10uT60P0n94RaixI2Xl7JF0AG2oIc7JboISU=
Date: Tue, 16 Sep 2008 03:35:04 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] Fix "notes" kobject leak
Message-ID: <20080915233504.GB21012@x200.localdomain>
References: <20080830044246.GA26435@x200.localdomain> <20080830054343.GA16899@suse.de> <20080906054522.GA3191@x200.localdomain> <20080912155105.GA3526@suse.de> <20080914084225.GA3133@x200.localdomain> <20080915225322.GA4504@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080915225322.GA4504@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 03:53:22PM -0700, Greg KH wrote:
> On Sun, Sep 14, 2008 at 12:42:25PM +0400, Alexey Dobriyan wrote:
> > On Fri, Sep 12, 2008 at 08:51:05AM -0700, Greg KH wrote:
> > > On Sat, Sep 06, 2008 at 09:45:22AM +0400, Alexey Dobriyan wrote:
> > > > On Fri, Aug 29, 2008 at 10:43:43PM -0700, Greg KH wrote:
> > > > > On Sat, Aug 30, 2008 at 08:42:46AM +0400, Alexey Dobriyan wrote:
> > > > > > 	size-32: 3511 kvasprintf+0x57/0x90
> > > > > > 	size-64: 3059 kobject_create+0x1c/0x40
> > > > > > 
> > > > > > These two buddies increase after every "modprobe; rmmod" sequence.
> > > > > 
> > > > > Do they also do so in mainline?
> > > > 
> > > > Yep, same bug in mainline.
> > > 
> > > Not good.  Does 2.6.26 show this as well?
> > 
> > Uh-oh, this was actually 10-minute exercise.
> > 
> > 
> > 
> > [PATCH] Fix "notes" kobject leak
> > 
> > It happens every rmmod if KALLSYMS=y and SYSFS=y.
> > 
> > 	# modprobe foo
> > 
> > kobject: 'foo' (ffffffffa00743d0): kobject_add_internal: parent: 'module', set: 'module'
> > kobject: 'holders' (ffff88017e7c5770): kobject_add_internal: parent: 'foo', set: '<NULL>'
> > kobject: 'foo' (ffffffffa00743d0): kobject_uevent_env
> > kobject: 'foo' (ffffffffa00743d0): fill_kobj_path: path = '/module/foo'
> > kobject: 'notes' (ffff88017fa9b668): kobject_add_internal: parent: 'foo', set: '<NULL>'
> > 	  ^^^^^
> > 
> > 	# rmmod foo
> > 
> > kobject: 'holders' (ffff88017e7c5770): kobject_cleanup
> > kobject: 'holders' (ffff88017e7c5770): auto cleanup kobject_del
> > kobject: 'holders' (ffff88017e7c5770): calling ktype release
> > kobject: (ffff88017e7c5770): dynamic_kobj_release
> > kobject: 'holders': free name
> > kobject: 'foo' (ffffffffa00743d0): kobject_cleanup
> > kobject: 'foo' (ffffffffa00743d0): does not have a release() function, it is broken and must be fixed.
> > kobject: 'foo' (ffffffffa00743d0): auto cleanup 'remove' event
> > kobject: 'foo' (ffffffffa00743d0): kobject_uevent_env
> > kobject: 'foo' (ffffffffa00743d0): fill_kobj_path: path = '/module/foo'
> > kobject: 'foo' (ffffffffa00743d0): auto cleanup kobject_del
> > kobject: 'foo': free name
> > 
> > 	[whooops]
> > 
> > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> > ---
> > 
> >  kernel/module.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -1174,6 +1174,7 @@ static void free_notes_attrs(struct module_notes_attrs *notes_attrs,
> >  			sysfs_remove_bin_file(notes_attrs->dir,
> >  					      &notes_attrs->attrs[i]);
> >  		kobject_del(notes_attrs->dir);
> > +		kobject_put(notes_attrs->dir);
> 
> Hm, no, that should just be a call to kobject_put() instead of
> kobject_del(), can you try that instead and see if that solves the issue
> (am at a conference and can't test that at the moment, sorry.)

Why?! kobject_del() puts parent kobject.
