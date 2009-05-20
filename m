Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbZETO14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbZETO14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 10:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbZETO1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 10:27:46 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:34414 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbZETO1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 10:27:43 -0400
X-Greylist: delayed 1538 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 May 2009 10:27:43 EDT
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20090520124920.GZ11363@kernel.dk>
Subject: Re: [PATCH 02/11] writeback: switch to per-bdi threads for flushing data
References: <1242649192-16263-1-git-send-email-jens.axboe@oracle.com> <1242649192-16263-3-git-send-email-jens.axboe@oracle.com> <20090520123710.GA29974@infradead.org> <20090520124920.GZ11363@kernel.dk>
Message-Id: <5DB1E671-D2D7-4052-977E-981EEDAD98FB@cam.ac.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Date: Wed, 20 May 2009 15:02:01 +0100
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, akpm@linux-foundation.org, jack@suse.cz,
       yanmin_zhang@linux.intel.com, aia21@cantab.net,
       linux-ntfs-dev@lists.sourceforge.net
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 20 May 2009, at 13:49, Jens Axboe wrote:
> On Wed, May 20 2009, Christoph Hellwig wrote:
>> Can you run the hunk below past Anton and get it upstream separately?
>> The code does indeed looks extremly fishy, but I'd rather not see it
>> go in a large unrelated patch..
>
> Yes, it really should go out of this patchset and into a prep patch.
> Anton, care to comment?
>
>> On Mon, May 18, 2009 at 02:19:43PM +0200, Jens Axboe wrote:
>>> diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
>>> index f76951d..c4cb157 100644
>>> --- a/fs/ntfs/super.c
>>> +++ b/fs/ntfs/super.c
>>> @@ -2373,39 +2373,13 @@ static void ntfs_put_super(struct  
>>> super_block *sb)
>>> 		vol->mftmirr_ino = NULL;
>>> 	}
>>> 	/*
>>> -	 * If any dirty inodes are left, throw away all mft data page  
>>> cache
>>> -	 * pages to allow a clean umount.  This should never happen any  
>>> more
>>> -	 * due to mft.c::ntfs_mft_writepage() cleaning all the dirty  
>>> pages as
>>> -	 * the underlying mft records are written out and cleaned.  If  
>>> it does,
>>> +	 * We should have no dirty inodes left, due to
>>> +	 * mft.c::ntfs_mft_writepage() cleaning all the dirty pages as
>>> +	 * the underlying mft records are written out and cleaned.
>>> 	 * happen anyway, we want to know...

You need to remove the above line, too.  It does not make sense to  
leave half a sentence there...

Otherwise you can apply this patch if you really want.  It is just a  
debug/bandaid.  I used to have problems where dirty inodes were left  
and I had put that in to allow the unmount to succeed properly.  I  
believe that should not happen any more as explained in the comment  
above but I left the fixup code as a sanity check that would produce  
output to the system log that people would hopefully report should my  
fix not be correct/sufficient...

Best regards,

Anton


>>>
>>> 	 */
>>> 	ntfs_commit_inode(vol->mft_ino);
>>> 	write_inode_now(vol->mft_ino, 1);
>>> -	if (sb_has_dirty_inodes(sb)) {
>>> -		const char *s1, *s2;
>>> -
>>> -		mutex_lock(&vol->mft_ino->i_mutex);
>>> -		truncate_inode_pages(vol->mft_ino->i_mapping, 0);
>>> -		mutex_unlock(&vol->mft_ino->i_mutex);
>>> -		write_inode_now(vol->mft_ino, 1);
>>> -		if (sb_has_dirty_inodes(sb)) {
>>> -			static const char *_s1 = "inodes";
>>> -			static const char *_s2 = "";
>>> -			s1 = _s1;
>>> -			s2 = _s2;
>>> -		} else {
>>> -			static const char *_s1 = "mft pages";
>>> -			static const char *_s2 = "They have been thrown "
>>> -					"away.  ";
>>> -			s1 = _s1;
>>> -			s2 = _s2;
>>> -		}
>>> -		ntfs_error(sb, "Dirty %s found at umount time.  %sYou should "
>>> -				"run chkdsk.  Please email "
>>> -				"linux-ntfs-dev@lists.sourceforge.net and say "
>>> -				"that you saw this message.  Thank you.", s1,
>>> -				s2);
>>> -	}
>>> #endif /* NTFS_RW */
>>>
>>> 	iput(vol->mft_ino);

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

