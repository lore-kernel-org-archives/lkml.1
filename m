Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbZF1CT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbZF1CT3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 22:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbZF1CTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 22:19:19 -0400
Received: from mail.samba.org ([66.70.73.150]:34110 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbZF1CTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 22:19:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19014.54044.484370.187018@samba.org>
Date: Sun, 28 Jun 2009 12:19:08 +1000
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <m1d48p5dil.fsf@fess.ebiederm.org>
References: <19013.8005.541836.436991@samba.org>
	<m1d48p5dil.fsf@fess.ebiederm.org>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

 > This hunk allowing the examination of the long name if there is not a
 > short name is something else entirely.
 > 
 > You don't describe it in your summary, and don't make the case that
 > this is the correct behavior.

Sorry for not explaining that part of the patch in my posting.

The reason I initially included it was that during the development of
this patch we were experimenting with variations of the
vfat_build_dummy_83_buffer() function which put a wide varity of
different values in the 11 bytes where a short filename would normally
go.

The most technically attractive varient was to put 11 spaces in
there. That has the advantage that Windows then returns the long name
to the GetShortPathName() API call, which is also what Windows does on
a NTFS filesystem when the NTFS filesystem is configured not to have
8.3 names. So it would have been very nice to have this same behaviour
on VFAT, instead of getting a single space back from
GetShortPathName() as we get with the patch I posted.

The reason we didn't go with the 11 spaces varient is that it causes
WindowsXP to bluescreen. This is just a bug in WinXP, and is not
present in Vista or Windows7.

The 2nd technical problem with 11 spaces is that current Linux kernels
would not see the long names, as the last_u logic in fat_search_long()
will skip files where the the 11 bytes don't have at least one
non-space byte before the first nul byte in either the 8 byte prefix
or the 3 byte extension.

The last_u logic is at odds with the behaviour of other operating
systems for VFAT. On all windows varients that I have tested (and on
MacOSX), the long name is still used no matter what values are in the
11 bytes. You can stick all nul bytes, all spaces, or anything else
you like in there and Windows will still allow you to operate on the
file by the long name and the filesystem will work perfectly.

So that part of the patch is bringing us inline with the behaviour of
other VFAT implementations.

More importantly, it gives us the opportunity in the future to move to
the techically better 11 spaces solution when either Microsoft fixes
their WindowsXP crash bug, or WindowsXP has such a low market share
that nobody cares any more (say like WfWg and maybe Win95 has now).

If we don't put in this change now then we won't be able to move to
the technically better solution later as we wouldn't have given Linux
distros a chance to include support for the 11 spaces in distros. By
putting that change in now, when (if?) we change to 11 spaces later we
will not be breaking recent Linux kernels.

 > This should probably be split out into a separate patch if it is the
 > right thing to do, or drop it if (as it looks) there is no point in
 > that change.

hopefully the above explanation makes it clear why the last_u change
should go together with the vfat_build_slots() change.

Cheers, Tridge
