Return-Path: <linux-kernel-owner+w=401wt.eu-S1752709AbYJWEOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbYJWEOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 00:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYJWEO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 00:14:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:40803 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbYJWEO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 00:14:27 -0400
Message-ID: <48FFFA15.8060603@kernel.org>
Date: Thu, 23 Oct 2008 13:14:13 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH 1/2] libata: get rid of ATA_MAX_QUEUE loop in ata_qc_complete_multiple()
References: <1224661243-7929-1-git-send-email-jens.axboe@oracle.com> <1224661243-7929-2-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1224661243-7929-2-git-send-email-jens.axboe@oracle.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 23 Oct 2008 04:14:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> @@ -4811,16 +4811,19 @@ int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active)
>               return -EINVAL;
>       }
>
> -     for (i = 0; i < ATA_MAX_QUEUE; i++) {
> +     while (done_mask) {
>               struct ata_queued_cmd *qc;
> +             unsigned int next = __ffs(done_mask);
>
> -             if (!(done_mask & (1 << i)))
> -                     continue;
> -
> -             if ((qc = ata_qc_from_tag(ap, i))) {
> +             qc = ata_qc_from_tag(ap, i + next);
> +             if (qc) {
>                       ata_qc_complete(qc);
>                       nr_done++;
>               }
> +             if (++next >= ATA_MAX_QUEUE)
> +                     break;
> +             i += next;
> +             done_mask >>= next;

Shouldn't this be...

        i += next + 1;
        if (i >= ATA_MAX_QUEUE)
                break;

or better...

while (done_mask) {
        struct ata_queued_cmd *qc;
        unsigned int next = __ffs(done_mask);

        tag += next;
        if ((qc = ata_qc_from_tag(ap, tag))) {
                ata_qc_complete(qc);
                nr_done++;
        }
        next++;
        tag += next;
        done_mask >>= next;
}

done_mask is guaranteed to be zero at when tag reaches ATA_MAX_QUEUE.

Thanks.

-- 
tejun
