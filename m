Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbYKEA4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbYKEA4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 19:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYKEA4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 19:56:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56873 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbYKEA4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 19:56:41 -0500
Message-ID: <4910EE95.9000802@cn.fujitsu.com>
Date: Wed, 05 Nov 2008 08:53:41 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: ananth@in.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, mhiramat@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kprobes: disable preempt for module_text_address()
References: <490FE405.1000105@cn.fujitsu.com> <20081104142824.GA24326@in.ibm.com>
In-Reply-To: <20081104142824.GA24326@in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ananth N Mavinakayanahalli wrote:
> On Tue, Nov 04, 2008 at 01:56:21PM +0800, Lai Jiangshan wrote:
>> __register_kprobe() may be preempted after module_text_address()
>> but before try_module_get(), and in this interval the module may be
>> unloaded and try_module_get(probed_mod) will access to invalid address.
>> this patch uses preempt_disable() to protect it.
> 
> Looking at other users of try_module_get, I don't see this as a usage
> model being followed elsewhere. Also, in case such a preemption does
> happen, module_is_live() will fail and we should still be ok.

when preemption happen, and mod is freed, module_is_live() will access to
invalid address. So it's NOT OK.

Other users of try_module_get() are correct. most are like this:

void func(XXX, XXXX)
{
	try_module_get(XXX->owner)
}

Because we have had a reference to the module before calling try_module_get().
this means the module is still in the kernel when try_module_get() called.
so we do not need any protection for using try_module_get().
<in other word, caller of func() has made sure the module will not be unloaded>

In this function __register_kprobe(), probed_mod is the return value of
module_text_address(), probed_mod will go in any time before try_module_get().

> 
> I don't see a reason for this patch unless there is a clear failure case
> (register_kprobe failing 'cos of a module unload is perfectly ok).
> 
> Ananth
> 




