Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbYCOBE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYCOBE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 21:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbYCOBEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 21:04:48 -0400
Received: from saeurebad.de ([85.214.36.134]:46229 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbYCOBEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 21:04:48 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gadi Oxman <gadio@netvision.net.il>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ide-tape: Avoid potential null pointer dereference in idetape_abort_pipeline()
References: <alpine.LNX.1.00.0803150123450.29784@dragon.funnycrock.com>
Date: Sat, 15 Mar 2008 02:02:16 +0100
In-Reply-To: <alpine.LNX.1.00.0803150123450.29784@dragon.funnycrock.com>
	(Jesper Juhl's message of "Sat, 15 Mar 2008 01:26:44 +0100 (CET)")
Message-ID: <87prtw2413.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,

Jesper Juhl <jesper.juhl@gmail.com> writes:

> If a NULL 'new_last_stage' is passed to idetape_abort_pipeline() then 
> we'll dereference a NULL pointer and go *boom*. 
> The function does test for a null pointer, unfortunately it only does it 
> after having already dereferenced it.

Did you hit an oops because of this?

> @@ -814,11 +814,14 @@ static void idetape_abort_pipeline(ide_drive_t *drive,
>  				   idetape_stage_t *new_last_stage)
>  {
>  	idetape_tape_t *tape = drive->driver_data;
> -	idetape_stage_t *stage = new_last_stage->next;
> +	idetape_stage_t *stage = NULL;
>  	idetape_stage_t *nstage;
>  
>  	debug_log(DBG_PROCS, "%s: Enter %s\n", tape->name, __func__);
>  
> +	if (new_last_stage)
> +		stage = new_last_stage->next;
> +
>  	while (stage) {
>  		nstage = stage->next;
>  		idetape_kfree_stage(tape, stage);

]		--tape->nr_stages;
]		--tape->nr_pending_stages;
]		stage = nstage;
]	}
]	if (new_last_stage)
]		new_last_stage->next = NULL;

... because if not, and new_last_stage will never be NULL at all in this
function, the check here could be removed instead of adding another one.
Or perhaps a BUG_ON(!stage) in idetape_end_request() already?

Bartlomiej, please have a look at the following patch.  Should all of
these hand-checks in the file be replaced by BUG_ON()s?  Or be removed
completely?

	Hannes

--

Turn possible NULL-pointer dereference in idetape_active_next_stage()
into an explicit bug and remove the warn-only checking for it.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

---
The explicit checking of @stage indicates that someone was expecting
that it could be NULL here.  Could someone with real understanding of
the code check if the condition is realistic?

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 43e0e05..b63f928 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -724,17 +724,15 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 
 static void idetape_activate_next_stage(ide_drive_t *drive)
 {
+	struct request *rq;
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_stage_t *stage = tape->next_stage;
-	struct request *rq = &stage->rq;
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
-	if (stage == NULL) {
-		printk(KERN_ERR "ide-tape: bug: Trying to activate a non"
-				" existing stage\n");
-		return;
-	}
+	BUG_ON(!stage);
+
+	rq = &stage->rq;
 
 	rq->rq_disk = tape->disk;
 	rq->buffer = NULL;

