Return-Path: <linux-kernel-owner+w=401wt.eu-S1756977AbYJVSYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977AbYJVSYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYJVSYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:24:04 -0400
Received: from nebensachen.de ([195.34.83.29]:45975 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbYJVSYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:24:02 -0400
X-Hashcash: 1:20:081022:jens.axboe@oracle.com::ZNiMIoRSVrthFsgn:00000000000000000000000000000000000000001ZyG
X-Hashcash: 1:20:081022:linux-ide@vger.kernel.org::2bBh6+CWyTJ2iE59:0000000000000000000000000000000000001AfJ
X-Hashcash: 1:20:081022:linux-kernel@vger.kernel.org::MgIIZAt7CZqInr5f:0000000000000000000000000000000007U/p
X-Hashcash: 1:20:081022:tj@kernel.org::0GJj4mCgom+eqgu/:0000JtIC
X-Hashcash: 1:20:081022:jeff@garzik.org::MZ9tBihHlNUH3FbY:001KuT
From: Elias Oltmanns <eo@nebensachen.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org,
       jeff@garzik.org
Subject: Re: [PATCH 1/2] libata: get rid of ATA_MAX_QUEUE loop in ata_qc_complete_multiple()
References: <1224661243-7929-1-git-send-email-jens.axboe@oracle.com>
	<1224661243-7929-2-git-send-email-jens.axboe@oracle.com>
Date: Wed, 22 Oct 2008 20:23:50 +0200
Message-ID: <878wsgqyix.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> wrote:
> We very rarely (if ever) complete more than one command in the
> sactive mask at the time, even for extremely high IO rates. So
> looping over the entire range of possible tags is pointless,
> instead use __ffs() to just find the completed tags directly.
>
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  drivers/ata/libata-core.c |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 1ee9499..c3c53e7 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -4799,9 +4799,9 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
>   */
>  int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active)
>  {
> +	unsigned int i = 0;
>  	int nr_done = 0;
>  	u32 done_mask;
> -	int i;
>  
>  	done_mask = ap->qc_active ^ qc_active;
>  
> @@ -4811,16 +4811,19 @@ int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active)
>  		return -EINVAL;
>  	}
>  
> -	for (i = 0; i < ATA_MAX_QUEUE; i++) {
> +	while (done_mask) {
>  		struct ata_queued_cmd *qc;
> +		unsigned int next = __ffs(done_mask);
>  
> -		if (!(done_mask & (1 << i)))
> -			continue;
> -
> -		if ((qc = ata_qc_from_tag(ap, i))) {
> +		qc = ata_qc_from_tag(ap, i + next);
> +		if (qc) {
>  			ata_qc_complete(qc);
>  			nr_done++;
>  		}
> +		if (++next >= ATA_MAX_QUEUE)
> +			break;

If you think about it, this statement is equivalent to

	if (ap->qc_active ^ qc_active == (1 << (ATA_MAX_QUEUE - 1)))

To fix this, you could say

	if (++next + i >= ATA_MAX_QUEUE)

but perhaps it would be even more efficient (or not much worse) to skip
this check entirely.

Regards,

Elias
