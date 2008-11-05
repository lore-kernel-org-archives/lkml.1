Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYKEB30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYKEB30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 20:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYKEB3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 20:29:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47220 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbYKEB3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 20:29:16 -0500
Message-ID: <4910F697.2050203@redhat.com>
Date: Tue, 04 Nov 2008 20:27:51 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, ananth@in.ibm.com,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] kprobes: disable preempt for module_text_address()
References: <490FE405.1000105@cn.fujitsu.com>
In-Reply-To: <490FE405.1000105@cn.fujitsu.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lai,

Lai Jiangshan wrote:
> __register_kprobe() may be preempted after module_text_address()
> but before try_module_get(), and in this interval the module may be
> unloaded and try_module_get(probed_mod) will access to invalid address.
> this patch uses preempt_disable() to protect it.

Thank you for your work.

I think this is the problem of module_text_address() because it can
return incorrect address of struct module if a preemption happens.
So, I think the module_text_address() would better to call try_module_get()
before returning its address, or at least they should comment that caller
needs disabling preemption.

struct module *module_text_address(unsigned long addr)
{
	struct module *mod;

	preempt_disable(); /*
			    * I also think this preemption disabling is not so useful
			    * without try_module_get(), because caller have to
			    * disable preemption...
			    */
	mod = __module_text_address(addr);
	/* here, try_module_get() is needed.
	 * (or commenting "caller must disable preemption!") */
	preempt_enable();

	/*
	 * !!Here!! if the preemption happened, it could return invalid "mod".
         * In that case, even if module_text_address() returns non-NULL,
	 * the addr is no longer in any module.
	 */
	return mod;
}

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

