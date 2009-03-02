Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbZCBNQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbZCBNQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 08:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbZCBNPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 08:15:52 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:22849 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZCBNPv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 08:15:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=m5Exux1F1AUC9TNxKsbXZmkyaWLuTv+brmh4F4ITh53kw/h3UMonzecMfe79G/MjLF
         cPMPC+TA65yGt4w5hePUJwHeGlpEOYsmE29JpcgURgLen0/RM+RsI8EB4xVLcUHNRA9Q
         /u0PO5+g+Pn/t7RUY7H03XZvgKEkSOrzCHvUs=
MIME-Version: 1.0
Reply-To: petkovbb@gmail.com
In-Reply-To: <200903020215.n222FBpu067502@www262.sakura.ne.jp>
References: <200902260229.n1Q2T2lY006773@www262.sakura.ne.jp>
	 <200902261529.43554.bzolnier@gmail.com>
	 <9ea470500902260751t4221d04cm839765a93300d861@mail.gmail.com>
	 <200903020215.n222FBpu067502@www262.sakura.ne.jp>
Date: Mon, 2 Mar 2009 14:15:48 +0100
Message-ID: <9ea470500903020515p4c4e5b9cu74c174a43bd4df3c@mail.gmail.com>
Subject: Re: linux-next-20090225: ide-cd triggers BUG at arch/x86/mm/ioremap.c:80!
From: Borislav Petkov <petkovbb@googlemail.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Borislav Petkov wrote:
>> Can you also apply the following patch and send us the output?
> I applied the patch after "git bisect reset" since I couldn't apply from this
> state.
>
> [    3.419143] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> [    3.424508] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> [    3.429658] ide-gd driver 1.18
> [    3.433879] ide-cd driver 5.00
> [    3.440135] mapping rq to sg: dev hda: type=a, flags=82640
> [    3.441873]   sector 4294967295, nr/cnr 0/0
> [    3.445288]   bio (null), biotail (null), buffer (null), data f700fbc4, len 24
> [    3.452602] ide-cd: hda: ATAPI 1X CD-ROM drive, 32kB Cache
> [    3.456659] Uniform CD-ROM driver Revision: 3.20
> [    3.460913] mapping rq to sg: dev hda: type=a, flags=8a640
> [    3.464697]   sector 4294967295, nr/cnr 0/0
> [    3.465881]   bio (null), biotail (null), buffer (null), data (null), len 0
> [    3.472354] Pid: 1, comm: swapper Not tainted 2.6.29-rc6-next-20090227-dirty #10
> [    3.476790] Call Trace:
> [    3.477860]  [<c02ef9bd>] ide_cd_do_request+0x12d/0x170
> [    3.480496]  [<c02e1d28>] start_request+0xa8/0x160
> [    3.481883]  [<c015d92b>] ? trace_hardirqs_on+0xb/0x10
> [    3.485680]  [<c02e1f7b>] do_ide_request+0x16b/0x250
> [    3.489231]  [<c025e5a5>] ? blk_remove_plug+0x75/0xf0
> [    3.492817]  [<c025f770>] blk_start_queueing+0x20/0x30
> [    3.495475]  [<c025d2be>] elv_insert+0x17e/0x1b0
> [    3.497088]  [<c025e458>] ? blk_plug_device+0x88/0x120
> [    3.499681]  [<c025d372>] __elv_add_request+0x82/0xc0
> [    3.501428]  [<c0263ad0>] blk_execute_rq_nowait+0x60/0xb0
> [    3.504214]  [<c0263bb6>] blk_execute_rq+0x96/0xd0
> [    3.505802]  [<c0263a40>] ? blk_end_sync_rq+0x0/0x30
> [    3.508392]  [<c025f59c>] ? get_request_wait+0x2c/0x160
> [    3.509883]  [<c0160429>] ? __lock_acquired+0x109/0x1c0
> [    3.512691]  [<c025f6f4>] ? blk_get_request+0x24/0x80
> [    3.515239]  [<c02ef196>] ide_cd_queue_pc+0xb6/0x140

ok, if I read the stack dump correctly, we map an rq with rq->data = NULL to an
sg. Code path starts at cdrom_check_status() and actually, we don't need a
buffer here since we send a TEST_UNIT_READY and we're only interested in the
sense returned. And this won't trigger if we haven't enabled
CONFIG_DEBUG_VIRTUAL. Yep, I know that this is a dirty hack but it fixes it
here. Tetsuo, does the following fix your problem?

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 481fb1b..e6ac4cc 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -238,6 +238,8 @@ void ide_map_sg(ide_drive_t *drive, struct ide_cmd *cmd)
 		sg_init_one(sg, rq->buffer, rq->nr_sectors * SECTOR_SIZE);
 		cmd->sg_nents = 1;
 	} else if (!rq->bio) {
+		if (!rq->data)
+			rq->data = &rq->data;
 		sg_init_one(sg, rq->data, rq->data_len);
 		cmd->sg_nents = 1;
 	} else

@Bart: I'm open for suggestions wrt to a more elegant solution :).

-- 
Regards/Gruss,
Boris
