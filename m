Return-Path: <linux-kernel-owner+w=401wt.eu-S1763763AbYHFImk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763763AbYHFImk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 04:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756400AbYHFIj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:39:57 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:43112 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762282AbYHFIjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:39:54 -0400
In-Reply-To: <1217896374.27684.53.camel@localhost.localdomain>
To: Eric Paris <eparis@redhat.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface	for	on
 access scanning
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Wed, 6 Aug 2008 09:39:03 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 06/08/2008 09:39:51,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 06/08/2008 09:39:51,
	Serialize complete at 06/08/2008 09:39:51,
	S/MIME Sign failed at 06/08/2008 09:39:51: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 06/08/2008 09:39:04,
	Serialize complete at 06/08/2008 09:39:04
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080806083956.63EDD2FE88B@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote on 05/08/2008 01:32:54:

> On Mon, 2008-08-04 at 15:32 -0700, Greg KH wrote:
> > Why would userspace care about these meta-file things, what does it 
want
> > with them?
> 
> Honstely?  I don't know.  Maybe someone with access to the black magic
> source code will stand up and say if most of this metadata is important
> and if so how.

In general this metadata provides more context to the event that happened. 
For example reporting - log message/UI popup/centralised something can be 
displayed saying which user running which application was involved with 
bad stuff. Also we can find out where the user is logged in and send him a 
message there.

It is more descriptive than just failing the access with -EACCESS which 
becomes ambigious.

> > > 10. Filesystem exclusions
> > > -------------------------
> > > One pretty important optimization is not to scan things like /proc, 
/sys
> > > or similar. Basically all filesystems where user can not store
> > > arbitrary, potentially malicious, content could and should be 
excluded
> > > from scanning.
> > 
> > Why, does scanning these files take extra time?  Just curious.
> 
> Perf win, why bothering looking for malware in /proc when it can't
> exist?  It doesn't take longer it just takes time having to do
> 
> userspace -> kernel -> userspace -> kernel -> userspace
> 
> just to cat /proc/mounts, all of this could probably be alliviated if we
> cached access on non block backed files but then we have to come up with
> a way to exclude only nfs/cifs.  I'd rather list the FSs that don't need
> scanning every time than those that do....

Agreed.

> > > Closing remarks
> > > ---------------
> > > Although some may argue some of the filters are not necessary or may
> > > better be implemented in userspace, we think it is better to have 
them
> > > in kernel primarily for performance reasons.
> > 
> > Why?  What numbers do you have that say the kernel is faster in
> > implementing this?  This is the first mention of such a requirement, 
we
> > need to see real data to back it up please.
> 
> In kernel caching is clearly a huge perf win.  I couldn't even measure a
> change in kernel build time when I didn't run a userspace client.  If
> anyone can explain a way to get race free in kernel caching and out of
> kernel redirection and scanning I'd love it   :)

When you don't run an userspace client cache should not come into play 
because nothing will be cached (in this iteration at least). So I guess 
you meant something different here? Like not running an userspace client 
and having the filter disabled (or even not) will produce very little 
overhead, probably not observable without micro-benchmarking. Having an 
userspace client which just replies with "allow" should have even less 
performance impact because most inodes will get cached which means filter 
chain will be shorter on subsequent accesses to the same inode.

In either case it will become obvious how huge performance win is to have 
in kernel caching once you get the numbers. Let me know if I can help you 
with that somehow.

Tvrtko


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

