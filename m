Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbXENPmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbXENPmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 11:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbXENPmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 11:42:09 -0400
Received: from smtp.linux-foundation.org ([207.189.120.12]:57630 "EHLO
	smtp.osdl.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbXENPmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 11:42:07 -0400
Date: Mon, 14 May 2007 08:41:57 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG][PATCH] Fix race condition about network device name
 allocation
Message-ID: <20070514084157.749ad4e7@freepuppy>
In-Reply-To: <1179106381.3881.16.camel@kane-linux>
References: <1178862045.3979.33.camel@kane-linux>
	<20070511092519.1f34ab34@freepuppy>
	<1179106381.3881.16.camel@kane-linux>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 10:33:01 +0900
Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> wrote:

> Hi Stephen,
> 
> Thank you for comments. I'll try your patch.
> 
> I have one concern about your patch, though I don't know very much 
> about netdev codes.
> 
> @@ -3411,6 +3410,9 @@ void unregister_netdevice(struct net_dev
> >  	/* Notifier chain MUST detach us from master device. */
> >  	BUG_TRAP(!dev->master);
> >  
> > +	/* Remove entries from sysfs */
> > +	netdev_unregister_sysfs(dev);
> > +
> >  	/* Finish processing unregister after unlock */
> >  	net_set_todo(dev);
> >  
> 
> With your patch, the netdev_unregister_sysfs() will be called
> earlier than now. Does it have no side effect? I'm worrying 
> about if there are somebody that depend on sysfs entry until
> net_run_todo() is called.


The unregister_sysfs() removes the entry in /sys/class/net and then
decrements the reference count. When ref count goes to zero, the kobject_release
callback gets called and which does kfree(). 

Changing the shutdown order makes the /sys/class/net entry disappear
sooner. In order to prevent the free from happening until after all the dev_put()
calls have happened, the reference count for the kobject needs to be increased.

