Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbYHRSgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbYHRSgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbYHRSgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:36:09 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:34105 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbYHRSgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:36:08 -0400
Date: Mon, 18 Aug 2008 14:35:40 -0400
From: Jan Harkes <jaharkes@cs.cmu.edu>
To: Eric Paris <eparis@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, tvrtko.ursulin@sophos.com,
       Theodore Tso <tytso@mit.edu>, davecb@sun.com, david@lang.hm,
       Adrian Bunk <bunk@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Casey Schaufler <casey@schaufler-ca.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro to
	a linux interface for on access scanning
Message-ID: <20080818183540.GA5470@cs.cmu.edu>
Mail-Followup-To: Eric Paris <eparis@redhat.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, tvrtko.ursulin@sophos.com,
	Theodore Tso <tytso@mit.edu>, davecb@sun.com, david@lang.hm,
	Adrian Bunk <bunk@kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	malware-list@lists.printk.net,
	Casey Schaufler <casey@schaufler-ca.com>,
	Arjan van de Ven <arjan@infradead.org>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com> <1219076143.15566.39.camel@localhost.localdomain> <20080818171500.78590801@lxorguk.ukuu.org.uk> <1219080504.15566.65.camel@localhost.localdomain> <20080818182556.13ced58f@lxorguk.ukuu.org.uk> <1219082097.15566.82.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219082097.15566.82.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 01:54:57PM -0400, Eric Paris wrote:
> But the file being installed needs to be at least RD for AV/Indexer.
> Particularly of interest to people here would be a file opened O_WRONLY
> and then the indexer wouldn't have the ability to read the data that was
> just written.  So we need a new FD, can't just send the old one.
> 
> I'd also assume that an HSM would need a WR file descriptor, which isn't
> easy.  I've found that (through trial and error not understanding the
> code) trying to make new descriptors for the new process have WR often
> returned with ETXTBUSY....

The devil is in the details, and besides everyone trying to heap other
things on, one thing that keeps getting brought up, and seemingly keeps
getting ignored is the fact that there already is a perfectly reasonable
interface to pass file system events (open, close, read, write, etc) to
userspace applications in the form of FUSE which has already in some
ways solved issues wrt. subtle deadlocks that can happen when you bounce
from an in-kernel context to a userspace application.

Fuse is definitely the way to go for HSM. But even for one of the
various threat models I've read in the past couple of days it would be
perfect. i.e. not allowing Linux servers to be used as a means to
propagate viruses for other machines.

The trick is to have a scanned view on the file storage though a FUSE
mount, and then have samba/knfs/apache/etc. export only the fuse mounted
tree or chroot the daemons under the scanned part of the namespace. This
provides an excellent way to separate 'trusted' applications from
non-trusted by leveraging the namespace. In fact the raw data can easily
be stored in such a way that it is owned and accessible only by fuse's
userspace process (and root) so that even without chroot, local users
can only access the data through the fuse mount/scanning layer.

And the kernel parts are already implemented, doesn't require new
syscalls, or placing policy about which processes happen to be
'priviledged' in the kernel and solves several nasty deadlocks that can
happen when you start blocking processes in their open, close, read,
write or page faulting code paths.

...
> trouble) what would it look like?  A scanner constantly calls scan() to
> block for data to be scanned?  So an AV, HSM, or indexer all would be
> blocking in scan() just waiting for data?  How do they respond?  How is

They all block at different places because they all have very different
requirements.

HSM blocks in open before the file data is present because that still
needs to be fetched. AV scan blocks after the file data is accessible
but before returning to the application and the indexer only cares about
being notified after a open for write/mmap releases the last (writing)
reference to the file, since it seems to me to be quite useless indexing
not yet or partially written data.

As far as I am concerned, this thread has been going nowhere fast by
mixing up the various requirements that come from different possible
applications that people imagine this interface being used for. As far
as I was hoping, part of "defining the threat model" line of questioning
was to avoid having discussions spin into the realm of how even with all
the protections someone could still subvert the virus scanner by
bit-flipping memory state with a scanning tunneling microscope or
something.

Jan

