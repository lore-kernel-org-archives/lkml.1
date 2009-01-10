Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbZAJWQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbZAJWQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbZAJWP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:15:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38378 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509AbZAJWPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:15:55 -0500
Date: Sat, 10 Jan 2009 23:15:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       David Brown <lkml@davidb.org>, Phil Oester <kernel@linuxace.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Message-ID: <20090110221528.GA31774@elte.hu>
References: <20090108175338.2abbee16.akpm@linux-foundation.org> <4966B24E.1050700@lougher.demon.co.uk> <ac3eb2510901081824g38abc47g4619e80ffaf8f1c5@mail.gmail.com> <20090109023629.GA29520@linuxace.com> <20090109165422.GF24884@logfs.org> <20090109193738.GA9827@linode.davidb.org> <20090109211937.GA14342@logfs.org> <20090110124335.GB30744@elte.hu> <20090110165033.GA23943@logfs.org> <20090110101235.7ca24c44.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110101235.7ca24c44.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> More importantly, the filesystem driver has to be able to read older 
> filesystem instances.  This is a userspace-visible binary interface! A 
> really complex one.
> 
> If for some reason we wish to change the on-disk format then that could 
> be done now.  But once the code is merged, such changes could only be 
> done in a back-compatible way.

IMHO what makes squashfs special is that:

 1) it's read-only: i.e. we dont actually _generate_ this data structure.
    It comes from the outside.

 2) it's a the "cat is already out of the bag" situation.
    It's in the field, it's used.

And as such it's pretty much an externality already to Linux: the 
filesystem is in use, distros patch it in, devices ship with it, etc. etc.

So the main technical question at this stage is whether we want to support 
that binary format _at all_, whether we want to support that kind of data 
protocol.

Also, i think your interpretation of 'ABI' stretches it quite far: we dont 
control the lowlevel bits at all - we dont generate the data, we just 
interpret it in the kernel in a read-only way. We dont provide the raw 
lowlevel bits to user-space either - we provide VFS bindings to it and 
that is generalized and not touched by squashfs.

As such squashfs has little to no classic ABI bindings - other than the 
trivial "do we support this data format" question. (which is not a classic 
ABI question.)

[ Often such read-only formats can even be iterated slightly incompatibly 
  without much fuss, as the userspace side goes together with the kernel
  anyway so it's easy to stay in touch. ]

And the thing is, i think we never before in the kernel said "no" to any 
support for a data format externality. [Let me qualify that: 'unpure' data 
protocols with active 'code' components were always an exception to that: 
ACPI, reiser4, etc. - but read-only access to a passive medium is far more 
clear-cut.]

This is a nice filesystem, and we support far, far worse data formats 
already. Far, far, far, far worse data formats, formats that are less used 
and were developed completely regardless of Linux. We support data formats 
and physical transports that should not even be mentioned with squashfs in 
the same paragraph.

And the thing is, if in the mainline kernel we were at the forefront of FS 
R&D, we would and could prototype such filesystems in the mainline kernel 
and we would have efficient and prompt influence over lowlevel format 
decisions.

We are not at the forefront - distros tend to apply new filesystem patches 
far earlier than we do and it takes forever to get stuff upstream - for 
better or worse. And we (the upstream community) had little active role in 
developing this thing _at all_.

( This is not a criticism it's just an observation of current reality: it 
  is _fundamentally hard_ to do active high-flux R&D for persistent 
  formats upstream and still be reasonably compatible at the same time.
  So developing out-of-tree - or via FUSE - might as well be the right 
  model here. )

Generally when a filesystem driver comes to us, its lowlevel format is 
pretty much a done deal already - it's out in the wild and we should say 
'no' only as an exception mechanism for clearly unacceptable crap.

Instead of trying to flex our muscle and steer the big red firetruck way 
after the fire has been put out already - by others.

Saying 'no' at this stage comes at a great and largely unnecessary cost to 
everyone involved. I believe we force ourselves into the R&D flow at an 
inappropriately late stage - while at the same time we are unreceptive to 
early adopter projects who'd like to avoid that. We cannot have the cake 
and eat it too.

At least IMHO.

( What could _perhaps_ change the picture a bit IMO is drivers/staging/ i 
  think - we could take a far more active role in certain types of 
  projects that have been done out of tree typically, with no formal
  promise for compatibility - or something like that. )

	Ingo
