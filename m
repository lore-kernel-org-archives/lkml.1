Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbXGCNuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbXGCNuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 09:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbXGCNuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 09:50:00 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:46618 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753812AbXGCNt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 09:49:59 -0400
Subject: Re: [AppArmor 32/44] Enable LSM hooks to distinguish operations on
	file descriptors from operations on pathnames
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: James Morris <jmorris@namei.org>, John Johansen <jjohansen@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Miklos Szeredi <mszeredi@suse.cz>
In-Reply-To: <200706282015.51430.agruen@suse.de>
References: <20070626230756.519733902@suse.de>
	 <20070626231124.098710828@suse.de>
	 <Line.LNX.4.64.0706281206180.13250@localhost.localdomain>
	 <200706282015.51430.agruen@suse.de>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 03 Jul 2007 09:49:40 -0400
Message-Id: <1183470580.12218.253.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-28 at 20:15 +0200, Andreas Gruenbacher wrote:
> On Thursday 28 June 2007 18:12, James Morris wrote:
> > Are you trying to cater for the case where you're holding an open fd for a 
> > file which has been deleted, and thus has no pathname?
> 
> Yes, see the AA_CHECK_FD flag in security/apparmor/main.c:aa_perm_dentry(). We 
> want to distinguish between the following two cases:
> 
>  - process performs an operation on an open file descriptor,
> 
>  - process performs an operation on a pathname, and between the dentry
>    lookup and the LSM permission check, the file gets deleted.
> 
> In the former case, we obviously want to continue giving the process access to 
> his fd (the classical pattern: open temporary file; delete it so that it will 
> self-recycle, continue using the open file descriptor).
> 
> In the latter case, The file still existed at the time of the lookup but not 
> anymore at the time of the permission check. The file obviously doesn't have 
> a filename anymore, so we cannot check permissions. If we granted access in 
> that case, processes could bypass their profile permissions in that race 
> window. We close the race by returning -ENOENT in that case, the same result 
> as if the file had already been deleted before the lookup.

So you don't actually need/use the struct file pointer; you just need a
flag indicating whether or not access was by open file descriptor or by
pathname?

And what does this mean for a process that has "changed hats"?  Which
might not be authorized to access the file anymore, even via an already
opened descriptor.

-- 
Stephen Smalley
National Security Agency

