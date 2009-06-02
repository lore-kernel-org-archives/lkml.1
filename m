Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbZFBE4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbZFBE4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 00:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbZFBE4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 00:56:05 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:37134 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbZFBE4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 00:56:03 -0400
Date: Mon, 1 Jun 2009 21:54:18 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace: do_notify_parent_cldstop: fix the wrong
	->nsproxy usage
Message-ID: <20090602045418.GB8219@us.ibm.com>
References: <20090525185502.GA20781@redhat.com> <20090526210514.C1C91FC2BD@magilla.sf.frob.com> <20090526213346.GA7073@redhat.com> <20090527005527.B50B7FC36B@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527005527.B50B7FC36B@magilla.sf.frob.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath [roland@redhat.com] wrote:
| > Yes. Perhaps it would be nice to add a helper,
| 
| I agree.
| 
| > > sys_kill, do_tkill all look wrong to me.
| > 
| > They should be fine, note the
| > 
| > 	if (from_ancestor_ns)
| > 		q->info.si_pid = 0;
| > 
| > in __send_signal(). If we send the signal "down" to the sub-namespace,
| > si_pid == 0 is correct. And, unlike do_notify_parent/ptrace_notify/etc
| > kill/tkill can't send the signal "up".
| 
| Ah, right.  I knew there was something around this I was forgetting.

Setting si_pid to task_tgid_vnr(current); in places like do_tkill() is
slightly misleading bc, it can get modified later in send_signal().  We
can't set si_pid correctly in do_tkill() since we must first establish
pid-namespace relationship and that can mess up control flow.

Maybe a comment will help.
