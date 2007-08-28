Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbXH1Eks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbXH1Eks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 00:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbXH1Ekg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 00:40:36 -0400
Received: from alnrmhc13.comcast.net ([204.127.225.93]:49966 "EHLO
	alnrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbXH1Ekf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 00:40:35 -0400
From: "Michael J. Evans" <mjevans1983@comcast.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [patch v3 1/1] md: Software Raid autodetect dev list not array
Date: Mon, 27 Aug 2007 21:38:19 -0700
User-Agent: KMail/1.9.7
Cc: "Michael Evans" <mjevans1983@gmail.com>, "Neil Brown" <neilb@suse.de>,
       "Ingo Molnar" <mingo@redhat.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200708222058.45480.mjevans1983@comcast.net> <200708271516.21889.mjevans1983@comcast.net> <20070827153020.43788e21.randy.dunlap@oracle.com>
In-Reply-To: <20070827153020.43788e21.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708272138.19785.mjevans1983@comcast.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 August 2007, Randy Dunlap wrote:
> On Mon, 27 Aug 2007 15:16:21 -0700 Michael J. Evans wrote:
> 
> > =============================================================
> > --- linux/drivers/md/md.c.orig	2007-08-21 03:19:42.511576248 -0700
> > +++ linux/drivers/md/md.c	2007-08-21 04:30:09.775525710 -0700
> > @@ -24,4 +24,6 @@
> > 
> > +   - autodetect dev list not array: Michael J. Evans 
<mjevans1983@gmail.com>
> > +
> 
> Nowadays we use an SCM for such comments, not the source file(s).

SCM?  Is this automatic, where do I go to see it?

> 
> >     This program is free software; you can redistribute it and/or modify
> >     it under the terms of the GNU General Public License as published by
> >     the Free Software Foundation; either version 2, or (at your option)
> > @@ -5752,13 +5754,26 @@ void md_autodetect_dev(dev_t dev)
> >   * Searches all registered partitions for autorun RAID arrays
> >   * at boot time.
> >   */
> > -static dev_t detected_devices[128];
> > -static int dev_cnt;
> > +
> > +static LIST_HEAD(all_detected_devices);
> > +struct detected_devices_node {
> > +	struct list_head list;
> > +	dev_t dev;
> > +};
> >  
> >  void md_autodetect_dev(dev_t dev)
> >  {
> > -	if (dev_cnt >= 0 && dev_cnt < 127)
> > -		detected_devices[dev_cnt++] = dev;
> > +	struct detected_devices_node *node_detected_dev;
> > +	char strbuf[BDEVNAME_SIZE];
> > +
> > +	node_detected_dev = kzalloc(sizeof(*node_detected_dev), GFP_KERNEL);\
> 
> Drop the trailing '\', as someone has already commented on.
> 

I thought I had fixed that, I must have copied the unfixed version out of the 
way when I made the other changes to it.

> > +	if (node_detected_dev) {
> > +		node_detected_dev->dev = dev;
> > +		list_add_tail(&node_detected_dev->list, &all_detected_devices);
> > +	} else {
> > +		printk(KERN_CRIT "md: md_autodetect_dev: kzAlloc node failed"
> > +		" (null return), skipping dev(%d,%d)\n", MAJOR(dev), MINOR(dev));
> 
> printk() formatting is bad.
> Drop the " (null return)" and indent that line more than the
> printk line is indented.
> 
> > +	}
> >  }
> >  
> >  
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 


