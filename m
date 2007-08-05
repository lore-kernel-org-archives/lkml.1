Return-Path: <linux-kernel-owner+w=401wt.eu-S1759484AbXHEMrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484AbXHEMrb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 08:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbXHEMrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 08:47:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35700 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbXHEMrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 08:47:22 -0400
Date: Sun, 5 Aug 2007 14:46:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jakob Oestergaard <jakob@unthought.net>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070805124648.GA21173@elte.hu>
References: <20070804063217.GA25069@elte.hu> <20070804070737.GA940@elte.hu> <20070804103347.GA1956@elte.hu> <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org> <20070804163733.GA31001@elte.hu> <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org> <46B4C0A8.1000902@garzik.org> <20070805102021.GA4246@unthought.net> <46B5A996.5060006@garzik.org> <20070805105850.GC4246@unthought.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070805105850.GC4246@unthought.net>
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


* Jakob Oestergaard <jakob@unthought.net> wrote:

> > If you can show massive amounts of users that will actually be 
> > negatively impacted, please present hard evidence.
> > 
> > Otherwise all this is useless hot air.
> 
> Peace Jeff :)
> 
> In another mail, I gave an example with tmpreaper clearing out unused 
> files; if some of those files are only read and never modified, 
> tmpreaper would start deleting files which were still frequently used.
> 
> That's a regression, the way I see it. As for 'massive amounts of 
> users', well, tmpreaper exists in most distros, so it's possible it 
> has other users than just me.

you mean tmpwatch? The trivial change below fixes this. And with that 
we've come to the end of an extremely short list of atime dependencies.

	Ingo

--- /etc/cron.daily/tmpwatch.orig
+++ /etc/cron.daily/tmpwatch
@@ -1,9 +1,9 @@
 #! /bin/sh
-/usr/sbin/tmpwatch -x /tmp/.X11-unix -x /tmp/.XIM-unix -x /tmp/.font-unix \
+/usr/sbin/tmpwatch --mtime -x /tmp/.X11-unix -x /tmp/.XIM-unix -x /tmp/.font-unix \
 	-x /tmp/.ICE-unix -x /tmp/.Test-unix 10d /tmp
-/usr/sbin/tmpwatch 30d /var/tmp
+/usr/sbin/tmpwatch --mtime 30d /var/tmp
 for d in /var/{cache/man,catman}/{cat?,X11R6/cat?,local/cat?}; do
     if [ -d "$d" ]; then
-	/usr/sbin/tmpwatch -f 30d "$d"
+	/usr/sbin/tmpwatch --mtime -f 30d "$d"
     fi
 done
