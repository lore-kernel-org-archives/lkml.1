Return-Path: <linux-kernel-owner+w=401wt.eu-S1758535AbZDQA2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535AbZDQA2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbZDQA2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:28:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55184 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820AbZDQA2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:28:08 -0400
Date: Fri, 17 Apr 2009 02:27:44 +0200
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
Message-ID: <20090417002744.GB29630@elte.hu>
References: <1239892078-6039-1-git-send-email-abogani@texware.it> <20090416160645.GB17804@elte.hu> <20090416235649.GF26366@ZenIV.linux.org.uk> <20090417000142.GF21405@elte.hu> <20090417001345.GH26366@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417001345.GH26366@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Fri, Apr 17, 2009 at 02:01:42AM +0200, Ingo Molnar wrote:
> > 
> > * Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > 
> > > remount is potentially nastier, but then it *is* nasty.  Again, 
> > > it's only per-fs stuff, so the obvious first step is taking BKL 
> > > down into the instances. It doesn't protect anything in VFS; all 
> > > uses are fs internal, so that'll take review of individual 
> > > filesystems.
> > > 
> > > NOTE: do not assume that code in fs/foo/* is correct; "it doesn't 
> > > take BKL elsewhere" does _not_ mean that we don't have races.  
> > > IOW, the same review ought to look for such beasts and deal with 
> > > them.  Mere "oh, no BKL anywhere in that fs" is not enough to 
> > > discard the ->remount_fs() instance.
> > 
> > what kind of races do you mean? Timing sensitive ones that are there 
> > just are not easy to trigger with the BKL held?
> > 
> > Or actual locking interaction between that body of BKL code and 
> > all other BKL using code?
> 
> Old foo_read_super/foo_write_super/foo_put_super/foo_remount_fs 
> for the same foo.  IOW, per-driver (and not per-fs - that's taken 
> care of) data structures.  Arbitrary weird ones.

Could you give an example of such a weird interaction?

I fear, unless i'm misunderstanding your feedback, that you are 
setting the purist's irrealistically high burden to get rid of the 
BKL from the VFS here.

"Arbitrary weird ones" means all BKL using sites in the kernel - all 
~800 ones - up to 800x800 == close to a million interactions to 
check.

That's not manageable humanly, nor does it really matter: most BKL 
assumptions have bit-rotted anyway already (by the sheer entropy of 
kernel facilities growing new schedule() sites or moving them, over 
a period of 10 years or more) and many BKL using drivers are broken 
already or dont need it at all.

Thanks,

	Ingo
