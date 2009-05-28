Return-Path: <linux-kernel-owner+w=401wt.eu-S1762541AbZE1VQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762541AbZE1VQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 17:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758511AbZE1VQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 17:16:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755852AbZE1VQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 17:16:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/12 v2] ptrace: introduce the empty "struct
	ptrace_context"
In-Reply-To: Oleg Nesterov's message of  Thursday, 28 May 2009 13:35:45 +0200 <20090528113545.GA18691@redhat.com>
References: <20090528113545.GA18691@redhat.com>
X-Windows: the problem for your problem.
Message-Id: <20090528211540.2A5BAFC2BD@magilla.sf.frob.com>
Date: Thu, 28 May 2009 14:15:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	task_lock(tsk);
> +	if (likely(!tsk->ptrace_ctx))
> +		tsk->ptrace_ctx = ptrace_ctx;
> +	else
> +		kfree(ptrace_ctx);
> +	task_unlock(tsk);

I don't think it's kosher call kfree with task_lock() held.
The kfree case is a very unlikely path, so it can be:

	task_lock(tsk);
	if (likely(!tsk->ptrace_ctx)) {
		tsk->ptrace_ctx = ptrace_ctx;
		task_unlock(tsk);
		return 0;
	}

	task_unlock(tsk);
	kfree(ptrace_ctx);

Thanks,
Roland
