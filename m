Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535Ab0CNQ6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 12:58:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35111 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab0CNQ6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 12:58:42 -0400
X-Authority-Analysis: v=1.0 c=1 a=pnHbx7LlBzgA:10 a=IkcTkHD0fZMA:10 a=zUv7YOsU7YJl4P8mGsMA:9 a=oWdcjAXW-CPajTmz0ub4ldDtab4A:4 a=QEXdDO2ut3YA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 5/5] tracing: Do not record user stack trace from NMI
 context
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       stable@kernel.org
In-Reply-To: <20100314102747.GB5140@nowhere>
References: <20100313025655.104950166@goodmis.org>
	 <20100313025855.495916344@goodmis.org>  <20100314102747.GB5140@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Mar 2010 12:58:40 -0400
Message-ID: <1268585920.13400.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-14 at 11:27 +0100, Frederic Weisbecker wrote:

> 
> Wow, that's a race :)
> 
> In perf this is dealt with a special copy_from_user_nmi()
> (see in arch/x86/kernel/cpu/perf_event.c)
> 
> May be save_stack_trace_user() should use that instead
> of a __copy_from_user_inatomic() based thing, just to
> cover such NMI corner race case.
> 

Yeah, we should move the __copy_from_user_nmi() out of the perf code and
into the normal uaccess code. Then we could do as you suggest, and have
the stack code do:

if (in_nmi())
	__copy_from_user_nmi();
else
	__copy_from_user_inatomic();

Or maybe it would be best to have the __copy_from_user_inatomic() handle
it.

-- Steve



