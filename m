Return-Path: <linux-kernel-owner+w=401wt.eu-S933264AbZLFKjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264AbZLFKjl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 05:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933247AbZLFKj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 05:39:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:48183 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933241AbZLFKj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 05:39:27 -0500
Subject: Re: [PATCH 2/9] perf: Remove pointless union that wraps the hw
 breakpoint fields
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <1260084898-11686-3-git-send-regression-fweisbec@gmail.com>
References: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
	 <1260084898-11686-3-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Dec 2009 11:38:55 +0100
Message-ID: <1260095935.7818.258.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-06 at 08:34 +0100, Frederic Weisbecker wrote:
> It stands to anonymize a structure, but structures can already
> anonymize by themselves.
> 
> Reported-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: "K. Prasad" <prasad@linux.vnet.ibm.com>
> ---
>  include/linux/perf_event.h |   14 ++++++--------
>  1 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index a61e4de..53230e9 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -215,14 +215,12 @@ struct perf_event_attr {
>  		__u32		wakeup_watermark; /* bytes before wakeup   */
>  	};
>  
> -	union {
> -		struct { /* Hardware breakpoint info */
> -			__u64		bp_addr;
> -			__u32		bp_type;
> -			__u32		bp_len;
> -			__u64		__bp_reserved_1;
> -			__u64		__bp_reserved_2;
> -		};
> +	struct { /* Hardware breakpoint info */
> +		__u64		bp_addr;
> +		__u32		bp_type;
> +		__u32		bp_len;
> +		__u64		__bp_reserved_1;
> +		__u64		__bp_reserved_2;
>  	};
>  
>  	__u32			__reserved_2;

So I'm a bit puzzled by the need for
 - that structure to begin with
 - specialized __bp reserves

Furthermore, you still got the packing wrong, leading to different
structure layout on 32 and 64 bit platforms,..

How about?

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 89098e3..5595154 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -215,17 +215,12 @@ struct perf_event_attr {
 		__u32		wakeup_watermark; /* bytes before wakeup   */
 	};
 
-	struct { /* Hardware breakpoint info */
-		__u64		bp_addr;
-		__u32		bp_type;
-		__u32		bp_len;
-		__u64		__bp_reserved_1;
-		__u64		__bp_reserved_2;
-	};
-
 	__u32			__reserved_2;
 
-	__u64			__reserved_3;
+	/* Hardware breakpoint info */
+	__u64		bp_addr;
+	__u32		bp_type;
+	__u32		bp_len;
 };
 
 /*


