Return-Path: <linux-kernel-owner+w=401wt.eu-S932234AbXDCHiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbXDCHiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 03:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932536AbXDCHiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 03:38:09 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34563 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234AbXDCHiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 03:38:08 -0400
Date: Tue, 3 Apr 2007 13:08:30 +0530
From: Maneesh Soni <maneesh@in.ibm.com>
To: Ethan Solomita <solo@google.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Martin Bligh <mbligh@google.com>, Rohit Seth <rohitseth@google.com>,
       viro@ftp.linux.org.uk, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix sysfs_readdir oops (was Re: sysfs reclaim crash)
Message-ID: <20070403073830.GA9796@in.ibm.com>
Reply-To: maneesh@in.ibm.com
References: <20070319140238.cbf28b2b.akpm@linux-foundation.org> <20070321134654.5wkqpfbpk0ggwks8@imap.linux.ibm.com> <20070321182123.GA12602@in.ibm.com> <20070323043047.GA5641@in.ibm.com> <20070322210504.3b052139.akpm@linux-foundation.org> <46042DDF.5060000@google.com> <20070324030535.GA8874@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070324030535.GA8874@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2007 at 08:35:35AM +0530, Maneesh Soni wrote:
> On Fri, Mar 23, 2007 at 12:43:27PM -0700, Ethan Solomita wrote:
> >     I ran stress testing overnight and came up with a similar failure
> > (s_dentry == NULL) but in a different location. A NULL pointer
> > dereference happened in sysfs_readdir():
> > 
> > |                                if (next->s_dentry)
> > |                                        ino =
> > next->s_dentry->d_inode->i_ino;
> > 
> >     It seems that d_inode was NULL. I don't have the pointer to d_inode
> > to look at, but I have next and, lo and behold, its s_dentry is now
> > NULL, which it clearly wasn't when the if-clause above ran.
> > 
> >     I tried to reconstruct the sysfs_dirents starting with "next". I
> > filled in all the structure contents that I had data for:
> > 
> > sysfs_dirent 0xffff81000fc61690:
> > s_count         1
> > s_sibling       ffff81000fc616e8 / ffff81000e0c7468
> > s_children      ffff81000fc616a8 / ffff81000fc616a8
> > s_element       ffff81000f4ad1b0
> >   DOR__ATA1RTS
> >   ffffffff8800b600
> >   124
> > s_type          4
> > s_mode          8124
> > s_dentry        NULL
> > s_iattr         NULL
> > s_event         0
> > 
> > s_sibling.prev:
> > s_count         1
> > s_sibling       ffff81000fc61738 / ffff81000fc61698
> > s_children      ffff81000fc616f8 / ffff81000fc616f8
> > s_element       ffff81000f4ad148
> > s_type          4
> > s_mode          8124
> > <unknown>
> > 
> > s_sibling.next:
> > s_count         1
> > s_sibling       ffff81000fc61698 / ffff81000fc61648
> > s_children      ffff81000e0c7478 / ffff81000e0c7478
> > s_element       NULL
> > s_type          0
> > s_mode          0
> > s_dentry        NULL
> > s_iattr         NULL
> > s_event         0
> > 
> > s_sibling.next.next:
> > s_count         1
> > s_sibling       ffff81000e0c7468 / ffff81000fc615f8
> > s_children      ffff81000fc61658 / ffff81000fc61658
> > s_element       ffff81000f4ad218
> >   DOR__ATA1RTS
> >   ffffffff8800b600
> >   124
> > s_type          4
> > s_mode          8124
> > s_dentry        NULL
> > s_iattr         NULL
> > s_event         0
> > 
> > s_sibling.next.next.next:
> > s_count         1
> > s_sibling       ffff81000fc61648 / ffff81000fc610f8
> > s_children      ffff81000fc61608 / ffff81000fc61608
> > s_element       ffff81000f4ad280
> >   CK??ATCR
> >   ffffffff8800b600
> >   124
> > s_type          4
> > s_mode          8124
> > s_dentry        NULL
> > s_iattr         NULL
> > s_event         0
> > 
> >     I should acknowledge that this is based upon 2.6.18 with some newer
> > code backported. If there are fixes since 2.6.18 that we should know
> > about I can try backporting them into our kernel.
> > 
> >     Thanks,
> >     -- Ethan
> 
> 

Hi Ethan / Andrew,

I have modified the previous patch (which was dropped from -mm) and now keeping
the statement making s_dentry as NULL in sysfs_d_iput(), so this should
_safely_ fix sysfs_readdir() oops. 

Please see the other mail for sysfs_d_iput() BUG hit.

Thanks
Maneesh

--
Maneesh Soni
Linux Technology Center,
IBM India Systems and Technology Lab, 
Bangalore, India




o sysfs_d_iput() is invoked in dentry reclaim path under memory pressure. This
  happens without i_mutex. It also nullifies s_dentry to indicate that
  the associated dentry is evicted. sysfs_readdir() accesses the s_dentry,
  and gets the inode number from the associated dentry->d_inode, if 
  there is one, else it invokes iunique(). This can create a race situation,
  and crash while accessing the d_inode in sysfs_readdir(). 

o The race happens when the dentry is getting reclaimed and detached from
  the corresponding sysfs_dirent though sysfs_dirent is still a valid
  node. Accessing dentry fields are ok as it is under RCU but the inode is
  not hence we may see oops accessing dentry->d_inode->i_no.

o The following patch always use i_unique() to get the inode number in
  sysfs_readdir. This is ok as sysfs doesnot have permanent inode numbering.
  It could be slower but avoids the oops. 



Signed-off-by: Maneesh Soni <maneesh@in.ibm.com>
---

 linux-2.6.21-rc5-mm3-maneesh/fs/sysfs/dir.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/sysfs/dir.c~fix-sysfs_readdir-oops fs/sysfs/dir.c
--- linux-2.6.21-rc5-mm3/fs/sysfs/dir.c~fix-sysfs_readdir-oops	2007-04-03 10:39:52.000000000 +0530
+++ linux-2.6.21-rc5-mm3-maneesh/fs/sysfs/dir.c	2007-04-03 10:39:52.000000000 +0530
@@ -538,10 +538,7 @@ static int sysfs_readdir(struct file * f
 
 				name = sysfs_get_name(next);
 				len = strlen(name);
-				if (next->s_dentry)
-					ino = next->s_dentry->d_inode->i_ino;
-				else
-					ino = iunique(sysfs_sb, 2);
+				ino = iunique(sysfs_sb, 2);
 
 				if (filldir(dirent, name, len, filp->f_pos, ino,
 						 dt_type(next)) < 0)
_
