Return-Path: <linux-kernel-owner+w=401wt.eu-S933991AbYBHFhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933991AbYBHFhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 00:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbYBHFhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 00:37:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52278 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYBHFhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 00:37:39 -0500
Date: Thu, 7 Feb 2008 21:41:58 -0800
From: Greg KH <greg@kroah.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [-mm PATCH] sysdev_unregister() should call kobject_del()
Message-ID: <20080208054158.GA12742@kroah.com>
References: <1202428618.26309.45.camel@dyn9047017100.beaverton.ibm.com> <20080208003825.GB27317@kroah.com> <1202433946.26309.47.camel@dyn9047017100.beaverton.ibm.com> <20080208045533.GA10988@kroah.com> <1202447322.13910.3.camel@badari-laptop.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202447322.13910.3.camel@badari-laptop.beaverton.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 09:08:42PM -0800, Badari Pulavarty wrote:
> 
> On Thu, 2008-02-07 at 20:55 -0800, Greg KH wrote:
> > On Thu, Feb 07, 2008 at 05:25:46PM -0800, Badari Pulavarty wrote:
> > > On Thu, 2008-02-07 at 16:38 -0800, Greg KH wrote:
> > > > On Thu, Feb 07, 2008 at 03:56:58PM -0800, Badari Pulavarty wrote:
> > > > > Hi Greg,
> > > > > 
> > > > > While playing with hotplug memory remove on 2.6.24-mm1, I 
> > > > > noticed that /sysfs directory entries are not getting removed.
> > > > > 
> > > > > sysdev_unregister() used to call kobject_unregister().
> > > > > But in 2.6.24-mm1, its only dropping the ref. It should
> > > > > call kobject_del() to remove the object. Correct ?
> > > > > 
> > > > > With this change, the directories are getting removed
> > > > > correctly. Comments ?
> > > > 
> > > > Ick, no, this shouldn't be needed, someone else must be holding a
> > > > reference to the kobject device somewhere.  See the kobject documenation
> > > > for more info.
> > > > 
> > > > I'll try to see where we grab 2 references...
> > > 
> > > I will take a closer look then. I was taking easy way out :(
> > 
> > Hm, I don't see anything obvious in the sys.c core.  What code is
> > controlling these objects that you are creating and removing from the
> > system?
> 
> add_memory_block()/register_memory() is creating sysfs entries
> for the memory blocks.
> 
> I am trying to make use of remove_memory_block() to clean up
> sysfs entries. BTW, remove_memory_block() is never tested
> before, since we don't support memory remove yet.

So how are you testing the sysdev removal logic then if you can't remove
memory?

Oh, one thing, remove the link in unregister_memory, before you call
sysdev_unregister().  You are trying to get the name of a kobject, and
the whole object, that has just been blown away, not nice...

Which makes me believe your statement about this never being tested
before :)

thanks,

greg k-h
