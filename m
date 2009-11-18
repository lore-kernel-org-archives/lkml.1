Return-Path: <linux-kernel-owner+w=401wt.eu-S1751658AbZKRM30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbZKRM30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 07:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbZKRM3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 07:29:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbZKRM3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 07:29:24 -0500
Date: Wed, 18 Nov 2009 07:29:16 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-nfs@vger.kernel.org, ebiederm@xmission.com, adobriyan@gmail.com,
       viro@ZenIV.linux.org.uk, jamie@shareable.org
Subject: Re: [PATCH 0/2] vfs: ensure that dentries are revalidated on open
 (try #2)
Message-ID: <20091118072916.720471b0@tlielax.poochiereds.net>
In-Reply-To: <20091118041906.GB1395@ucw.cz>
References: <1257870456-31188-1-git-send-email-jlayton@redhat.com>
	<20091118041906.GB1395@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Nov 2009 05:19:06 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > This is the second attempt to fix this problem. The first one attempted
> > to fix this in procfs, but Eric Biederman pointed out that file bind
> > mounts have a similar problem. This set attempts to fix the issue at a
> > higher level, in the generic VFS layer.
> > 
> > In certain situations, when it knows that they are valid, the path
> > walking code will skip revalidating dentries that it finds in the cache.
> > This causes problems with filesystems such as NFSv4 and CIFS that depend
> > on the d_revalidate routine to do opens during lookup.
> 
> ...and it allows bypassing directory permissions. Could we fix both
> here?
> 									Pavel

Does it? Here's what I just did to check that:

# cp /bin/sleep /root/sleep

# ls -l /root /root/sleep
dr-xr-x---. 19 root root  4096 2009-11-18 07:20 /root
-rwxr-xr-x.  1 root root 29152 2009-11-18 07:20 /root/sleep

# /root/sleep 600

...then as unprivileged user:

$ ps -ef | grep sleep 
(find pid of sleep program that root is running)

$ /proc/5258/exe 600
bash: /proc/5258/exe: Permission denied

...it looks like directory permissions are respected here. Did I
misunderstand what you're concerned about?

-- 
Jeff Layton <jlayton@redhat.com>
