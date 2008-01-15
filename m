Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbYAOImc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbYAOImc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 03:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbYAOIm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 03:42:26 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44641 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbYAOImZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 03:42:25 -0500
Subject: Re: 2.6.24-rc7 lockdep warning when poweroff
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080115012402.GA2780@darkstar.te-china.tietoenator.com>
References: <a8e1da0801140104m2d8dceaayd8cf85466659bbf@mail.gmail.com>
	 <1200302644.7415.6.camel@twins> <1200306902.5887.39.camel@johannes.berg>
	 <1200307288.7415.11.camel@twins> <1200307896.5887.42.camel@johannes.berg>
	 <a8e1da0801141631k50dfd74fo923973722d13c3a3@mail.gmail.com>
	 <20080115012402.GA2780@darkstar.te-china.tietoenator.com>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 09:42:16 +0100
Message-Id: <1200386536.15103.16.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-15 at 09:24 +0800, Dave Young wrote:
> On Tue, Jan 15, 2008 at 08:31:48AM +0800, Dave Young wrote:
> > On Jan 14, 2008 6:51 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > >
> > > > The warning that triggered (lockdep.c:700) means that one class (key)
> > > > was used with more than one name.
> > >
> > > Right.
> > >
> > > > Looking at cleanup_workqueue_thread(), the lock_acquire() there works on
> > > > wq->lockdep_map, and that is only initialized at one spot:
> > > > __create_workqueue_key(), thus it stands to reason that that was
> > > > mis-used.
> > >
> > > Oh ok, yes, makes sense. Maybe something is generating a workqueue with
> > > a name that's passed in but the key is statically from that place. I'll
> > > try to find it.
> > 
> > I add some debug printk and found the names :
> > 
> > block_osm/exec_osm
> > 
> > in drivers/message/i2o
> > 
> > maybe this helps.
> 
> Not sure right or not, the following patch fixed the problem:
> 
> diff -upr linux/include/linux/workqueue.h linux.new/include/linux/workqueue.h
> --- linux/include/linux/workqueue.h	2008-01-15 08:49:08.000000000 +0800
> +++ linux.new/include/linux/workqueue.h	2008-01-15 08:49:42.000000000 +0800
> @@ -154,7 +154,7 @@ __create_workqueue_key(const char *name,
>  #ifdef CONFIG_LOCKDEP
>  #define __create_workqueue(name, singlethread, freezeable)	\
>  ({								\
> -	static struct lock_class_key __key;			\
> +	struct lock_class_key __key;			\
>  								\
>  	__create_workqueue_key((name), (singlethread),		\
>  			       (freezeable), &__key);		\

That didn't get you:

  INFO: trying to register non-static key.

Msgs?

But it sure looks like __create_workqueue() is asking for trouble, if
there is a __create_workqueue() instance that takes a non constant name
we're in trouble.

