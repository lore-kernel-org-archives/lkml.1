Return-Path: <linux-kernel-owner+w=401wt.eu-S1763963AbXGaOsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763963AbXGaOsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760835AbXGaOs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:48:29 -0400
Received: from mail.fieldses.org ([66.93.2.214]:36001 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758237AbXGaOs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:48:27 -0400
Date: Tue, 31 Jul 2007 10:48:24 -0400
To: Stefan Walter <stefan.walter@inf.ethz.ch>
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net
Subject: Re: rpc.mountd crashes when extensively using netgroups
Message-ID: <20070731144824.GA15231@fieldses.org>
References: <46ADDFB2.9070709@inf.ethz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46ADDFB2.9070709@inf.ethz.ch>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 02:55:14PM +0200, Stefan Walter wrote:
> There are however two issues for which we could not find an easy
> solution:
> 
>  1. For every client rpc.mountd and the kernel seem to exchange
>     and use lists with _all_ netgroups used in exports that are
>     relevant for granting permission to some share for a particular
>     client. We could imagine two optimizations here:
> 
>        * Resolve netgroups and only put the (member) netgroups that
>          contained the host name that would be used to authorize
>          a mount in the list.
> 
>        * Use the list of mounted paths per client and only put the
>          netgroup(s) used to export paths that are actually mounted
>          on a client. 
> 
>     This also caused us severe performance problems because
>     rpc.mountd queries all these netgroups. We were initially using
>     a LDAP and mouting a directory took up to ten seconds
>     during which rpc.mountd was busily querying the LDAP server.
>     We got this down to two seconds using file based netgroups.
>  
>  2. Using a fixed size for NFSCLNT_IDMAX does not scale. Mounting
>     shares on a client for which the 'if' clause of the quick fix
>     becomes true will not be possible. We thought about enlarging
>     NFSCLNT_IDMAX and using a custom kernel but dropped the idea. 
> 
> Our ultimate goal is to get Red Hat fix the code in nfs-utils 1.0.6
> that is used in RHEL4. A first step would be to get a suitable fix in
> the current nfs-utils. 

That's an interesting problem.  Thanks for the report!

I don't believe that long comma-delimited string actually has any
meaning to the kernel--as far as the kernel is concerned, it's just an
opaque object that will be passed back to mountd later (along with a
path name) to get export options.

So I suppose that string could be replaced by a hash, or maybe even just
by the ip address of the particular host--the disadvantage to the latter
being that it would require the kernel to keep a separate export for
each client address.

--b.
