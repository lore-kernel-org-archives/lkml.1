Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbZAAELa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbZAAELa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 23:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbZAAELU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 23:11:20 -0500
Received: from mx2.netapp.com ([216.240.18.37]:32112 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbZAAELS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 23:11:18 -0500
X-IronPort-AV: E=Sophos;i="4.36,311,1228118400"; 
   d="scan'208";a="106452382"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Pull request for FS-Cache, including NFS patches
Date: Wed, 31 Dec 2008 20:11:13 -0800
Message-ID: <7A24DF798E223B4C9864E8F92E8C93EC01BD14BB@SACMVEXC1-PRD.hq.netapp.com>
In-Reply-To: <1230679056.11508.37.camel@heimdal.trondhjem.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Pull request for FS-Cache, including NFS patches
Thread-Index: Aclq1NeDCkkvgmaiRx6BeT3H4KKMOwA7mgQg
From: "Muntz, Daniel" <Dan.Muntz@netapp.com>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Bernd Schubert" <bernd.schubert@fastmail.fm>, <nfsv4@linux-nfs.org>,
       <linux-kernel@vger.kernel.org>, <steved@redhat.com>,
       <dhowells@redhat.com>, <linux-next@vger.kernel.org>,
       <linux-fsdevel@vger.kernel.org>, <rwheeler@redhat.com>
X-OriginalArrivalTime: 01 Jan 2009 04:11:15.0287 (UTC) FILETIME=[FD397E70:01C96BC6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure, trusted kernel and trusted executables,  but it's easier than it
sounds.  If you start with a "clean" system, you don't need to verify
excutables _if_ they're coming from the secured file server (by
induction: if you started out secure, the executables on the file server
will remain secure).  You simply can't trust the local disk from one
user to the next.  Following the protocol, a student can log into a
machine, su to do their OS homework, but not compromise the security of
the distributed file system.

If I can su while another user is logged in, or the kernel/cmds are not
validated between users, cryptfs isn't safe either.

If you're following the protocol, it doesn't even matter if a bad guy
("untrusted user"?) gets root on the client--they still can't gain
inappropriate access to the file server.  OTOH, if my security plan is
simply to not allow root access to untrusted users, history says I'm
going to lose.

  -Dan

-----Original Message-----
From: Trond Myklebust [mailto:trond.myklebust@fys.uio.no] 
Sent: Tuesday, December 30, 2008 3:18 PM
To: Muntz, Daniel
Cc: Andrew Morton; Stephen Rothwell; Bernd Schubert;
nfsv4@linux-nfs.org; linux-kernel@vger.kernel.org; steved@redhat.com;
dhowells@redhat.com; linux-next@vger.kernel.org;
linux-fsdevel@vger.kernel.org; rwheeler@redhat.com
Subject: RE: Pull request for FS-Cache, including NFS patches

On Tue, 2008-12-30 at 15:00 -0800, Muntz, Daniel wrote:
> Yes, and if you have a single user on the machine at a time (with 
> cache flushed inbetween, kernel refreshed), root can read /dev/kmem, 
> swap, intercept traffic and read cachefs data to its heart's 
> content--hence, those requirements.

Unless you _are_ root and can check every executable, after presumably
rebooting into your own trusted kernel, then those requirements won't
mean squat. If you're that paranoid, then you will presumably also be
using a cryptfs-encrypted partition for cachefs, which you unmount when
you're not logged in.

That said, most cluster environments will tend to put most of their
security resources into keeping untrusted users out altogether. The
client nodes tend to be a homogeneous lot with presumably only a trusted
few sysadmins...

Trond

> -----Original Message-----
> From: Trond Myklebust [mailto:trond.myklebust@fys.uio.no]
> Sent: Tuesday, December 30, 2008 2:36 PM
> To: Muntz, Daniel
> Cc: Andrew Morton; Stephen Rothwell; Bernd Schubert; 
> nfsv4@linux-nfs.org; linux-kernel@vger.kernel.org; steved@redhat.com; 
> dhowells@redhat.com; linux-next@vger.kernel.org; 
> linux-fsdevel@vger.kernel.org; rwheeler@redhat.com
> Subject: RE: Pull request for FS-Cache, including NFS patches
> 
> On Tue, 2008-12-30 at 14:15 -0800, Muntz, Daniel wrote:
> > >> As for security, look at what MIT had to do to prevent local disk

> > >> caching from breaking the security guarantees of AFS.
> > >
> > >See what David has added to the LSM code to provide the same 
> > >guarantees
> > for cachefs...
> > >
> > >Trond
> > 
> > Unless it (at least) leverages TPM, the issues I had in mind can't 
> > really be addressed in code.  One requirement is to prevent a local 
> > root user from accessing fs information without appropriate
> permissions.
> > This leads to unwieldly requirements such as allowing only one user 
> > on
> 
> > a machine at a time, blowing away the cache on logout, validating 
> > (e.g.,
> > refreshing) the kernel on each boot, etc.  Sure, some applications 
> > won't care, but you're also potentially opening holes that users may

> > not consider.
> 
> You can't prevent a local root user from accessing cached data: that's

> true with or without cachefs. root can typically access the data using

> /dev/kmem, swap, intercepting tty traffic, spoofing user creds,...
> If root can't be trusted, then find another machine.
> 
> The worry is rather that privileged daemons may be tricked into 
> revealing said data to unprivileged users, or that unprivileged users 
> may attempt to read data from files to which they have no rights using

> the cachefs itself. That is a problem that is addressable by means of 
> LSM, and is what David has attempted to solve.
> 
>   Trond
> 
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

