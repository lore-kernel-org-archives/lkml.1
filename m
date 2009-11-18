Return-Path: <linux-kernel-owner+w=401wt.eu-S932528AbZKRSyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528AbZKRSyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758279AbZKRSyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:54:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758268AbZKRSyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:54:07 -0500
Date: Wed, 18 Nov 2009 13:54:07 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] vfs: ensure that dentries are revalidated on open
 (try #2)
Message-ID: <20091118135407.45b3715d@tlielax.poochiereds.net>
In-Reply-To: <20091118173817.GE25150@elf.ucw.cz>
References: <1257870456-31188-1-git-send-email-jlayton@redhat.com>
	<20091118041906.GB1395@ucw.cz>
	<20091118072916.720471b0@tlielax.poochiereds.net>
	<20091118173817.GE25150@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Nov 2009 18:38:17 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > > > This is the second attempt to fix this problem. The first one attempted
> > > > to fix this in procfs, but Eric Biederman pointed out that file bind
> > > > mounts have a similar problem. This set attempts to fix the issue at a
> > > > higher level, in the generic VFS layer.
> > > > 
> > > > In certain situations, when it knows that they are valid, the path
> > > > walking code will skip revalidating dentries that it finds in the cache.
> > > > This causes problems with filesystems such as NFSv4 and CIFS that depend
> > > > on the d_revalidate routine to do opens during lookup.
> > > 
> > > ...and it allows bypassing directory permissions. Could we fix both
> > > here?
> > 
> > Does it? Here's what I just did to check that:
> 
> Yes it does, see http://seclists.org/bugtraq/2009/Oct/179
> 
> 
> > # cp /bin/sleep /root/sleep
> > 
> > # ls -l /root /root/sleep
> > dr-xr-x---. 19 root root  4096 2009-11-18 07:20 /root
> > -rwxr-xr-x.  1 root root 29152 2009-11-18 07:20 /root/sleep
> > 
> > # /root/sleep 600
> > 
> > ...then as unprivileged user:
> > 
> > $ ps -ef | grep sleep 
> > (find pid of sleep program that root is running)
> > 
> > $ /proc/5258/exe 600
> > bash: /proc/5258/exe: Permission denied
> > 
> > ...it looks like directory permissions are respected here. Did I
> > misunderstand what you're concerned about?
> 
> /proc does not allow you to use /proc/XX/fd of unrelated users; it is
> another mechanism disallowing access. (Plus, I did my experiments with
> /proc/XX/fd, not /exe).
> 									Pavel

Thanks for the info. Took me a while to get through it but I read most
of the thread. I agree that it sounds like a very similar problem.

I'm beginning to wonder whether the right answer is to just make
these /proc symlinks behave more like normal symlinks. Get rid of
LAST_BIND and have follow_link turn the dentry into a path via d_path().

It's less efficient, but it means less special-casing in the path
walking code. I don't see /proc symlinks as being so performance
critical that we can't do it that way instead.

That still leaves the issue with bind mounted files not causing a
d_revalidate, but we can deal with that separately once the other issue
is resolved...

Thoughts?
-- 
Jeff Layton <jlayton@redhat.com>
