Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbXLKTyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbXLKTyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 14:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbXLKTx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 14:53:57 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:50749 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbXLKTx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 14:53:56 -0500
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
	settings for task actions [try #2]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: David Howells <dhowells@redhat.com>, Karl MacMillan <kmacmill@redhat.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <899818.54251.qm@web36606.mail.mud.yahoo.com>
References: <899818.54251.qm@web36606.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 11 Dec 2007 14:52:16 -0500
Message-Id: <1197402736.28006.90.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-10 at 15:46 -0800, Casey Schaufler wrote:
> --- David Howells <dhowells@redhat.com> wrote:
> 
> > Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > 
> > > From a config file whose pathname would be provided by libselinux (ala
> > > the way in which dbusd imports contexts), or directly as a context
> > > returned by a libselinux function.
> > 
> > That sounds too SELinux specific.  How do I do it so that it works for any
> > LSM?
> > 
> > Is linking against libselinux is a viable option if it's not available under
> > all LSM models?  Is it available under all LSM models?  Perhaps Casey can
> > answer this one.
> 
> Linking against libselinux is not now, nor will it ever be, a viable
> option. There's just too much sophistication contained in libselinux
> for us simple folk to deal with.
> 
> > > > I use to do that, but someone objected...  Possibly Karl MacMillan.
> > > 
> > > Yes, but I think I disagreed then too.
> > 
> > So, who's right?
> 
> Me! (smiley inserted here, for those in need)
> 
> > > It doesn't fit with how other users of security_kernel_act_as() will
> > > likely want to work (they will want to just set the context to a
> > > specified value, whether one obtained from the client or from some local
> > > source), nor with how type transitions normally work (exec, with the
> > > program type as the second type field).  I think it will just cause
> > > confusion and subtle breakage.
> > 
> > It's causing me lots of confusion as it is.  I have been / am being told by
> > different people to do different things just in dealing with SELinux, and
> > various people are raising extra requirements or restrictions beyond that.
> > There doesn't seem to be a consensus.
> > 
> > It sounds like the best option is just to have the kernel nick the userspace
> > daemon's security context and use that as is, and junk all the restrictions
> > on
> > what the daemon can do so that the kernel isn't too restricted.
> 
> That would be consistant with the (perhaps archaic now) behavior
> of nfsd on Unix, which did nothing but "lend it's credential" to the
> underlying kernel code. I think it's a rational approach, although I
> expect that in may have troubles under SELinux.

nfsd needs to able to set the acting label to a value determined based
on the client so that file operations performed on behalf of the client
are subjected to the right set of permission checks and new files are
labeled properly, just as it already does for uid and gid (via fsuid and
fsgid).  So merely inheriting the label from the nfsd daemon doesn't
help with that purpose.

Both nfsd and cachefiles need a way to set the acting label, so having a
common hook for both to do that makes sense.  The authorization of that
label will differ, so splitting the authorization into a separate hook
also makes sense.
 
-- 
Stephen Smalley
National Security Agency

