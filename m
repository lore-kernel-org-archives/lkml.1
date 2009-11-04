Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbZKDTBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbZKDTBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbZKDTBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:01:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbZKDTBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:01:20 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 15/20] blkio: Take care of preemptions across groups
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
	<1257291837-6246-16-git-send-email-vgoyal@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 04 Nov 2009 14:00:33 -0500
In-Reply-To: <1257291837-6246-16-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Tue, 3 Nov 2009 18:43:52 -0500")
Message-ID: <x49d43yt8ry.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> +static bool cfq_should_preempt_group(struct cfq_data *cfqd,
> +		struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
> +{
> +	struct cfq_entity *cfqe = &cfqq->entity;
> +	struct cfq_entity *new_cfqe = &new_cfqq->entity;
> +
> +	if (cfqq_to_cfqg(cfqq) != &cfqd->root_group)
> +		cfqe = parent_entity(&cfqq->entity);
> +
> +	if (cfqq_to_cfqg(new_cfqq) != &cfqd->root_group)
> +		new_cfqe = parent_entity(&new_cfqq->entity);
> +
> +	/*
> +	 * Allow an RT request to pre-empt an ongoing non-RT cfqq timeslice.
> +	 */
> +
> +	if (new_cfqe->ioprio_class == IOPRIO_CLASS_RT
> +	    && cfqe->ioprio_class != IOPRIO_CLASS_RT)
> +		return true;
> +	/*
> +	 * Allow an BE request to pre-empt an ongoing IDLE clas timeslice.
> +	 */
> +
> +	if (new_cfqe->ioprio_class == IOPRIO_CLASS_BE
> +	    && cfqe->ioprio_class == IOPRIO_CLASS_IDLE)
> +		return true;
> +
> +	return false;
> +}

What was the motivation for this?  It seems like this would really break
isolation.  What if one group has all RT priority tasks, will it starve
out the other groups?

Cheers,
Jeff
