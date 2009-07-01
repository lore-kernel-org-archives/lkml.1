Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbZGAKut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbZGAKut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 06:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbZGAKuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 06:50:40 -0400
Received: from mail.samba.org ([66.70.73.150]:37810 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbZGAKuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 06:50:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19019.16217.291678.588673@samba.org>
Date: Wed, 1 Jul 2009 20:50:01 +1000
To: Pavel Machek <pavel@ucw.cz>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <20090630063102.GB1351@ucw.cz>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

 > Defaults should be back-compatible.

I would usually agree, but I think we have an unusual situation here,
in some ways similar to a demonstrated security hole. The previous
behaviour exposed a lot of Linux vendors to the possibility of an
expensive legal fight.

If we had some way to be completely backwards compatible while
avoiding the legal issues then of course we should take that. I tried
hard to find a varient that achieved that, but the best I could manage
was what I have posted. It may be that someone else can find a better
varient that avoids the legal issues while remaining fully backward
compatible.

 > Users considering disabling this should understand that filesystem
 > they write to will not be valid vfat filesystems, and may trigger bugs
 > in some devices.

If we find any devices that exhibit any problems with this patch while
it is in linux-next (and maybe linux-mm?) then this warning would
indeed be appropriate. It no such devices are known then I think the
warning is going a bit far. 

Do you have a specific device in mind with regard to this warning?

 > What happens on collision? With 60000 entries in directory, there will
 > be 50% chance of collision. BAD.

Why do you say it is bad? You need to remember that those 11 bytes
cannot be used as a filename, so it isn't a filename collision. As I
mentioned in the reply to Eric's question, a quite good choice is to
use 11 spaces for every file, and that only falls down because
WindowsXP has a bug that causes that varient to bluescreen.

The only risks with collisions that I am aware of are:

  - there is a very small chance (much, _much_ less than 50% with 60k
    files) of WindowsXP bluescreening. I've never in fact managed to
    reproduce this with the current patch, despite many days of
    continuous randomised testing. The reason the probability is much
    smaller than 50% at 60k is that it doesn't bluescreen just because
    there is a duplicate 8.3 entry - it bluescreens with a particular
    access pattern that involves 2 entries with the same 11 bytes,
    that access pattern is very hard to produce.

  - chkdsk.exe will complain about duplicates, and will rename one of
    the two files. That is a 50% chance of 1 file being renamed for a
    single directory containing 60k files. Given it isn't all that
    common to run chkdsk on removable media that is shared between
    Linux and Windows, I thought that this is not a terribly large
    concern.

 > Why not use something like position in directory instead of random
 > number?

We did of course consider that, and the changes to the patch to
implement collision avoidance are relatively simple. We didn't do it
as it would weaken the legal basis behind the patch. I'll leave it to
John Lanza (the LF patent attorney) to expand on that if you want more
information.

Cheers, Tridge
