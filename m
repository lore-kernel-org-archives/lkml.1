Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbYIRITk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbYIRITk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 04:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYIRITb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 04:19:31 -0400
Received: from web32606.mail.mud.yahoo.com ([68.142.207.233]:23431 "HELO
	web32606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752640AbYIRITa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 04:19:30 -0400
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Thu, 18 Sep 2008 01:19:29 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
To: Greg Banks <gnb@melbourne.sgi.com>
Cc: linux-nfs list <linux-nfs@vger.kernel.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <136998.55258.qm@web32606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Greg Banks <gnb@melbourne.sgi.com>
> To: Martin Knoblauch <knobi@knobisoft.de>
> Cc: linux-nfs list <linux-nfs@vger.kernel.org>; linux-kernel@vger.kernel.org
> Sent: Thursday, September 18, 2008 3:42:54 AM
> Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
> 
> Martin Knoblauch wrote:
> > Hi,
> >
> > the following/attached patch works around a [obscure] problem when an 2.6 (not 
> sure/caring about 2.4) NFS client accesses an "offline" file on a Sun/Solaris-10 
> NFS server when the underlying filesystem is of type SAM-FS. Happens with 
> RHEL4/5 and mainline kernels. Frankly, it is not a Linux problem, but the chance 
> for a short-/mid-term solution from Sun are very slim. So, being lazy, I would 
> love to get this patch into Linux. If not, I just will have to maintain it for 
> eternity out of tree.
> >
> > The problem: SAM-FS is Suns proprietary HSM filesystem. It stores meta-data 
> and a relatively small amount of data "online" on disk and pushes old or 
> infrequently used data to "offline" media like e.g. tape. This is completely 
> transparent to the users. If the date for an "offline" file is needed, the so 
> called "stager daemon" copies it back from the offline medium. All of this works 
> great most of the time. Now, if an Linux NFS client tries to read such an 
> offline file, performance drops to "extremely slow". 
> By "extremely slow" do you mean "tape read speed"?
> > After lengthly investigation of tcp-dumps, mount options and procedures 
> involving black cats at midnight, we found out that the readahead behaviour of 
> the Linux NFS client causes the problem. Basically it seems to issue read 
> requests up to 15*rsize to the server. In the case of the "offline" files, this 
> behaviour causes heavy competition for the inode lock between the NFSD process 
> and the stager daemon on the Solaris server.
> > 
Hi Greg,

 my impression is, there is some confusion here. Likely caused by me not writing a good description :-(
 
> So, you need to
> 
> a) make your stager daemon do IO more sensibly, and
>

 As I am not affiliated with Sun in any way, it is "their" stager daemon. And I told "them", but a solution will not come before the next major release :-(
 
> b) apply something like this patch which adds O_NONBLOCK when knfsd does
> reads writes and truncates and translates -EAGAIN into NFS3ERR_JUKEBOX
> 
> http://kerneltrap.org/mailarchive/linux-fsdevel/2006/5/5/312567
> 

 OK, what has knfsd to do with it? The NFS server is Solaris-10 on Sparc.

> and
> 
> c) make your filesystem IO interposing layer report -EAGAIN when a
> process tries to do IO to an offline region in a file and O_NONBLOCK is
> present.

 I leave that to "them" :-)

> > - The real solution: fixing SAM-FS/NFSD interaction. Sun engineering acks the 
> problem, but a solution will need time. Lots of it.
> > - The working solution: disable the client side readahead, or make it tunable. 
> The patch does that by introducing a NFS module parameter "ra_factor" which can 
> take values between 1 and 15 (default 15) and a tunable 
> "/proc/sys/fs/nfs/nfs_ra_factor" with the same range and default.
> >  
> I think having a tunable for client readahead is an excellent idea,
> although not to solve your particular problem.  The SLES10 kernel has a
> patch which does precisely that, perhaps Neil could post it.
> 
> I don't think there's a lot of point having both a module parameter and
> a sysctl.
> 

 Actually there is a good reason. The module parameter can be used to set the new value at load time and never bother again. The sysctl is very convenient when doing experiments.

 As Andrew already pointed out, the best solution would be a mount option. But that seems much more involved as my workaround patch.

> A maximum of 15 is unwise.  I've found that (at least with the older
> readahead mechanisms in SLES10) a multiple of 4 is required to preserve
> rsize-alignment of READ rpcs to the server, which helps a lot with wide
> RAID backends.  So in SGI we tune client readahead to 16.
>

 15 is the value that the Linux NFS client uses., at least since 2.6.3. As it is not tunable up to today, the comment seems moot :-)  But it opens the questions:

a) should 1 be the minimum, or 0?
b) can the backing_dev_info.ra_pages field safely be set to something higher than 15?

> Your patch seems to have a bunch of other unrelated stuff mixed in.
> 

 Yeah, someone already pointed out, that the Makefile hunk does not belong there. But you say "a bunch" - anything else?

Cheers
Martin
PS: Did we ever meet/mail when I was at SGI (1991-1997)?

