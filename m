Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbYEDPbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbYEDPbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 11:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbYEDPbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 11:31:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47650 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbYEDPbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 11:31:01 -0400
Date: Sun, 4 May 2008 16:30:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [vfs/proc] task_nommu: fix compile failing bug
	because of spilt file.h
Message-ID: <20080504153056.GJ5882@ZenIV.linux.org.uk>
References: <1209913975-19242-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209913975-19242-1-git-send-email-cooloney@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 11:12:55PM +0800, Bryan Wu wrote:
> diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
> index 6cba820..987bc69 100644
> --- a/fs/proc/task_nommu.c
> +++ b/fs/proc/task_nommu.c
> @@ -1,6 +1,7 @@
>  
>  #include <linux/mm.h>
>  #include <linux/file.h>
> +#include <linux/fdtable.h>
>  #include <linux/mount.h>
>  #include <linux/ptrace.h>
>  #include <linux/seq_file.h>

Well...  I see what it's trying to do, but it's a bullshit.  Look: it's from
        if (current->files && atomic_read(&current->files->count) > 1)
                sbytes += kobjsize(current->files);
        else
                bytes += kobjsize(current->files);
Now, what we really have is size of current->files (fixed and not too large)
+ if descriptor table is too large to be embedded,
	size of current->files->fdt
	size of current->files->fdt->fd
	size of current->files->fdt->open_fds/->close_on_exec
And the second term there can be *large*, so if we are really serious about
taking descriptor table footprint into account, we'd better take care of
that too.  I'm not sure that we want to, though - note that we do that only
on nommu targets...

So what's that code really trying to achieve?
