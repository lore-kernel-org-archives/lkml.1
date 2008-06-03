Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbYFCRrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbYFCRrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbYFCRr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:47:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbYFCRr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:47:26 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Ian Kent <raven@themaw.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, jesper@krogh.cc,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Linux 2.6.26-rc4
References: <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk>
	<E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu>
	<20080603104035.GT28946@ZenIV.linux.org.uk>
	<E1K3U1F-0005le-07@pomaz-ex.szeredi.hu>
	<20080603105258.GV28946@ZenIV.linux.org.uk>
	<1212499623.3025.46.camel@raven.themaw.net>
	<alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
	<1212509263.3025.66.camel@raven.themaw.net>
	<alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org>
	<1212513189.3025.101.camel@raven.themaw.net>
	<20080603173029.GD28946@ZenIV.linux.org.uk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 03 Jun 2008 13:46:41 -0400
In-Reply-To: <20080603173029.GD28946@ZenIV.linux.org.uk> (Al Viro's message of
	"Tue, 3 Jun 2008 18:30:30 +0100")
Message-ID: <x49ej7ejtry.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Wed, Jun 04, 2008 at 01:13:08AM +0800, Ian Kent wrote:
>
>> "What happens is that during an expire the situation can arise
>> that a directory is removed and another lookup is done before
>> the expire issues a completion status to the kernel module.
>> In this case, since the the lookup gets a new dentry, it doesn't
>> know that there is an expire in progress and when it posts its
>> mount request, matches the existing expire request and waits
>> for its completion. ENOENT is then returned to user space
>> from lookup (as the dentry passed in is now unhashed) without
>> having performed the mount request.
>> 
>> The solution used here is to keep track of dentrys in this
>> unhashed state and reuse them, if possible, in order to
>> preserve the flags. Additionally, this infrastructure will
>> provide the framework for the reintroduction of caching
>> of mount fails removed earlier in development."
>> 
>> I wasn't able to do an acceptable re-implementation of the negative
>> caching we had in 2.4 with this framework, so just ignore the last
>> sentence in the above description. 
>
>> Unfortunately no, but I thought that once the dentry became unhashed
>> (aka ->rmdir() or ->unlink()) it was invisible to the dcache. But, of
>> course there may be descriptors open on the dentry, which I think is the
>> problem that's being pointed out.
>  
> ... or we could have had a pending mount(2) sitting there with a reference
> to mountpoint-to-be...
>
>> Yes, that would be ideal but the reason we arrived here is that, because
>> we must release the directory mutex before calling back to the daemon
>> (the heart of the problem, actually having to drop the mutex) to perform
>> the mount, we can get a deadlock. The cause of the problem was that for
>> "create" like operations the mutex is held for ->lookup() and
>> ->revalidate() but for a "path walks" the mutex is only held for
>> ->lookup(), so if the mutex is held when we're in ->revalidate(), we
>> could never be sure that we where the code path that acquired it.
>> 
>> Sorry, this last bit is unclear.
>> I'll need to work a bit harder on the explanation if you're interested
>> in checking further.
>
> I am.

commit 1864f7bd58351732593def024e73eca1f75bc352
Author: Ian Kent <raven@themaw.net>
Date:   Wed Aug 22 14:01:54 2007 -0700

    autofs4: deadlock during create
    
    Due to inconsistent locking in the VFS between calls to lookup and
    revalidate deadlock can occur in the automounter.
    
    The inconsistency is that the directory inode mutex is held for both lookup
    and revalidate calls when called via lookup_hash whereas it is held only
    for lookup during a path walk.  Consequently, if the mutex is held during a
    call to revalidate autofs4 can't release the mutex to callback the daemon
    as it can't know whether it owns the mutex.
    
    This situation happens when a process tries to create a directory within an
    automount and a second process also tries to create the same directory
    between the lookup and the mkdir.  Since the first process has dropped the
    mutex for the daemon callback, the second process takes it during
    revalidate leading to deadlock between the autofs daemon and the second
    process when the daemon tries to create the mount point directory.
    
    After spending quite a bit of time trying to resolve this on more than one
    occassion, using rather complex and ulgy approaches, it turns out that just
    delaying the hashing of the dentry until the create operation works fine.

> Oh, well...  Looks like RTFS time for me for now...  Additional parts of
> braindump would be appreciated - the last time I've seriously looked at
> autofs4 internal had been ~2005 or so ;-/

Well, let me know what level of dump you'd like.  I can give the 50,000
foot view, or I can give you the history of things that happened to get
us to where we are today, or anything inbetween.  The more specific
your request, the quicker I can respond.  A full brain-dump would take
some time!

Cheers,

Jeff
