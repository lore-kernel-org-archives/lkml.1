Return-Path: <linux-kernel-owner+w=401wt.eu-S1762355AbXJMMDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762355AbXJMMDu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 08:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762260AbXJMMDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 08:03:32 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:13337 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762248AbXJMMD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 08:03:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=F0N/wKQc7ABje5ms7TRSRNdVkciMDK6KEu6TjO3rbiUEYc0RPNu17aC0TljeIFlQXSiZcuZTMvQHrGxEKLmrCwC9M4cANmjMWqM23UOM99k+LYshXYcyBp28A9+H56MTdOZUp4UAteCaB7aQ6lHbxmihF29xR5+QgqmIUriIVrQ=
Message-ID: <64bb37e0710130503haa66d6eu93e75ecdc78ac866@mail.gmail.com>
Date: Sat, 13 Oct 2007 14:03:28 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: 2.6.23-mm1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, "Kuan Luo" <kluo@nvidia.com>,
       "Peer Chen" <pchen@nvidia.com>
In-Reply-To: <4710A407.3070000@garzik.org>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/07, Jeff Garzik <jeff@garzik.org> wrote:
> Torsten Kaiser wrote:
> > On 10/12/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >> On Fri, 12 Oct 2007 10:31:42 +0200 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
> >>> Oct 12 10:23:03 treogen smartd[6091]: Device: /dev/sdc, not found in
> >>> smartd database.
> >> hm.
> >>
> >>> Oct 12 10:23:03 treogen [  105.990000] WARNING: at
> >>> drivers/ata/libata-core.c:5752 ata_qc_issue()
> >> Let's cc linux-ide.
> >>
> >>> Oct 12 10:23:03 treogen [  105.990000]
> >>> Oct 12 10:23:03 treogen [  105.990000] Call Trace:
> >>> Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff804442ef>]
> >>> ata_qc_issue+0x47f/0x540
> >>> Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff80432e60>] scsi_done+0x0/0x20
> >>> Oct 12 10:23:03 treogen [  105.990000]  [<ffffffff80449c80>]
> >>> ata_scsi_flush_xlat+0x0/0x30
>
> > Oct 13 07:46:48 treogen [   99.850000]
> > Oct 13 07:46:48 treogen [   99.850000] ata3: EH in SWNCQ
> > mode,QC:qc_active 0x3 sactive 0x1
> > Oct 13 07:46:48 treogen [   99.850000] ata3: SWNCQ:qc_active 0x1
> > defer_bits 0x0 last_issue_tag 0x0
>
> The WARNING indicates that there is a SWNCQ bug in sata_nv.  Given that
> the problem appears when SYNCHRONIZE CACHE is being issued, I would

I can't follow you on SYNCHRONIZE CACHE.
The only command written to the syslog in the errors where
0x60==ATA_CMD_FPDMA_READ and 0xB0 (which is not in
include/linux/ata.h, but ATA-6 says that this is SMART related. That
makes sense, as smartd is failing).

> guess that sata_nv is not properly handling non-queued commands.

But that still seems correct, as I would not expect that SMART
commands get queued. (Thats just a guess, as I did not try to find the
code that does this distinction)

> This is a patch from libata-dev.git#nv-swncq (via #ALL).

Comparing sata_nv.c from 2.6.23-rc8-mm1 and 2.6.23-mm1 I see two
changes, that look suspicious:

http://git.kernel.org/?p=linux/kernel/git/jgarzik/libata-dev.git;a=commitdiff;h=31cc23b34913bc173680bdc87af79e551bf8cc0d

The comment says: "ahci and sata_sil24 are converted to use ata_std_qc_defer()."
But the patch also adds ".qc_defer = ata_std_qc_defer," to sata_nv.c

The second change is the removal of the 'lock' spinlock from sata_nv.c
that was used in nv_swncq_qc_issue and nv_swncq_host_interrupt.

Should I try to revert one or both of these changes?

Torsten
