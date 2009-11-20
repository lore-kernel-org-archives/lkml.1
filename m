Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbZKTVhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbZKTVhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbZKTVhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:37:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754530AbZKTVhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:37:18 -0500
Date: Fri, 20 Nov 2009 13:36:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: O_NOATIME and files in /proc
Message-Id: <20091120133651.9df2da80.akpm@linux-foundation.org>
In-Reply-To: <1258477590.16246.35.camel@tara.firmix.at>
References: <1258477590.16246.35.camel@tara.firmix.at>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009 18:06:29 +0100
Bernd Petrovitsch <bernd@firmix.at> wrote:

> Hi all!
> 
> Is there a specific reason that open can not open files (at
> least /proc/noatime and /proc/cpuinfo) under /proc with NO_ATIME as the
> following program shows:
> ----  snip  ----
> {12}cat noatime.c
> 
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <string.h>
> #include <errno.h>
> #include <fcntl.h>
> 
> int main(void)
> {
> 	int fd = open("/proc/uptime", O_RDONLY|O_NOATIME);
> 	if (fd == -1) {
> 		printf("fd=%d, errno=%s\n", fd, strerror(errno));
> 	} else {
> 		printf("fd=%d\n", fd);
> 	}
> 	return 0;
> }
> ----  snip  ----
> When I compile and run it, it prints
> ----  snip  ----
> {13}./noatime 
> fd=-1, errno=Operation not permitted
> ----  snip  ----
> Removing the "NO_ATIME" makes it work (of course).
> 
> I can also set the "noatime" mount flag on a remount and it shows up
> in /proc/mounts but it makes for the above no difference.
> 

I guess you're hitting the check in may_open():

	/* O_NOATIME can only be set by the owner or superuser */
	if (flag & O_NOATIME)
		if (!is_owner_or_cap(inode)) {
			error = -EPERM;
			goto err_out;
		}

This code was added in 2004 and neither the changelog nor the code
comment explain _why_ this was done (bad).  It might be recorded in the
contemporary email discussion.

I assume it was done this way under the assumption that people might
want to use atime to determine if other users have been peeking at
their junk.  Avoid permitting junk-peekers to conceal their tracks.

