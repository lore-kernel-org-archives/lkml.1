Return-Path: <linux-kernel-owner+w=401wt.eu-S932494AbZDAW6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494AbZDAW6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 18:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761204AbZDAW6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 18:58:25 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:58616 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765760AbZDAW6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 18:58:24 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-12.arcor-online.net EB3791B3895
Date: Thu, 2 Apr 2009 00:58:20 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Pavel Machek <pavel@ucw.cz>
cc: Theodore Tso <tytso@mit.edu>, Bodo Eggert <7eggert@gmx.de>,
       Artem Bityutskiy <dedekind@yandex.ru>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: replace() system call needed (was Re: EXT4-ish "fixes" in
 UBIFS)
In-Reply-To: <20090401205201.GI17808@elf.ucw.cz>
Message-ID: <alpine.LSU.0.999.0904020025180.6204@be1.lrz>
References: <ckjPq-2Dl-15@gated-at.bofh.it> <cl2jy-65z-1@gated-at.bofh.it>
 <cl2CZ-6q2-21@gated-at.bofh.it> <cl2N9-6Bj-9@gated-at.bofh.it>
 <E1LolUc-0003kM-FU@be1.7eggert.dyndns.org> <20090401000657.GH15063@mit.edu>
 <20090401205201.GI17808@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Apr 2009, Pavel Machek wrote:
> On Tue 2009-03-31 20:06:57, Theodore Tso wrote:
> > On Tue, Mar 31, 2009 at 11:27:33PM +0200, Bodo Eggert wrote:

> > > This can be done using implicit logic:
> > > 
> > > ->E.g. on close(), mark inodes without being sync()ed as poisoned.
> > > (I can think of more sophisticated logic, but ...)
> > > ->On completing the inode with the delayed allocations, unpoison it.
> > > ->Don't commit rename()s if the corresponding inode is poisoned.
> > 
> > Send us patches if you think it's that easy to do what you are
> > proposing.   I assure it's not easy.
> 
> Well, implementing replace() syscall would be quite easy. Would you
> want such a patch?

You'd need - minus setting the flag on close - about the same logic:
- detecting if the inode are dirty
- detecting when the inode gets into a clean state
- delaying the commit of the rename() until then
- not replaying parts of the journal

As I understand, the replace() should not behave different from rename(),
except for making a guaranty. Since this guaranty is desired anyway, I 
think making it automatically would be a good thing. Especially until
all applications are rewritten ...

Off cause if you call replace, you know it's going to be OK, but you could 
also use pathconf($configdir, _PC_SYNC_BEFORE_RENAME)
(== 0: Sync or barrier implicit, (data = ordered)
    1: small chance of data loss due to not syncing, (vfat?)
    2: guarantee of data loss without sync (ext4))

// userspace.c
static inline int sync_before_rename(char * where, int is_important_data)
{
	#ifndef _PC_SYNC_BEFORE_RENAME
		// be optimistic for unimportant data
		return is_important_data;
	#else
		int ret = pathconf(where, _PC_SYNC_BEFORE_RENAME);
		if (is_important_data)
			return ret;
		return (ret > 1);
	#endif
}
-- 
How do I set my laser printer on stun?
