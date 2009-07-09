Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbZGIRWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbZGIRWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 13:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbZGIRWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 13:22:40 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:48998 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbZGIRWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 13:22:39 -0400
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Greg KH <gregkh@suse.de>
Cc: jmorris@namei.org, sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <20090709151803.GB24302@suse.de>
References: <1247074106-23405-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <20090709151803.GB24302@suse.de>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 09 Jul 2009 13:13:33 -0400
Message-Id: <1247159613.4398.215.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 08:18 -0700, Greg KH wrote:
> On Wed, Jul 08, 2009 at 01:28:26PM -0400, David P. Quigley wrote:
> > --- a/fs/sysfs/sysfs.h
> > +++ b/fs/sysfs/sysfs.h
> > @@ -57,6 +57,7 @@ struct sysfs_dirent {
> >  	ino_t			s_ino;
> >  	umode_t			s_mode;
> >  	struct iattr		*s_iattr;
> > +	u32			s_secid;
> >  };
> 
> Why not just make this a void * like all other security hooks, and then
> you and SMACK can pick and choose what you want to embed here?
> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

The issue is that there really aren't any LSM hooks to accommodate that.
I have a few LSM hooks for the Labeled NFS work which could be used for
this but it still requires us to store the full xattr value somewhere
and referencing it in the sysfs_dirent structure. The issue here is that
there are two ways of presenting security information. The first is
through the xattr interface which represents the security information as
an opaque blob which the LSM turns into an internal representation. The
second which is left over from the early days is the secid which I
equate to a file handle. The problem I see is that the opaque blob (the
xattr) is the interface presented to user space. It isn't really used
internally except to turn it into a data structure or to write it to
disk for persistence.

The situation we have with sysfs is that there is no persistence for
labels and the in-core inode maybe evicted so we need a way of
persisting changes from the default label. What is really need here is
a way of persisting the security structure maintained by the LSM. Since
these structures are contained in the LSM the only reasonable
abstraction for this is for the LSM to provide a handle to refer to the
structure. There are two ways of doing this. One is with a large string
(the xattr) and the other is with a light weight handle (the secid).

Dave

