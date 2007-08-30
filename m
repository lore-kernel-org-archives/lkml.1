Return-Path: <linux-kernel-owner+w=401wt.eu-S1764126AbXH3Wr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764126AbXH3Wr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 18:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbXH3WrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 18:47:17 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:16919 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763301AbXH3WrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 18:47:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:references:in-reply-to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:content-language;
        b=VPG0Y75TSve9hoTRYV6jDpALKJX9Tdzzti2uihAs9ZMI46ltXTFrOAdrl/asME0sXKIA72ez1P3xJpuXGItOYHszfyfBLZmqXqWN2s0yHYYG4DJFxLmYNm+mPhep0F5YXID2n/5lfTTl6IkOfUBJRpa841KKPdjBvSS0T0peiBQ=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Trond Myklebust'" <trond.myklebust@fys.uio.no>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       <akpm@linux-foundation.org>
References: <000701c7eb49$cff701c0$6fe50540$@com> <1188513433.6626.24.camel@heimdal.trondhjem.org>
In-Reply-To: <1188513433.6626.24.camel@heimdal.trondhjem.org>
Subject: RE: recent nfs change causes autofs regression
Date: Thu, 30 Aug 2007 15:47:02 -0700
Message-ID: <001001c7eb57$afd2d320$0f787960$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcfrVlF5sH5ct+MJTOu5oN/jpqTgcQAAGuvQ
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trond,

> On Thu, 2007-08-30 at 14:07 -0700, Hua Zhong wrote:
> > I am re-sending this after help from Ian and git-bisect. To me it's a
> > show-stopper: I cannot find an acceptable workaround that I can
> > implement. The problem: upgrading to 2.6.23-rc4 from 2.6.22 causes 
> > several autofs mounts to fail silently - they just not appear when 
> > they should.
> > I believe it's caused by the NFS change that forces multiple mounts
> > from different directories under the same server side filesystem to have
> > the same mount options by default, otherwise it returns EBUSY.
> >
> > For example, if server has a filesystem /a, and it exports /a/x and /a/y
> > (maybe with rw or ro), and a client must mount /a/x and /a/y with the
> > same mount options now.
> 
> Which is better than having it fail silently, or giving you a mount
> with the wrong mount options.

Well, it depends on how you define "better".

In this particular scenario, the maps read as follows:

tools
-fstype=nfs,udp,rw,intr,nosuid,nodev,rsize=8192,wsize=8192,mountvers=3,nfsve
rs=3,actimeo=600 fs1.domain.com:/a/tools
share
-fstype=nfs,udp,rw,intr,nosuid,nodev,rsize=8192,wsize=8192,mountvers=3,nfsve
rs=3 fs1.domain.com:/a/share

The only difference is in the actimeo (I don't even know what it means). Is
this enough to fail a mount?

More importantly, it is a regression. My understanding is that unless
absolutely necessary we do not introduce a "feature" that breaks working
setups.

> If you need to mount the same filesystem with incompatible mount
> options on the same client, then there is a new mount option
"nosharecache",
> which enables it.

Unfortunately, as I said, I don't control the auto.auto nis map.

> The new option is there in order to make it damned clear to sysadmins
> that this is a dangerous thing to do: mounts which don't share the same
> superblock also don't share the same data and attribute caches. Any
> file or directory which appears in both mounts had better only be used by
> one application at a time or be using an appropriate locking scheme.

I guess the question is what should be the default.

I'll convey this to our system admin (fortunately we are not a very big
company), but I am just not 100% sure this is a well-thought change because
I believe many people will be impacted once 2.6.23 is out. Shouldn't we give
some time to user to fix their config before we enforce this, by like some
kernel warnings?

Thanks.

> Trond

