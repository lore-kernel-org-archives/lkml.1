Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbZFXUBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbZFXUBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbZFXUBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:01:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47892 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZFXUBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:01:45 -0400
Date: Wed, 24 Jun 2009 21:01:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ray Lee <ray-lk@madrabbit.org>,
       renton@renton.name, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: devpts mounts too slowly
Message-ID: <20090624200108.GR8633@ZenIV.linux.org.uk>
References: <20090603142801.GC21646@beaver.vrungel.ru> <4A26EB18.6060907@zytor.com> <20090609161945.811cc01f.akpm@linux-foundation.org> <2c0942db0906091630l1cc79647h8689e9e929ed1bba@mail.gmail.com> <20090609165304.add1a872.akpm@linux-foundation.org> <4A301CCD.7070707@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A301CCD.7070707@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 01:51:25PM -0700, H. Peter Anvin wrote:
> Andrew Morton wrote:
> > 
> > hm, OK.
> > 
> > I've now mounted 15000 devpts's and still no slowdown is evident.
> 
> I ran my test script, mounting ramfs, with n=100000, and well, gave up
> since it hadn't gotten any further than 57000 or so overnight.  At that
> time each individual mount was taking several seconds.
> 
> Graphing the delays seem to indicate O(n^2) behavior.
> 
> umounts do not appear affected; each umount still take negible time.

I think I know what's going on.  /sbin/mount is linked against libselinux
/sbin/umount is not.  And FPOS in question blows if you
	* do not have selinuxfs mounted (e.g. because selinux is not enabled)
	* have a lot of mounts.

What happens is that this piece of crap checks for presence of selinuxfs
on /selinux; then, if the thing isn't there, we go and scan the entire
/proc/mounts in search of selinuxfs mounts.

If akpm has selinux enabled on his testbox and you don't have it on yours,
we have all observations explained.  I'd expect similar slowdown from
ls on an empty directory, BTW - /bin/ls is linked against the same thing,
so it gets hit as well.  Before it even gets to main().
