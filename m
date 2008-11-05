Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbYKEBus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbYKEBus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 20:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbYKEBuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 20:50:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60511 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754171AbYKEBuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 20:50:39 -0500
Message-ID: <4910FB3D.4020805@cn.fujitsu.com>
Date: Wed, 05 Nov 2008 09:47:41 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, ananth@in.ibm.com,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] kprobes: disable preempt for module_text_address()
References: <490FE405.1000105@cn.fujitsu.com> <4910F697.2050203@redhat.com>
In-Reply-To: <4910F697.2050203@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Hi Lai,
> 
> Lai Jiangshan wrote:
>> __register_kprobe() may be preempted after module_text_address()
>> but before try_module_get(), and in this interval the module may be
>> unloaded and try_module_get(probed_mod) will access to invalid address.
>> this patch uses preempt_disable() to protect it.
> 
> Thank you for your work.
> 
> I think this is the problem of module_text_address() because it can
> return incorrect address of struct module if a preemption happens.
> So, I think the module_text_address() would better to call try_module_get()
> before returning its address, or at least they should comment that caller
> needs disabling preemption.
> 
> struct module *module_text_address(unsigned long addr)
> {
> 	struct module *mod;
> 
> 	preempt_disable(); /*
> 			    * I also think this preemption disabling is not so useful
> 			    * without try_module_get(), because caller have to
> 			    * disable preemption...
> 			    */
> 	mod = __module_text_address(addr);
> 	/* here, try_module_get() is needed.
> 	 * (or commenting "caller must disable preemption!") */
> 	preempt_enable();
> 
> 	/*
> 	 * !!Here!! if the preemption happened, it could return invalid "mod".
>          * In that case, even if module_text_address() returns non-NULL,
> 	 * the addr is no longer in any module.
> 	 */
> 	return mod;
> }
> 
> Thank you,
> 

I don't think module_text_address() are needed to modified.
only __register_kprobe() uses module_text_address()'s return value.
other users of module_text_address() are just for testing it's
return value. so only __register_kprobe() needs disabling preemption
currently.

actually, calling __module_text_address() in __register_kprobe() is
better after my fix applied. but I found that a line have exceed
80 characters, so I don't use __module_text_address().

Thanx, Lai



