Return-Path: <linux-kernel-owner+w=401wt.eu-S1758591AbXFAI7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbXFAI7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 04:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbXFAI7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 04:59:34 -0400
Received: from ppsw-4.csi.cam.ac.uk ([131.111.8.134]:35248 "EHLO
	ppsw-4.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbXFAI7c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 04:59:32 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <20070516170110.GC8113@lazybastard.org>
References: <20070516170110.GC8113@lazybastard.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <B2D11B52-B25C-4063-BC4F-4066F78E286C@cam.ac.uk>
Cc: Andrew Morton <akpm@osdl.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       David Chinner <dgc@sgi.com>, Al Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
Content-Transfer-Encoding: 8BIT
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [PATCH resend] introduce I_SYNC
Date: Fri, 1 Jun 2007 09:59:17 +0100
To: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@lazybastard.org>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 16 May 2007, at 18:01, Jörn Engel wrote:
> Patches fixes a deadlock problem well enough for LogFS to survive.   
> The
> problem itself is generic and seems to be ancient.  Shaggy has code in
> JFS from about 2.4.20 that seems to work around the deadlock.  Dave
> Chinner indicated that this could cause latency problems (not a
> deadlock) on the NFS server side.

I agree that your patch is a good idea.  I reviewed the latest  
incarnation and it makes sense to me.  And your comment concerning  
the flags is a very welcome addition.  Probably ought to find its way  
into Documentation/filesystems/Locking or vfs.txt or somewhere like  
that also.

Note that once your patch is applied I think it would make sense to  
follow up with a second patch to remove the I_LOCK flag completely.   
The only remaining uses are either together with I_NEW in which case  
I_LOCK can be removed altogether or can be substituted with I_NEW  
when only I_LOCK is used.  This is because no places remain where we  
set I_LOCK by itself any more with your patch.  The only place where  
we set it is the place where a new inode gets created in memory and  
in that place we also set I_NEW at the same time as I_LOCK.   
wait_on_inode() can then be changed to wait on I_NEW instead of on  
I_LOCKED.  That way we have one less confusing flag to worry about  
and things are much easier to understand.

> I still suspect that NTFS has hit the same deadlock and its current  
> "fix" will cause data corruption instead.

The NTFS "fix" will not cause data corruption at all.  The usage in  
NTFS is very different...  I am afraid your patch does not address  
the deadlock with NTFS or rather it only addresses the inode write  
deadlock and does not address the get_new_inode() deadlock that  
exists with ilookup5() and is avoided by ilookup5_nowait().  This  
deadlock is inherent to what NTFS does so you don't need to worry  
about it.  (If you want I am happy to explain it but I would rather  
not waste my time explaining if no-one except me cares about it...)

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/


