Return-Path: <linux-kernel-owner+w=401wt.eu-S1759439AbZCSHUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439AbZCSHUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 03:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbZCSHUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 03:20:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64174 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbZCSHUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 03:20:41 -0400
Message-ID: <49C1F1DF.2020105@cn.fujitsu.com>
Date: Thu, 19 Mar 2009 15:18:55 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: oops in tracepoint_update_probe_range()
References: <1237393396.3322.6.camel@localhost.localdomain> <20090318163531.GE21331@elte.hu>
In-Reply-To: <20090318163531.GE21331@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
>> Good: f4c3c4cdb1de232
>> Bad : 1e08816af0bc345
>>
>> Config:
>> http://userweb.kernel.org/~jaswinder/oops_20090318/config-hpdv5-tip-bad-20090318
>>
>> oops:
>> http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page1.jpg
>> http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page2.jpg
>> http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page3.jpg
>> http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page4.jpg
>>
>> <freeze>
> 
> Steve, Frederic - the crashes above are in:
> 
> 	tracepoint_update_probe_range()
> 
> in a modular kernel apparently.
> 
>

I look up the jpg files, this oops is occurred when a new module is
being loaded.

tracepoint_module_notify() is added by Mathieu Desnoyers on the
suggestion of me.

tracepoint_update_probe_range() and tracepoint_module_notify()
can not trigger this oops if the arguments are correct.

If @begin is NULL, @end is NULL too, it's ensued by kernel/module.c.

load_module(...):
	mod->tracepoints = section_objs(hdr, sechdrs, secstrings,
					"__tracepoints",
					sizeof(*mod->tracepoints),
					&mod->num_tracepoints);
static void *section_objs(...)
{
	unsigned int sec = find_sec(hdr, sechdrs, secstrings, name);

	/* Section 0 has sh_addr 0 and sh_size 0. */
	*num = sechdrs[sec].sh_size / object_size;
	return (void *)sechdrs[sec].sh_addr;
}

If the module has not "__tracepoints" section, find_sec() returns 0.
So I think, sechdrs[0].sh_size is corrupted.

Is the following fix fixed the oops for you?
---
diff --git a/kernel/module.c b/kernel/module.c
index 7fa134e..2ee47ff 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1950,6 +1950,7 @@ static noinline struct module *load_module(void __user *umod,
 	sechdrs = (void *)hdr + hdr->e_shoff;
 	secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
 	sechdrs[0].sh_addr = 0;
+	sechdrs[0].sh_size = 0;
 
 	for (i = 1; i < hdr->e_shnum; i++) {
 		if (sechdrs[i].sh_type != SHT_NOBITS


