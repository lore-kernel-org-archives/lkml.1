Return-Path: <linux-kernel-owner+w=401wt.eu-S1760323AbZBTRgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760323AbZBTRgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758313AbZBTReK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:34:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41890 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757042AbZBTReE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:34:04 -0500
Date: Fri, 20 Feb 2009 18:33:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/5] ftrace: break out modify loop immediately on
	detection of error
Message-ID: <20090220173334.GJ24538@elte.hu>
References: <20090220163846.709775139@goodmis.org> <20090220164046.287797665@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220164046.287797665@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -561,11 +561,15 @@ static void ftrace_replace_code(int enable)
>  				if ((system_state == SYSTEM_BOOTING) ||
>  				    !core_kernel_text(rec->ip)) {
>  					ftrace_free_rec(rec);
> -				} else
> +				} else {
>  					ftrace_bug(failed, rec->ip);
> +					goto out;
> +				}
>  			}
>  		}
>  	}
> + out:
> +	return;

wouldnt a simple 'break' suffice? Hm, nope, 
do_for_each_ftrace_rec() is a double loop.

Then perhaps a 'return' would perhaps be cleaner in this case. 
(even though it does make the flow a bit assymetric - the out 
label and the empty return looks a bit ugly.)

	Ingo
