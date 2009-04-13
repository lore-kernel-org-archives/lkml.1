Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbZDMTET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbZDMTET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 15:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZDMTEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 15:04:09 -0400
Received: from mx2.netapp.com ([216.240.18.37]:8730 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbZDMTEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 15:04:08 -0400
X-IronPort-AV: E=Sophos;i="4.40,180,1239001200"; 
   d="scan'208";a="154006450"
Subject: Re: [PATCH] slow_work_thread() should do the exclusive wait
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       Steve Dickson <steved@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Daire Byrne <Daire.Byrne@framestore.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090413181733.GA10424@redhat.com>
References: <20090413181733.GA10424@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Mon, 13 Apr 2009 15:03:49 -0400
Message-Id: <1239649429.16771.9.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
X-OriginalArrivalTime: 13 Apr 2009 19:04:05.0672 (UTC) FILETIME=[9DCC0A80:01C9BC6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-13 at 20:17 +0200, Oleg Nesterov wrote:
> slow_work_thread() sleeps on slow_work_thread_wq without WQ_FLAG_EXCLUSIVE,
> this means that slow_work_enqueue()->__wake_up(nr_exclusive => 1) wakes up
> all kslowd threads. Afaics this is not what we want, change slow_work_thread()
> to use prepare_to_wait_exclusive().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> --- 6.30/kernel/slow-work.c~1_SW_EXCLUSIVE	2009-04-06 00:03:42.000000000 +0200
> +++ 6.30/kernel/slow-work.c	2009-04-13 19:40:20.000000000 +0200
> @@ -372,8 +372,8 @@ static int slow_work_thread(void *_data)
>  		vsmax *= atomic_read(&slow_work_thread_count);
>  		vsmax /= 100;
>  
> -		prepare_to_wait(&slow_work_thread_wq, &wait,
> -				TASK_INTERRUPTIBLE);
> +		prepare_to_wait_exclusive(&slow_work_thread_wq, &wait,
> +						TASK_INTERRUPTIBLE);
>  		if (!freezing(current) &&
>  		    !slow_work_threads_should_exit &&
>  		    !slow_work_available(vsmax) &&
> 

Should that really be TASK_INTERRUPTIBLE? I don't see anything obvious
in the enclosing for(;;) loop that checks for or handles signals...

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
