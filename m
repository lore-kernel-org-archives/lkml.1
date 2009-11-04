Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbZKDIe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbZKDIe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 03:34:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZKDIe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 03:34:29 -0500
Received: from ozlabs.org ([203.10.76.45]:52588 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbZKDIe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 03:34:28 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH] Correct nr_processes() when CPUs have been unplugged
Date: Wed, 4 Nov 2009 19:04:29 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1257243074.23110.779.camel@zakaz.uk.xensource.com>
In-Reply-To: <1257243074.23110.779.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911041904.29362.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009 08:41:14 pm Ian Campbell wrote:
> nr_processes() returns the sum of the per cpu counter process_counts for
> all online CPUs. This counter is incremented for the current CPU on
> fork() and decremented for the current CPU on exit(). Since a process
> does not necessarily fork and exit on the same CPU the process_count for
> an individual CPU can be either positive or negative and effectively has
> no meaning in isolation.
> 
> Therefore calculating the sum of process_counts over only the online
> CPUs omits the processes which were started or stopped on any CPU which
> has since been unplugged. Only the sum of process_counts across all
> possible CPUs has meaning.
> 
> The only caller of nr_processes() is proc_root_getattr() which
> calculates the number of links to /proc as
>         stat->nlink = proc_root.nlink + nr_processes();
> 
> You don't have to be all that unlucky for the nr_processes() to return a
> negative value leading to a negative number of links (or rather, an
> apparently enormous number of links). If this happens then you can get
> failures where things like "ls /proc" start to fail because they got an
> -EOVERFLOW from some stat() call.
> 
> Example with some debugging inserted to show what goes on:
>         # ps haux|wc -l
>         nr_processes: CPU0:     90
>         nr_processes: CPU1:     1030
>         nr_processes: CPU2:     -900
>         nr_processes: CPU3:     -136
>         nr_processes: TOTAL:    84
>         proc_root_getattr. nlink 12 + nr_processes() 84 = 96
>         84
>         # echo 0 >/sys/devices/system/cpu/cpu1/online
>         # ps haux|wc -l
>         nr_processes: CPU0:     85
>         nr_processes: CPU2:     -901
>         nr_processes: CPU3:     -137
>         nr_processes: TOTAL:    -953
>         proc_root_getattr. nlink 12 + nr_processes() -953 = -941
>         75
>         # stat /proc/
>         nr_processes: CPU0:     84
>         nr_processes: CPU2:     -901
>         nr_processes: CPU3:     -137
>         nr_processes: TOTAL:    -954
>         proc_root_getattr. nlink 12 + nr_processes() -954 = -942
>           File: `/proc/'
>           Size: 0               Blocks: 0          IO Block: 1024   directory
>         Device: 3h/3d   Inode: 1           Links: 4294966354
>         Access: (0555/dr-xr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
>         Access: 2009-11-03 09:06:55.000000000 +0000
>         Modify: 2009-11-03 09:06:55.000000000 +0000
>         Change: 2009-11-03 09:06:55.000000000 +0000
> 
> I'm not 100% convinced that the per_cpu regions remain valid for offline
> CPUs, although my testing suggests that they do.

Yep.  And so code should usually start with for_each_possible_cpu() then:

> If not then I think the
> correct solution would be to aggregate the process_count for a given CPU
> into a global base value in cpu_down().

If it proves to be an issue.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.
