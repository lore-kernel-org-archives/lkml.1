Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbYIOWzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbYIOWzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 18:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYIOWzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 18:55:08 -0400
Received: from mail.suse.de ([195.135.220.2]:34203 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbYIOWzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 18:55:07 -0400
Date: Mon, 15 Sep 2008 15:53:22 -0700
From: Greg KH <gregkh@suse.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] Fix "notes" kobject leak
Message-ID: <20080915225322.GA4504@suse.de>
References: <20080830044246.GA26435@x200.localdomain> <20080830054343.GA16899@suse.de> <20080906054522.GA3191@x200.localdomain> <20080912155105.GA3526@suse.de> <20080914084225.GA3133@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080914084225.GA3133@x200.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2008 at 12:42:25PM +0400, Alexey Dobriyan wrote:
> On Fri, Sep 12, 2008 at 08:51:05AM -0700, Greg KH wrote:
> > On Sat, Sep 06, 2008 at 09:45:22AM +0400, Alexey Dobriyan wrote:
> > > On Fri, Aug 29, 2008 at 10:43:43PM -0700, Greg KH wrote:
> > > > On Sat, Aug 30, 2008 at 08:42:46AM +0400, Alexey Dobriyan wrote:
> > > > > 	size-32: 3511 kvasprintf+0x57/0x90
> > > > > 	size-64: 3059 kobject_create+0x1c/0x40
> > > > > 
> > > > > These two buddies increase after every "modprobe; rmmod" sequence.
> > > > 
> > > > Do they also do so in mainline?
> > > 
> > > Yep, same bug in mainline.
> > 
> > Not good.  Does 2.6.26 show this as well?
> 
> Uh-oh, this was actually 10-minute exercise.
> 
> 
> 
> [PATCH] Fix "notes" kobject leak
> 
> It happens every rmmod if KALLSYMS=y and SYSFS=y.
> 
> 	# modprobe foo
> 
> kobject: 'foo' (ffffffffa00743d0): kobject_add_internal: parent: 'module', set: 'module'
> kobject: 'holders' (ffff88017e7c5770): kobject_add_internal: parent: 'foo', set: '<NULL>'
> kobject: 'foo' (ffffffffa00743d0): kobject_uevent_env
> kobject: 'foo' (ffffffffa00743d0): fill_kobj_path: path = '/module/foo'
> kobject: 'notes' (ffff88017fa9b668): kobject_add_internal: parent: 'foo', set: '<NULL>'
> 	  ^^^^^
> 
> 	# rmmod foo
> 
> kobject: 'holders' (ffff88017e7c5770): kobject_cleanup
> kobject: 'holders' (ffff88017e7c5770): auto cleanup kobject_del
> kobject: 'holders' (ffff88017e7c5770): calling ktype release
> kobject: (ffff88017e7c5770): dynamic_kobj_release
> kobject: 'holders': free name
> kobject: 'foo' (ffffffffa00743d0): kobject_cleanup
> kobject: 'foo' (ffffffffa00743d0): does not have a release() function, it is broken and must be fixed.
> kobject: 'foo' (ffffffffa00743d0): auto cleanup 'remove' event
> kobject: 'foo' (ffffffffa00743d0): kobject_uevent_env
> kobject: 'foo' (ffffffffa00743d0): fill_kobj_path: path = '/module/foo'
> kobject: 'foo' (ffffffffa00743d0): auto cleanup kobject_del
> kobject: 'foo': free name
> 
> 	[whooops]
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  kernel/module.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1174,6 +1174,7 @@ static void free_notes_attrs(struct module_notes_attrs *notes_attrs,
>  			sysfs_remove_bin_file(notes_attrs->dir,
>  					      &notes_attrs->attrs[i]);
>  		kobject_del(notes_attrs->dir);
> +		kobject_put(notes_attrs->dir);

Hm, no, that should just be a call to kobject_put() instead of
kobject_del(), can you try that instead and see if that solves the issue
(am at a conference and can't test that at the moment, sorry.)

thanks,

greg k-h
