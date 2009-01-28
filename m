Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbZA1Dmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbZA1Dmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 22:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbZA1DmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 22:42:25 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:21161 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbZA1DmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 22:42:24 -0500
Date: Tue, 27 Jan 2009 19:41:14 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Louis Rilling <louis.rilling@kerlabs.com>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com, swhiteho <swhiteho@redhat.com>
Subject: Re: [PATCH] configfs: Silence lockdep on mkdir(), rmdir() and
	configfs_depend_item()
Message-ID: <20090128034114.GC7244@mail.oracle.com>
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Louis Rilling <louis.rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
	swhiteho <swhiteho@redhat.com>
References: <20081212100615.GD19128@hawkmoon.kerlabs.com> <1229095751-23984-1-git-send-email-louis.rilling@kerlabs.com> <20081217134020.42da55fc.akpm@linux-foundation.org> <1229585208.9487.112.camel@twins> <20081218092744.GB30789@mail.oracle.com> <1229601399.9487.218.camel@twins> <1229603308.9487.227.camel@twins> <20081218225837.GB21870@mail.oracle.com> <1232973009.4863.76.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232973009.4863.76.camel@laptop>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.497FD409.00DD:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 01:30:09PM +0100, Peter Zijlstra wrote:
> I don't think I was suggesting that. All you need is to serialize any
> mkdir/creat against the rmdir of the youngest non-default group, and you
> can do that by holding su_mutex.
> 
> In rmdir, you already own all the i_mutex instances you need to uncouple
> the whole tree, all you need to do is validate that its indeed empty --
> you don't need i_mutex's for that, because you're holding su_mutex, and
> any concurrent mkdir/creat will be blocking on that.
> 
> If you find it empty, just mark everybody DEAD, drop su_mutex and
> decouple. All concurrent mkdir/creat thingies that were blocking will
> now bail because their parent is found DEAD.

	Right, that's what I was talking about when I said:

> > 	Now look in detach_groups().  We drop the groups children before
> > marking them DEAD.  Louis' plan, I think, is to perhaps mark a group
> > DEAD, disconnect it from the vfs, and then operate on its children.  In
> > this fashion, perhaps we can unlock the trailing lock like a normal VFS
> > operation.
> > 	This will require some serious auditing, however, because now
> > vfs functions can get into the vfs objects behind us.  And more vfs
> > changes affect us.  Whereas the current locking relies on the vfs's
> > parent->child lock ordering only, something that isn't likely to be
> > changed.
 
	That is, the vfs has already walked past this directory,
dropped i_mutex, and is in a child default group holding its i_mutex.
It wants to mkdir(2) down there.  You're saying that, if mkdir(2) holds
su_mutex higher up, it can check S_DEAD and compare with us, and that's
exactly the scheme I mentioned in the first of the quoted paragraphs
(Louis proposed it a while back).  Thus, though we don't hold i_mutex on that
child, it will eventually either a) have gotten su_mutex first, and will
cause rmdir to ENOTEMPTY or b) have gotten su_mutex second, will see
S_DEAD, and return -ENOENT.  As far as preventing mkdir(2), I don't see
why it wouldn't work.
	The issue is in that second quoted paragraph.  We know that the
VFS can look up our children if we're not holding i_mutex.  In fact,
cached_lookup() can find them without i_mutex.  Now, we know that
mkdir(2) and rmdir(2) will block at su_mutex.  But what about all other
file operations, both on the child directories *and* the attribute
files?  For attribute files, we prevent access at creation time with a
flag.  We can trust the flag because we hold i_mutex.  This might hold
anyway because we're holding that toplevel i_mutex.  At teardown time,
though, we know they can't be found because of i_mutex.  Now we don't
have that protection for processes that are farther down the tree.
	But the bigger issue is just the plain regular operations on our
directories.  An example is ->readdir().  We currently lock out
->readdir() during rmdir(2) with our holding of i_mutex.  However, if we
are not holding i_mutex, vfs_readdir() can call into our ->readdir()
right as we're tearing things down.  We may not have gotten to S_DEAD
yet in the rmdir(2) path, and the two will race.  We can't take su_mutex
in ->readdir(), because that sort of solution effectively says "we have
to take su_mutex for all operations", and we end up serializing all
operations on a subsustem.
	Now, I can think of a way to make ->readdir() safe without
su_mutex.  But what other operation is next?  How do I know I have them
all?  How do I notice when someone adds a new operation or code path to
the generic code that I have to protect against?  With i_mutex, I *know*
that everyone has agreed that is the gatekeeper.  Without it...
	*That's* the big worry.  That's what I'm worried about being
sure of.  I'd love to hear a solution that we know will work, or at
least move towards one.

Joel
	
PS:  And we haven't even talked about configfs_depend_item() yet.

-- 

Life's Little Instruction Book #252

	"Take good care of those you love."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
