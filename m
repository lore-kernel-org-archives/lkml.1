Return-Path: <linux-kernel-owner+w=401wt.eu-S1761419AbYARO4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761419AbYARO4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 09:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756961AbYARO4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 09:56:07 -0500
Received: from gecko.sbs.de ([194.138.37.40]:24327 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756933AbYARO4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 09:56:06 -0500
Message-ID: <4790BDD1.40808@siemens.com>
Date: Fri, 18 Jan 2008 15:55:13 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jiri Kosina <jikos@jikos.cz>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>, Kirill Korotaev <dev@sw.ru>
Subject: Re: [PATCH] printk deadlocks if called with runqueue lock held
References: <Pine.LNX.4.58.0801172000430.32679@gandalf.stny.rr.com> <Pine.LNX.4.64.0801181203240.15647@twin.jikos.cz> <Pine.LNX.4.58.0801180634040.7574@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0801180634040.7574@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
...
> @@ -978,7 +980,13 @@ void release_console_sem(void)
>  	console_locked = 0;
>  	up(&console_sem);

Hmm, just looking at this fragment: Doesn't up() include the risk of
running onto the runqueue lock as well?

>  	spin_unlock_irqrestore(&logbuf_lock, flags);
> -	if (wake_klogd)
> +	/*
> +	 * If we try to wake up klogd while printing with the runqueue lock
> +	 * held, this will deadlock. We don't have access to the runqueue
> +	 * lock from here, but just checking for interrupts disabled
> +	 * should be enough.
> +	 */
> +	if (!irqs_disabled() && wake_klogd)
>  		wake_up_klogd();
>  }
>  EXPORT_SYMBOL(release_console_sem);

Jan
