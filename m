Return-Path: <linux-kernel-owner+w=401wt.eu-S1757784AbXJMOc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbXJMOc1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbXJMOcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:32:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:24028 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbXJMOcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:32:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Mv3Y21S0U64u3WmUgeMosgVP7NT17+FYScaYVLJMyFFnZAKEVfL6weeak8zZPqZyxyLZP3FSD7C0SnoMtV3Jr0lXVk+tYBHOKpjUxZRSUD/aHG5BY38OxFBV3lXf0wqbYDsdZ6c9oqj6dEeap1KrtFv25svNGWdo0OtqwUboxNQ=
Message-ID: <64bb37e0710130732p303547e3n54cfa9dac34c53b5@mail.gmail.com>
Date: Sat, 13 Oct 2007 16:32:14 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: 2.6.23-mm1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, "Kuan Luo" <kluo@nvidia.com>,
       "Peer Chen" <pchen@nvidia.com>
In-Reply-To: <4710B7C5.5050403@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	 <20071012140328.f82af8e8.kamezawa.hiroyu@jp.fujitsu.com>
	 <20071011234202.2f15bb76.akpm@linux-foundation.org>
	 <64bb37e0710120131y6b939951y74c50bd596b1d938@mail.gmail.com>
	 <20071012013729.ada2127b.akpm@linux-foundation.org>
	 <64bb37e0710130101y7fb8e4c0lf214fd821e8305ed@mail.gmail.com>
	 <4710A407.3070000@garzik.org>
	 <64bb37e0710130503haa66d6eu93e75ecdc78ac866@mail.gmail.com>
	 <4710B7C5.5050403@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/07, Jeff Garzik <jeff@garzik.org> wrote:
> Torsten Kaiser wrote:
> > On 10/13/07, Jeff Garzik <jeff@garzik.org> wrote:
> >> Torsten Kaiser wrote:
> > I can't follow you on SYNCHRONIZE CACHE.
> > The only command written to the syslog in the errors where
> > 0x60==ATA_CMD_FPDMA_READ and 0xB0 (which is not in
> > include/linux/ata.h, but ATA-6 says that this is SMART related. That
> > makes sense, as smartd is failing).
>
> In the traceback you have "ata_scsi_flush_xlat", which is the function
> that translates a SCSI sync-cache command into an ATA flush-cache command.

Aha. That makes sense.
But on the second error, where the drive was kicked out completely all
three traces did not have ata_scsi_flush_xlat.
First WARNING:
Oct 13 07:46:48 treogen [   99.850000] Call Trace:
Oct 13 07:46:48 treogen [   99.850000]  [<ffffffff8044431a>]
ata_qc_issue+0x4aa/0x540
Oct 13 07:46:48 treogen [   99.850000]  [<ffffffff80432e60>] scsi_done+0x0/0x20
Oct 13 07:46:48 treogen [   99.850000]  [<ffffffff8044ce30>]
ata_scsi_pass_thru+0x0/0x2c0
Oct 13 07:46:48 treogen [   99.850000]  [<ffffffff8044a6ea>]
ata_scsi_translate+0xfa/0x180
Oct 13 07:46:48 treogen [   99.850000]  [<ffffffff80432e60>] scsi_done+0x0/0x20
...

Second+Third:
Oct 13 07:46:49 treogen [  100.510000]  [<ffffffff804442ef>]
ata_qc_issue+0x47f/0x540
Oct 13 07:46:49 treogen [  100.510000]  [<ffffffff80432e60>] scsi_done+0x0/0x20
Oct 13 07:46:49 treogen [  100.510000]  [<ffffffff80432e60>] scsi_done+0x0/0x20
Oct 13 07:46:49 treogen [  100.510000]  [<ffffffff8044a440>]
ata_scsi_rw_xlat+0x0/0x1b0
Oct 13 07:46:49 treogen [  100.510000]  [<ffffffff8044a6ea>]
ata_scsi_translate+0xfa/0x180
Oct 13 07:46:49 treogen [  100.510000]  [<ffffffff80432e60>] scsi_done+0x0/0x20
...

So the commands that generate the WARNINGs seem only later collateral damage.

> The "WARNING: at drivers/ata/libata-core.c:5752 ata_qc_issue()" also
> guides us to the code comment
>
>          /* Make sure only one non-NCQ command is outstanding.  The
>           * check is skipped for old EH because it reuses active qc to
>           * request ATAPI sense.
>           */
>
> which is a check related to NCQ->off and off->NCQ edge cases.
>
> So those are the two bits of information I found interesting.

But I very much agree about this. But rather than 'normal' edges with
the cache flushes, I would blame it on the SMART commands from smartd
that trigger the switch.
Both errors happend during the startup of smartd.

> >> guess that sata_nv is not properly handling non-queued commands.
> >
> > But that still seems correct, as I would not expect that SMART
> > commands get queued. (Thats just a guess, as I did not try to find the
> > code that does this distinction)
> >
> >> This is a patch from libata-dev.git#nv-swncq (via #ALL).
> >
> > Comparing sata_nv.c from 2.6.23-rc8-mm1 and 2.6.23-mm1 I see two
> > changes, that look suspicious:
> >
> > http://git.kernel.org/?p=linux/kernel/git/jgarzik/libata-dev.git;a=commitdiff;h=31cc23b34913bc173680bdc87af79e551bf8cc0d
> >
> > The comment says: "ahci and sata_sil24 are converted to use ata_std_qc_defer()."
> > But the patch also adds ".qc_defer = ata_std_qc_defer," to sata_nv.c

Looking more at this patch, I thing the code change is correct and
only the comment is missing sata_nv. (Only ahci, sil24 and nv seem to
use NCQ und so need the logic from qc_defer)

> > The second change is the removal of the 'lock' spinlock from sata_nv.c
> > that was used in nv_swncq_qc_issue and nv_swncq_host_interrupt.
> >
> > Should I try to revert one or both of these changes?
>
> If you are git-capable, IMO the next steps in problem elimination should be

... I should really take the time install this, but I don't think git
will help in this special case, because:

> * download latest linux-2.6.git (currently
> 752097cec53eea111d087c545179b421e2bde98a)
> * build and test linux-2.6.git, to establish a new baseline

2.6.23-rc8-mm1 worked.

> * download latest libata-dev.git#nv-swncq (currently
> 3cb664c2d319a4fde5028c3c5dab6221fe70bd2d)

That commit (3cb664c2d319a4fde5028c3c5dab6221fe70bd2d) seems to be the
only commit relevant to swncq, as it adds it completely without any
partial steps that could be bisected.

> * build and test, with sata_nv module option swncq=0
> * build and test, with sata_nv module option swncq=1

I will try this. Currently I have sata_nv.swncq=1 in my kernel
commandline so its trivial to change that.
But as only 2 out of 3 boots failed, I think I hit another heisenbug.

> My gut feeling is that there is a lingering bug in sata_nv SWNCQ somewhere.

Older versions of SWNCQ already worked for me, so I don't think its a
general problem.
And as the symptoms would nicely fit into a race condition when
manipulating the NCQ state, the removal of the lock protecting the
private sata_nv defer_queue between 2.6.23-rc8-mm1 and 2.6.23-mm1
looks like the prime suspect.

So now booting with and without swncq and if swncq=0 works, I will try
to add the lock back...

Torsten
