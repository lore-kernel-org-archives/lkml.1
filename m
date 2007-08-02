Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbXHBPdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbXHBPdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 11:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755665AbXHBPdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 11:33:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653AbXHBPdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 11:33:12 -0400
Date: Thu, 2 Aug 2007 11:32:55 -0400
From: Jeff Layton <jlayton@redhat.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Stefan Walter <stefan.walter@inf.ethz.ch>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [NFS] rpc.mountd crashes when extensively using netgroups
Message-Id: <20070802113255.d686894c.jlayton@redhat.com>
In-Reply-To: <20070731144824.GA15231@fieldses.org>
References: <46ADDFB2.9070709@inf.ethz.ch>
	<20070731144824.GA15231@fieldses.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 10:48:24 -0400
"J. Bruce Fields" <bfields@fieldses.org> wrote:

> On Mon, Jul 30, 2007 at 02:55:14PM +0200, Stefan Walter wrote:
> > There are however two issues for which we could not find an easy
> > solution:
> > 
> >  1. For every client rpc.mountd and the kernel seem to exchange
> >     and use lists with _all_ netgroups used in exports that are
> >     relevant for granting permission to some share for a particular
> >     client. We could imagine two optimizations here:
> > 
> >        * Resolve netgroups and only put the (member) netgroups that
> >          contained the host name that would be used to authorize
> >          a mount in the list.
> > 
> >        * Use the list of mounted paths per client and only put the
> >          netgroup(s) used to export paths that are actually mounted
> >          on a client. 
> > 
> >     This also caused us severe performance problems because
> >     rpc.mountd queries all these netgroups. We were initially using
> >     a LDAP and mouting a directory took up to ten seconds
> >     during which rpc.mountd was busily querying the LDAP server.
> >     We got this down to two seconds using file based netgroups.
> >  
> >  2. Using a fixed size for NFSCLNT_IDMAX does not scale. Mounting
> >     shares on a client for which the 'if' clause of the quick fix
> >     becomes true will not be possible. We thought about enlarging
> >     NFSCLNT_IDMAX and using a custom kernel but dropped the idea. 
> > 
> > Our ultimate goal is to get Red Hat fix the code in nfs-utils 1.0.6
> > that is used in RHEL4. A first step would be to get a suitable fix in
> > the current nfs-utils. 
> 
> That's an interesting problem.  Thanks for the report!
> 
> I don't believe that long comma-delimited string actually has any
> meaning to the kernel--as far as the kernel is concerned, it's just an
> opaque object that will be passed back to mountd later (along with a
> path name) to get export options.
> 
> So I suppose that string could be replaced by a hash, or maybe even just
> by the ip address of the particular host--the disadvantage to the latter
> being that it would require the kernel to keep a separate export for
> each client address.
> 
> --b.
> 

I started having a look at this today. The original patches that I
proposed to clean up the rmtab a few months ago also eliminated this
comma-delimited string. Neil had valid objections to it at the time,
but if we switched to using the IP address as a cache key like Bruce
describes then doing that becomes more reasonable.

The only downside I see is the one Bruce points out -- the size of
the kernel export cache would increase. I don't have a feel for whether
this is a show stopper, however.

Neil, do you have thoughts on what you'd consider a reasonable approach
to fixing this?

-- 
Jeff Layton <jlayton@redhat.com>
