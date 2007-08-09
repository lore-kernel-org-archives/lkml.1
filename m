Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbXHIRYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbXHIRYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765488AbXHIRYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:24:45 -0400
Received: from ns.suse.de ([195.135.220.2]:55843 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbXHIRYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:24:44 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 04/10] Temporary struct vfs_lookup in file_permission
Date: Thu, 9 Aug 2007 19:23:56 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, John Johansen <jjohansen@suse.de>,
       Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
References: <20070808171622.632749741@suse.de> <200708082341.06329.agruen@suse.de> <20070808232409.GA7876@infradead.org>
In-Reply-To: <20070808232409.GA7876@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 4048
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708091923.56997.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 August 2007 01:24, Christoph Hellwig wrote:
> On Wed, Aug 08, 2007 at 11:41:06PM +0200, Andreas Gruenbacher wrote:
> > Lookup or not doesn't actually matter. Think of fchdir(2): it does a 
> > permission check, and it should also pass down the LOOKUP_CHDIR flag.
> 
> fchdir per defintion doesn't do any lookup, and it should not pretend to be
> doing one.

fchdir doesn't pretend to do a lookup by passing the LOOKUP_CHDIR flag, it 
indicates that a chdir is being done. The lookup happened earlier at a time 
at which the kernel didn't know that a chdir would follow. If fchdir doesn't 
pass down the LOOKUP_CHDIR flag, then that flag is pretty pointless: it could 
be bypassed any time by an open followed by fchdir.

> > The vfsmnt that this patch passes down in file_permission() is not some
> > crap as you chose to call it, it's the appropriate vfsmnt.
> 
> No, it's wrong.  There is no path except for informal purposes attached to
> a struct file.

I'm sorry, but the dentry and vfsmnt in struct file is *not* only used for 
informational purposes: openat does a lookup relative to a file's dentry and 
vfsmnt, and there are other examples as well.

The dentry and vfsmnt identify a particular object in the filesystem 
hierarchy. As long as the file hasn't been deleted, they can be used to 
compute a pathname that leads to the file (if the file is reachable at all). 
You can used that pathname for more than informational purposes. It is real, 
and canonical too.

> I created file_permission to document that clearly and people don't try
> things like this. There's lots of chances where fs passing has happened,

						  ^ you must mean fd passing

> were into a lazily detached tree, after a pviot_root, etc where trying to do
> anything that remotely looks like pathname based operation just doesn't make
> any sense in this case.

What you are saying doesn't make sense. It makes perfect sense to compute the 
pathname of an open file in some situations. Obviously it does not make sense 
when the file has been deleted, and you really do want to detect when a file 
has become unreachable (lazily unmounted, other namespace, whatever). You 
will always find that out when trying to compute its pathname, so that's not 
an issue. (Caveat: this requires the d_path fixes I have posted earlier.)

Thanks,
Andreas
