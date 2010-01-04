Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564Ab0ADQzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab0ADQzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 11:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145Ab0ADQzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 11:55:07 -0500
Received: from mrout3.yahoo.com ([216.145.54.173]:32809 "EHLO mrout3.yahoo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab0ADQzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 11:55:06 -0500
DomainKey-Signature: a=rsa-sha1; s=serpent; d=yahoo-inc.com; c=nofws; q=dns;
	h=received:date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:user-agent;
	b=vUCqTK71ucNel0BNpIqvbTZBTFvtUBl4i+i//tNa0msKx2zFOluWzK/RfVW44cMT
Date: Mon, 4 Jan 2010 10:50:44 -0600
From: Quentin Barnes <qbarnes@yahoo-inc.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Wu Fengguang <fengguang.wu@intel.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC][PATCH v3] readahead: introduce O_RANDOM for POSIX_FADV_RANDOM
Message-ID: <20100104165044.GD25663@yahoo-inc.com>
References: <20091225000717.GA26949@yahoo-inc.com> <87aax18xms.fsf@basil.nowhere.org> <20091230051540.GA16308@localhost> <20091230052402.GB26364@localhost> <873a2s8hmp.fsf@basil.nowhere.org> <20100104045020.GA21021@localhost> <20100104161719.a0bb35ad.sfr@canb.auug.org.au> <20100104073328.GA3422@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100104073328.GA3422@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 03, 2010 at 11:33:28PM -0800, Christoph Hellwig wrote:
> On Mon, Jan 04, 2010 at 04:17:19PM +1100, Stephen Rothwell wrote:
> > > @@ -80,6 +80,10 @@
> > >  #define O_NDELAY	O_NONBLOCK
> > >  #endif
> > >  
> > > +#ifndef O_RANDOM
> > > +#define O_RANDOM	010000000	/* random access pattern hint */
> > > +#endif
> > 
> > This value conflicts with O_CLOEXEC on alpha and parisc and O_NOATIME on
> > sparc.
> 
> Also when I tried to use this value for O_RSYNC and tested it I could
> not actually see it getting propagated by the open code.
> 
> Eitherway I don't think an O_ value is a good idea for a simple access
> pattern hint.

Could you expand on that?

I was surprised by Wu's O_RANDOM approach, but after thinking about
it, I liked it.  I'm used to seeing (on non-UNIX OSes) a parameter
as part of the open syscall that announces to the OS what the app's
access strategy through that file descriptor will be for that file.
An issue with the current fadvise(2) approach is for random access
files it necessitates two syscalls (open plus fadvise) for what
could be or should be only one syscall (open).

My guess on your issue is that open(2) should take only flags that
are necessary for the open state itself and therefore can't be
implemented as a separate and later syscall.  I would generally
agree with that.  There is however already at least two exceptions
to that principle, the O_SYNC and O_DIRECT flags.  They are access
states though.  I guess the question is whether to think of the
O_RANDOM flag as a "hint" or as an "access strategy".

Quentin
