Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbYGaTN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbYGaTN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757854AbYGaTNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:13:31 -0400
Received: from relay2.sgi.com ([192.48.171.30]:52733 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757845AbYGaTNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:13:30 -0400
Date: Thu, 31 Jul 2008 14:13:28 -0500
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: rakib.mullick@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Removes extra checking in kernel/cpuset.c
Message-Id: <20080731141328.0e2f4bce.pj@sgi.com>
In-Reply-To: <6599ad830807311009o4275c0d0k84d4a5d4eadc3f41@mail.gmail.com>
References: <b9df5fa10807310846g27913d82icf2a82e77992ba9f@mail.gmail.com>
	<20080731111522.6417f750.pj@sgi.com>
	<6599ad830807311009o4275c0d0k84d4a5d4eadc3f41@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> True, but if top_cpuset.cpus_allowed doesn't intersect with
> cpu_online_map then maybe we have other problems?

Good point.

... if I did agree to this patch, there are two nits that would have
to be fixed, and the patch resubmitted:

 1) The file pathnames should be one level deeper.  As stated in
    Documentation/applying-patches.txt:

	This means that paths to files inside the patch file contain the name of the
	kernel source directories it was generated against (or some other directory
	names like "a/" and "b/").

    This patch has:

	--- kernel/cpuset.c.orig	2008-07-31 17:03:34.000000000 +0600
	+++ kernel/cpuset.c	2008-07-31 21:33:34.000000000 +0600

    There needs to be one more level of path, as in:

	--- a/kernel/cpuset.c	2008-07-31 17:03:34.000000000 +0600
	+++ b/kernel/cpuset.c	2008-07-31 21:33:34.000000000 +0600

    I prefer to use specific directory names here, reflecting the
    actual kernel version used in the development, as in:

	--- 2.6.27-rc1-mm1.orig/kernel/cpuset.c	2008-07-31 17:03:34.000000000 +0600
	+++ 2.6.27-rc1-mm1/kernel/cpuset.c	2008-07-31 21:33:34.000000000 +0600

    (though "2.6.27-rc1-mm1" is not the actual version that was
    used in composing this patch -- I don't what version was used.)

 2) The spacing of the "else" should place it on the same line as the
    preceding closing "}" from the preceding "if (...) { ... }", as in:

        if (cs) {
                while (!cpus_intersects(cs->cpus_allowed, cpu_online_map))
                        cs = cs->parent;
                cpus_and(*pmask, cs->cpus_allowed, cpu_online_map);
        } else

    As submitted, the "else" was on the next line, by itself.


However ... I still don't like the patch all that much.  Granted, it
seems to save a few bytes of kernel text space (11 bytes on my x86_64
build), which is always tempting.

My problem with the patch is that it entangles the logic a (slight)
little bit more.  This can be seen in the above observation of Paul M,
which is -needed- in the case of the new code to prove that the kernel
can't crash here, but is not needed in the case of the old code to help
prove that.

I work very hard in code to minimize the special cases and conditions
that need to be in affect for each code statement.  Doing so makes for
more robust code, that is easier to understand, and less likely to get
broken by some future change.

I am presuming here that this code change was motivated by reading the
source code and noticing that it resulted in some non-essential runtime
checks for "cs" not being NULL.  If this proposed change was motivated
by actual performance analysis -- some real life need to optimize this
code path more than I ever imagined it needed to be optimized, then my
bias would change, toward accepting this patch.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
