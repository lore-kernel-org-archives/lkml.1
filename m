Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426Ab0ADO6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab0ADO6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 09:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193Ab0ADO6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 09:58:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab0ADO6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 09:58:22 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe\@oracle.com" <jens.axboe@oracle.com>,
       "Zhang\, Yanmin" <yanmin.zhang@intel.com>
Subject: Re: [PATCH]cfq-iosched: don't take requests with long distence as close
References: <20091224005506.GA7879@sli10-desk.sh.intel.com>
	<4e5e476b0912250216n2b4aceacyf22a0e73425efd3a@mail.gmail.com>
	<20091228020348.GB28115@sli10-desk.sh.intel.com>
	<4e5e476b0912280036r6e55587dj66952fcd6ff4d08b@mail.gmail.com>
	<20091228084659.GA31389@sli10-desk.sh.intel.com>
	<4e5e476b0912280111s6a977251m3416341b4bd2c272@mail.gmail.com>
	<20091228092844.GA9710@sli10-desk.sh.intel.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 04 Jan 2010 09:58:16 -0500
In-Reply-To: <20091228092844.GA9710@sli10-desk.sh.intel.com> (Shaohua Li's
	message of "Mon, 28 Dec 2009 17:28:44 +0800")
Message-ID: <x49my0tc3xz.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li <shaohua.li@intel.com> writes:
> seek_mean could be very big sometimes, using it as close criteria is meaningless
> as this doen't improve any performance. So if it's big, let's fallback to
> default value.

I think the real problem is that we lost a check for a seeky queue.  The
close cooperator code initially was written to help interleaved
sequential I/Os.  Given that, I'm not a big fan of the proposed patch.
I'd rather see an extra check for CFQQ_SEEKY added to the close
cooperator code paths and leave cfq_rq_close alone.

Cheers,
Jeff

>
> Signed-off-by: Shaohua Li<shaohua.li@intel.com>
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index e2f8046..e80bd47 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1675,13 +1675,17 @@ static inline sector_t cfq_dist_from_last(struct cfq_data *cfqd,
>  #define CFQQ_SEEKY(cfqq)	((cfqq)->seek_mean > CFQQ_SEEK_THR)
>  
>  static inline int cfq_rq_close(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> -			       struct request *rq)
> +			       struct request *rq, bool for_preempt)
>  {
>  	sector_t sdist = cfqq->seek_mean;
>  
>  	if (!sample_valid(cfqq->seek_samples))
>  		sdist = CFQQ_SEEK_THR;
>  
> +	/* if seek_mean is big, using it as close criteria is meaningless */
> +	if (sdist > CFQQ_SEEK_THR && !for_preempt)
> +		sdist = CFQQ_SEEK_THR;
> +
>  	return cfq_dist_from_last(cfqd, rq) <= sdist;
>  }
>  
> @@ -1709,7 +1713,7 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
>  	 * will contain the closest sector.
>  	 */
>  	__cfqq = rb_entry(parent, struct cfq_queue, p_node);
> -	if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq))
> +	if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq, false))
>  		return __cfqq;
>  
>  	if (blk_rq_pos(__cfqq->next_rq) < sector)
> @@ -1720,7 +1724,7 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
>  		return NULL;
>  
>  	__cfqq = rb_entry(node, struct cfq_queue, p_node);
> -	if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq))
> +	if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq, false))
>  		return __cfqq;
>  
>  	return NULL;
> @@ -3143,7 +3147,7 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
>  	 * if this request is as-good as one we would expect from the
>  	 * current cfqq, let it preempt
>  	 */
> -	if (cfq_rq_close(cfqd, cfqq, rq))
> +	if (cfq_rq_close(cfqd, cfqq, rq, true))
>  		return true;
>  
>  	return false;
