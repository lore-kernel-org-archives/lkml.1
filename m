Return-Path: <linux-kernel-owner+w=401wt.eu-S1030258AbXDUIJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030258AbXDUIJr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 04:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030316AbXDUIJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 04:09:47 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:36192 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030258AbXDUIJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 04:09:46 -0400
To: akpm@linux-foundation.org
CC: serue@us.ibm.com, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       ebiederm@xmission.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
In-reply-to: <20070421005503.f3bbf1e5.akpm@linux-foundation.org> (message from
	Andrew Morton on Sat, 21 Apr 2007 00:55:03 -0700)
Subject: Re: [patch 1/8] add user mounts to the kernel
References: <20070420102532.385211890@szeredi.hu>
	<20070420102624.975879175@szeredi.hu> <20070421005503.f3bbf1e5.akpm@linux-foundation.org>
Message-Id: <E1HfAc0-0002KK-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 21 Apr 2007 10:06:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Add ownership information to mounts.
> > 
> > A new mount flag, MS_SETUSER is used to make a mount owned by a user.
> > If this flag is specified, then the owner will be set to the current
> > real user id and the mount will be marked with the MNT_USER flag.  On
> > remount don't preserve previous owner, and treat MS_SETUSER as for a
> > new mount.  The MS_SETUSER flag is ignored on mount move.
> 
> So is a modified mount(8) needed?  If so, is there some convenient way
> in which testers can get hold of it?

I haven't yet added this to mount(8).  I'll do that and post patches.

There's an ultra sophisticated mount tester program I use.  It's
slightly user unfriendly...

Miklos

----
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mount.h>

int main(int argc, char *argv[])
{
	int res;
	int un = (strrchr(argv[0], '/') ?: argv[0] - 1)[1] == 'u';
	if ((un && argc != 3) || (!un && argc != 6)) {
		fprintf(stderr, "usage: %s %s\n", argv[0],
			un ? "dir flags" : "dev dir type flags opts");
		return 1;
	}
	if (un)
		res = umount2(argv[1], atoi(argv[2]));
	else
		res = mount(argv[1], argv[2], argv[3], atoi(argv[4]), argv[5]);
	if (res == -1) {
		perror(argv[0]);
		return 1;
	}
	return 0;
}

