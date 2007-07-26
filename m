Return-Path: <linux-kernel-owner+w=401wt.eu-S1763906AbXGZJlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763906AbXGZJlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 05:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbXGZJku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 05:40:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45594 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbXGZJkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 05:40:49 -0400
Date: Thu, 26 Jul 2007 11:40:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frank Kingswood <frank@kingswood-consulting.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ray Lee <ray-lk@madrabbit.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       ck list <ck@vds.kolivas.org>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: RFT: updatedb "morning after" problem [was: Re: -mm merge plans
	for 2.6.23]
Message-ID: <20070726094024.GA15583@elte.hu>
References: <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com> <46A57068.3070701@yahoo.com.au> <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com> <46A58B49.3050508@yahoo.com.au> <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com> <46A6CC56.6040307@yahoo.com.au> <p73abtkrz37.fsf@bingen.suse.de> <46A85D95.509@kingswood-consulting.co.uk> <20070726092025.GA9157@elte.hu> <20070726023401.f6a2fbdf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726023401.f6a2fbdf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 26 Jul 2007 11:20:25 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Once we give the kernel the knowledge that the dentry wont be used again 
> > by this app, the kernel can do a lot more intelligent decision and not 
> > baloon the dentry cache.
> > 
> > ( we _do_ want to baloon the dentry cache otherwise - for things like 
> >   "find" - having a fast VFS is important. But known-use-once things 
> >   like the daily updatedb job can clearly be annotated properly. )
> 
> Mutter.  /proc/sys/vm/vfs_cache_pressure has been there for what, 
> three years?  Are any distros raising it during the updatedb run yet?

but ... that's system-wide, and the 'dont baloon the dcache' is only a 
property of updatedb. Still, it's useful to debug this thing.

below is an updatedb hack that sets vfs_cache_pressure down to 0 during 
an updatedb run. Could someone who is affected by the 'morning after' 
problem give it a try? If this works then we can think about any other 
measures ...

	Ingo

--- /etc/cron.daily/mlocate.cron.orig
+++ /etc/cron.daily/mlocate.cron
@@ -1,4 +1,7 @@
 #!/bin/sh
 nodevs=$(< /proc/filesystems awk '$1 == "nodev" { print $2 }')
 renice +19 -p $$ >/dev/null 2>&1
+PREV=`cat /proc/sys/vm/vfs_cache_pressure 2>/dev/null`
+echo 0 > /proc/sys/vm/vfs_cache_pressure 2>/dev/null
 /usr/bin/updatedb -f "$nodevs"
+[ "$PREV" != "" ] && echo $PREV > /proc/sys/vm/vfs_cache_pressure 2>/dev/null
