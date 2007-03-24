Return-Path: <linux-kernel-owner+w=401wt.eu-S1752249AbXCXDFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbXCXDFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 23:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbXCXDFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 23:05:22 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44716 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbXCXDFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 23:05:20 -0400
Date: Sat, 24 Mar 2007 08:35:35 +0530
From: Maneesh Soni <maneesh@in.ibm.com>
To: Ethan Solomita <solo@google.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Martin Bligh <mbligh@google.com>, Rohit Seth <rohitseth@google.com>,
       viro@ftp.linux.org.uk, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sysfs reclaim crash
Message-ID: <20070324030535.GA8874@in.ibm.com>
Reply-To: maneesh@in.ibm.com
References: <20070319140238.cbf28b2b.akpm@linux-foundation.org> <20070321134654.5wkqpfbpk0ggwks8@imap.linux.ibm.com> <20070321182123.GA12602@in.ibm.com> <20070323043047.GA5641@in.ibm.com> <20070322210504.3b052139.akpm@linux-foundation.org> <46042DDF.5060000@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46042DDF.5060000@google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 12:43:27PM -0700, Ethan Solomita wrote:
>     I ran stress testing overnight and came up with a similar failure
> (s_dentry == NULL) but in a different location. A NULL pointer
> dereference happened in sysfs_readdir():
> 
> |                                if (next->s_dentry)
> |                                        ino =
> next->s_dentry->d_inode->i_ino;
> 
>     It seems that d_inode was NULL. I don't have the pointer to d_inode
> to look at, but I have next and, lo and behold, its s_dentry is now
> NULL, which it clearly wasn't when the if-clause above ran.
> 
>     I tried to reconstruct the sysfs_dirents starting with "next". I
> filled in all the structure contents that I had data for:
> 
> sysfs_dirent 0xffff81000fc61690:
> s_count         1
> s_sibling       ffff81000fc616e8 / ffff81000e0c7468
> s_children      ffff81000fc616a8 / ffff81000fc616a8
> s_element       ffff81000f4ad1b0
>   DOR__ATA1RTS
>   ffffffff8800b600
>   124
> s_type          4
> s_mode          8124
> s_dentry        NULL
> s_iattr         NULL
> s_event         0
> 
> s_sibling.prev:
> s_count         1
> s_sibling       ffff81000fc61738 / ffff81000fc61698
> s_children      ffff81000fc616f8 / ffff81000fc616f8
> s_element       ffff81000f4ad148
> s_type          4
> s_mode          8124
> <unknown>
> 
> s_sibling.next:
> s_count         1
> s_sibling       ffff81000fc61698 / ffff81000fc61648
> s_children      ffff81000e0c7478 / ffff81000e0c7478
> s_element       NULL
> s_type          0
> s_mode          0
> s_dentry        NULL
> s_iattr         NULL
> s_event         0
> 
> s_sibling.next.next:
> s_count         1
> s_sibling       ffff81000e0c7468 / ffff81000fc615f8
> s_children      ffff81000fc61658 / ffff81000fc61658
> s_element       ffff81000f4ad218
>   DOR__ATA1RTS
>   ffffffff8800b600
>   124
> s_type          4
> s_mode          8124
> s_dentry        NULL
> s_iattr         NULL
> s_event         0
> 
> s_sibling.next.next.next:
> s_count         1
> s_sibling       ffff81000fc61648 / ffff81000fc610f8
> s_children      ffff81000fc61608 / ffff81000fc61608
> s_element       ffff81000f4ad280
>   CK??ATCR
>   ffffffff8800b600
>   124
> s_type          4
> s_mode          8124
> s_dentry        NULL
> s_iattr         NULL
> s_event         0
> 
>     I should acknowledge that this is based upon 2.6.18 with some newer
> code backported. If there are fixes since 2.6.18 that we should know
> about I can try backporting them into our kernel.
> 
>     Thanks,
>     -- Ethan


Hi Ethan,

Thank you very much for the crash data. This is helpful. Could you please
test the appended patch. Here we avoid modifying s_dentry in sysfs_d_iput()
and also uses iunique() in sysfs_readdir() instead of accessing s_dentry
to get the inode number. 

Though I was not able to recreate this race without the patch, but I am
running this patch successfully for more than 6 hrs now with the following
loops parallely on a 4-way SMP system. So, at least it has not done anything
bad.

1. while true; do insmod drivers/net/dummy.ko ; rmmod dummy; done
2. [root@llm01 net]# pwd
   /sys/class/net
   [root@llm01 net]# while true; do find | xargs cat > /dev/null; done
3. [root@llm01 sys]# pwd
   /sys
   [root@llm01 sys]# while true; do ls -liR; done

Also, CC-ed Viro and lkml for feedback.

Thanks
Maneesh


o sysfs_d_iput() is invoked in dentry reclaim path under memory pressure. This
  happens without i_mutex. It also nullifies s_dentry just to indicate that
  the associated dentry is evicted. sysfs_readdir() access the s_dentry,
  and gets the inode number from the associated dentry, if there is one, else
  it invokes iunique(). This can create a race situation, and crash while
  accessing the dentry/inode in sysfs_readdir().
  
o The following patch always use i_unique() to get the inode number. This
  is ok as sysfs doesnot have permanent inode numbering. It could be slower
  but avoids the above mentioned race. 

o This also avoids the now unnecessary s_dentry in sysfs_d_iput().

Signed-off-by: Maneesh Soni <maneesh@in.ibm.com>
---

 linux-2.6.21-rc4-git8-maneesh/fs/sysfs/dir.c |    6 +-----
 1 files changed, 1 insertion(+), 5 deletions(-)

diff -puN fs/sysfs/dir.c~fix-sysfs-reclaim-race fs/sysfs/dir.c
--- linux-2.6.21-rc4-git8/fs/sysfs/dir.c~fix-sysfs-reclaim-race	2007-03-24 02:06:38.000000000 +0530
+++ linux-2.6.21-rc4-git8-maneesh/fs/sysfs/dir.c	2007-03-24 02:09:26.000000000 +0530
@@ -20,7 +20,6 @@ static void sysfs_d_iput(struct dentry *
 
 	if (sd) {
 		BUG_ON(sd->s_dentry != dentry);
-		sd->s_dentry = NULL;
 		sysfs_put(sd);
 	}
 	iput(inode);
@@ -538,10 +537,7 @@ static int sysfs_readdir(struct file * f
 
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

--
Maneesh Soni
Linux Technology Center,
IBM India Systems and Technology Lab, 
Bangalore, India
