Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbZCFQFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbZCFQFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 11:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbZCFQFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 11:05:37 -0500
Received: from mail-gx0-f163.google.com ([209.85.217.163]:44653 "EHLO
	mail-gx0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbZCFQFg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 11:05:36 -0500
MIME-Version: 1.0
In-Reply-To: <20090228204622.29719.55082.stgit@localhost.localdomain>
References: <20090228204622.29719.55082.stgit@localhost.localdomain>
Date: Fri, 6 Mar 2009 09:05:33 -0700
Message-ID: <fa686aa40903060805i489d8676waad08e8263c02fe@mail.gmail.com>
Subject: Re: [PATCH] Fix Xilinx SystemACE driver to handle empty CF slot
From: Grant Likely <grant.likely@secretlab.ca>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       John.Linn@xilinx.com, sr@denx.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, sorry Jens.  I forgot to CC: you on this patch.

g.

On Sat, Feb 28, 2009 at 1:46 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
>
> The SystemACE driver does not handle an empty CF slot gracefully.  An
> empty CF slot ends up hanging the system.  This patch adds a check for
> the CF state and stops trying to process requests if the slot is empty.
>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>
>  drivers/block/xsysace.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
>
>
> diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
> index 381d686..ec5b8ca 100644
> --- a/drivers/block/xsysace.c
> +++ b/drivers/block/xsysace.c
> @@ -489,6 +489,28 @@ static void ace_fsm_dostate(struct ace_device *ace)
>                ace->fsm_state, ace->id_req_count);
>  #endif
>
> +       /* Verify that there is actually a CF in the slot.  If not, then
> +        * bail out back to the idle state and wake up all the waiters */
> +       status = ace_in32(ace, ACE_STATUS);
> +       if ((status & ACE_STATUS_CFDETECT) == 0) {
> +               ace->fsm_state = ACE_FSM_STATE_IDLE;
> +               ace->media_change = 1;
> +               set_capacity(ace->gd, 0);
> +               dev_info(ace->dev, "No CF in slot\n");
> +
> +               /* Drop all pending requests */
> +               while ((req = elv_next_request(ace->queue)) != NULL)
> +                       end_request(req, 0);
> +
> +               /* Drop back to IDLE state and notify waiters */
> +               ace->fsm_state = ACE_FSM_STATE_IDLE;
> +               ace->id_result = -EIO;
> +               while (ace->id_req_count) {
> +                       complete(&ace->id_completion);
> +                       ace->id_req_count--;
> +               }
> +       }
> +
>        switch (ace->fsm_state) {
>        case ACE_FSM_STATE_IDLE:
>                /* See if there is anything to do */
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
