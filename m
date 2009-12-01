Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbZLAO00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbZLAO00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 09:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbZLAO00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 09:26:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35010 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbZLAO0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 09:26:25 -0500
Date: Tue, 1 Dec 2009 15:26:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, steved@redhat.com,
       jens.axboe@oracle.com, linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org
Subject: Re: [PATCH] SLOW_WORK: Fix the CONFIG_MODULES=n case
Message-ID: <20091201142611.GA1183@elte.hu>
References: <25668.1259675528@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25668.1259675528@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Howells <dhowells@redhat.com> wrote:

> @@ -943,6 +953,7 @@ EXPORT_SYMBOL(slow_work_register_user);
>   */
>  static void slow_work_wait_for_items(struct module *module)
>  {
> +#ifdef CONFIG_MODULES
>  	DECLARE_WAITQUEUE(myself, current);
>  	struct slow_work *work;
>  	int loop;
> @@ -989,6 +1000,7 @@ static void slow_work_wait_for_items(struct module *module)
>  
>  	remove_wait_queue(&slow_work_unreg_wq, &myself);
>  	mutex_unlock(&slow_work_unreg_sync_lock);
> +#endif /* CONFIG_MODULES */
>  }

this slow_work_wait_for_items() function should move into the #ifdef 
block too.

With that fixed it looks good to me for .33 (but i havent tested it):

  Acked-by: Ingo Molnar <mingo@elte.hu>

In terms of .32 i guess it's OK too and the fix is needed - but i'd 
really not have done even the preceding changes - why again did we need 
/proc/slow_work_rq via 8fba10a and why did it have to happen right 
before the final kernel?

If then it should have been done in debugfs - we dont need yet another 
/proc ABI.

Also, a very small aesthetic detail: i think the title should use the 
'slow-work: ' prefix, not 'SLOW_WORK: '.

Thanks,

	Ingo
