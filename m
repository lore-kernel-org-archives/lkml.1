Return-Path: <linux-kernel-owner+w=401wt.eu-S1759227AbXKGX3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227AbXKGX3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 18:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbXKGX3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 18:29:04 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37878 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753453AbXKGX3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 18:29:03 -0500
Date: Wed, 7 Nov 2007 15:28:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brown <lkml@davidb.org>
Cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>,
       Michael Kerrisk <mtk-manpages@gmx.net>
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
Message-Id: <20071107152833.6f302c2a.akpm@linux-foundation.org>
In-Reply-To: <20071107224722.GA20204@old.davidb.org>
References: <20071107224722.GA20204@old.davidb.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 7 Nov 2007 14:47:22 -0800 David Brown <lkml@davidb.org> wrote:
> compat_sys_times() has bogus return until jiffies is >= 0.  I discovered
> this running LTP within 5 minutes of booting.
> 
> The return result
> 
> 	return compat_jiffies_to_clock_t(jiffies);
> 
> will return '-1' to user space and set the negated clock_t value to errno.
> 
> I'm not sure what the correct fix for this is.  I can come up with a patch
> if anyone has ideas on how to fix it.
> 
> At minimum, perhaps it should return a sane errno value.

RETURN VALUE
       times()  returns  the  number of clock ticks that have elapsed since an
       arbitrary point in the past.  For Linux 2.4 and earlier this  point  is
       the  moment  the  system  was  booted.   Since Linux 2.6, this point is
       (2^32/HZ) - 300 (i.e., about 429 million) seconds  before  system  boot
       time.   The  return  value  may  overflow  the  possible  range of type
       clock_t.  On error, (clock_t) -1 is returned, and errno is  set  appro-
       priately.


Perhaps this is a bug in glibc: it is interpreting the times() return value
in the same way as other syscalls.

It would have been sensible for us to add INITIAL_JIFFIES to the value
instead of exposing this kernel-only detail to the world, although the
problem will of course reoccur once jiffies hits 0x80000000.  Unfortunately
we've even gone and enshrined this bogon in the manpage.

Proposed fix:

-        return compat_jiffies_to_clock_t(jiffies);
+        return compat_jiffies_to_clock_t((jiffies + INITIAL_JIFFIES) &
+						0x7fffffff);

?
