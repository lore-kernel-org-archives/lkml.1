Return-Path: <linux-kernel-owner+w=401wt.eu-S1030687AbXDJV0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030687AbXDJV0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030688AbXDJV0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:26:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030687AbXDJV0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:26:49 -0400
From: Neil Brown <neilb@suse.de>
To: Theodore Tso <tytso@mit.edu>
Date: Wed, 11 Apr 2007 07:26:43 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17948.275.59001.855822@notabene.brown>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
In-Reply-To: message from Theodore Tso on Monday April 9
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com>
	<20070407203633.GA21555@thunk.org>
	<20070407233037.GA16508@infradead.org>
	<46193048.6000606@zytor.com>
	<20070408184129.GA20871@lazybastard.org>
	<20070408191955.GD29180@thunk.org>
	<46194260.3050900@zytor.com>
	<20070409014426.GA18580@thunk.org>
	<20070409110927.GA23240@lazybastard.org>
	<1176121897.6210.8.camel@heimdal.trondhjem.org>
	<20070409131918.GC18580@thunk.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday April 9, tytso@mit.edu wrote:
> On Mon, Apr 09, 2007 at 08:31:37AM -0400, Trond Myklebust wrote:
> > That is a protocol limitation, not a client limitation.
> 
> <Groan>
> 
> And after quickly checking RFC 3010, I see this limitation hasn't been
> lifted in NFSv4.
> 
> Speaking of which, right now ext3 doesn't know whether it's talking to
> an NFSv2 or NFS v3/v4 server, so it's always passing a 32-bit cookie.
> If NFSv3/v4 could use an explicit interface to request a 64-bit
> cookie, instead of just relying on the f_pos field in the file handle,
> we can reduce the chance of hash collisions when reading an ext3
> directory significantly.   
> 

We don't use f_pos (any more), we call llseek.

I think it would make a lot of sense - as Trond suggests - to not pass
O_LARGEFILE to dentry_open for an NFSv2 request.  Then ext3 could
trigger off that and return 64bits of cookie ... and I think nfsd will
actually pass them all back to the client now.  There is a
truncate-to-32bits bug that has only just been fixed.

But if a separate call is wanted, we have the export_operations struct
to put it in.  All we need is a good case an useful specification.


> If there are 2 or 3 directory entries that have a hash collision,
> would the NFS protocol allow the server to juggle things so that those
> 2-3 directory entries with the hash collision are sent back in a
> single readdir RPC reply?  Is it aceptable/legal to have multiple
> entries in the same READDIR reply packet have the same cookie value?

I think Trond has answered this, but I think it is also worth noting
that every entry returned in a READDIR reply includes a cookie, the
NFS client may use any of those cookies in a subsequent READDIR.  One
might hope the client will only ever use the last, but one can never
be sure....


NeilBrown
