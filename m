Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbZIBSxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbZIBSxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 14:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbZIBSxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 14:53:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbZIBSxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 14:53:15 -0400
Date: Wed, 2 Sep 2009 20:53:16 +0200
From: Jan Blunck <jblunck@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Kay Sievers <kay.sievers@suse.de>,
       gregkh@suse.de, kasievers@suse.de, USB list <linux-usb@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: driver/base/dd.c lockdep warning
Message-ID: <20090902185315.GU28804@bolzano.suse.de>
References: <Pine.LNX.4.44L0.0909011146030.3190-100000@iolanthe.rowland.org> <1251887933.7547.141.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251887933.7547.141.camel@twins>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, Peter Zijlstra wrote:

> 
> So the proposal I currently have to solve this is to allocate 48 lock
> classes:
> 
> struct lock_class_key device_tree_depth[MAX_LOCK_DEPTH];
> 
> and when creating a new device node, set the lock class corresponding
> the depth in the tree:
> 
>   mutex_lock_init(&device->lock);
>   BUG_ON(device->depth >= MAX_LOCK_DEPTH); // surely we're not that deep
>   lockdep_set_class(&device->lock, device_tree_depth + device->depth);
>   ...
>   mutex_lock(&device->lock); /* already have parent locked */
>   device_attach(device, parent);
> 
> and take multiple child locks using:
> 
>   mutex_lock_nest_lock(&device->lock, &device->parent->lock);
> 
> Which, I think should work for most cases out there.
> 
> Alan had some funny corner cases, but I think he wasn't sure whether
> those would indeed show up in reality.

JFYI, I tried to get away with just parent, child and normal class but
the problem is that device_add() is called recursive via driver probing
code. So either we change that (and iterate down the device tree) or we need
to implement what you proposed.

Cheers,
Jan
