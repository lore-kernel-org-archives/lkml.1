Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbYAYXJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbYAYXJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 18:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756495AbYAYXJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 18:09:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53217 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759057AbYAYXJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 18:09:33 -0500
Date: Fri, 25 Jan 2008 15:08:02 -0800
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>, jacob.shin@amd.com
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: threshold_init_device/kobject_uevent_env oops
Message-ID: <20080125230802.GA25074@suse.de>
References: <86802c440801251305u21517078y12ff68ef3015aaae@mail.gmail.com> <20080125221548.GA15172@suse.de> <20080125223556.GB24708@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125223556.GB24708@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 11:35:56PM +0100, Ingo Molnar wrote:
> 
> * Greg KH <gregkh@suse.de> wrote:
> 
> > On Fri, Jan 25, 2008 at 01:05:40PM -0800, Yinghai Lu wrote:
> > > current linus tree + x86.git
> > > 
> > > got
> > > 
> > > Calling initcall 0xffffffff80b93d98: threshold_init_device+0x0/0x3f()
> > > BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
> > > IP: [<ffffffff80458e20>] kobject_uevent_env+0x2a/0x3d9
> > 
> > Does this happen on just Linus's tree?
> > 
> > Can you send me a .config file for this?
> > 
> > What is threshold_init()?  Is it something new in the x86.git tree?
> 
> no. A quick grep shows that it is in a file that _your_ changes in 
> Linus' latest have touched:
> 
>   arch/x86/kernel/cpu/mcheck/mce_amd_64.c

In looking at this code some more, I'm a bit confused.  We have an array
of kobjects in per_cpu(threshold_banks, cpu)[bank]->kobj

Now the kobject in the struct threshold_bank structure is a "static"
one, one that should govern the lifecycle of the object, yet there is no
release function for it at all.  I don't see a way for it to ever be
properly torn down.

But it's the bank kobjects that are dynamic.  They look to be created
properly, and the life cycle is correct because they are initialized by
the kobject core now correctly.  But which order are things initialized
by the cpu code?

Ideally the banks are created before the blocks, but by the error
message that we have here, I'm not so sure about this.  Can anyone
confirm this order is always correct?

Can someone send me the sysfs 'tree' output of what these kobjects are
supposed to be looking like?

Also, can someone enable CONFIG_KOBJECT_DEBUG and send me the output of
the startup of this code?  That should help explain what order things
are happening it.

Actually the debug output with this oops would be great, it should show
the offending logic pretty well.

thanks,

greg k-h
