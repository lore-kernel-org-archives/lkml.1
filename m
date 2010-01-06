Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875Ab0AFPQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab0AFPQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 10:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842Ab0AFPQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 10:16:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52891 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab0AFPQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 10:16:40 -0500
X-Authority-Analysis: v=1.0 c=1 a=BBXzeBQ_xvQA:10 a=7U3hwN5JcxgA:10 a=hkq_raiZbRIyoCAuYh8A:9 a=XCjQtoGoEfdIsqUV3DilaLtmue8A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: tracing: confusing output of function_graph when notrace
 function calls traceable function
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiri Olsa <jolsa@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100106130806.GA7682@jolsa.lab.eng.brq.redhat.com>
References: <4B446972.9050901@cn.fujitsu.com>
	 <20100106130806.GA7682@jolsa.lab.eng.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 06 Jan 2010 10:16:37 -0500
Message-ID: <1262790997.28171.2865.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-06 at 14:08 +0100, Jiri Olsa wrote:
> On Wed, Jan 06, 2010 at 06:44:02PM +0800, Lai Jiangshan wrote:
> > cat <debugfs_dir>/tracing/trace
> > you can get these at the end of the outputs:
> > 
> >  1)               |        nameidata_to_filp() {
> >  1)               |          __dentry_open() {
> >  1)               |            file_move() {
> >  1)   0.834 us    |              _raw_spin_lock();
> >  1)   0.926 us    |              _raw_spin_unlock();
> >  1)   4.768 us    |            }
> > 
> > !!!! file_move() is really called by __dentry_open()

?? And that is exactly what the above shows.

> > 
> >  1)               |            kmem_cache_alloc_notrace() {
> >  1)   5.879 us    |              memset();
> >  1) + 12.390 us   |            }
> >  1)   1.025 us    |            mutex_lock();
> >  1)               |            kmem_cache_alloc_notrace() {
> >  1)   0.929 us    |              memset();
> >  1)   3.329 us    |            }
> >  1)   1.195 us    |            memcpy();
> >  1)   1.026 us    |            __mutex_init();
> > 
> > !!!! the above are actually called by __tracing_open() which called by __dentry_open()
> > (But at the first I was confused, I wondered why __dentry_open() calls them.)
> > 
> >  1)               |            kmem_cache_alloc_notrace() {
> >  1)   0.978 us    |              memset();
> >  1)   2.745 us    |            }
> >  1)               |            __alloc_percpu() {
> >  1)               |              pcpu_alloc() {
> >  1)   1.053 us    |                mutex_lock();
> >  1)   1.282 us    |                _raw_spin_lock_irqsave();
> >  1)               |                pcpu_size_to_slot() {
> >  1)   0.819 us    |                  __pcpu_size_to_slot();
> >  1)   5.455 us    |                }
> >  1)   1.135 us    |                pcpu_need_to_extend();
> >  1)               |                pcpu_alloc_area() {
> >  1)               |                  pcpu_chunk_slot() {
> >  1)               |                    pcpu_size_to_slot() {
> >  1)   0.813 us    |                      __pcpu_size_to_slot();
> >  1)   2.535 us    |                    }
> >  1)   8.349 us    |                  }
> >  1)   1.160 us    |                  memmove();
> >  1)               |                  pcpu_chunk_relocate() {
> >  1)               |                    pcpu_chunk_slot() {
> >  1)               |                      pcpu_size_to_slot() {
> >  1)   0.803 us    |                        __pcpu_size_to_slot();
> >  1)   2.478 us    |                      }
> >  1)   4.129 us    |                    }
> >  1)   8.583 us    |                  }
> >  1) + 29.665 us   |                }
> >  1)   1.038 us    |                _raw_spin_unlock_irqrestore();
> >  1)   1.178 us    |                pcpu_next_pop();
> >  1)   1.087 us    |                pcpu_chunk_addr();
> >  1)   0.975 us    |                memset();
> >  1)   0.821 us    |                pcpu_chunk_addr();
> >  1)   0.943 us    |                memset();
> >  1)   0.896 us    |                mutex_unlock();
> >  1) + 75.625 us   |              }
> >  1) + 77.453 us   |            }
> > 
> > !!!! the above are actually called by graph_trace_open() which called by __tracing_open()
> > 
> > == real graph ==:
> > 
> > father_fun()
> >   child_fun()
> >   notrace_child_fun()
> >     grandchild_fun1()
> >     grandchild_fun2()
> > 
> > ===function_graph shows===>
> > 
> > father_fun()
> >   child_fun()
> >   grandchild_fun1()
> >   grandchild_fun2()
> > 
> > When the notrace function calls traceable function, function_graph will
> > get wrong depth of functions, and show wrong graph.
> > 
> > Is there any method to fix it?
> I dont think so..
>
> AFAIK the depth computation is based on the traced functions, and there's
> no other 'depth related' input apart from them.

Right.


Honestly, if you think about it, the "father_fun()" does call those
grandchild_fun() functions. Just indirectly. I don't find anything wrong
with this.

You get the same issue if gcc decides to inline a function, since those
inlined functions don't get traced either.

-- Steve


