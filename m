Return-Path: <linux-kernel-owner+w=401wt.eu-S1761791AbZDQQ5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761791AbZDQQ5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbZDQQ5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:57:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34689 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630AbZDQQ5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:57:02 -0400
Date: Fri, 17 Apr 2009 18:56:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alessio Igor Bogani <abogani@texware.it>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -tip] remove the BKL: Replace BKL in mount/umount
	syscalls with a mutex
Message-ID: <20090417165643.GL8253@elte.hu>
References: <1239892078-6039-1-git-send-email-abogani@texware.it> <20090416160645.GB17804@elte.hu> <20090416235649.GF26366@ZenIV.linux.org.uk> <20090417000142.GF21405@elte.hu> <20090417001345.GH26366@ZenIV.linux.org.uk> <20090417002744.GB29630@elte.hu> <20090417003805.GI26366@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417003805.GI26366@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ZenIV.linux.org.uk> wrote:


> > > Old 
> > > foo_read_super/foo_write_super/foo_put_super/foo_remount_fs 
> > > for the same foo.  IOW, per-driver (and not per-fs - that's 
> > > taken care of) data structures.  Arbitrary weird ones.
[...]
> > I fear, unless i'm misunderstanding your feedback, that you are 
> > setting the purist's irrealistically high burden to get rid of the 
> > BKL from the VFS here.
> > 
> > "Arbitrary weird ones" means all BKL using sites in the kernel - all 
> > ~800 ones - up to 800x800 == close to a million interactions to 
> > check.
> 
> Sigh...  How about dumping that lovely strawman?  I've 
> exsoddingplicitly told you that all such stuff is *within* 
> *individual* *fs* *driver*.

Ah, i misunderstood: "per-driver (and not per-fs" to mean to include 
all other BKL-using Linux drivers as well ;-)

The 'not per-fs' excluded the 'fs driver' meaning (to me).

Per fs analysis is of course a must-review if we weaken or change 
locking.

> Start with taking these guys down into the superblock methods in question.
> Drop that junk on VFS-only side of things completely (mount --move,
> mount --bind, etc.).  Then we go looking for data structures that are
> 	a) internal to fs driver
> 	b) accessed by methods in question (in that fs driver)
> 	c) are shared between different filesystems.
> 
> Analysis is on per-fs basis.  And getting rid of these turds 
> doesn't have to happen in one patch.

Stupid question regarding c): wouldnt such data structures go via 
the VFS - which you said was free of BKL constraints? Or are there 
interconnected private data structures between certain types of 
closely related filesystems that the VFS does not know about? (and 
hence might have BKL assumptions)

	Ingo
