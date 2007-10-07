Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbXJGIof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbXJGIof (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 04:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbXJGIo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 04:44:28 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:50499 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbXJGIo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 04:44:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kz5fmIoxZmtDZX+W3WTY7acnrsTSID7IbisVzIVqzvrgrOswvJi+/DPpg7zqLtnvSuTuLE7899SLxZMSgaYt2IcRpeyndgE0aKmMULnDPq02+Z73kLY13sV1ZTerBxFYBnlPfoB743ku7Co/J8hE2tBRbCuKroKnauq5mqXWDiw=
Message-ID: <64bb37e0710070144m6bc2c844oc96ef715b53b9819@mail.gmail.com>
Date: Sun, 7 Oct 2007 10:44:25 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
Cc: "Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <64bb37e0710042306s6c629163gde7bc5c93973153e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0709292300t39028029n2375899d7ba1e8ce@mail.gmail.com>
	 <46FFDF64.1080005@gmail.com>
	 <64bb37e0709301139h456a82d6u98630a4d1503eaf@mail.gmail.com>
	 <64bb37e0710011100t2cd81a32g501435b98f783ba9@mail.gmail.com>
	 <64bb37e0710030821u56157ad1s6252ee01e050c7d5@mail.gmail.com>
	 <64bb37e0710030855t360f2216mb4c38cfab6d88f37@mail.gmail.com>
	 <20071003163804.GR19691@waste.org>
	 <64bb37e0710032232o71225bf6k8a0d493687eb80bd@mail.gmail.com>
	 <20071004170536.GY19691@waste.org>
	 <64bb37e0710042306s6c629163gde7bc5c93973153e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/07, Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> So I will use the weekend to see if I can find out who issues this
> command and add more debug to that place...

I added some DPRINTK to sil24_qc_issue and sil24_fill_sg, but I only
found one suspicious thing.

My sil24_fill_sg now looks like this:
static inline void sil24_fill_sg(struct ata_queued_cmd *qc,
                                 struct sil24_sge *sge)
{
        struct scatterlist *sg;

        ata_for_each_sg(sg, qc) {
                sge->addr = cpu_to_le64(sg_dma_address(sg));
                sge->cnt = cpu_to_le32(sg_dma_len(sg));
                if (ata_sg_is_last(sg, qc))
                        sge->flags = cpu_to_le32(SGE_TRM);
                else
                        sge->flags = 0;
                DPRINTK("flags,addr,cnt = 0x%x, 0x%X, 0x%X\n", sge->flags,
                        sge->addr, sge->cnt);
                sge++;
        }
}

Suspicious is, that *all* output from this DPRINTK shows flags as 0x0,
so the last sg is never terminated (SGE_TRM is 1<<31)?
But if that is the cause, how is this working at all? Or am I doing
something stupid?

Timing and outputs from five boots:
good:                                bad:
          more         moreboot                more
3->35     3->35        3->35         3->35     3->35
3->2a     2->35        2->35         3->2a     3->2a
3->setup  2->2a        2->2a         3->setup  3->setup
2->35     2->35        2->35         2->35     2->35
1->35     3->2a        3->2a         1->35     1->35
2->2a     3->setup     3->setup      2->2a     2->2a
1->2a     1->35        1->35         1->2a     1->2a
2->35     1->2a        1->2a         2->35
1->35     1->35        1->35                   1->35
3->int    3->int       3->int        3->int    3->int
3->35     3->35        3->35         3->35     3->35
          1->5DF/1439C 1->5DC/1439C            1->5DE/1439C
          2->5E0/143BC 2->5DE/143BC            2->5DF/143BC
          sg:170E      sg:1AAB                 sg:1A60
XXX:
5DD       5DF          5DC           5DF       5DE
5E0       5E0          5DE           5E0       5DF

The first three columns where working tries, the last two failed one drive.
column 1: ATA_DEBUG added, reboot
column 2: +my additions, reboot
column 3: +my additions, cold boot, wanted to make it fail, but worked
column 4: ATA_DEBUG added, cold boot
column 5: +my additions, cold boot
[x]->[y]: x is the ata-port, 1+2 on the sata_sil24, 3 on sata_nv with swncq
y:35 -> SYNCHRONIZE_CACHE commands that where send to the drive
y:2a -> WRITE_10 commands that where send to the drive
y:setup -> Debug from swncq: nv_swncq_dmafis: dma setup tag 0x0
y:int -> Debug from swncq: nv_swncq_host_interrupt: id 0x3 SWNCQ:
qc_active 0x1 ...

The lines before the XXX:
x->a/b: x is the ata-port, a the paddr from sil24_qc_issue, b the
activate from sil24_qc_issue
All outputs from sil24_qc_issue where identical in each boot sequence,
only differed from run to run.
sg:a: a is the sge->addr from sil24_fill_sg

The lines after the XXX:
This are the addresses that the XXX-printk from sil24_port_start prints.

I hope I explained enough what above table should mean.
This hole sequence (two syncs and one write to each drive) happens
between the output:
[   40.300000] md1: bitmap initialized from disk: read 10/10 pages, set 87 bits
[   40.320000] created bitmap (145 pages) for device md1
and the error on a bad boot:
[   70.680000] ata2.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
[   70.700000] ata2.00: cmd 61/08:00:09:d6:42/00:00:25:00:00/40 tag 0
cdb 0x0 data 4096 out
or if on a good boot:
[   40.910000] md: considering sdb1 ...
(sdb1 is part of another raid)

(If someone whats to complete bootlogs, just ask)

So now I have two questions:
1) What happens in sil24_fill_sg with SGE_TRM?
2) If that is ok, should I try to add debug to sil24_error_intr and/or
sil24_host_intr?

Torsten
