Return-Path: <linux-kernel-owner+w=401wt.eu-S1755641AbZHZHkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbZHZHkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 03:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbZHZHkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 03:40:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:42265 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbZHZHku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 03:40:50 -0400
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
In-Reply-To: <4A94E4BA.1030208@cn.fujitsu.com>
References: <20090824092455.GA25267@elte.hu>
	 <1251106058.7538.149.camel@twins> <4A937505.5000209@cn.fujitsu.com>
	 <1251181266.7538.1016.camel@twins> <4A9385AA.508@cn.fujitsu.com>
	 <1251182405.7538.1050.camel@twins> <20090825090558.GC14003@elte.hu>
	 <1251191546.7538.1118.camel@twins> <20090825102215.GC26801@elte.hu>
	 <1251196359.7538.1133.camel@twins>  <20090825103907.GB28287@elte.hu>
	 <1251197235.7538.1142.camel@twins> <1251211963.7538.1164.camel@twins>
	 <4A94D3A8.1090902@cn.fujitsu.com>  <1251269207.7538.1217.camel@twins>
	 <1251270092.7538.1226.camel@twins>  <4A94DFF4.5030301@cn.fujitsu.com>
	 <1251271588.7538.1235.camel@twins>  <4A94E4BA.1030208@cn.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Aug 2009 09:39:45 +0200
Message-Id: <1251272385.7538.1238.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 15:31 +0800, Li Zefan wrote:
> 15:26, Peter Zijlstra wrote:
> > On Wed, 2009-08-26 at 15:10 +0800, Li Zefan wrote:
> >> Peter Zijlstra wrote:
> >>> On Wed, 2009-08-26 at 08:46 +0200, Peter Zijlstra wrote:
> >>>
> >>>> Aahh, I see the bug, its only ftrace that knows about the module, not
> >>>> tracepoints themselves, _that_ needs fixing.
> >>> You could possibly do something like:
> >>>
> >>>  struct module *tp_mod = __module_address(&some_tp_symbol);
> >>>  struct module *cb_mod = __module_text_address(func);
> >>>
> >>>  if (tp_mod && tp_mod != cb_mod) {
> >>> 	ret = try_get_module(tp_mod);
> >>> 	if (ret)
> >>> 		goto fail;
> >>>  }
> >>>
> >>> in register_trace_##name() or thereabout.
> >>>
> >> Actually I tried it, but it didn't work. As I said, You can't find
> >> any tp symbol when registering tp callback. The same example again:
> >>
> >> 	In module bar, we have register_trace_foo()
> >> 	In module foo, we have DEFINE_TRACE(foo) and trace_foo().
> >>
> >> bar doesn't know any symbol of foo, so it can't bump foo's refcnt,
> > 
> > Well, clearly it knows about register_trace_foo() which itself knows at
> > least one symbol that should be in module foo, right? How else could it
> > register a callback in that module (if it were loaded)?
> > 
> > It appears to use some intermediate code, in which case the intermediate
> > code knows about foo, which too solves our problem.
> > 
> >> *Note: you can load module bar without loading module foo*
> > 
> > In which case the tracepoint registration fails, right?
> > 
> 
> No, it won't fail. ;)
> 
> Instead, when foo is loaded, tracepoint_update_probe_range() will be
> called, and the probe registered in bar will be added to the tracepoint.

*blink*

so we'll succeed in registering a tracepoint we know isn't there?
