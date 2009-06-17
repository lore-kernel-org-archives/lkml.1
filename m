Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbZFQTwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbZFQTwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 15:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZFQTwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 15:52:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36506 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbZFQTwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 15:52:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.01.0906171112530.16802@localhost.localdomain>
References: <alpine.LFD.2.01.0906171112530.16802@localhost.localdomain> <alpine.LFD.2.01.0906171027470.16802@localhost.localdomain> <alpine.LFD.2.01.0906170901480.16802@localhost.localdomain> <20090617001157.065ee652@lxorguk.ukuu.org.uk> <20090616203845.4526.60013.stgit@warthog.procyon.org.uk> <10437.1245193192@redhat.com> <11650.1245198358@redhat.com> <20090617075502.GB13073@webber.adilger.int> <28023.1245259479@redhat.com> <28259.1245261823@redhat.com> 
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Andreas Dilger <adilger@sun.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, linux-afs@lists.infradead.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/17] [RFC] AFS: Implement OpenAFS pioctls(version)s
Date: Wed, 17 Jun 2009 20:51:41 +0100
Message-ID: <29249.1245268301@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Ummm...  I'm not sure I completely agree.  If you've managed to open, say,
> > "/afs", where's the race with mount/umount?
> 
> Well, if you mean that you're going to have a new system call that then 
> passes in both the 'fd' from that /afs open, _and_ the pathname you want 
> to work on, then sure.

No.  I meant open + ioctl.

> But if you do that new system call, then what's the point again? You're 
> back to pinfo() anyway.

Ummm...  pinfo()?  Did you mean pioctl()?

> No. It's because it's another _typeless_ multiplexor.

What do you mean by 'typeless'?  Even the master syscall mux is typeless,
depending on how you look at it; either that, or it's the superposition of a
multiplicity of types selected by an arbitrary number.

Short of doing something like an XML or ASN1 structured interface, we aren't
going to get that, and do we really want to go down that path?

The difference between the syscall mux and a filesystem's ioctl/pioctl mux is
that the both need to check on their arguments.

> Look at ioctl. It's a F*CKING DISASTER. Look at all the compat crap, and 
> at the ioctl numbers that mean different things for different file types, 
> and all the random sizing crap. You fixed the random sizing crap (at least 
> it has well-defined "input" and "output" areas), and that's an 
> improvement, but it's still just random numbers with no semantics.

Well, to be fair, I didn't fix it.  That's the way pioctl() was defined before
I got to deal with it.  Compat code is not necessary beyond the outermost VFS
layer because you have to carefully structure your input and output blobs, and
pointers and CPU-dependent tyeps are not allowed therein.  It even uses XDR
encoding in some circumstances (VIOCSETTOK2 and VIOCGETTOK2), so some pioctls
will even work on a mixed-endian machine.  Now if it only used XDR for all...

>  - learn from your mistake, and not do another f*cking disaster that just 
>    takes a pathname instead of a fd. Do something else, that actually has 
>    semantics and has a well-defined input and output buffer.

That sounds like you want all the pioctl functions promoted to syscalls.
Emulation through ioctl does not gain this; nor does going through xattrs -
that's just a way of doing ioctls with textual command names instead of
numbers.

> And guess which one "pioctl()" is. Just take a wild stab at it.

Well, I'd say it's more intelligent that open+ioctl...

> > 	fd = open("/the/target/file", O_SUPPRESS | (nofollow?O_NOFOLLOW:0));
> > 	ioctl(fd, cmd, &args);
> > 	close(fd);
> 
> Yes, I think that would be better.

But it isn't sufficient to address all the cases - in which case it's
pointless.

David
