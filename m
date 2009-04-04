Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbZDDQqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbZDDQqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 12:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbZDDQqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 12:46:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:44596 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbZDDQqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 12:46:07 -0400
Message-ID: <49D6E7FA.3000306@kernel.org>
Date: Sat, 04 Apr 2009 13:54:18 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Niel Lambrechts <niel.lambrechts@gmail.com>
CC: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <ckpL0-3TE-3@gated-at.bofh.it> <ckpL0-3TE-5@gated-at.bofh.it> <ckpL0-3TE-7@gated-at.bofh.it> <ckpL0-3TE-9@gated-at.bofh.it> <ckpL0-3TE-11@gated-at.bofh.it> <ckpL0-3TE-1@gated-at.bofh.it> <cllvN-2Gf-1@gated-at.bofh.it> <49D0D788.6070405@gmail.com> <49D419E8.2080603@kernel.org> <49D4591B.3070807@gmail.com> <49D46096.1040701@kernel.org> <49D49B8A.7070408@gmail.com> <49D4C886.1010101@gmail.com>
In-Reply-To: <49D4C886.1010101@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 04 Apr 2009 16:46:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Neil.

Niel Lambrechts wrote:
>> Thanks for your help, I've done at least 5 hibernate cycles without the
>> problem recurring, I'll keep at it for a while... :)

Hmmm..

>> For the sake of being thorough, I'd like to mention some of the
>> remaining issues/messages, but to be honest some of them were there
>> before and may not be relevant to your efforts:
>>
>> 1) Can you perhaps confirm if the remaining ATA messages are harmless
>> enough to ignore?
>>
>> dmesg:
>> ata2: exception Emask 0x10 SAct 0x0 SErr 0x4050000 action 0x1e frozen
>> ata2: irq_stat 0x00400040, connection status changed
>> ata2: SError: { PHYRdyChg CommWake DevExch }
>> Clocksource tsc unstable (delta = -412838835 ns)

Yeah, that happens on some machines during resume.  It doesn't on some
machines (including mine) and dunno what's the difference yet.  It's a
bit annoying and probably adds a bit to resume time but libata handles
things like this just fine, so no need to be alarmed too much.

>> and in messages:
>> Apr  2 12:31:44 linux-7vph kernel: ata1: exception Emask 0x10 SAct 0x0
>> SErr 0x0 action 0x9 t4
>>
>> 2) The screen remains blank on resume, right until I both press a key
>> _and_ touch the touchpad. Weird, but this happens in 2.6.28.9 as well,
>> perhaps this is i915 related.

Heh... yeah, black magic of display suspend/resume.  Hopefully it will
get better with KMS.

> UPDATE:
> 
> Just arrived back home, before suspending I enabled all the powertop
> laptop mode/SATA link management etc and I removed a CD-ROM from the
> CD drive so I'm not sure what could be responsible for this:
> 
> ata2.00: XXX setting retry on qc0
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> ata2.00: irq_stat 0x40000001
> ata2.00: XXX terminating qc0 (SENSE), retries=0
> XXX scsi_eh_flush_done_q: online=1(2) noretry=0 retries=3 allowed=3
> scsi_eh_1: flush finish cmd: f5dea740
> ata2.00: XXX setting retry on qc0
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> ata2.00: irq_stat 0x40000001
> ata2.00: XXX terminating qc0 (SENSE), retries=0
> XXX scsi_eh_flush_done_q: online=1(2) noretry=0 retries=2 allowed=2
> .. loop ..
> 
> I hope it's simply something like "drive not ready" debugging ouput,
> since ata2 seems associated with the CD-Rom drive... :)
> 
> This continued, until I again in powertop enabled SATA link management.

That's probably hal polling for media presence.  It uses
TEST_UNIT_READY and if there's no media in the drive, it will raise
CHECK_SENSE condition which is handled by the libata EH which is
usually quiet about it as it's not an error but with the debugging
patch, it got more whiny.  If you're annoyed by it just put a media in
the drive.

Thanks.

-- 
tejun

