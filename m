Return-Path: <linux-kernel-owner+w=401wt.eu-S1757617AbXJ3JXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617AbXJ3JXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756211AbXJ3JXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:23:30 -0400
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:36947 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757503AbXJ3JX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:23:29 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: Mike Galbraith <efault@gmx.de>
In-Reply-To: <1193731202.7229.9.camel@Homer.simpson.net>
Subject: Re: [Linux-NTFS-Dev] 2.6.23 regression: second access of empty ntfs file leads to D	state hang
References: <1193638086.7409.21.camel@Homer.simpson.net> <E3E758D0-25AC-45B8-9BAB-F8CDF75AF3CA@cam.ac.uk> <1193658311.7324.2.camel@Homer.simpson.net> <4E61D235-B8E8-43DF-96A5-B3169E6AB223@cam.ac.uk> <1193668997.7284.2.camel@Homer.simpson.net> <1193671099.7172.0.camel@Homer.simpson.net> <1193731202.7229.9.camel@Homer.simpson.net>
Message-Id: <3BFCE55A-F7E2-4A19-8FD9-F23AF2A29D76@cam.ac.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v912)
Date: Tue, 30 Oct 2007 09:23:06 +0000
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ntfs-dev@lists.sourceforge.net,
       Neil Brown <neilb@suse.de>
X-Mailer: Apple Mail (2.912)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 30 Oct 2007, at 08:00, Mike Galbraith wrote:
> On Mon, 2007-10-29 at 16:18 +0100, Mike Galbraith wrote:
>> On Mon, 2007-10-29 at 15:43 +0100, Mike Galbraith wrote:
>>> On Mon, 2007-10-29 at 13:39 +0000, Anton Altaparmakov wrote:
>>>> Hi Mike,
>>>>
>>>> Thanks for the files.  That is really odd.  And you are sure this  
>>>> just
>>>> works with 2.6.22.10 on the exact same file?  Have you run   
>>>> "chkdsk /
>>>> f /v /x" on the NTFS volume from Windows?
>>>
>>> Yes, 2.6.22.10 can md5sum that file just fine, did it several  
>>> times.  I
>>> haven't run chkdsk.
>>
>> I now have fun chkdsk, it didn't gripe, and the error is still  
>> present.
>
> Not being very good at walking away from unsolved mysteries, I  
> chased it
> down.  The problem is that...
> 	commit[a32ea1e1f925399e0d81ca3f7394a44a6dafa12c] Fix read/truncate  
> race
> ...calls ntfs_readpage() for a zero i_size inode, which it isn't
> accustomed to.

Great, thanks for doing that!

> Below is the hammer which made my box a happy camper again.

Yes that will fix it but the complete solution is more involved as  
there are three related bugs which explain why you were getting the  
hangs after the error...  I will make a patch for all of these in the  
next few days...

Best regards,

	Anton

> diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
> index 6e5c253..ddab5a3 100644
> --- a/fs/ntfs/aops.c
> +++ b/fs/ntfs/aops.c
> @@ -401,7 +401,7 @@ static int ntfs_readpage(struct file *file,  
> struct page *page)
> 	MFT_RECORD *mrec;
> 	unsigned long flags;
> 	u32 attr_len;
> -	int err = 0;
> +	int err = 0, once = 0;
>
> retry_readpage:
> 	BUG_ON(!PageLocked(page));
> @@ -414,6 +414,18 @@ retry_readpage:
> 		return 0;
> 	}
> 	vi = page->mapping->host;
> +	/*
> +	 * If we've been called to read a zero sized inode, zero and bail.
> +	 */
> +	if (!once) {
> +		loff_t i_size = i_size_read(vi);
> +
> +		once++;
> +		if (!i_size) {
> +			zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
> +			goto done;
> +		}
> +	}
> 	ni = NTFS_I(vi);
> 	/*
> 	 * Only $DATA attributes can be encrypted and only unnamed $DATA


-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

