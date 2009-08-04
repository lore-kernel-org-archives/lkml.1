Return-Path: <linux-kernel-owner+w=401wt.eu-S933394AbZHDWAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933394AbZHDWAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 18:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933193AbZHDWAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 18:00:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933191AbZHDWAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 18:00:51 -0400
Date: Tue, 4 Aug 2009 14:59:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: ieidus@redhat.com, aarcange@redhat.com, riel@redhat.com, chrisw@redhat.com,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 5/12] ksm: keep quiet while list empty
Message-Id: <20090804145935.e258cd2f.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0908031313030.16754@sister.anvils>
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils>
	<Pine.LNX.4.64.0908031313030.16754@sister.anvils>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Aug 2009 13:14:03 +0100 (BST)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> +		if (ksmd_should_run()) {
>  			schedule_timeout_interruptible(
>  				msecs_to_jiffies(ksm_thread_sleep_millisecs));
>  		} else {
>  			wait_event_interruptible(ksm_thread_wait,
> -					(ksm_run & KSM_RUN_MERGE) ||
> -					kthread_should_stop());
> +				ksmd_should_run() || kthread_should_stop());
>  		}

Yields


		if (ksmd_should_run()) {
			schedule_timeout_interruptible(
				msecs_to_jiffies(ksm_thread_sleep_millisecs));
		} else {
			wait_event_interruptible(ksm_thread_wait,
				ksmd_should_run() || kthread_should_stop());
		}

can it be something like

		wait_event_interruptible_timeout(ksm_thread_wait,
			ksmd_should_run() || kthread_should_stop(),
			msecs_to_jiffies(ksm_thread_sleep_millisecs));

?

That would also reduce the latency in responding to kthread_should_stop().
