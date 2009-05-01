Return-Path: <linux-kernel-owner+w=401wt.eu-S1765190AbZEAT44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765190AbZEAT44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 15:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762019AbZEAT4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 15:56:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753444AbZEAT43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 15:56:29 -0400
Date: Fri, 1 May 2009 12:53:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: peterz@infradead.org, rientjes@google.com, david@fromorbit.com,
       cl@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: prevent divide error for small values of
 vm_dirty_bytes
Message-Id: <20090501125317.599c3af8.akpm@linux-foundation.org>
In-Reply-To: <20090501145639.GA24443@linux>
References: <1240993759-30787-1-git-send-email-righi.andrea@gmail.com>
	<1240994676.8021.83.camel@laptop>
	<20090429093449.GB3151@linux>
	<20090429144655.e60fdf7a.akpm@linux-foundation.org>
	<20090501145639.GA24443@linux>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009 16:56:40 +0200
Andrea Righi <righi.andrea@gmail.com> wrote:

> On Wed, Apr 29, 2009 at 02:46:55PM -0700, Andrew Morton wrote:
> > On Wed, 29 Apr 2009 11:34:51 +0200
> > Andrea Righi <righi.andrea@gmail.com> wrote:
> > 
> > > --- a/Documentation/sysctl/vm.txt
> > > +++ b/Documentation/sysctl/vm.txt
> > > @@ -90,6 +90,10 @@ will itself start writeback.
> > >  If dirty_bytes is written, dirty_ratio becomes a function of its value
> > >  (dirty_bytes / the amount of dirtyable system memory).
> > >  
> > > +Note: the minimum value allowed for dirty_bytes is two pages (in bytes); any
> > > +value lower than this limit will be ignored and the old configuration will be
> > > +retained.
> > 
> > Well.  This implies that the write to the procfs file would appear to
> > succeed.  One hopes that the write would in fact return -EINVAL or
> > such?
> 
> I definitely agree. Just tested the following patch and it looks much
> better with the error code.
> 
> -Andrea
> 
> ---
> sysctl: return error code if values are not within a valid range
> 
> Currently __do_proc_doulongvec_minmax(), as well as
> __do_proc_dointvec(), simply skip the invalid values instead of return
> -EINVAL.

Oh geeze, I didn't know that.

> A more correct behaviour is to report to the userspace that some values
> were invalid and they couldn't be written instead of silently drop
> them.
> 
> For example (vm_dirty_bytes must be greater or equal than 2*PAGE_SIZE):
> - before:
>   # cat /proc/sys/vm/dirty_bytes
>   0
>   # /bin/echo 1 > /proc/sys/vm/dirty_bytes
>   # cat /proc/sys/vm/dirty_bytes
>   0
>   # /bin/echo 8192 > /proc/sys/vm/dirty_bytes
>   # cat /proc/sys/vm/dirty_bytes
>   8192
> 
> - after:
>   # cat /proc/sys/vm/dirty_bytes
>   0
>   # /bin/echo 1 > /proc/sys/vm/dirty_bytes
>   /bin/echo: write error: Invalid argument
>   # cat /proc/sys/vm/dirty_bytes
>   0
>   # /bin/echo 8192 > /proc/sys/vm/dirty_bytes
>   # cat /proc/sys/vm/dirty_bytes
>   8192
> 

Unfortunately the potential here for breaking existing userspace is
huge.  I think it's too late for us to fix this :(


