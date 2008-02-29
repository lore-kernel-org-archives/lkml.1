Return-Path: <linux-kernel-owner+w=401wt.eu-S1762963AbYB2A3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762963AbYB2A3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 19:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760350AbYB2A3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:29:32 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:33338 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759106AbYB2A3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:29:30 -0500
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr
	name
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: Christoph Hellwig <hch@infradead.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, casey@schaufler-ca.com,
       viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <20080228234850.GA25829@infradead.org>
References: <746385.69480.qm@web36611.mail.mud.yahoo.com>
	 <1204227035.31790.207.camel@moss-spartans.epoch.ncsc.mil>
	 <20080228234850.GA25829@infradead.org>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 19:04:57 -0500
Message-Id: <1204243497.2715.24.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 18:48 -0500, Christoph Hellwig wrote:
> On Thu, Feb 28, 2008 at 02:30:35PM -0500, Stephen Smalley wrote:
> > This is an interface to be used by NFS to get information from the
> > security module.  The information desired is specific to the MAC
> > labeling functionality in NFSv4 that is being proposed.  That
> > functionality is MAC specific (necessarily so, just like the ACL
> > functionality is ACL specific).  We are hiding the SELinux-specific bits
> > behind the LSM interface, and non-MAC LSMs are free to return NULL in
> > order to indicate that they don't support MAC labeling.  We do NOT want
> > the capability module to return its security blob here, or any other
> > non-MAC LSM - it will yield the wrong semantics for the NFS MAC support.
> 
> I think Casey is totally right here.  The LSM interface should not be
> as specific here.  If you want to limit the NFSv4 interface to single
> MAC xattr label based systems add an additional method to check if
> the LSM is that.  But the proper fix is of course to not add somthing
> so specific to NFSv4 at all, as it's got enough shortcoming already.
> Please add a proper xattr protocol.  It's not like it's hard, SGI
> has been doing this in IRIX for NFSv3 for ages as a sideband protocol,
> and even release the reference source under the GPL.  Just either use
> that with NFSv4 or if you feel fancy merge it into the NFS spec for
> NFSv6^H4.2.

There are several things here. I've spoken to several people about this
and the belief I've gotten from most of them is that a recommended
attribute is how this is to be transported. The NFSv4 spec people will
probably say that if you want xattr like functionality for NFSv4 use
named attributes. For us this is not an option since we require
semantics to label on create/open and the only way we can do this is by
adding a recommended attribute. The create/open calls in NFSv4 takes a
list of attributes to use on create as part of the request. I really
don't see a difference between the security blob and the
username/groupname that NFSv4 currently uses. Also there is a good
chance that we will need to translate labels at some point (read future
work).

> 
> > In any event, I don't think we need your permission.
> 
> Wow, that's rude even to someone as direct as me.  Casey is the only
> other person having an in-tree LSM, and I think his input in this
> area is important.  But if not I as a VFS person can happily give
> you my "no" for the current version from the VFS point of view.

I can only speak for myself but honestly I've only seen Casey act
confrontational to this idea from the beginning. There is absolutely
nothing in here that is SELinux specific, tecnically its not even MAC
specific. I said from the beginning that this was perhaps not the best
name and we are willing to change it. There is nothing in this hook that
wasn't in LSM before. This is almost identical functionality to what
Adrian removed in 2.6.24. The only difference between this and
security_inode_getsuffix is that this returns security.suffix and that
the name is different. I don't have a SMACK box to test it on but I'm
99% sure that if Casey tried to use SMACK with this patch set that he
would have labeled nfs working with SMACK. If it doesn't work with SMACK
right now I'm willing to help him with that and even include it in the
patch set. But spreading FUD about how we are including SELinux specific
code in here is just that.

Dave

