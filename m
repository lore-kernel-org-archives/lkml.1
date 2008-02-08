Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbYBHXWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbYBHXWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbYBHXWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:22:35 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47656 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbYBHXWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:22:34 -0500
Subject: Re: [-mm PATCH] sysdev_unregister() should call kobject_del()
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Greg KH <greg@kroah.com>, haveblue@us.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080208045533.GA10988@kroah.com>
References: <1202428618.26309.45.camel@dyn9047017100.beaverton.ibm.com>
	 <20080208003825.GB27317@kroah.com>
	 <1202433946.26309.47.camel@dyn9047017100.beaverton.ibm.com>
	 <20080208045533.GA10988@kroah.com>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 15:22:29 -0800
Message-Id: <1202512949.6354.3.camel@badari-laptop.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-07 at 20:55 -0800, Greg KH wrote:
> On Thu, Feb 07, 2008 at 05:25:46PM -0800, Badari Pulavarty wrote:
> > On Thu, 2008-02-07 at 16:38 -0800, Greg KH wrote:
> > > On Thu, Feb 07, 2008 at 03:56:58PM -0800, Badari Pulavarty wrote:
> > > > Hi Greg,
> > > > 
> > > > While playing with hotplug memory remove on 2.6.24-mm1, I 
> > > > noticed that /sysfs directory entries are not getting removed.
> > > > 
> > > > sysdev_unregister() used to call kobject_unregister().
> > > > But in 2.6.24-mm1, its only dropping the ref. It should
> > > > call kobject_del() to remove the object. Correct ?
> > > > 
> > > > With this change, the directories are getting removed
> > > > correctly. Comments ?
> > > 
> > > Ick, no, this shouldn't be needed, someone else must be holding a
> > > reference to the kobject device somewhere.  See the kobject documenation
> > > for more info.
> > > 
> > > I'll try to see where we grab 2 references...
> > 
> > I will take a closer look then. I was taking easy way out :(
> 
> Hm, I don't see anything obvious in the sys.c core.  What code is
> controlling these objects that you are creating and removing from the
> system?
> 

I found the culprit. Its not in sys.c core :)

remove_memory_block() takes a reference on kobject by calling
find_memory_block(). It then calls  unregister_memory() to free up sysfs
entry.
It drops only one ref (which it got at register time). So it never gets
freed up. I am going to send out a separate patch for it.

Thanks for your help.

Thanks,
Badari



