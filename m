Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbYIQQXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbYIQQXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbYIQQXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:23:07 -0400
Received: from web32607.mail.mud.yahoo.com ([68.142.207.234]:34481 "HELO
	web32607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753396AbYIQQXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:23:06 -0400
X-YMail-OSG: r9PPbd0VM1kej7.Mvfq7PEY82hRx1YFowHXf1DZOKCtIejuYwonPQ3uj5XSAbu.UafLG.wlKeZgVSQyQfGBA4OZznaVsgroV_we0DA6Ey5SdQyaFm56lwXJEp0tjeL4-
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Wed, 17 Sep 2008 09:23:03 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
To: Chuck Lever <chucklever@gmail.com>, Peter Staubach <staubach@redhat.com>
Cc: linux-nfs list <linux-nfs@vger.kernel.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <804604.40886.qm@web32607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Chuck Lever <chucklever@gmail.com>
> To: Peter Staubach <staubach@redhat.com>
> Cc: Martin Knoblauch <knobi@knobisoft.de>; linux-nfs list <linux-nfs@vger.kernel.org>; linux-kernel@vger.kernel.org
> Sent: Wednesday, September 17, 2008 5:41:15 PM
> Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
> 
> On Wed, Sep 17, 2008 at 9:06 AM, Peter Staubach wrote:
> > Martin Knoblauch wrote:
> >>
> >> Hi,
> >>
> >> the following/attached patch works around a [obscure] problem when an 2.6
> >> (not sure/caring about 2.4) NFS client accesses an "offline" file on a
> >> Sun/Solaris-10 NFS server when the underlying filesystem is of type SAM-FS.
> >> Happens with RHEL4/5 and mainline kernels. Frankly, it is not a Linux
> >> problem, but the chance for a short-/mid-term solution from Sun are very
> >> slim. So, being lazy, I would love to get this patch into Linux. If not, I
> >> just will have to maintain it for eternity out of tree.
> >>
> >> The problem: SAM-FS is Suns proprietary HSM filesystem. It stores
> >> meta-data and a relatively small amount of data "online" on disk and pushes
> >> old or infrequently used data to "offline" media like e.g. tape. This is
> >> completely transparent to the users. If the date for an "offline" file is
> >> needed, the so called "stager daemon" copies it back from the offline
> >> medium. All of this works great most of the time. Now, if an Linux NFS
> >> client tries to read such an offline file, performance drops to "extremely
> >> slow". After lengthly investigation of tcp-dumps, mount options and
> >> procedures involving black cats at midnight, we found out that the readahead
> >> behaviour of the Linux NFS client causes the problem. Basically it seems to
> >> issue read requests up to 15*rsize to the server. In the case of the
> >> "offline" files, this behaviour causes heavy competition for the inode lock
> >> between the NFSD process and the stager daemon on the Solaris server.
> >>
> >> - The real solution: fixing SAM-FS/NFSD interaction. Sun engineering acks
> >> the problem, but a solution will need time. Lots of it.
> >> - The working solution: disable the client side readahead, or make it
> >> tunable. The patch does that by introducing a NFS module parameter
> >> "ra_factor" which can take values between 1 and 15 (default 15) and a
> >> tunable "/proc/sys/fs/nfs/nfs_ra_factor" with the same range and default.
> >
> > Hi.
> >
> > I was curious if a design to limit or eliminate read-ahead
> > activity when the server returns EJUKEBOX was considered?
> > Unless one can know that the server and client can get into
> > this situation ahead of time, how would the tunable be used?
> 
> I tend to agree.  A tunable is probably not a good solution in this case.
> 
> I would bet that this lock contention issue is a problem in other more
> common cases, and would merit some careful analysis.
> 

 Are you talking wrt. a Solaris NFS-Server with SAM-FS/QFS as backend filesystem? We have in a lot of tests not observed any problems when accessing online files with the default readahead setting. The "offline" situation seems unique. As for other NFS Servers, we have never observed any readahead related problems either.

 As I already replied elsewhere, teaching the Linux NFS client to do "proper" readahead handling is beyond my knowledge. But I can test. I guess Sun engineering would be delighted if they don't have to fix their stuff :-)

Cheers
Martin

