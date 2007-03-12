Return-Path: <linux-kernel-owner+w=401wt.eu-S1030616AbXCLQdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030616AbXCLQdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030603AbXCLQdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:33:44 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:23972 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030616AbXCLQdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:33:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QWXeXHV4T/NRet7m+43retKAbA9/kseTz6zJ+d8oZUHJ7WBA63elOj07EzR0nLKTUNkXso7UJOeKGJ248cFlNQmcsiXVCYe/P4taPEXMaU0SV+yzu/cvX16ITMQ5E8K6hSZi29FuHYviqRNjp07qQ+AphV2xZzQ9zPIzoPr6kM8=
Message-ID: <f2b55d220703120926k1ab7112fh60227fac670b8b4c@mail.gmail.com>
Date: Mon, 12 Mar 2007 09:26:22 -0700
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: 7eggert@gmx.de
Subject: Re: sys_write() racy for multi-threaded append?
Cc: "Eric Dumazet" <dada1@cosmosbay.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <E1HQfLX-0000fk-68@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7WzUo-1zl-21@gated-at.bofh.it> <7WAx2-2pg-21@gated-at.bofh.it>
	 <7WAGF-2Bx-9@gated-at.bofh.it> <7WB07-3g5-33@gated-at.bofh.it>
	 <7WBt7-3SZ-23@gated-at.bofh.it> <E1HQfLX-0000fk-68@be1.lrz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/07, Bodo Eggert <7eggert@gmx.de> wrote:
> Michael K. Edwards <medwards.linux@gmail.com> wrote:
> > Actually, I think it would make the kernel (negligibly) faster to bump
> > f_pos before the vfs_write() call.
>
> This is a security risk.
>
> ----------------
> other process:
> unlink(secrest_file)
>
> Thread 1:
> write(fd, large)
> (interrupted)
>
> Thread 2:
> fseek(fd, -n, relative)
> read(fd, buf)
> ----------------

I don't entirely follow this.  Which process is supposed to be secure
here, and what information is supposed to be secret from whom?  But in
any case, are you aware that f_pos is clamped to the inode's
max_bytes, not to the current file size?  Thread 2 can seek/read past
the position at which Thread 1's write began, whether f_pos is bumped
before or after the vfs_write.

> BTW: The best thing you can do to a program where two threads race for
> writing one fd is to let it crash and burn in the most spectacular way
> allowed without affecting the rest of the system, unless it happens to
> be a pipe and the number of bytes written is less than PIPE_MAX.

That's fine when you're doing integration test, and should probably be
the default during development.  But if the race is first exposed in
the field, or if the developer is trying to concentrate on a different
problem, "spectacular crash and burn" may do more harm than good.
It's easy enough to refactor the f_pos handling in the kernel so that
it all goes through three or four inline accessor functions, at which
point you can choose your trade-off between speed and idiot-proofness
-- at _kernel_ compile time, or (given future hardware that supports
standardized optionally-atomic-based-on-runtime-flag operations) per
process at run-time.

Frankly, I think that unless application programmers poke at some sort
of magic "I promise to handle short writes correctly" bit, write()
should always return either the full number of bytes requested or an
error code.  If they do poke at that bit, the (development) kernel
should deliberately split writes a few percent of the time, just to
exercise the short-write code paths.  And in order to find out where
that magic bit is, they should have to read the kernel code or ask on
LKML (and get the "standard lecture").

Really very IEEE754-like, actually.  (Harp, harp.)

Cheers,
- Michael
