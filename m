Return-Path: <linux-kernel-owner+w=401wt.eu-S1765655AbZAPJ3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765655AbZAPJ3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 04:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758923AbZAPJ3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 04:29:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45794 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758492AbZAPJ3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 04:29:18 -0500
Date: Fri, 16 Jan 2009 10:28:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL}: latest tip/cpus4096 changes
Message-ID: <20090116092859.GD4305@elte.hu>
References: <49704DF6.8040205@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49704DF6.8040205@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> diff --git a/kernel/kgdb.c b/kernel/kgdb.c
> index e4dcfb2..21fde60 100644
> --- a/kernel/kgdb.c
> +++ b/kernel/kgdb.c
> @@ -72,7 +72,7 @@ struct kgdb_state {
>  static struct debuggerinfo_struct {
>  	void			*debuggerinfo;
>  	struct task_struct	*task;
> -} kgdb_info[NR_CPUS];
> +} *kgdb_info;
>  
>  /**
>   * kgdb_connected - Is a host GDB connected to us?
> @@ -1651,6 +1651,13 @@ int kgdb_register_io_module(struct kgdb_io *new_kgdb_io_ops)
>  		return -EBUSY;
>  	}
>  
> +	kgdb_info = kmalloc(nr_cpu_ids * sizeof(*kgdb_info), GFP_KERNEL);
> +	if (unlikely(!kgdb_info)) {
> +		spin_unlock(&kgdb_registration_lock);
> +		printk(KERN_ERR "kgdb: No memory for kgdb_info\n");
> +		return -ENOMEM;
> +	}
> +
>  	if (new_kgdb_io_ops->init) {
>  		err = new_kgdb_io_ops->init();
>  		if (err) {

Look how it continues:

                        spin_unlock(&kgdb_registration_lock);
                        return err;
                }
        }

See the memory leak? This is _trivially_ broken. When you add dynamic 
allocation to any codepath you _need_ to be careul and you need to check 
all interim paths of return.

Also, please submit kgdb patches via the KGDB maintainer:

 KGDB
 P:      Jason Wessel
 M:      jason.wessel@windriver.com
 L:      kgdb-bugreport@lists.sourceforge.net
 S:      Maintained

	Ingo
