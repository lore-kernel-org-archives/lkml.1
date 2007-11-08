Return-Path: <linux-kernel-owner+w=401wt.eu-S1760117AbXKHDIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117AbXKHDIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 22:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbXKHDIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 22:08:09 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57151 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753539AbXKHDIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 22:08:09 -0500
Date: Wed, 7 Nov 2007 19:07:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: lkml@davidb.org, linux-kernel@vger.kernel.org, drepper@redhat.com,
       mtk-manpages@gmx.net
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
Message-Id: <20071107190714.9c404e28.akpm@linux-foundation.org>
In-Reply-To: <18226.27701.782268.375231@cargo.ozlabs.ibm.com>
References: <20071107224722.GA20204@old.davidb.org>
	<20071107152833.6f302c2a.akpm@linux-foundation.org>
	<20071107161853.044b6e8f.akpm@linux-foundation.org>
	<18226.27701.782268.375231@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 8 Nov 2007 12:53:57 +1100 Paul Mackerras <paulus@samba.org> wrote:
> Andrew Morton writes:
> 
> > Given all this stuff, the return value from sys_times() doesn't seem a
> > particularly useful or reliable kernel interface.
> 
> I think the best thing would be to ignore any error from copy_to_user
> and always return the number of clock ticks.  We should call
> force_successful_syscall_return, and glibc on x86 should be taught not
> to interpret negative values as an error.

Changing glibc might be hard ;)

> POSIX doesn't require us to return an EFAULT error if the buf argument
> is bogus.  If userspace does supply a bogus buf pointer, then either
> it will dereference it itself and get a segfault, or it won't
> dereference it, in which case it obviously didn't care about the
> values we tried to put there.
> 
> If we try to return an error under some circumstances, then there is
> at least one 32-bit value for the number of ticks that will cause
> confusion.  We can either change that value (or values) to some other
> value, which seems pretty bogus, or we can just decide not to return
> any errors.  The latter seems to me to have no significant downside
> and to be the simplest solution to the problem.

"the latter" is what my protopatch does isn't it?  It wraps at 0x7fffffff.
It appears that glibc treats all of 0x80000000-0xffffffff as an error.
