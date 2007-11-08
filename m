Return-Path: <linux-kernel-owner+w=401wt.eu-S1760200AbXKHGMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbXKHGMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 01:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbXKHGM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 01:12:27 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32827 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750857AbXKHGM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 01:12:27 -0500
Date: Wed, 7 Nov 2007 22:12:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: lkml@davidb.org, linux-kernel@vger.kernel.org, drepper@redhat.com,
       mtk-manpages@gmx.net
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
Message-Id: <20071107221200.f5560df0.akpm@linux-foundation.org>
In-Reply-To: <18226.41032.912666.467900@cargo.ozlabs.ibm.com>
References: <20071107224722.GA20204@old.davidb.org>
	<20071107152833.6f302c2a.akpm@linux-foundation.org>
	<20071107161853.044b6e8f.akpm@linux-foundation.org>
	<18226.27701.782268.375231@cargo.ozlabs.ibm.com>
	<20071107190714.9c404e28.akpm@linux-foundation.org>
	<18226.38816.486372.52353@cargo.ozlabs.ibm.com>
	<20071107212005.f039c279.akpm@linux-foundation.org>
	<18226.41032.912666.467900@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 8 Nov 2007 16:36:08 +1100 Paul Mackerras <paulus@samba.org> wrote:
> Andrew Morton writes:
> 
> > Yup.  But userspace will already have a fit if either the start or end time
> > advanced into the glibc-thought-that-was-an-error range.
> 
> Not nearly as much of a fit.  The effect on x86 is that values between
> -4095 and -1 are reported as -1, so the end-start difference will be
> out by less than 41 seconds.  That's not nearly as dramatic as a
> difference of 21 million seconds (over 16 years). :)
> 
> I really think that wrapping at 0x7fffffff makes the situation worse,
> not better.
> 

Sure.

So we need to do what you say: never return an error from sys_times() and
change glibc to not perform error-interpretation on sys_times() return
values and recommend that people bypass libc and go direct to the syscall
so they'll work correctly on older glibc.   Lovely.

I wonder what happens with things like F_GETOWN, shmat() and lseek(/dev/mem)
on x86 (things which use force_successful_syscall_return()).  According
to the comment in include/linux/ptrace.h, glibc should be special-casing
these.
