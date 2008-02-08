Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbYBIAA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbYBIAA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 19:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755228AbYBIAAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 19:00:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59253 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbYBIAAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 19:00:49 -0500
Date: Fri, 8 Feb 2008 15:57:56 -0800
From: Greg KH <greg@kroah.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: haveblue@us.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [-mm PATCH] sysdev_unregister() should call kobject_del()
Message-ID: <20080208235756.GA7876@kroah.com>
References: <1202428618.26309.45.camel@dyn9047017100.beaverton.ibm.com> <20080208003825.GB27317@kroah.com> <1202433946.26309.47.camel@dyn9047017100.beaverton.ibm.com> <20080208045533.GA10988@kroah.com> <1202512949.6354.3.camel@badari-laptop.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202512949.6354.3.camel@badari-laptop.beaverton.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 03:22:29PM -0800, Badari Pulavarty wrote:
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
> > 
> 
> I found the culprit. Its not in sys.c core :)

Glad to hear it :)

> remove_memory_block() takes a reference on kobject by calling
> find_memory_block(). It then calls  unregister_memory() to free up sysfs
> entry.
> It drops only one ref (which it got at register time). So it never gets
> freed up. I am going to send out a separate patch for it.

Ah, nice catch.

thanks,

greg k-h
