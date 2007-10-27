Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbXJ0Vhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbXJ0Vhe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 17:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbXJ0VhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 17:37:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48582 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbXJ0VhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 17:37:24 -0400
Subject: Re: Networked filesystems vs backing_dev_info
From: Peter Zijlstra <peterz@infradead.org>
To: Steve French <smfrench@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, sfrench@samba.org,
       jaharkes@cs.cmu.edu, Andrew Morton <akpm@linux-foundation.org>,
       vandrove@vc.cvut.cz
In-Reply-To: <1193520625.27652.30.camel@twins>
References: <1193477666.5648.61.camel@lappy>
	 <524f69650710271402g65a9ec1cqcc7bc3a964097e39@mail.gmail.com>
	 <1193520625.27652.30.camel@twins>
Content-Type: text/plain
Date: Sat, 27 Oct 2007 23:37:21 +0200
Message-Id: <1193521041.27652.37.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-10-27 at 23:30 +0200, Peter Zijlstra wrote:
> On Sat, 2007-10-27 at 16:02 -0500, Steve French wrote:
> > On 10/27/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > Hi,
> > >
> > > I had me a little look at bdi usage in networked filesystems.
> > >
> > >  NFS, CIFS, (smbfs), AFS, CODA and NCP
> > >
> > > And of those, NFS is the only one that I could find that creates
> > > backing_dev_info structures. The rest seems to fall back to
> > > default_backing_dev_info.
> > >
> > > With my recent per bdi dirty limit patches the bdi has become more
> > > important than it has been in the past. While falling back to the
> > > default_backing_dev_info isn't wrong per-se, it isn't right either.
> > >
> > > Could I implore the various maintainers to look into this issue for
> > > their respective filesystem. I'll try and come up with some patches to
> > > address this, but feel free to beat me to it.
> > 
> > I would like to understand more about your patches to see what bdi
> > values makes sense for CIFS and how to report possible congestion back
> > to the page manager. 
> 
> So, what my recent patches do is carve up the total writeback cache
> size, or dirty page limit as we call it, proportionally to a BDIs
> writeout speed. So a fast device gets more than a slow device, but will
> not starve it.
> 
> However, for this to work, each device, or remote backing store in the
> case of networked filesystems, need to have a BDI.
> 
> >   I had been thinking about setting bdi->ra_pages
> > so that we do more sensible readahead and writebehind - better
> > matching what is possible over the network and what the server
> > prefers.  
> 
> Well, you'd first have to create backing_dev_info instances before
> setting that value :-)
> 
> >   SMB/CIFS Servers typically allow a maximum of 50 requests
> > in parallel at one time from one client (although this is adjustable
> > for some).
> 
> That seems like a perfect point to set congestion.
> 
> So in short, stick a struct backing_dev_info into whatever represents a
> client, initialize it using bdi_init(), destroy using bdi_destroy().

Oh, and the most important point, make your fresh I_NEW inodes point to
this bdi struct.

> Mark it congested once you have 50 (or more) outstanding requests, clear
> congestion when you drop below 50.
> 
> and you should be set.
> 

