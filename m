Return-Path: <linux-kernel-owner+w=401wt.eu-S1764006AbYASBOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764006AbYASBOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 20:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761447AbYASBOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 20:14:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763504AbYASBOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 20:14:40 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Vinay Sridhar <vinay@linux.vnet.ibm.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org,
       drepper@redhat.com, wli@holomorphy.com, akpm@linux-foundation.org,
       sripathik@in.ibm.com
Subject: Re: [RFC] Per-thread getrusage
In-Reply-To: Vinay Sridhar's message of  Thursday, 17 January 2008 13:57:05 +0530 <1200558425.5992.17.camel@srivinay.in.ibm.com>
References: <1200558425.5992.17.camel@srivinay.in.ibm.com>
X-Zippy-Says: Fold, fold, FOLD!!  FOLDING many items!!
Message-Id: <20080119011413.4B2CD26F9FD@magilla.localdomain>
Date: Fri, 18 Jan 2008 17:14:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree that RUSAGE_THREAD is fine.  (In fact, if you'd pressed me to
remember without looking, I would have assumed we put it in already.)
However, in the implementation, I would keep it cleaner by moving the
identical code from inside the loop under case RUSAGE_SELF into a shared
subfunction, rather than duplicating it.  In fact, here you go (next posting).

As to getting arbitrary other threads' data, there are several problems
there.  Adding a syscall is often more trouble than it's worth.  Ulrich
cited the issues with that as the API.  You also didn't handle compat for
it correctly.  To warrant the code necessary to make this available by
whatever API, I think you need to say some more about what it's needed for.

Off hand, it seems most in keeping with other things to expose this via a
/proc file, i.e. /proc/tgid/task/tid/rusage and (/proc/tgid/rusage for the
RUSAGE_SELF behavior on a foreign process).  There we already have the
infrastructure for dealing with the security issues uniformly with how we
control other similar information.  Personally I tend to prefer a binary
interface, i.e. a virtual file whose contents are struct rusage; for that
you still need to do the extra compat work, since a 32-bit process should
have the 32-bit struct rusage layout in its /proc files.  If you put the
numbers into ascii text as some /proc interfaces do, you don't need any
special considerations for CONFIG_COMPAT.


Thanks,
Roland
