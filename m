Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbZCCMbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbZCCMbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 07:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZCCMbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 07:31:36 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:62981 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbZCCMbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 07:31:35 -0500
To: petkovbb@gmail.com
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: linux-next-20090225: ide-cd triggers BUG at arch/x86/mm/ioremap.c:80!
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200902260229.n1Q2T2lY006773@www262.sakura.ne.jp>
	<200902261529.43554.bzolnier@gmail.com>
	<9ea470500902260751t4221d04cm839765a93300d861@mail.gmail.com>
	<200903020215.n222FBpu067502@www262.sakura.ne.jp>
	<9ea470500903020515p4c4e5b9cu74c174a43bd4df3c@mail.gmail.com>
In-Reply-To: <9ea470500903020515p4c4e5b9cu74c174a43bd4df3c@mail.gmail.com>
Message-Id: <200903032131.CCF57372.JOOLMOVSFFQHFt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Tue, 3 Mar 2009 21:31:30 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Borislav Petkov wrote:
> ok, if I read the stack dump correctly, we map an rq with rq->data = NULL to an
> sg. Code path starts at cdrom_check_status() and actually, we don't need a
> buffer here since we send a TEST_UNIT_READY and we're only interested in the
> sense returned. And this won't trigger if we haven't enabled
> CONFIG_DEBUG_VIRTUAL. Yep, I know that this is a dirty hack but it fixes it
> here. Tetsuo, does the following fix your problem?
> 
> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
> index 481fb1b..e6ac4cc 100644
> --- a/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
> @@ -238,6 +238,8 @@ void ide_map_sg(ide_drive_t *drive, struct ide_cmd *cmd)
>  		sg_init_one(sg, rq->buffer, rq->nr_sectors * SECTOR_SIZE);
>  		cmd->sg_nents = 1;
>  	} else if (!rq->bio) {
> +		if (!rq->data)
> +			rq->data = &rq->data;
>  		sg_init_one(sg, rq->data, rq->data_len);
>  		cmd->sg_nents = 1;
>  	} else
> 
Yes. This patch solved the problem.



You sent me another patch.
> @Tetsuo: please do test, this should fix your OOPS.
I'll try your new patch tomorrow.



Thanks.
