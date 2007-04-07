Return-Path: <linux-kernel-owner+w=401wt.eu-S965626AbXDGIb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965626AbXDGIb3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 04:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965635AbXDGIb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 04:31:28 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:62857 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965626AbXDGIb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 04:31:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=iGnuQIDvaiDzIFPpzbL/Eq4UV2kVqHHvDbhiS4mA+YT8Qsm+1UqH8ePlpKpXV1QTTNkb8LGMsxlibRZNBWbL3peDec4EMh8d3h1tLfI8ilYgsXnMm7i4+qkW2M+dlpVSt5YvVB/VaPBB8m3KC8wMkF+uSO54GuwhN4RDqlmguMQ=
Message-ID: <461756D8.8070002@gmail.com>
Date: Sat, 07 Apr 2007 17:31:20 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: maneesh@in.ibm.com
CC: Ethan Solomita <solo@google.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Martin Bligh <mbligh@google.com>, Rohit Seth <rohitseth@google.com>,
       viro@ftp.linux.org.uk, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix sysfs_readdir oops (was Re: sysfs reclaim crash)
References: <20070319140238.cbf28b2b.akpm@linux-foundation.org> <20070321134654.5wkqpfbpk0ggwks8@imap.linux.ibm.com> <20070321182123.GA12602@in.ibm.com> <20070323043047.GA5641@in.ibm.com> <20070322210504.3b052139.akpm@linux-foundation.org> <46042DDF.5060000@google.com> <20070324030535.GA8874@in.ibm.com> <20070403073830.GA9796@in.ibm.com>
In-Reply-To: <20070403073830.GA9796@in.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Maneesh.

Maneesh Soni wrote:
> o sysfs_d_iput() is invoked in dentry reclaim path under memory pressure. This
>   happens without i_mutex. It also nullifies s_dentry to indicate that
>   the associated dentry is evicted. sysfs_readdir() accesses the s_dentry,
>   and gets the inode number from the associated dentry->d_inode, if 
>   there is one, else it invokes iunique(). This can create a race situation,
>   and crash while accessing the d_inode in sysfs_readdir(). 
> 
> o The race happens when the dentry is getting reclaimed and detached from
>   the corresponding sysfs_dirent though sysfs_dirent is still a valid
>   node. Accessing dentry fields are ok as it is under RCU but the inode is
>   not hence we may see oops accessing dentry->d_inode->i_no.
> 
> o The following patch always use i_unique() to get the inode number in
>   sysfs_readdir. This is ok as sysfs doesnot have permanent inode numbering.
>   It could be slower but avoids the oops. 

This isn't correct as i_unique() assumes the inode is in inode hash
table which isn't true for sysfs.  This can result in duplicate inode
numbers.  Please take a look at the following alternative fix.

  http://article.gmane.org/gmane.linux.kernel/513325

Thanks.

-- 
tejun
