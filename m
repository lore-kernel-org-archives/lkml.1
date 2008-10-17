Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbYJQTv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbYJQTv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 15:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbYJQTvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 15:51:47 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:12566 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668AbYJQTvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 15:51:45 -0400
Date: Fri, 17 Oct 2008 12:48:57 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>,
       SCST-Devel <scst-devel@lists.sourceforge.net>,
       Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@osdl.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [ConfigFS]: Allow symbolic links from a SysFS struct
	kobject source.
Message-ID: <20081017194857.GD5633@mail.oracle.com>
Mail-Followup-To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
	Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
	Linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-scsi <linux-scsi@vger.kernel.org>,
	"Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>,
	SCST-Devel <scst-devel@lists.sourceforge.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrew Morton <akpm@osdl.org>,
	Christoph Hellwig <hch@infradead.org>
References: <1224226555.5556.279.camel@haakon2.linux-iscsi.org> <20081017074453.GA4850@kroah.com> <1224231739.5556.303.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224231739.5556.303.camel@haakon2.linux-iscsi.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 01:22:18AM -0700, Nicholas A. Bellinger wrote:
> On Fri, 2008-10-17 at 00:44 -0700, Greg KH wrote:
> > What is the problem you are attempting to solve here?
> > 
> 
> So, the generic target_core_mod engine that lives
> under /sys/kernel/config/target/core needs a method to locate struct
> block_device and struct scsi_device for access via bio_submit() and
> scsi_execute_() respectively.
> 
> Originally, target_core_mod used key echoed through configfs attributes
> like so:
> 
> export TARGET=/sys/kernel/config/target/core/
> 
> # Create $STORAGE_OBJECT of type Linux/BLOCK in generic target_core_mod
> mkdir -p $TARGET/iblock_0/lvm_test0
> # OLD METHOD to reference struct block_device
> echo iblock_major=254,iblock_minor=2 > $TARGET/iblock_0/lvm_test0/control
> echo 1 > $TARGET/iblock_0/lvm_test0/enable
> # NEW METHOD using sysfs ->configfs symlinks to reference struct block_device
> ln -s /sys/block/dm-2 $TARGET/iblock_0/lvm_test0/dm-2

	Pass an open file descriptor.  In bash(1):

    exec 3<>/dev/dm-7
    echo 3 >$TARGET/iblock_0/lvm_test0/control  # I'd call it 'fd'

In kernel, in the ->store() function of 'control':

	p = (char *)page;
	fd = simple_strtol(p, &p, 0);
	filp = fget(fd);
	inode = igrab(filp->f_mapping->host);
	dev = I_BDEV(filp->f_mapping->host);
	blkdev_get(dev, FMODE_WRITE | FMODE_READ, 0);

Error handling is left up to you (validate the strtol, fd range, ISBLK,
etc).  This assumes you want the struct block_device and want to pin it
in memory.  I assume you do.

Joel

-- 

Life's Little Instruction Book #450

	"Don't be afraid to say, 'I need help.'"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
