Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbXKDHY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbXKDHY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 02:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbXKDHYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 02:24:19 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56234 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbXKDHYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 02:24:18 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: sukadev@us.ibm.com
Cc: Pavel Emelyanov <xemul@openvz.org>, Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [patch] PID namespace design bug, workaround
References: <20071101144307.GA29566@elte.hu> <4729E7E4.8070208@openvz.org>
	<4729E936.4040400@redhat.com> <4729EB3C.9050102@openvz.org>
	<472A6D91.1020300@redhat.com> <472AD7D6.80900@openvz.org>
	<20071102010419.23f3db5c.akpm@linux-foundation.org>
	<472ADC78.6070706@openvz.org> <472B2EBD.7070007@redhat.com>
	<472B327E.2060006@openvz.org> <20071103200154.GA23234@us.ibm.com>
Date: Sun, 04 Nov 2007 01:17:49 -0600
In-Reply-To: <20071103200154.GA23234@us.ibm.com> (sukadev@us.ibm.com's message
	of "Sat, 3 Nov 2007 13:01:54 -0700")
Message-ID: <m1fxzmbhsy.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sukadev@us.ibm.com writes:

> Pavel Emelianov [xemul@openvz.org] wrote:
> | Ulrich Drepper wrote:
> | > -----BEGIN PGP SIGNED MESSAGE-----
> | > Hash: SHA1
> | > 
> | > Pavel Emelyanov wrote:
> | >>> Isn't it this?
> | >>>
> | >>> http://lkml.org/lkml/2007/11/1/141
> | >> That was the initial problem, and I already answered to Ingo about
> | >> it
> | > 
> | > No, look at my old mail which Ingo referenced in that posting.
> | 
> | You pointed only one problem that is not a variation of "how do 
> | we handle the case when we pass our pid outside the namespace".
> | 
> | This problem with signals is now being resolved at IBM by Sukadev 
> | and Serge (I put them in Cc), so this is about to be fixed by the
> | time 2.6.24 releases (I hope).
>
> Yes. We (Oleg, Eric included in Cc) have a patchset to address signals
> issues in child pid namespaces. It is being discussed on Containers list:
>
> https://lists.linux-foundation.org/pipermail/containers/2007-October/008240.html
>
> We will post the patchset to LKML soon.

Yes.  Getting all of the cross namespace cases working that we can is a
goal.  Currently I don't know if we can do better with the futexes that
have pids in the user/kernel ABI.  Plain futexes should be fine.

Implementation wise si_pid is a bit of a pain but we should have that
one sorted out shortly.  It is a well understood and we just need to get
the code right.

The pids in the sysvipc space should also be fairly simple to handle
just do a classic struct pid conversion.  And convert from struct pid
to a pid_t right at the user/kernel interface.

Unless I missed something we already properly handle giving people
usable pids from the tty layer.

Getting pids working properly for unix domain socket credential when
we cross pid namespaces is another case that needs a struct pid
conversion to get things working, but the kernel should be able to
do the right thing at that point.

In summary when pids are stored inside the kernel we have all of the
needed infrastructure with struct pid to handle doing the right
thing processes communicate between pid namespaces.

Right now we just need to go through every place in the kernel make
certain we haven't over looked something we can handle.  And there
are a lot of places where the kernel uses pids....

Eric
