Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbZF1ELP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbZF1ELP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 00:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbZF1ELE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 00:11:04 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43473 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbZF1ELD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 00:11:03 -0400
To: tridge@samba.org
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
References: <19013.8005.541836.436991@samba.org>
	<m1d48p5dil.fsf@fess.ebiederm.org>
	<19014.54044.484370.187018@samba.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 27 Jun 2009 21:10:57 -0700
In-Reply-To: <19014.54044.484370.187018@samba.org> (tridge@samba.org's message of "Sun\, 28 Jun 2009 12\:19\:08 +1000")
Message-ID: <m1vdmh2e26.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: tridge@samba.org, paulmck@linux.vnet.ibm.com, cmm@us.ibm.com, sfrench@us.ibm.com, shaggy@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, john.lanza@linux.com, hirofumi@mail.parknet.co.jp
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;tridge@samba.org
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_Sft_Brands_C00 XM_Sft_Brands_C00
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tridge@samba.org writes:

> Hi Eric,
>
>  > This hunk allowing the examination of the long name if there is not a
>  > short name is something else entirely.
>  > 
>  > You don't describe it in your summary, and don't make the case that
>  > this is the correct behavior.
>
> Sorry for not explaining that part of the patch in my posting.
>
> The reason I initially included it was that during the development of
> this patch we were experimenting with variations of the
> vfat_build_dummy_83_buffer() function which put a wide varity of
> different values in the 11 bytes where a short filename would normally
> go.
>
> The most technically attractive varient was to put 11 spaces in
> there. That has the advantage that Windows then returns the long name
> to the GetShortPathName() API call, which is also what Windows does on
> a NTFS filesystem when the NTFS filesystem is configured not to have
> 8.3 names. So it would have been very nice to have this same behaviour
> on VFAT, instead of getting a single space back from
> GetShortPathName() as we get with the patch I posted.
>
> The reason we didn't go with the 11 spaces varient is that it causes
> WindowsXP to bluescreen. This is just a bug in WinXP, and is not
> present in Vista or Windows7.
>
> The 2nd technical problem with 11 spaces is that current Linux kernels
> would not see the long names, as the last_u logic in fat_search_long()
> will skip files where the the 11 bytes don't have at least one
> non-space byte before the first nul byte in either the 8 byte prefix
> or the 3 byte extension.
>
> The last_u logic is at odds with the behaviour of other operating
> systems for VFAT. On all windows varients that I have tested (and on
> MacOSX), the long name is still used no matter what values are in the
> 11 bytes. You can stick all nul bytes, all spaces, or anything else
> you like in there and Windows will still allow you to operate on the
> file by the long name and the filesystem will work perfectly.
>
> So that part of the patch is bringing us inline with the behaviour of
> other VFAT implementations.
>
> More importantly, it gives us the opportunity in the future to move to
> the techically better 11 spaces solution when either Microsoft fixes
> their WindowsXP crash bug, or WindowsXP has such a low market share
> that nobody cares any more (say like WfWg and maybe Win95 has now).
>
> If we don't put in this change now then we won't be able to move to
> the technically better solution later as we wouldn't have given Linux
> distros a chance to include support for the 11 spaces in distros. By
> putting that change in now, when (if?) we change to 11 spaces later we
> will not be breaking recent Linux kernels.
>
>  > This should probably be split out into a separate patch if it is the
>  > right thing to do, or drop it if (as it looks) there is no point in
>  > that change.
>
> hopefully the above explanation makes it clear why the last_u change
> should go together with the vfat_build_slots() change.

It is part of the same investigation certainly.

Given what you have said our interpretation of vfat has a bug,
and that small change is a candidate for -stable.  If it could
be it's own patch.

That change seems much less controversial and obviously correct
than the other.

Eric
