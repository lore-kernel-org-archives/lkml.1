Return-Path: <linux-kernel-owner+w=401wt.eu-S932304AbZHJQ4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbZHJQ4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932284AbZHJQ4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:56:22 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:54358 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932237AbZHJQ4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:56:21 -0400
Subject: Re: Possible memory leak via alloc_pid()
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
In-Reply-To: <m1ws5lekmy.fsf@fess.ebiederm.org>
References: <b0943d9e0907081433y599e6d51j285c390f18d7b32c@mail.gmail.com>
	 <20090729170315.f62066c0.akpm@linux-foundation.org>
	 <20090730212956.GA26863@redhat.com>
	 <1249035398.29967.8.camel@pc1117.cambridge.arm.com>
	 <20090802213528.GA18795@redhat.com>  <m1ws5lekmy.fsf@fess.ebiederm.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 10 Aug 2009 17:55:58 +0100
Message-Id: <1249923358.10848.75.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2009 16:55:59.0932 (UTC) FILETIME=[6FE56FC0:01CA19DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-02 at 18:44 -0700, Eric W. Biederman wrote:
> Hmm.  I'm starting to wonder if kmemleak is right.  I don't know how
> it works but something about the way pids are used might be confusing it.

It could as well be a false positive but I can't find its source.

Basically, the pid structure for the dead Xorg is still allocated
minutes after Xorg died with a pid->count of 2. Kmemleak scans the data
and bss sections, task stacks and most of the allocated objects (which
are not reported as leaks) but cannot find a pointer to this pid
structure (or anywhere inside it like pid->number.pid_chain).

The supposedly leaked pid structure also have pid_chain.pprev ==
LIST_POISON2 which means that it was already removed from the pid_hash
(this block of memory is scanned by kmemleak anyway).

The free_pid() function was also called on this object according to the
pid->rcu values but put_pid() couldn't free it because of pid->count.

If this structure in not on pid_hash, is there any other place where its
pointer may be stored for a long time? Otherwise it looks like a real
leak (though not a big one).

I'll do more tests in the next few days as suggested by Oleg.

-- 
Catalin

