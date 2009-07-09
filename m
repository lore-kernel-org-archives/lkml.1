Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbZGITiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbZGITiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 15:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZGITiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 15:38:07 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:41417 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbZGITiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 15:38:06 -0400
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Greg KH <gregkh@suse.de>
Cc: jmorris@namei.org, sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <20090709175250.GB26378@suse.de>
References: <1247074106-23405-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <20090709151803.GB24302@suse.de> <1247159613.4398.215.camel@localhost>
	 <20090709175250.GB26378@suse.de>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 09 Jul 2009 15:28:58 -0400
Message-Id: <1247167738.4398.229.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 10:52 -0700, Greg KH wrote:
> On Thu, Jul 09, 2009 at 01:13:33PM -0400, David P. Quigley wrote:
> > The issue is that there really aren't any LSM hooks to accommodate that.
> > I have a few LSM hooks for the Labeled NFS work which could be used for
> > this but it still requires us to store the full xattr value somewhere
> > and referencing it in the sysfs_dirent structure.
> 
> A void pointer would handle that properly, right?

A void pointer would suffice if we wanted to store the opaque blob. My
argument is that storing that blob is too heavy weight memory wise.

> 
> > The issue here is that there are two ways of presenting security
> > information. The first is through the xattr interface which represents
> > the security information as an opaque blob which the LSM turns into an
> > internal representation. The second which is left over from the early
> > days is the secid which I equate to a file handle. The problem I see
> > is that the opaque blob (the xattr) is the interface presented to user
> > space. It isn't really used internally except to turn it into a data
> > structure or to write it to disk for persistence.
> 
> That is the way that selinux does it, do the other lsms also handle it
> this way?

Casey handles this a different way in Smack but it has more to do with
his model than his design. Since a Smack label is just a simple 23 byte
string he doesn't do any conversion to store it in Smack. SELinux
differs in that the label contains 4 components so these get broken out
into the security structure so they can be handled separately by the
security structure. I can't say for certain but I would probably say
that a label based LSM which attempts to implement several models will
probably have to do what SELinux does. The only thing I'm concerned with
is that Casey did mention when I was creating hooks for the Labeled NFS
work a situation where an LSM may implement multiple security.* xattrs.
We don't currently have any LSMs that work that way so I'm not sure if I
need to handle that now.

> 
> > The situation we have with sysfs is that there is no persistence for
> > labels and the in-core inode maybe evicted so we need a way of
> > persisting changes from the default label.
> 
> So you put it in the structure you did, which is correct.  You should
> also listen to all sysfs netlink messages to be sure to lable things
> when they are created, to handle the lack of persistence.

Thanks for the heads up. I'll make sure I look into this.

> 
> thanks,
> 
> greg k-h

