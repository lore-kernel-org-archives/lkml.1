Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbYK3ETp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbYK3ETp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 23:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbYK3ETf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 23:19:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848AbYK3ETf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 23:19:35 -0500
Date: Sat, 29 Nov 2008 20:19:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2.6.28-rc6] when to BUG(), and when to not BUG()
Message-Id: <20081129201930.a591395b.akpm@linux-foundation.org>
In-Reply-To: <200811291921.30759.david-b@pacbell.net>
References: <200811291921.30759.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008 19:21:30 -0800 David Brownell <david-b@pacbell.net> wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Provide some basic advice about when to use BUG()/BUG_ON():
> never, unless there's really no better option.
> 
> This matches my understanding of the standard policy ... which
> seems not to be written down so far, outside of LKML messages
> that I haven't bookmarked.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> ---
> This arguably belongs in patch checklists too... but I figure we
> should start by flushing out any contrary opinions.
> 
>  include/asm-generic/bug.h |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> --- a/include/asm-generic/bug.h
> +++ b/include/asm-generic/bug.h
> @@ -20,6 +20,17 @@ struct bug_entry {
>  #define BUGFLAG_WARNING	(1<<0)
>  #endif	/* CONFIG_GENERIC_BUG */
>  
> +/*
> + * Don't use BUG() or BUG_ON() unless there's really no way out; one
> + * example might be detecting data structure corruption in the middle
> + * of an operation that can't be backed out of.  If the (sub)system
> + * can somehow continue operating, perhaps with reduced functionality,
> + * it's probably not BUG-worthy.
> + *
> + * If you're tempted to BUG(), think again:  is completely giving up
> + * really the *only* solution?  There are usually better options, where
> + * users don't need to reboot ASAP and can mostly shut down cleanly.
> + */
>  #ifndef HAVE_ARCH_BUG
>  #define BUG() do { \
>  	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __func__); \
> @@ -31,6 +42,12 @@ struct bug_entry {
>  #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
>  #endif
>  
> +/*
> + * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
> + * significant issues that need prompt attention if they should ever
> + * appear at runtime.  Use the versions with printk format strings
> + * to provide better diagnostics.
> + */
>  #ifndef __WARN
>  #ifndef __ASSEMBLY__
>  extern void warn_on_slowpath(const char *file, const int line);

I don't disagree.

One reason for trying to keep going rather than going BUG is that it
increases the chances that the information about the bug gets into the
logs, gets sent across netconsole, etc.

