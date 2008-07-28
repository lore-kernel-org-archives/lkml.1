Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbYG1QYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbYG1QYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbYG1QYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:24:24 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:46198 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbYG1QYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:24:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=jLlLdYuHS6zNwu0juWh9z3U2cDgfIleHlAIBaPs226LkYvbCcyv/d723xtgYYu8aXS
         7mjay71BMaGNMC0H1TZsiPxzLYwCZy7Uf3UTPdaCu7biLYmpEVafuIPd2Gd1hU4siI4J
         OtBvL1AMTxkU7DYPea5L2ca47TQ+SjI5UW0Po=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: IDE S.M.A.R.T. ioctl errors
Date: Mon, 28 Jul 2008 18:22:05 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080728060133.GA14007@gollum.tnic> <200807281644.38419.bzolnier@gmail.com> <9ea470500807280916k7824dc28m169f4c4db65023fa@mail.gmail.com>
In-Reply-To: <9ea470500807280916k7824dc28m169f4c4db65023fa@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807281822.05211.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2008, Boris Petkov wrote:
> On Mon, Jul 28, 2008 at 4:44 PM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> >
> > Hi,
> >
> > On Monday 28 July 2008, Borislav Petkov wrote:
> >
> > [...]
> >
> >> [   32.918048] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x1, args[2]: 0xd5 args[3]: 0x1
> >> [   32.918164] hdd: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> >> [   32.918392] ide: failed opcode was: 0xb0
> >> [   32.918491] hdd: drive not ready for command
> >> [   32.918618] hdd: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> >> [   32.918844] ide: failed opcode was: 0xea
> >> [   32.918949] hdd: drive not ready for command
> >> ...
> >>
> >> and this is "caused" by
> >> ide-use-correct-data-phase-for-smart-read-data-log-in-ide_cmd_ioctl.patch. This
> >> happens, IMHO, because when you do ATA_CMD_SMART from userspace ioctl, one of
> >> the cases is that the tf->feature flags have values which are inconsistent with
> >> the ATA/ATAPI v.7 spec (6.54.5 SMART READ DATA):
> >>
> >> "If the device does not support this command, if SMART is disabled, or if the
> >> values in the Features, LBA Mid, or LBA High registers are invalid, the device
> >> shall return command aborted."
> >>
> >> For example this one:
> >>
> >> [   30.499581] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x1, args[2]: 0xd1 args[3]: 0x1
> >> [   30.516111] hda: task_no_data_intr: status=0x58 { DriveReady SeekComplete DataRequest }
> >> [   30.516387] ide: failed opcode was: 0xb0
> >>
> >> However, the case with the SMART_READ_LOG looks correct above: args[2] = 0xd5
> >> which is the tf->feature flag, cmd = 0xb0 (ATA_CMD_SMART). This one fails too, though.
> >
> > Thanks for spotting it.
> >
> > It seems that ide_cmd_ioctl() ->data_phase change is not as obvious as
> > I previously thought.  Since the patch is quite low-prio (it prepares
> > the code for future changes) I just dropped it until we learn more about
> > the underlying issues.
> 
> How about aborting the ioctl in all those cases when the relevant
> registers above contain invalid values
> according to the spec? It sounds a pretty sane thing to do...

Dunno, either userspace is doing something really stupid currently
w.r.t. SMART (which I doubt but maybe it really is) or spec doesn't
really meet reality in SMART's case.

Thanks,
Bart
