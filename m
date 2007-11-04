Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbXKDKjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbXKDKjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 05:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbXKDKjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 05:39:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54684 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755028AbXKDKjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 05:39:13 -0500
Date: Sun, 4 Nov 2007 11:38:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org,
       "Dinakar Guniguntala [imap]" <dino@in.ibm.com>,
       Sripathi Kodi <sripathik@in.ibm.com>
Subject: Re: [patch] PID namespaces
Message-ID: <20071104103851.GA14317@elte.hu>
References: <4729E7E4.8070208@openvz.org> <4729E936.4040400@redhat.com> <4729EB3C.9050102@openvz.org> <472A6D91.1020300@redhat.com> <472AD7D6.80900@openvz.org> <20071102010419.23f3db5c.akpm@linux-foundation.org> <1194024622.6271.108.camel@localhost> <alpine.LFD.0.999.0711021038480.3342@woody.linux-foundation.org> <20071103201251.GB26366@elte.hu> <alpine.LFD.0.999.0711031535450.15101@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0711031535450.15101@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(changed the Subject line)

* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 3 Nov 2007, Ingo Molnar wrote:
> > 
> > - one problem is that this condition is 'invisible'. If two 
> >   namespaces happen to access the same robust futex (say a yum 
> >   update from two PID namespaces sharing the same read-mostly 
> >   filesystem) there's silent breakage and data corruption due to PID 
> >   overlap.
> 
> .. and this is in *no* way different from thousands of applications 
> that write their pid to lock-files, and others decide that it's 
> "stale" because using "kill(pid, 0)" returns that the pid doesn't 
> exist any more.
> 
> The solution? You can't do that kind of locking over NFS, or across 
> pid namespaces. Nobody blames NFS or pid namespaces for it.

the difference to NFS is that for PID namespaces we do have a single 
trusted kernel that fully controls all the domains so there's no obvious 
"hard barrier of trust" that people could perceive as a showstopper.

We've got a global kernel and unlike other namespaces there's (almost) 
no "directed allocation" done of specific PIDs (unlike files, socket 
addresses or fds). So the PID is a cookie that is 99.9% shaped _by the 
kernel already_. [there are a few exceptions but those are much less 
problematic than the lack of global PIDs is] So we might as well shape 
the cookies in a way that keeps them global. What is the technological 
reason for not keeping PIDs globally unique? We've cited a good number 
of reasons why it's desirable - it's a pretty damn useful cookie for 
identifying tasks. (it's also very scalable - PID -> task lookup is 
completely lockless.)

I.e. keep the namespace functionality but use a modulo 1.000.000 base 
for the PIDs so that it all looks nicer to the user. Minimal visibility 
difference but maximum compatibility. (The resulting limits are 
reasonable: 1 million tasks per container and 4 million containers on a 
single 32-bit box.) We could still restrict cross-namespace API use but 
all the cases where a global PID is desirable would still all work. I 
might be missing something obvious though.

The reason why i bring this up now is because 2.6.24 is an 
all-or-nothing flag day for this detail. Once it's out there we wont 
realistically be able to change any of these details. (And in general 
i'm very supportive of the containers concept - a year ago at the KS i 
was one of the very few proponents of quickly merging containers into 
the kernel.)

	Ingo
