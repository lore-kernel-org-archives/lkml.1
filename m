Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbXDZXZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbXDZXZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbXDZXZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:25:41 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755203AbXDZXZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:25:39 -0400
Date: Thu, 26 Apr 2007 16:25:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utimensat implementation
Message-Id: <20070426162530.bc30a1bb.akpm@linux-foundation.org>
In-Reply-To: <200704262249.l3QMn5C2021588@devserv.devel.redhat.com>
References: <200704262249.l3QMn5C2021588@devserv.devel.redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 18:49:05 -0400 Ulrich Drepper <drepper@redhat.com> wrote:

> 
> The next revision of POSIX will support fine-grained filesystem timestamps the way we already support.  struct stat will report nanosecond values.  So far so good.
> 
> During the development one additional problem was found: there is no interface to set the file timestamp with that precision.  utimes only takes a timeval structure which allows only micro-second resolution.

Does the spec say what the OS should do if (ts_nsec => 1e9)?

> This is why the utimensat() interface was created.  It is basically the same as our futimesat() interface but it takes a timespec structure.
> 
> While adding this new interface two more features got added.  Programmers sometimes/often only want to set one value.  This currently requires reading the current value with stat() and then use this value in the futimesat() call.  This is slow and might create even wrong results (the file could have been updated in the meantime).  If the tv_nsec value of either of the elements of the utimes parameter to utimensat() is UTIME_OMIT no update of that respective value is performed.

ITYM "If the value of either of the elements..."

+#define UTIME_NOW	((1l << 30) - 1l)
+#define UTIME_OMIT	((1l << 30) - 2l)

OK, so there's no collision on ts_nsec if unnormalised timespecs are
disallowed.

But there's a potential collision on ts_sec?  Do we know what date that
corresponds to?

> The second extension allows to set one of the values to the correct current time.  Today it is only possible to set both values at the same time.  Once again this is slower and might to lead to incorrect results.  The use of UTIME_NOW for the respective tv_nsec value implements this functionality.
> 
> The resulting patch is attached.  It modifies the do_utimes function which is also used in the compat code.  The callers are adjusted.  Most of the added code are checks for invalid parameters.  In fact, I think one problem where the old code wouldn't recognize certain overflows (if tv_nsec * 1000 overflows).
> 
> I've tested the code on x86-64.

Do you have a testcase app which can be used by arch maintainers?

