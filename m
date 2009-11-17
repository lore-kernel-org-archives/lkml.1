Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbZKQMsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbZKQMsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbZKQMsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:48:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbZKQMsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:48:16 -0500
Date: Tue, 17 Nov 2009 07:47:39 -0500
From: Jeff Layton <jlayton@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, samba-technical@lists.samba.org,
       Steve French <sfrench@samba.org>, linux-mm <linux-mm@kvack.org>,
       kosaki.motohiro@jp.fujitsu.com,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-cifs-client@lists.samba.org
Subject: Re: [PATCH 6/7] cifs: Don't use PF_MEMALLOC
Message-ID: <20091117074739.4abaef85@tlielax.poochiereds.net>
In-Reply-To: <20091117162111.3DE8.A69D9226@jp.fujitsu.com>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
	<20091117162111.3DE8.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009 16:22:32 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> 
> Non MM subsystem must not use PF_MEMALLOC. Memory reclaim need few
> memory, anyone must not prevent it. Otherwise the system cause
> mysterious hang-up and/or OOM Killer invokation.
> 
> Cc: Steve French <sfrench@samba.org>
> Cc: linux-cifs-client@lists.samba.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  fs/cifs/connect.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 63ea83f..f9b1553 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -337,7 +337,6 @@ cifs_demultiplex_thread(struct TCP_Server_Info *server)
>  	bool isMultiRsp;
>  	int reconnect;
>  
> -	current->flags |= PF_MEMALLOC;
>  	cFYI(1, ("Demultiplex PID: %d", task_pid_nr(current)));
>  
>  	length = atomic_inc_return(&tcpSesAllocCount);

This patch appears to be safe for CIFS. I believe that the demultiplex
thread only does mempool allocations currently. The only other case
where it did an allocation was recently changed with the conversion of
the oplock break code to use slow_work.

Barring anything I've missed...

Acked-by: Jeff Layton <jlayton@redhat.com>
