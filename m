Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbYIVSqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbYIVSqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbYIVSqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:46:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:61954 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbYIVSqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:46:11 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [NFS] blocks of zeros (NULLs) in NFS files in kernels >= 2.6.20
Date: Mon, 22 Sep 2008 20:45:51 +0200
User-Agent: KMail/1.9.10
Cc: Aaron Straus <aaron@merfinllc.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Chuck Lever <chuck.lever@oracle.com>, Neil Brown <neilb@suse.de>,
       Linux NFS Mailing List <linux-nfs@vger.kernel.org>
References: <20080905191939.GG22796@merfinllc.com> <1222104541.7615.23.camel@localhost> <20080922174525.GF12483@merfinllc.com>
In-Reply-To: <20080922174525.GF12483@merfinllc.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809222045.52388.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX19LYEsgyAh6iQ0FOtp9eOsDWDwuNoJDl/1bHEn
 JQYQCGXow5jtG1F3Kf7Oo+KKL6JoJB3HsmZ5bgYVTYD9eZZ52P
 kRKIDorCzlMRiTG0dVRwQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 22. September 2008 schrieb Aaron Straus:
> Hi,
>
> On Sep 22 01:29 PM, Trond Myklebust wrote:
> > > Anyway, I agree the new writeout semantics are allowed and possibly
> > > saner than the previous writeout path.  The problem is that it is
> > > __annoying__ for this use case (log files).
> >
> > There is always the option of using syslog.
>
> Definitely.  Everything in our control we can work around.... there are
> a few applications we cannot easily change... see the follow-up in
> another e-mail.
>
> > > I'm not sure if there is an easy solution.  We want the VM to
> > > writeout the address space in order.   Maybe we can start the scan
> > > for dirty pages at the last page we wrote out i.e. page 0 in the
> > > example above?
> >
> > You can never guarantee that in a multi-threaded environment.
>
> Definitely.  This is a single writer, single reader case though.

...where it happens, that the reader gets chunks of zeros from reading a 
file, that is written from another (single threaded) process.

Note, that going through syslog isn't an option in many cases unless we want 
to rewrite the "world" to work around this phenomenon, thus it's not simply 
annoying, as Aaron points out, the "in order" approach is inevitable.

> > Two threads may, for instance, force 2 competing fsync() calls: that
> > again may cause out-of-order writes.
>
> Yup.
>
> > ...and even if the client doesn't reorder the writes, the _server_ may
> > do it, since multiple nfsd threads may race when processing writes to
> > the same file.
>
> Yup.  We're definitely not asking for anything like that.
>
> > Anyway, the patch to force a single threaded nfs client to write out
> > the data in order is trivial. See attachment...
> >
> > diff --git a/fs/nfs/write.c b/fs/nfs/write.c
> > index 3229e21..eb6b211 100644
> > --- a/fs/nfs/write.c
> > +++ b/fs/nfs/write.c
> > @@ -1428,7 +1428,8 @@ static int nfs_write_mapping(struct address_space
> > *mapping, int how) .sync_mode = WB_SYNC_NONE,
> >  		.nr_to_write = LONG_MAX,
> >  		.for_writepages = 1,
> > -		.range_cyclic = 1,
> > +		.range_start = 0,
> > +		.range_end = LLONG_MAX,
> >  	};
> >  	int ret;
>
> Yeah I was looking at that while debugging.  Would that change have
> chance to make it into mainline?  I assume it makes the normal writeout
> path more expensive, by forcing a scan of the entire address space.

If this patch solves this issue, it is necessary to get applied as soon as 
possible as outlined above.. 

> Also, I should test this, but I thought the VM was calling
> nfs_writepages directly i.e. not going through nfs_write_mapping.  Let
> me test with this patch.

Let us know about the outcome. 

Thanks,
Pete
