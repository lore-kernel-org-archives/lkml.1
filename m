Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbYHLNHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbYHLNHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbYHLNG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:06:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbYHLNGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:06:55 -0400
Date: Tue, 12 Aug 2008 09:06:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -v3 6/7] kexec jump: __ftrace_enabled_save/restore
Message-ID: <20080812130609.GB3951@redhat.com>
References: <1218510876.24951.45.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218510876.24951.45.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 11:14:36AM +0800, Huang Ying wrote:
> Add __ftrace_enabled_save/restore, used to disable ftrace for a
> while. Now, this is used by kexec jump, which need a version without
> lock, for general situation, a locked version should be used.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> ---
>  include/linux/ftrace.h |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -98,6 +98,27 @@ static inline void tracer_disable(void)
>  #endif
>  }
>  
> +/* Ftrace disable/restore without lock. Some synchronization mechanism
> + * must be used to prevent ftrace_enabled to be changed between
> + * disable/restore. */
> +static inline int __ftrace_enabled_save(void)
> +{
> +#ifdef CONFIG_FTRACE
> +	int saved_ftrace_enabled = ftrace_enabled;
> +	ftrace_enabled = 0;
> +	return saved_ftrace_enabled;
> +#else
> +	return 0;
> +#endif
> +}
> +
> +static inline void __ftrace_enabled_restore(int enabled)
> +{
> +#ifdef CONFIG_FTRACE
> +	ftrace_enabled = enabled;
> +#endif
> +}
> +
>  #ifdef CONFIG_FRAME_POINTER
>  /* TODO: need to fix this for ARM */
>  # define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))

I guess steven would like to see a patch which introduces both locked
and lockless versions and with a very good comment explaining in what
kind of unusual situation one can use the lockless version.

Thanks
Vivek
