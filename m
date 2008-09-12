Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbYILNLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbYILNLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 09:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbYILNLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 09:11:12 -0400
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:33746 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753253AbYILNLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 09:11:12 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: vfat file system extreme fragmentation on multiprocessor
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Harun Scheutzow <harun04@scheutzow.de>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Fri, 12 Sep 2008 15:19:27 +0200
References: <baZfg-1yC-3@gated-at.bofh.it> <baZS2-2rX-15@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1Ke8YZ-0001Ss-QE@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen <lsorense@csclub.uwaterloo.ca> wrote:
> On Thu, Sep 11, 2008 at 08:01:16PM +0200, Harun Scheutzow wrote:

>> I like to share the following observation made with different kernels of
>> 2.6.x series, a T7100 Core2Duo CPU (effectively 2 processors). I have not
>> seen such a post while searching.
>> 
>> Two applications compress data at the same time and try to do their best to
>> avoid fragmenting the file system by writing blocks of 50 MByte to a VFAT
>> (FAT32) partition on SATA harddisk, cluster size 8 KByte. Resulting file size
>> is 200 to 250 MByte. It is ok to get 4 to 5 fragments per file. But at
>> random, approximately at every 4th file, there are a few 100 up to more than
>> 4500 (most likely case approx 1500) fragments for each of the two files
>> written in parallel.
[...]

> I don't think fat filesystems have any concept of reserving space for
> expanding files.  It's a pretty simple filesystem after all designed for
> a single cpu machine with a non-multitasking OS (if you can call DOS an
> OS).

And it's not designed to allow deleting files if they are open. Ad yet you
manage to keep the allocation in memory after removing the directory entry.
Keeping a pre-allocation will require a slightly different mechanism, because
the pre-allocated space needs to be stolen sometimes.

> Space tends to be allocated from the start of the disk wherever 
> free space is found since otherwise you would have to go searching for
> the free space, which isn't that efficient.

That's how it used to be done in very ancient DOS versions. Current versions
allocate from the most recently allocated cluster (and cache this value in
the superblock). It would be perfectly legal to search from the directory's
on-disk location onward, too, if you want to emulate ext2 behavior. (You'd
pick a random cluster if you'd create a directory.)

[...]
> Now what would happen if you used ftruncate to extend the file you open
> to a large size, and then started writing it, and then set the size
> correctly at the end?

The fs would write zeroes instead of the data, doing the same bad allocation,
because FAT doesn't support holes.

