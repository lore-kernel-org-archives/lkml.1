Return-Path: <linux-kernel-owner+w=401wt.eu-S1759943AbYJJOEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943AbYJJOEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 10:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbYJJOEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 10:04:39 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:41010 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbYJJOEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 10:04:38 -0400
Date: Fri, 10 Oct 2008 09:04:30 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] first callers of process_deny_checkpoint()
Message-ID: <20081010140430.GA14640@us.ibm.com>
References: <20081009190405.13A253CB@kernel> <20081009190406.1B257119@kernel> <48EF2BAB.1010009@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EF2BAB.1010009@fr.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Cedric Le Goater (clg@fr.ibm.com):
> > diff -puN ipc/mqueue.c~no-checkpointing-for-sockets ipc/mqueue.c
> > --- linux-2.6.git/ipc/mqueue.c~no-checkpointing-for-sockets	2008-10-09 11:56:58.000000000 -0700
> > +++ linux-2.6.git-dave/ipc/mqueue.c	2008-10-09 11:56:58.000000000 -0700
> > @@ -14,6 +14,7 @@
> >   */
> >  
> >  #include <linux/capability.h>
> > +#include <linux/checkpoint.h>
> >  #include <linux/init.h>
> >  #include <linux/pagemap.h>
> >  #include <linux/file.h>
> > @@ -655,6 +656,8 @@ asmlinkage long sys_mq_open(const char _
> >  	char *name;
> >  	int fd, error;
> >  
> > +	process_deny_checkpointing(current);
> > +
> 
> mqueue being a file system, i would put the checks in the inode_operations.
> 
> Also, you can't always deny ! I would expect some allow in sys_mq_unlink().

Remember a part of Ingo's motivation is to push c/r developers to
address the lacking features that users use most, earlier.  So the
warnings and subsequent email complaints are what we're after.  Hence a
single 'checkpointable or not' flag.

Given the single flag, how do you know at sys_mq_unlink() whether the
process also has an opensocket?

Rather than make this tracking facility more complicated and intrusive,
if people complain that they couldn't checkpoint bc of a warning about
aio, then we implement aio c/r!  We don't just try and reduce the amount
of time that you can't checkpoint bc of lack of aio c/r support  :)

-serge
