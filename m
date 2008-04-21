Return-Path: <linux-kernel-owner+w=401wt.eu-S1755005AbYDUVJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbYDUVJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYDUVIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:08:54 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42342 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYDUVIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:08:53 -0400
Date: Mon, 21 Apr 2008 15:08:45 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 0/4] jbd: possible filesystem corruption fixes
In-reply-to: <1208546807.9475.4.camel@localhost.localdomain>
To: Mingming Cao <cmm@us.ibm.com>
Cc: Josef Bacik <jbacik@redhat.com>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, jack@suse.cz,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Message-id: <20080421210738.GN2775@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <48089B86.5020108@hitachi.com>
 <20080418140946.GA26062@unused.rdu.redhat.com>
 <1208546807.9475.4.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 18, 2008  12:26 -0700, Mingming Cao wrote:
> On Fri, 2008-04-18 at 10:09 -0400, Josef Bacik wrote:
> > On Fri, Apr 18, 2008 at 10:00:54PM +0900, Hidehiro Kawai wrote:
> > > Subject: [PATCH 0/4] jbd: possible filesystem corruption fixes
> > > 
> > > The current JBD is not sufficient for I/O error handling.  It can
> > > cause filesystem corruption.   An example scenario:
> > > 
> > > 1. fail to write a metadata buffer to block B in the journal
> > > 2. succeed to write the commit record
> > > 3. the system crashes, reboots and mount the filesystem
> > > 4. in the recovery phase, succeed to read data from block B
> > > 5. write back the read data to the filesystem, but it is a stale
> > >    metadata
> > > 6. lose some files and directories!
> > > 
> > > This scenario is a rare case, but it (temporal I/O error)
> > > can occur.  If we abort the journal between 1. and 2., this
> > > tragedy can be avoided.
> > > 
> > > This patch set fixes several error handling problems to protect
> > > from filesystem corruption caused by I/O errors.  It has been
> > > done only for JBD and ext3 parts.
> 
> Could you sent Ext4/JBD2 version patches? Thanks!

Actually, the journal checksum in ext4/jbd2 detects this kind of error,
as well as errors that are NOT reported to the caller (e.g. media errors
not reported to the kernel).

One question is whether we want to _introduce_ a point of failure to the
filesystem that may never actually cause a problem for the system,
since the journal is only needed in the case of a crash.  By aborting
the journal at this point instead of letting the checkpoint write the
data to the filesystem then we are guaranteed a filesystem failure
instead of "likely no problem at all".

The journal checksum would detect the bad data in the transaction in the
cases where it is important, and during operation it makes more sense
to report the error via printk() so the administrator has some chance to
do something about it.  There is no reason why the jbd2 change couldn't be
merged back to jbd so ext3 could use the journal checksumming.  It is a
"COMPAT" journal feature.

> > There doesn't seem like much point in taking these patches as Jan is rewriting
> > the ordered mode path and most of these functions will be going away soon.
> > Those patches seem like they will be coming soon and will obsolete these.
> 
> I hope we have a better ordered mode very soon too. Just thought it's
> still valid to fix the current ordered mode for people who uses
> linux-2.6.25 kernel today. 

I agree that we should at least report the errors to the syslog (if this
isn't happening already) so the admin knows there is a problem, and I also
agree that waiting for some future patch isn't a good reason to stop making
fixes to the current code.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

