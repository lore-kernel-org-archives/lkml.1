Return-Path: <linux-kernel-owner+w=401wt.eu-S1030847AbXDPQVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030847AbXDPQVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 12:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030844AbXDPQVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 12:21:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58533 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030839AbXDPQVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 12:21:47 -0400
Date: Mon, 16 Apr 2007 17:21:46 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>
Subject: Re: [nameidata 1/2] Don't pass NULL nameidata to vfs_create
Message-ID: <20070416162146.GA8029@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
	Tony Jones <tonyj@suse.de>
References: <20070412090809.917795000@suse.de> <20070412090836.207973000@suse.de> <20070412100628.GA25078@infradead.org> <200704161811.30364.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704161811.30364.agruen@suse.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 06:11:30PM +0200, Andreas Gruenbacher wrote:
> On Thursday 12 April 2007 12:06, Christoph Hellwig wrote:
> > Once again very strong NACK.  Every conditional passing of vfsmounts get my
> > veto.  As mentioned last time if you really want this send a patch series
> > first that passed the vfsmount consistantly.
> 
> I don't consider it fair to NACK this patch just because some other part of 
> the kernel uses vfs_create() in the wrong way -- those are really independent 
> issues. The bug is not that hard to fix though; here is a proposed patch on 
> top of the other AppArmor patches.

Note that it's not just this particular hunk, all these kinds of conditional
passing are wrong.

> 
> The offenders are nfsd and the mqueue filesystem. Instantiate a struct 
> nameidata there.
> 
> The .dentry and .mnt fields can easily be filled in in nfsd. The mqueue 
> filesystem is somewhat special: files that mq_open creates are on an internal 
> mount and the mqueue filesystem is not generally visible (it may or may not 
> be mounted). When passing a regular vfsmount to vfs_create the files would 
> appear disconnected while they actually are kernel-internal objects. Use a 
> NULL vfsmount there to avoid that -- passing the kernel-internal vfsmount 
> there wouldn't help, anyway.

But anyway, creating fake nameidata structures is not really helpful.
If there is a nameidata passed people expect it to be complete, and
if you pass them to an LSM people will e.g. try to look into lookup
intents.  But similar to the per-mountpoint r/o work I suspect you're
simply operating on the wrong level, but then again this might not
be fixable due to the braindead apparmor design.
