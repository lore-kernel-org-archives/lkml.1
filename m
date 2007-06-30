Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbXF3Jnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbXF3Jnp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 05:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbXF3Jnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 05:43:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58494 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbXF3Jne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 05:43:34 -0400
Date: Sat, 30 Jun 2007 10:43:32 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Christoph Hellwig <hch@infradead.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC PATCH 4/4] Directory listing support for union mounted directories.
Message-ID: <20070630094332.GA22889@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	Bharata B Rao <bharata@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jan Blunck <j.blunck@tu-harburg.de>
References: <20070620055050.GB4267@in.ibm.com> <20070620055418.GF4267@in.ibm.com> <20070620120947.GA3973@infradead.org> <1182349348.6225.15.camel@heimdal.trondhjem.org> <20070620170221.GA13237@infradead.org> <1182361492.6480.12.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182361492.6480.12.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 01:44:52PM -0400, Trond Myklebust wrote:
> > Which is exactly that problem this tries to solve.  Once you have
> > union mounts you'll have a single open file descriptor for multiple
> > actual directories.   Beause of that you can't simply attach to the
> > state to the struct file but have to keep it in a different way.
> 
> Which creates another, much WORSE problem.
> 
> Authentication information is part of a series of things that POSIX
> requires you to keep on per-descriptor basis (because POSIX assumes that
> you can suid/sgid a process without any security implications for file
> descriptors that are already open). It is quite natural to pass it
> around by means of the struct file.
> 
> If you don't want to pass the struct file around, then you at least need
> to come up with an alternative mechanism that allows filesystems to
> provide correct semantics in the standard non-union case.

That'd be struct ucred..

Anyway, to get back to the original problem - currently filesystems
are perfectly fine to keep whatever state they want in struct file
(mostly ->private), with union mounts we will have a single file descriptor
and struct file for two directories, so we need to restrict this.
Getting this right is the key to any unioning work that actually works
on an arbitrary filesystem and not just on disk filesystems that don't
do anything fancy.
