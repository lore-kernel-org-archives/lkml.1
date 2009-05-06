Return-Path: <linux-kernel-owner+w=401wt.eu-S1752205AbZEFE6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbZEFE6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 00:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbZEFE6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 00:58:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43100 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbZEFE6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 00:58:01 -0400
Date: Wed, 6 May 2009 06:52:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ptrace: ptrace_attach: check PF_KTHREAD +
	exit_state instead of ->mm
Message-ID: <20090506045241.GA26214@redhat.com>
References: <20090505224722.GA954@redhat.com> <20090506020223.A4F1AFC328@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506020223.A4F1AFC328@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05, Roland McGrath wrote:
>
> This changes the order of the already-traced and security checks.
> It would match the previous behavior to have the ->exit_state and ->ptrace
> checks before __ptrace_may_access().  This is a small nit, but it could
> affect whether some existing harmless usage pattern starts generating new
> access failure logging from security modules (e.g. SELinux avc denials).

Another subtle change I forgot to comment.

> I don't see any reason you can't just swap the order back as it was before.

The last patch in series, "do not use task_lock()", is the reason.

We need tasklist for writing to check (and set) ->ptrace, but we need
task_lock() to call __ptrace_may_access().

We can preserve the current behaviour, we can do get_task_mm() beforehand,
modify __ptrace_may_access() a bit, and call __ptrace_may_access() under
tasklist later (in fact, this was the very first version of this patch which
I didn't send).

But do we really care? If selinux denies to ptrace this task, can't we
return -EACESS regardless of ->ptrace?

Oleg.

