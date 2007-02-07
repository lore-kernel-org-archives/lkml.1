Return-Path: <linux-kernel-owner+w=401wt.eu-S1161281AbXBGMLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161281AbXBGMLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 07:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161253AbXBGMLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 07:11:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39015 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161237AbXBGMLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 07:11:43 -0500
Date: Wed, 7 Feb 2007 12:11:25 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
Message-ID: <20070207121125.GA15989@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andreas Gruenbacher <agruen@suse.de>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
	linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com> <200702051920.36057.agruen@suse.de> <20070206094709.GB5328@infradead.org> <200702070158.15997.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702070158.15997.agruen@suse.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 01:58:15AM -0800, Andreas Gruenbacher wrote:
> > It's not actually a pathname we care about, but a vfsmount + dentry
> > combo.  That one means as much in nfsd as elsewhere.  We want nfsd
> > to obey r/o or noatime mount flags if /export/foo is exported with them
> > but /foo not.
> 
> This assumes that you can discover from the file handle which export it 
> belongs to. And right, this can be done using the fsid export option. Okay, 
> I'm now convinced that passing the vfsmounts from the svc_export to the vfs_ 
> helpers is good at least for *something*. I'll update the patches.

As I mentioned before I have a big patchset reworking this area, so please
wait a week or two for me two finish it instead of creating lots of rejects.

> > This doesn't matter.  hardlinks are per definition on the same vfsmount.
> 
> Hardlinks are per definition on the same filesystem. This doesn't mean that 
> you can't have two filehandles for the same file but with different 
> vfsmounts -- you can have the same file visible in multiple locations, each 
> with their own vfsmount.

Sure, but that doesn't matter here.  Exports are per-vfsmount, and
each export has the vfsmount stored in it.  So we know which of the
vfsmount we want before we even resolve the dentry.  And yes, if
I have /export/foo mounted with option but /foo now I want those
options to apply to the nfs export.  Note that we actually have another
little bug in this area currently:  if you export two different
patch that have the same underlying filesystems they actually do get
the same file handle unless using fsid=.  We probably need to put
a check into svc_export_parse so that we don't export the same
device twice without using fsid=.


