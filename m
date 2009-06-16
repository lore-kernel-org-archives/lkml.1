Return-Path: <linux-kernel-owner+w=401wt.eu-S1762346AbZFPTpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762346AbZFPTpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758879AbZFPTp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:45:28 -0400
Received: from smtp-out.google.com ([216.239.33.17]:49911 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbZFPTp1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:45:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=uu4rcjOgu6xCb8HgbbWtiY6KNVUfzbBYI8LJjW+8tvNyng9kUP+vzn72iZO+yv1na
	PcLTP5sEh8XzlSVQaREjw==
MIME-Version: 1.0
In-Reply-To: <1244513342-11758-3-git-send-email-vgoyal@redhat.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com> 
	<1244513342-11758-3-git-send-email-vgoyal@redhat.com>
From: Divyesh Shah <dpshah@google.com>
Date: Tue, 16 Jun 2009 12:44:58 -0700
Message-ID: <af41c7c40906161244q61fd47c5u1a10243c8839938@mail.gmail.com>
Subject: Re: [PATCH 02/19] io-controller: Common flat fair queuing code in 
	elevaotor layer
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 8, 2009 at 7:08 PM, Vivek Goyal<vgoyal@redhat.com> wrote:
> void elv_deactivate_ioq(struct elv_fq_data *efqd, struct io_queue *ioq,
> +                                       int requeue)
> +{
> +       if (ioq == efqd->active_queue)
> +               elv_reset_active_ioq(efqd);
> +
> +       bfq_deactivate_entity(&ioq->entity, requeue);
> +}

The check for ioq == efqd->active_queue and the call to
elv_reset_active_ioq() seem to be unnecessary. This gets called from
elv_del_ioq_busy() which has 2 callers which:
- either explicitly check for ioq != efqd->active_queue
- or call elv_reset_active_ioq() right before invoking this function

This was needed earlier as the io_ioq_move() function didn't fall in
one of the 2 categories above. This has been done away with the ref
counting patch, AFAICT.

-Divyesh
