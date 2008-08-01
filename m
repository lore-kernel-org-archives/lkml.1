Return-Path: <linux-kernel-owner+w=401wt.eu-S1757635AbYHASRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbYHASRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757400AbYHASQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:16:49 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57250 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYHASQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:16:47 -0400
Date: Fri, 01 Aug 2008 12:16:16 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: high resolution timers, scheduling & sleep granularity
In-reply-to: <20080801132537.GB14001@unused.rdu.redhat.com>
To: Josef Bacik <jbacik@redhat.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org
Message-id: <20080801181616.GZ3292@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <4892FC11.4020105@redhat.com>
 <20080801132537.GB14001@unused.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 01, 2008  09:25 -0400, Josef Bacik wrote:
> +	if (unlikely(!journal->j_average_commit_time))
> +		journal->j_average_commit_time = commit_time;
> +	else
> +		journal->j_average_commit_time = (commit_time +
> +					journal->j_average_commit_time) / 2;

You may also consider making this a decaying average, so that minor changes
in the workload are smoothed out.  Also, it is probably easier to read
likely(foo) instead of unlikely(!foo)...

	if (likely(journal->j_average_commit_time != 0))
		journal->j_average_commit_time =
			(commit_time * 3 + journal->j_average_commit_time) / 4;
	else
		journal->j_average_commit_time = commit_time;

> +	if (journal->print_count < 100) {
> +		journal->print_count++;
> +		printk(KERN_ERR "avg commit time = %lu\n",
> +		       journal->j_average_commit_time);
> +	}

There is already the jbd stats patch in jbd2 that is reporting this
information for the previous transactions.

>  
> +		spin_lock(&journal->j_state_lock);
> +		commit_time = journal->j_average_commit_time;
> +		spin_unlock(&journal->j_state_lock);
> +
> +		sleep_time = elapsed_jiffies(transaction->t_start_time, jiffies);
> +		if (!sleep_time)
> +			sleep_time = 1;
> +		sleep_time = (commit_time / sleep_time) * commit_time;

I was also going to comment on the use of jiffies here, but Ric beat me
to it.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

