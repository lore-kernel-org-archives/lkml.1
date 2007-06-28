Return-Path: <linux-kernel-owner+w=401wt.eu-S1764777AbXF1SQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764777AbXF1SQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 14:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765445AbXF1SPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 14:15:54 -0400
Received: from mail.suse.de ([195.135.220.2]:51553 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765427AbXF1SPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 14:15:53 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: James Morris <jmorris@namei.org>
Subject: Re: [AppArmor 32/44] Enable LSM hooks to distinguish operations on file descriptors from operations on pathnames
Date: Thu, 28 Jun 2007 20:15:51 +0200
User-Agent: KMail/1.9.5
Cc: John Johansen <jjohansen@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Miklos Szeredi <mszeredi@suse.cz>
References: <20070626230756.519733902@suse.de> <20070626231124.098710828@suse.de> <Line.LNX.4.64.0706281206180.13250@localhost.localdomain>
In-Reply-To: <Line.LNX.4.64.0706281206180.13250@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2486
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200706282015.51430.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 June 2007 18:12, James Morris wrote:
> Are you trying to cater for the case where you're holding an open fd for a 
> file which has been deleted, and thus has no pathname?

Yes, see the AA_CHECK_FD flag in security/apparmor/main.c:aa_perm_dentry(). We 
want to distinguish between the following two cases:

 - process performs an operation on an open file descriptor,

 - process performs an operation on a pathname, and between the dentry
   lookup and the LSM permission check, the file gets deleted.

In the former case, we obviously want to continue giving the process access to 
his fd (the classical pattern: open temporary file; delete it so that it will 
self-recycle, continue using the open file descriptor).

In the latter case, The file still existed at the time of the lookup but not 
anymore at the time of the permission check. The file obviously doesn't have 
a filename anymore, so we cannot check permissions. If we granted access in 
that case, processes could bypass their profile permissions in that race 
window. We close the race by returning -ENOENT in that case, the same result 
as if the file had already been deleted before the lookup.

Andreas
