Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab0CJL32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 06:29:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48843 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271Ab0CJL30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 06:29:26 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH 0/2] Correct behavior for listxattr and 'trusted' xattrs
Date: Wed, 10 Mar 2010 12:26:59 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; i686; ; )
Cc: James Morris <jmorris@namei.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>,
       Alex Elder <aelder@sgi.com>, Chris Mason <chris.mason@oracle.com>
References: <alpine.LRH.2.00.1003021845310.1594@tundra.namei.org> <20100303140940.GA2253@infradead.org>
In-Reply-To: <20100303140940.GA2253@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003101226.59705.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 March 2010 15:09:41 Christoph Hellwig wrote:
> On Tue, Mar 02, 2010 at 07:01:05PM +1100, James Morris wrote:
> > I noticed that there are differences in the behavior of listxattr(2) for 
> > xattrs in the trusted namespace.
> > 
> > Some filesystems, such as ext[234], require CAP_SYS_ADMIN for this, i.e. 
> > trusted xattr names are hidden from unprivileged users.
> > 
> > I audited the kernel for users of the trusted xattr namespace, and found 
> > the following filesystems not checking for CAP_SYS_ADMIN:
> > 
> >   - jffs2
> >   - ocfs2
> >   - btrfs
> >   - xfs
> > 
> > I've created patches for jffs2 (tested) and ocfs2 (not tested) to add the 
> > check -- see following emails. btrfs and xfs have custom listxattr 
> > operations and will need a bit more work to fix.
> 
> I think the behaviour of the above filesystems is correct.  There is no
> requirement for privilegues to see the existence of these attributes.
> We also don't hide entries that aren't readable from readdir output.

The original idea was that regular processes will never have access to 
trusted.* attributes anyway, and so there is little point in listing such 
attributes in the first place.

This is different from user.* attributes which a particular process may or may 
not have access to depending on file permissions.  Checking those permissions 
in listxattr() would have significant overheads, and race with permission 
changes, possibly leading to weird results.  (In contrast, processes don't 
usually listxattr() with privileges and then getxattr() without privileges, or 
vice versa.)

Andreas
