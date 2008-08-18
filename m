Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbYHRRh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbYHRRh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbYHRRht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:37:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44907 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbYHRRhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:37:48 -0400
Subject: Re: [malware-list] scanner interface proposal was: [TALPA]
	Intro	to a linux interface for on access scanning
From: Eric Paris <eparis@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: tvrtko.ursulin@sophos.com, Theodore Tso <tytso@mit.edu>, davecb@sun.com,
       david@lang.hm, Adrian Bunk <bunk@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Casey Schaufler <casey@schaufler-ca.com>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20080818171500.78590801@lxorguk.ukuu.org.uk>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com>
	 <1219076143.15566.39.camel@localhost.localdomain>
	 <20080818171500.78590801@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 13:28:24 -0400
Message-Id: <1219080504.15566.65.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 17:15 +0100, Alan Cox wrote:
> > On async notification we fire a message to everything that registered
> > 'simultaneously.' On blocking we fire a message to everything in
> > priority order and block until we get a response.  That response should
> > be of the form ALLOW/DENY and should include "mark result"/"don't mark
> > result."
> 
> No can do - you get stuck with recursive events with the virus checker
> trying to stop the indexer from indexing a worm.

My last interface was single leveled and was able to efficiently stop
recursion by simply excluding all processes which were scanners.  It was
implemented as a flag in the task_struct.  I could probably go the same
route and just exclude all kernel initiated scanners from all scanning
operations.  I also included an interface for a process to be completely
excluded, but given multi-level scanners I don't think an 'exclude all'
is appropriate.

I could add a separate interface for background/purely userspace
scanners to register their level and only call scanners from the kernel
with a lower level.  Not sure what security I'd want to put around this
interface.

> 
> > read -> we have the ALLOW/mark result bit in core set so just allow.
> 
> Don't think we need this - SELinux can do that bit
> 
> > mtime update -> clear ALLOW/"mark result" bit in core, send async
> > notification to userspace
> 
> Why via the kernel ?

the single in core allow/deny bit is so that the vast majority of
operations are completely free.  Say we scan/index /lib/ld-linux.so.2
once.  Do you really want every single read/mmap operation from then on
to have to block waiting for the userspace caches of you HSM, your AV
scanner, and you indexer?  If all three tell the kernel they don't need
to see it again and that information is easy and free to maintain, lets
do it.

> > The communication with userspace has a very specific need.  The scanning
> > process needs to get 'something' that will give it access to the
> > original file/inode/data being worked on.  My previous patch set does
> 
> file handle. Really you need to give the handle of the object because it
> may not have a name or a meaningful inode number

I think I'm going to stick with my special file in securityfs since it
makes it some simple to install the fd in the scanning process (as
opposed to netlink where I don't even know how it would be possible...)

-Eric

