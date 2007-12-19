Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbXLSO4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbXLSO4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 09:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbXLSOz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 09:55:56 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:56682 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537AbXLSOzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 09:55:55 -0500
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
	settings for task actions [try #2]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Crispin Cowan <crispin@crispincowan.com>
Cc: David Howells <dhowells@redhat.com>, Karl MacMillan <kmacmill@redhat.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org,
       apparmor-dev <apparmor-dev@forge.novell.com>
In-Reply-To: <47688FEA.9070905@crispincowan.com>
References: <1197401823.28006.74.camel@moss-spartans.epoch.ncsc.mil>
	 <1197322068.18120.176.camel@moss-spartans.epoch.ncsc.mil>
	 <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil>
	 <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil>
	 <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
	 <20071205193859.24617.36392.stgit@warthog.procyon.org.uk>
	 <25037.1197306473@redhat.com> <25572.1197320887@redhat.com>
	 <25965.1197329769@redhat.com>   <9789.1197405725@redhat.com>
	 <1197408847.28006.184.camel@moss-spartans.epoch.ncsc.mil>
	 <47688FEA.9070905@crispincowan.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 19 Dec 2007 09:54:14 -0500
Message-Id: <1198076054.19081.34.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-12-18 at 19:28 -0800, Crispin Cowan wrote:
> Stephen Smalley wrote:
> >> It is if I have to maintain a special pieces of code for each possible LSM.
> >> One piece for SELinux, one piece for AppArmour, one piece for Smack, one piece
> >> for Casey's security system.  That sounds like a pain.
> >>     
> > All your code has to do is invoke a function provided by libselinux.  If
> > at some later time a liblsm is introduced that provides a common
> > front-end to a libselinux, libsmack, ..., then you can use that.  But it
> > doesn't exist today.   But it all just becomes a simple function call
> > regardless.
> >   
> libapparmor exists. It only had one API, and now it has 2, but just 2
> versions on the same concept (change_hat and change_profile).
> 
> This is the API for change_hat http://man-wiki.net/index.php/2:change_hat
> 
> What does the corresponding API in SELinux look like?

The SELinux API for changing context is described in:
http://linux.die.net/man/3/setcon

However, setting the current context (SELinux) or profile (AppArmor) for
a userspace task doesn't really provide the functionality required here
for cachefiles, nor does it solve the (different, yet related) nfsd
problem.

cachefiles is a kernel module that needs to assume a different set of
credentials for its internal accesses to the cache files it manages when
a userspace process tries to access a file that has been cached, as the
userspace process in whose context it is operating may (and should) lack
direct permission to those cache files.  The userspace API being talked
about is simply how one configures the credentials to be used by
cachefiles kernel module for its internal accesses, and is done up front
when cachefiles is configured to create a cache.  The internal switching
of the active set of credentials is done via a kernel-internal API (or
just by switching the pointer to the credential structure previously set
up) when the cachefiles kernel module wants to access a cache file.
Further, when this internal switching occurs, we have to be careful that
there are no user-visible side effects on the current task - no change
in how others may operate on that task e.g. signal permission checks or
on how the task appears to others e.g. via /proc.

Neither change_hat nor setcon helps with that problem.

For AppArmor, I suspect that you just want the cachefiles kernel module
to act as unconfined for its internal accesses, nothing more.

-- 
Stephen Smalley
National Security Agency

