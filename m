Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbYKNA3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbYKNA3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 19:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbYKNA3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 19:29:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753553AbYKNA3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 19:29:11 -0500
Date: Thu, 13 Nov 2008 16:27:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: ananth@in.ibm.com, jkenisto@us.ibm.com, davem@davemloft.net,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com
Subject: Re: [PATCH 4/7] kprobes: Support probing module __exit function
Message-Id: <20081113162739.5e871fab.akpm@linux-foundation.org>
In-Reply-To: <4919F19A.9050904@redhat.com>
References: <4919F19A.9050904@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 15:56:58 -0500
Masami Hiramatsu <mhiramat@redhat.com> wrote:

> @@ -69,9 +69,6 @@ struct kprobe {
>  	/* list of kprobes for multi-handler support */
>  	struct list_head list;
> 
> -	/* Indicates that the corresponding module has been ref counted */
> -	unsigned int mod_refcounted;
> -
>  	/*count the number of times this probe was temporarily disarmed */
>  	unsigned long nmissed;
> 
> @@ -103,8 +100,19 @@ struct kprobe {
> 
>  	/* copy of the original instruction */
>  	struct arch_specific_insn ainsn;
> +
> +	/* Indicates various status flags */
> +	u32 flags;
>  };
> 
> +/* Kprobe status flags */
> +#define KPROBE_FLAG_GONE	1 /* breakpoint has already gone */
> +
> +static inline int kprobe_gone(struct kprobe *p)
> +{
> +	return p->flags & KPROBE_FLAG_GONE;
> +}

If we're not going to use atomic bitops on kprobe.flags then
modifications to that member will require that the caller hold a lock. 
The comment above that member should describe its locking protocol.  It
seems that it is kprobe_mutex, so...

--- a/include/linux/kprobes.h~kprobes-support-probing-module-__exit-function-fix
+++ a/include/linux/kprobes.h
@@ -101,7 +101,7 @@ struct kprobe {
 	/* copy of the original instruction */
 	struct arch_specific_insn ainsn;
 
-	/* Indicates various status flags */
+	/* Indicates various status flags.  Protected by kprobe_mutex. */
 	u32 flags;
 };
 
_


yes?
