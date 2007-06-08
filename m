Return-Path: <linux-kernel-owner+w=401wt.eu-S932197AbXFHGcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197AbXFHGcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 02:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756583AbXFHGcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 02:32:01 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46296 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755507AbXFHGcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 02:32:01 -0400
Date: Thu, 7 Jun 2007 23:31:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miloslav Trmac <mitr@redhat.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
       Alexander Viro <aviro@redhat.com>
Subject: Re: [PATCH, v2] Audit: Add TTY input auditing
Message-Id: <20070607233139.de85725f.akpm@linux-foundation.org>
In-Reply-To: <4668D9BB.3010600@redhat.com>
References: <4666832D.8080603@redhat.com>
	<46668814.7080404@redhat.com>
	<20070606174113.b7fc31da.akpm@linux-foundation.org>
	<4668D9BB.3010600@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Jun 2007 06:23:23 +0200 Miloslav Trmac <mitr@redhat.com> wrote:

> From: Miloslav Trmac <mitr@redhat.com>
> 
> Add TTY input auditing, used to audit system administrator's actions.
> TTY input auditing works on a higher level than auditing all system
> calls within the session, which would produce an overwhelming amount of
> mostly useless audit events.
> 
> Add an "audit_tty" attribute, inherited across fork ().  Data read from
> TTYs by process with the attribute is sent to the audit subsystem by the
> kernel.  The audit netlink interface is extended to allow modifying the
> audit_tty attribute, and to allow sending explanatory audit events from
> user-space (for example, a shell might send an event containing the
> final command, after the interactive command-line editing and history
> expansion is performed, which might be difficult to decipher from the
> TTY input alone).
> 
> Because the "audit_tty" attribute is inherited across fork (), it would
> be set e.g. for sshd restarted within an audited session.  To prevent
> this, the audit_tty attribute is cleared when a process with no open TTY
> file descriptors (e.g. after daemon startup) opens a TTY.
> 
> See https://www.redhat.com/archives/linux-audit/2007-June/msg00000.html
> for a more detailed rationale document for an older version of this patch.
> 
> ---
> Changes since the previous patch:
> * use spin_lock_irq() for siglock
> * add an is_tty() function instead of checking f_op->read from n_tty.c;
>   handle hung TTYs
> * replace the audit_tty bit field by a whole word to avoid the risk of
>   incorrect locking
> * move most new code from n_tty.c to a separate file
> * fix coding style violations
> * fix compilation with !CONFIG_AUDIT
> 

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index d58e74b..d9d734c 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -506,6 +506,8 @@ struct signal_struct {
>  #ifdef CONFIG_TASKSTATS
>  	struct taskstats *stats;
>  #endif
> +	unsigned audit_tty;
> +	struct tty_audit_buf *tty_audit_buf;
>  };

Can we ifdef these?


