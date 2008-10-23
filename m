Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbYJWGp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbYJWGp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 02:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbYJWGo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 02:44:57 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51824 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007AbYJWGoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 02:44:55 -0400
Date: Thu, 23 Oct 2008 08:43:57 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH 1/2] libata: get rid of ATA_MAX_QUEUE loop in ata_qc_complete_multiple()
Message-ID: <20081023064357.GT22217@kernel.dk>
References: <1224661243-7929-1-git-send-email-jens.axboe@oracle.com> <1224661243-7929-2-git-send-email-jens.axboe@oracle.com> <48FFFA15.8060603@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FFFA15.8060603@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23 2008, Tejun Heo wrote:
> while (done_mask) {
>         struct ata_queued_cmd *qc;
>         unsigned int next = __ffs(done_mask);
> 
>         tag += next;
>         if ((qc = ata_qc_from_tag(ap, tag))) {
>                 ata_qc_complete(qc);
>                 nr_done++;
>         }
>         next++;
>         tag += next;
>         done_mask >>= next;
> }

That doesn't work (you're adding next to tag twice), it needs a little
tweak:

while (done_mask) {
        struct ata_queued_cmd *qc;
        unsigned int next = __ffs(done_mask);

        if ((qc = ata_qc_from_tag(ap, tag + next))) {
                ata_qc_complete(qc);
                nr_done++;
        }
        next++;
        tag += next;
        done_mask >>= next;
}

and I think it should work. Not tested yet :-)

-- 
Jens Axboe

