Return-Path: <linux-kernel-owner+w=401wt.eu-S933705AbZIDQU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933705AbZIDQU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933681AbZIDQUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:20:25 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:64481 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933674AbZIDQUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:20:22 -0400
Subject: Re: [PATCH 2/3] LSM/SELinux: inode_{get,set,notify}secctx hooks to
 access LSM security context information.
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>, jmorris@namei.org,
       casey@schaufler-ca.com, gregkh@suse.de, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <20090904154917.GB15342@us.ibm.com>
References: <1252002358-6612-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <1252002358-6612-3-git-send-email-dpquigl@tycho.nsa.gov>
	 <20090904154917.GB15342@us.ibm.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 04 Sep 2009 12:21:54 -0400
Message-Id: <1252081314.13634.333.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-04 at 10:49 -0500, Serge E. Hallyn wrote:
> Quoting David P. Quigley (dpquigl@tycho.nsa.gov):
> > This patch introduces three new hooks. The inode_getsecctx hook is used to get
> > all relevant information from an LSM about an inode. The inode_setsecctx is
> 
> The 'security_xyz_getctx' namespace is getting a bit polluted.  I suspect
> I should take this as a hint to rename my
> 	selinux_file_get_ctx()
> to
> 	selinux_checkpoint_file()

Yes, I think that would be clearer.

> or
> 	selinux_checkpoint_file_ctx()
> 
> to more clearly distinguish it from your hooks and the existing
> secid_to_secctx() set of .hooks
> 
> > used to set both the in-core and on-disk state for the inode based on a context
> > derived from inode_getsecctx.The final hook inode_notifysecctx will notify the
> > LSM of a change for the in-core state of the inode in question. These hooks are
> > for use in the labeled NFS code and addresses concerns of how to set security
> > on an inode in a multi-xattr LSM. For historical reasons Stephen Smalley's
> > explanation of the reason for these hooks is pasted below.
> > 
> > Quote Stephen Smalley
> > 
> > inode_setsecctx:  Change the security context of an inode.  Updates the
> > in core security context managed by the security module and invokes the
> > fs code as needed (via __vfs_setxattr_noperm) to update any backing
> > xattrs that represent the context.  Example usage:  NFS server invokes
> > this hook to change the security context in its incore inode and on the
> > backing file system to a value provided by the client on a SETATTR
> > operation.
> 
> So this is only to be called by kernel code, right?  Hence no
> authorization checks needed?

Correct.  And just to clarify, these hooks have been previously
discussed for the labeled NFS work, but were on hold until a user of
them (e.g. the labeled NFS support itself) was ready to upstream.  But
they turn out to be useful for sysfs labeling as well since they address
Casey's concerns about not passing secids and supporting multi-xattr
LSMs, so the sysfs patch was reworked to use them.

> 
> > inode_notifysecctx:  Notify the security module of what the security
> > context of an inode should be.  Initializes the incore security context
> > managed by the security module for this inode.  Example usage:  NFS
> > client invokes this hook to initialize the security context in its
> > incore inode to the value provided by the server for the file when the
> > server returned the file's attributes to the client.
> > 
> > Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
> 
> Acked-by: Serge Hallyn <serue@us.ibm.com>

-- 
Stephen Smalley
National Security Agency

