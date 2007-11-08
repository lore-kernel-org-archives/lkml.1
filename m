Return-Path: <linux-kernel-owner+w=401wt.eu-S1759479AbXKHIx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479AbXKHIx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 03:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbXKHIxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 03:53:50 -0500
Received: from ozlabs.org ([203.10.76.45]:47142 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450AbXKHIxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 03:53:50 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18226.52864.225837.882954@cargo.ozlabs.ibm.com>
Date: Thu, 8 Nov 2007 19:53:20 +1100
From: Paul Mackerras <paulus@samba.org>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, lkml@davidb.org, linux-kernel@vger.kernel.org,
       drepper@redhat.com, mtk-manpages@gmx.net
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
In-Reply-To: <20071107.222530.156152513.davem@davemloft.net>
References: <20071107190714.9c404e28.akpm@linux-foundation.org>
	<18226.38816.486372.52353@cargo.ozlabs.ibm.com>
	<20071107212005.f039c279.akpm@linux-foundation.org>
	<20071107.222530.156152513.davem@davemloft.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:

> On x86 only.  We could use force_successful_syscall_return()
> to make sure the condition codes get set correctly on
> other platforms.
> 
> But even in that case we'd still be broken when the return
> value is exactly -1 and that's what the application is going
> to compare against to test for errors.

We could special-case that and turn it into 0.  That would introduce a
0.01 second blip, which would be better than a 41 second window for
bad behaviour like we have at the moment.

It's also possible that many applications already don't check for
errors.  For example, glibc deliberately doesn't check for errors when
it calls __times in the clock() implementation.  There is a comment in
sysdeps/unix/sysv/linux/clock.c that says this:

  /* We don't check for errors here.  The only error the kernel
     returns is EFAULT if the value cannot be written to the struct we
     pass a pointer to.  Otherwise the kernel returns an `unsigned
     long' value which is the number of jiffies since system start.
     But this number can be negative (when read as `long') when the
     system is up for some time.  Ignoring errors should therefore
     have no negative impacts but solve the problem.  */
  __times (&buf);

Paul.

