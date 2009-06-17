Return-Path: <linux-kernel-owner+w=401wt.eu-S1751536AbZFQSZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbZFQSZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 14:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbZFQSZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 14:25:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373AbZFQSZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 14:25:06 -0400
Date: Wed, 17 Jun 2009 11:24:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: Andreas Dilger <adilger@sun.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       linux-afs@lists.infradead.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/17] [RFC] AFS: Implement OpenAFS pioctls(version)s
In-Reply-To: <28259.1245261823@redhat.com>
Message-ID: <alpine.LFD.2.01.0906171112530.16802@localhost.localdomain>
References: <alpine.LFD.2.01.0906171027470.16802@localhost.localdomain> <alpine.LFD.2.01.0906170901480.16802@localhost.localdomain> <20090617001157.065ee652@lxorguk.ukuu.org.uk> <20090616203845.4526.60013.stgit@warthog.procyon.org.uk> <10437.1245193192@redhat.com>
 <11650.1245198358@redhat.com> <20090617075502.GB13073@webber.adilger.int> <28023.1245259479@redhat.com>  <28259.1245261823@redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Jun 2009, David Howells wrote:

> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > What _I_ mean is that THIS IS IMPOSSIBLE TO DO FROM USER SPACE!
> > 
> > Try it. Not doable. User space simply doesn't know enough, and has 
> > fundamental races with mount/umount.
> 
> Ummm...  I'm not sure I completely agree.  If you've managed to open, say,
> "/afs", where's the race with mount/umount?

Well, if you mean that you're going to have a new system call that then 
passes in both the 'fd' from that /afs open, _and_ the pathname you want 
to work on, then sure.

But if you do that new system call, then what's the point again? You're 
back to pinfo() anyway.

> > I just don't think "pioctl()" is a good one.
> 
> Out of interest, why not?  Is it just because it's another multipexor?  Or is
> it because it's been abused to have pathless commands?

No. It's because it's another _typeless_ multiplexor.

Look at ioctl. It's a F*CKING DISASTER. Look at all the compat crap, and 
at the ioctl numbers that mean different things for different file types, 
and all the random sizing crap. You fixed the random sizing crap (at least 
it has well-defined "input" and "output" areas), and that's an 
improvement, but it's still just random numbers with no semantics.

Now, you can take two approaches:

 - learn from your mistake, and not do another f*cking disaster that just 
   takes a pathname instead of a fd. Do something else, that actually has 
   semantics and has a well-defined input and output buffer.

 - do the same stupid thing over again, and never learn.

And quite frankly, I know which of those choices I'd call "intelligent", 
and which of them I'd call "you're a f*cking moron for doing it".

And guess which one "pioctl()" is. Just take a wild stab at it.

> > You'd be better off with some modification of open and then use ioctl.
> 
> So you'd say use:
> 
> 	fd = open("/the/target/file", O_SUPPRESS | (nofollow?O_NOFOLLOW:0));
> 	ioctl(fd, cmd, &args);
> 	close(fd);

Yes, I think that would be better. It's not perfect, because I think ioctl 
is still a f*cking broken mess (and with the sizing issue, it's arguably 
_worse_ then your pioctl), but at least we're not adding _another_ broken 
mess.

So I don't think the above is great either.

What I'd really prefer is something that actually has semantics. Not just 
"here's input, here's output, do something random to it".

> Do you also disagree with OpenAFS's idea of creating a proc file to open so
> that you can do ioctls on that to emulate pioctl()?  That would serve also.

Oh yes, I think that's a piece of crap too.

			Linus
