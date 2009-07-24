Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbZGXS6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbZGXS6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 14:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZGXS6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 14:58:42 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:34084 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbZGXS6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 14:58:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19050.1094.758320.38666@stoffel.org>
Date: Fri, 24 Jul 2009 14:58:14 -0400
From: "John Stoffel" <john@stoffel.org>
To: Andreas Dilger <adilger@sun.com>
Cc: Ludwig Nussel <ludwig.nussel@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] implement uid mount option for ext2
In-Reply-To: <20090724165201.GA4231@webber.adilger.int>
References: <1248348991-849-1-git-send-email-ludwig.nussel@suse.de>
	<1248431444-18842-1-git-send-email-ludwig.nussel@suse.de>
	<1248431444-18842-2-git-send-email-ludwig.nussel@suse.de>
	<20090724165201.GA4231@webber.adilger.int>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andreas" == Andreas Dilger <adilger@sun.com> writes:

Andreas> On Jul 24, 2009  12:30 +0200, Ludwig Nussel wrote:
>> @@ -1353,7 +1356,13 @@ int ext2_write_inode(struct inode *inode, int do_sync)
>> 
>> ext2_get_inode_flags(ei);
raw_inode-> i_mode = cpu_to_le16(inode->i_mode);
>> +	if (EXT2_SB(sb)->s_uid &&
>> +	    inode->i_uid == EXT2_SB(sb)->s_uid) {
>> +		raw_inode->i_uid_high = 0;
>> +		raw_inode->i_uid_low  = 0;
>> +		raw_inode->i_gid_high = 0;
>> +		raw_inode->i_gid_low  = 0;

Andreas> I would suggest to also clear the SUID flag on this inode.
Andreas> Otherwise, it opens the risk of creating SUID root files that
Andreas> might be handled incorrectly.

Andreas> To be honest, rather than mapping the specified file to uid
Andreas> == 0/gid == 0 it would be more useful (and safe) to allow
Andreas> specifying a mapping from one UID to another, or have the
Andreas> on-disk UID always be set to/from the specified UID.  Given
Andreas> that your original problem is for the user having UIDX on
Andreas> system X and UIDY on system Y, you should just specify the
Andreas> X->Y mapping explicitly, instead of an implicit X->0 mapping.
Andreas> Otherwise, if the user is unable to access root-owned files
Andreas> on either one of system X or Y your current patch fails.

I didn't read the original email closely, but I have to say that both
of these plans don't sound good to me.  If you can mount a filesystem,
you're root already, so you can do any fixup you need.

If you're sharing the filesystem via a Network Filesystem, then you
have to have proper UIDs that match.

If you're moving a disks (USB, eSATA, whatever) between systems, then
I don't think *either* system should do anything automatically.  It's
too fraught with danger.  

Andreas> I would have the option be something like
Andreas> "uid={local_uid}={disk_uid}" (which hopefully the option
Andreas> parser can handle), or "uid=X:Y" if not.  That way, the
Andreas> on-disk filesystem will remain correct for at least one of
Andreas> the two systems.  If someone wants to specify disk_uid=0 that
Andreas> is fine, but it shouldn't be the only option.

So what happens when you have 1000 UIDs on a disk you want to re-map?
How does that happen?  Or if this option is just for a single UID
mapping, then it's seems to be just as easy to have a script you run
after mounting to fixup the disk.  

Or better yet, just match the UIDs, though I understand why this would
be a problem if you don't control one of the systems completely, or if
you're trying to move the disk between three or more systems and you
can't control two or more of them with conflicting UIDs.

But in that case, you're screwed anyway and it's going to become
un-manageable.  Push this to userspace, not the kernel since it's a
userspace issue when you come right down to it.

John
