Return-Path: <linux-kernel-owner+w=401wt.eu-S1758498AbZLGBqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498AbZLGBqo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 20:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758297AbZLGBqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 20:46:42 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:59534 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622AbZLGBql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 20:46:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FdxLkg+tEGz7Qb6PfgYGUTfLyahtd5/Y5L3L0UNxr+Q6AprpBV9wR/CdkPgPifL5cY
         97jfNbOVr1ELLGBoOkypeXULSEqd5LtW5ssg9KPxpEa4s98sThl4bM9TYVVVS5FC7rOv
         2tYS4rgrGjXdVlDYkevKDNdVKIheHg6dEZO9o=
Date: Mon, 7 Dec 2009 02:46:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 2/9] perf: Remove pointless union that wraps the hw
	breakpoint fields
Message-ID: <20091207014645.GD4966@nowhere>
References: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com> <1260084898-11686-3-git-send-regression-fweisbec@gmail.com> <1260095935.7818.258.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260095935.7818.258.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 06, 2009 at 11:38:55AM +0100, Peter Zijlstra wrote:
> On Sun, 2009-12-06 at 08:34 +0100, Frederic Weisbecker wrote:
> > It stands to anonymize a structure, but structures can already
> > anonymize by themselves.
> > 
> > Reported-by: Peter Zijlstra <peterz@infradead.org>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: "K. Prasad" <prasad@linux.vnet.ibm.com>
> > ---
> >  include/linux/perf_event.h |   14 ++++++--------
> >  1 files changed, 6 insertions(+), 8 deletions(-)
> > 
> > diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> > index a61e4de..53230e9 100644
> > --- a/include/linux/perf_event.h
> > +++ b/include/linux/perf_event.h
> > @@ -215,14 +215,12 @@ struct perf_event_attr {
> >  		__u32		wakeup_watermark; /* bytes before wakeup   */
> >  	};
> >  
> > -	union {
> > -		struct { /* Hardware breakpoint info */
> > -			__u64		bp_addr;
> > -			__u32		bp_type;
> > -			__u32		bp_len;
> > -			__u64		__bp_reserved_1;
> > -			__u64		__bp_reserved_2;
> > -		};
> > +	struct { /* Hardware breakpoint info */
> > +		__u64		bp_addr;
> > +		__u32		bp_type;
> > +		__u32		bp_len;
> > +		__u64		__bp_reserved_1;
> > +		__u64		__bp_reserved_2;
> >  	};
> >  
> >  	__u32			__reserved_2;
> 
> So I'm a bit puzzled by the need for
>  - that structure to begin with



It has no practical use. It's just a logical separation
that makes it easier to review.

I won't mind much if you prefer to remove it.


>  - specialized __bp reserves


Because we'll probably have further new needs in the future
in the breakpoint fields. But well, these can map to the
current reserved fields already.



> Furthermore, you still got the packing wrong, leading to different
> structure layout on 32 and 64 bit platforms,..
> 
> How about?
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 89098e3..5595154 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -215,17 +215,12 @@ struct perf_event_attr {
>  		__u32		wakeup_watermark; /* bytes before wakeup   */
>  	};
>  
> -	struct { /* Hardware breakpoint info */
> -		__u64		bp_addr;
> -		__u32		bp_type;
> -		__u32		bp_len;
> -		__u64		__bp_reserved_1;
> -		__u64		__bp_reserved_2;
> -	};
> -
>  	__u32			__reserved_2;
>  
> -	__u64			__reserved_3;
> +	/* Hardware breakpoint info */
> +	__u64		bp_addr;
> +	__u32		bp_type;
> +	__u32		bp_len;
>  };



Right this fixes the packing layout, but what if
we need other fields for the breakpoints in the future?

Thanks.

