Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbYAOBVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbYAOBVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 20:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYAOBUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 20:20:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:22517 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbYAOBUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 20:20:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=qPebWY3huRWQWCiEI7fIFtS131CFt5btGgkw2C6jN8qsJaicrHFd0VmBeV6xR7W3TKVjQwJai415ceFnG+qMOVolxnJG5f5xPKd3dzdwvJHZvmeJZC0NJ5hdQ/fDc8qHeAYV8wOt5olgsKXuAVnMaKjmHju29Za9n+zVy3Ue154=
Date: Tue, 15 Jan 2008 09:24:02 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc7 lockdep warning when poweroff
Message-ID: <20080115012402.GA2780@darkstar.te-china.tietoenator.com>
References: <a8e1da0801140104m2d8dceaayd8cf85466659bbf@mail.gmail.com> <1200302644.7415.6.camel@twins> <1200306902.5887.39.camel@johannes.berg> <1200307288.7415.11.camel@twins> <1200307896.5887.42.camel@johannes.berg> <a8e1da0801141631k50dfd74fo923973722d13c3a3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0801141631k50dfd74fo923973722d13c3a3@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 08:31:48AM +0800, Dave Young wrote:
> On Jan 14, 2008 6:51 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> >
> > > The warning that triggered (lockdep.c:700) means that one class (key)
> > > was used with more than one name.
> >
> > Right.
> >
> > > Looking at cleanup_workqueue_thread(), the lock_acquire() there works on
> > > wq->lockdep_map, and that is only initialized at one spot:
> > > __create_workqueue_key(), thus it stands to reason that that was
> > > mis-used.
> >
> > Oh ok, yes, makes sense. Maybe something is generating a workqueue with
> > a name that's passed in but the key is statically from that place. I'll
> > try to find it.
> 
> I add some debug printk and found the names :
> 
> block_osm/exec_osm
> 
> in drivers/message/i2o
> 
> maybe this helps.

Not sure right or not, the following patch fixed the problem:

diff -upr linux/include/linux/workqueue.h linux.new/include/linux/workqueue.h
--- linux/include/linux/workqueue.h	2008-01-15 08:49:08.000000000 +0800
+++ linux.new/include/linux/workqueue.h	2008-01-15 08:49:42.000000000 +0800
@@ -154,7 +154,7 @@ __create_workqueue_key(const char *name,
 #ifdef CONFIG_LOCKDEP
 #define __create_workqueue(name, singlethread, freezeable)	\
 ({								\
-	static struct lock_class_key __key;			\
+	struct lock_class_key __key;			\
 								\
 	__create_workqueue_key((name), (singlethread),		\
 			       (freezeable), &__key);		\
> 
> Regards
> dave
> 
> >
> > johannes
> >
