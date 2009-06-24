Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbZFXV6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbZFXV6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZFXV6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:58:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751515AbZFXV6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:58:36 -0400
Date: Wed, 24 Jun 2009 14:58:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: hpa@zytor.com, ray-lk@madrabbit.org, renton@renton.name,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: devpts mounts too slowly
Message-Id: <20090624145822.72aaaff6.akpm@linux-foundation.org>
In-Reply-To: <20090624200108.GR8633@ZenIV.linux.org.uk>
References: <20090603142801.GC21646@beaver.vrungel.ru>
	<4A26EB18.6060907@zytor.com>
	<20090609161945.811cc01f.akpm@linux-foundation.org>
	<2c0942db0906091630l1cc79647h8689e9e929ed1bba@mail.gmail.com>
	<20090609165304.add1a872.akpm@linux-foundation.org>
	<4A301CCD.7070707@zytor.com>
	<20090624200108.GR8633@ZenIV.linux.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 21:01:08 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Wed, Jun 10, 2009 at 01:51:25PM -0700, H. Peter Anvin wrote:
> > Andrew Morton wrote:
> > > 
> > > hm, OK.
> > > 
> > > I've now mounted 15000 devpts's and still no slowdown is evident.
> > 
> > I ran my test script, mounting ramfs, with n=100000, and well, gave up
> > since it hadn't gotten any further than 57000 or so overnight.  At that
> > time each individual mount was taking several seconds.
> > 
> > Graphing the delays seem to indicate O(n^2) behavior.
> > 
> > umounts do not appear affected; each umount still take negible time.
> 
> I think I know what's going on.  /sbin/mount is linked against libselinux
> /sbin/umount is not.  And FPOS in question blows if you
> 	* do not have selinuxfs mounted (e.g. because selinux is not enabled)
> 	* have a lot of mounts.
> 
> What happens is that this piece of crap checks for presence of selinuxfs
> on /selinux; then, if the thing isn't there, we go and scan the entire
> /proc/mounts in search of selinuxfs mounts.
> 
> If akpm has selinux enabled on his testbox and you don't have it on yours,
> we have all observations explained.

CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT is not set
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set

>  I'd expect similar slowdown from
> ls on an empty directory, BTW - /bin/ls is linked against the same thing,
> so it gets hit as well.  Before it even gets to main().
