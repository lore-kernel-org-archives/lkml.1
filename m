Return-Path: <linux-kernel-owner+w=401wt.eu-S1764220AbXH3XXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764220AbXH3XXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 19:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762927AbXH3XW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 19:22:58 -0400
Received: from pat.uio.no ([129.240.10.15]:33418 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761529AbXH3XW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 19:22:57 -0400
Subject: RE: recent nfs change causes autofs regression
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Hua Zhong <hzhong@gmail.com>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org
In-Reply-To: <001001c7eb57$afd2d320$0f787960$@com>
References: <000701c7eb49$cff701c0$6fe50540$@com>
	 <1188513433.6626.24.camel@heimdal.trondhjem.org>
	 <001001c7eb57$afd2d320$0f787960$@com>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 19:22:53 -0400
Message-Id: <1188516173.6626.46.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.0, required=12.0, autolearn=disabled, AWL=-0.030)
X-UiO-Scanned: 456966B5A97ADF4CBA833C5672716BAC0832A1EF
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 90 total 3573278 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 15:47 -0700, Hua Zhong wrote:
> Hi Trond,
> 
> > On Thu, 2007-08-30 at 14:07 -0700, Hua Zhong wrote:
> > > I am re-sending this after help from Ian and git-bisect. To me it's a
> > > show-stopper: I cannot find an acceptable workaround that I can
> > > implement. The problem: upgrading to 2.6.23-rc4 from 2.6.22 causes 
> > > several autofs mounts to fail silently - they just not appear when 
> > > they should.
> > > I believe it's caused by the NFS change that forces multiple mounts
> > > from different directories under the same server side filesystem to have
> > > the same mount options by default, otherwise it returns EBUSY.
> > >
> > > For example, if server has a filesystem /a, and it exports /a/x and /a/y
> > > (maybe with rw or ro), and a client must mount /a/x and /a/y with the
> > > same mount options now.
> > 
> > Which is better than having it fail silently, or giving you a mount
> > with the wrong mount options.
> 
> Well, it depends on how you define "better".

"better" as in: "I now have a chance to notice, when my 'read-only
mount' is actually 'read-write'".

> In this particular scenario, the maps read as follows:
> 
> tools
> -fstype=nfs,udp,rw,intr,nosuid,nodev,rsize=8192,wsize=8192,mountvers=3,nfsve
> rs=3,actimeo=600 fs1.domain.com:/a/tools
> share
> -fstype=nfs,udp,rw,intr,nosuid,nodev,rsize=8192,wsize=8192,mountvers=3,nfsve
> rs=3 fs1.domain.com:/a/share
> 
> The only difference is in the actimeo (I don't even know what it means). Is
> this enough to fail a mount?

Yes. The default values for acregmin, acregmax, acdirmin, acdirmax are
not 600. If /a/tools and /a/share are on the same filesystem on the
server, then the NFS client should warn you that you are about to do
something that may result in cache coherency problems instead of
silently allowing it, and then leaving you to debug the coherency issue.

If you know what you are doing, then there is an option which allows you
to override the default behaviour.

> More importantly, it is a regression. My understanding is that unless
> absolutely necessary we do not introduce a "feature" that breaks working
> setups.

Your turn to define what you mean by "working"? In my book that means "a
setup that doesn't include unexpected or unintended behaviour".

Not being able to notice cache coherency failures on a file that is
mounted in two different places with two different sets of mount options
counts as "unexpected behaviour".

Not being able to notice that your mount options have been overridden by
the kernel also counts as "unexpected behaviour".

Trond

