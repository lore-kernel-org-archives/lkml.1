Return-Path: <linux-kernel-owner+w=401wt.eu-S1757881AbXI3Ogn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881AbXI3Ogn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 10:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756507AbXI3Ogf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 10:36:35 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:31565 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbXI3Oge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 10:36:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=VO8Ke3TYGrguCDdvnNEz/Afv6hh5sKZuXCRoL/3NTxkKn9c7r2PIQO8XtGU0C07VoNZjKQXuAPX32nIeP31a6/1hiYZ8nVI9cCVOR8rj5QjNMG265HJjR2zOKHsbZ+W9aWuhWEG5yec/1sVYRODWu6/X653svHxCDxDjMu63nZ8=
Message-ID: <46FFB412.20202@gmail.com>
Date: Sun, 30 Sep 2007 07:34:58 -0700
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
References: <64bb37e0709261326h4890a07fx60c7d6772e4e63c4@mail.gmail.com>	 <46FB3793.9060607@gmail.com> <46FB3843.2030708@gmail.com>	 <64bb37e0709262314x1b0100d8lfe34327db6b9bec8@mail.gmail.com>	 <46FB4CB3.3090004@garzik.org>	 <64bb37e0709271034h72b5eb9fy3aa7980cbc483f4f@mail.gmail.com>	 <46FC1104.8080105@gmail.com>	 <64bb37e0709272236g7da8f370lc7f737e908725e88@mail.gmail.com> <64bb37e0709292300t39028029n2375899d7ba1e8ce@mail.gmail.com>
In-Reply-To: <64bb37e0709292300t39028029n2375899d7ba1e8ce@mail.gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Torsten.

Torsten Kaiser wrote:
> On 9/28/07, Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
>> So in case of -rc3-mm1 I'm pretty sure that it works.
> 
> That's still the case.

Ah... that's weird.  It would be much better if -rc3-mm1 is broken too.  :-P

>> Not completely sure is if 2.6.23-rc7-sglist kernel works. I booted
>> that 9 times, but from a quick look in /var/log/messages, I might not
>> have hit the "correct" situation to trigger the error.
>> That kernel is vanilla 2.6.23-rc7 plus the patch from
>> http://www.kernel.org/pub/linux/kernel/people/tomo/misc/v2.6.23-rc7-sglist-arch.diff.bz2
>> ( http://marc.info/?l=linux-ide&m=119055574826083&w=2 )
> 
> That is no longer the case. Yesterday this kernel did also show the failure.
> The error looked a little bit different, but happend at the same
> location during the bootup.
> Sadly dmesg overflowed and I was not able to capture the first error.
> 
> [   53.462632] Freeing unused kernel memory: 332k freed
> ite cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   77.170903] ata1.00: exception Emask 0x40 SAct 0x1 SErr 0x0 action 0x2
> [   77.170905] ata1.00: irq_stat 0x00020002, SGT no on qword boundary
> [   77.170908] ata1.00: cmd 61/08:00:09:d6:42/00:00:25:00:00/40 tag 0
> cdb 0x0 data 4096 out
> [   77.170909]          res 50/00:00:af:ea:42/00:00:25:00:00/e0 Emask
> 0x40 (internal error)

Hmm... SGT not on qword boundary?  Please add the following to the end
of sil24_port_start() and report successful and failed kernel boot log.

	printk("XXX sil24 cb=%p cb_dma=%llx\n",
		cb, (unsigned long long)cb_dma);

Also, does 'dmesg -s 10000000' give full dmesg?

> I rebooted into a system (kernel 2.6.21-rc5-mm2, please not the
> 2.6.*21*, that is only a rescue system and not updated often) on a
> separate partition to rebuild it. When I tried to readd the failed sdb
> the system locked up with this error:
> 
> Sep 29 22:25:37 treogen [  205.407893] ata2.00: exception Emask 0x0
> SAct 0x0 SErr 0x0 action 0x2 frozen
> Sep 29 22:25:37 treogen [  205.407900] ata2.00: cmd
> ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0
> Sep 29 22:25:37 treogen [  205.407901]          res
> 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (time out)
> 
> Is it possible that the bug is much older, and only some change in
> rc3-mm->rc4-mm makes it visible that the initialization of the SiI3132
> is incomplete?

I can't tell but there is a pretty large userbase of sil24/32 and you
seem to be the only one to report this problem yet.  I think it might be
coming somewhere else than libata or sata_sil24 itself.  Hmmm... It
would be really great if you can break -rc3-mm1 too.  Correct behavior
for something like that for just one -mm version sounds very weird.

Thanks.

-- 
tejun
