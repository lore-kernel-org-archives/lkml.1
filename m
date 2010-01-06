Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848Ab0AFKps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab0AFKps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 05:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755714Ab0AFKps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 05:45:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62006 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755676Ab0AFKpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 05:45:47 -0500
Message-ID: <4B446972.9050901@cn.fujitsu.com>
Date: Wed, 06 Jan 2010 18:44:02 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: tracing: confusing output of function_graph when notrace function
 calls traceable function
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cat <debugfs_dir>/tracing/trace
you can get these at the end of the outputs:

 1)               |        nameidata_to_filp() {
 1)               |          __dentry_open() {
 1)               |            file_move() {
 1)   0.834 us    |              _raw_spin_lock();
 1)   0.926 us    |              _raw_spin_unlock();
 1)   4.768 us    |            }

!!!! file_move() is really called by __dentry_open()

 1)               |            kmem_cache_alloc_notrace() {
 1)   5.879 us    |              memset();
 1) + 12.390 us   |            }
 1)   1.025 us    |            mutex_lock();
 1)               |            kmem_cache_alloc_notrace() {
 1)   0.929 us    |              memset();
 1)   3.329 us    |            }
 1)   1.195 us    |            memcpy();
 1)   1.026 us    |            __mutex_init();

!!!! the above are actually called by __tracing_open() which called by __dentry_open()
(But at the first I was confused, I wondered why __dentry_open() calls them.)

 1)               |            kmem_cache_alloc_notrace() {
 1)   0.978 us    |              memset();
 1)   2.745 us    |            }
 1)               |            __alloc_percpu() {
 1)               |              pcpu_alloc() {
 1)   1.053 us    |                mutex_lock();
 1)   1.282 us    |                _raw_spin_lock_irqsave();
 1)               |                pcpu_size_to_slot() {
 1)   0.819 us    |                  __pcpu_size_to_slot();
 1)   5.455 us    |                }
 1)   1.135 us    |                pcpu_need_to_extend();
 1)               |                pcpu_alloc_area() {
 1)               |                  pcpu_chunk_slot() {
 1)               |                    pcpu_size_to_slot() {
 1)   0.813 us    |                      __pcpu_size_to_slot();
 1)   2.535 us    |                    }
 1)   8.349 us    |                  }
 1)   1.160 us    |                  memmove();
 1)               |                  pcpu_chunk_relocate() {
 1)               |                    pcpu_chunk_slot() {
 1)               |                      pcpu_size_to_slot() {
 1)   0.803 us    |                        __pcpu_size_to_slot();
 1)   2.478 us    |                      }
 1)   4.129 us    |                    }
 1)   8.583 us    |                  }
 1) + 29.665 us   |                }
 1)   1.038 us    |                _raw_spin_unlock_irqrestore();
 1)   1.178 us    |                pcpu_next_pop();
 1)   1.087 us    |                pcpu_chunk_addr();
 1)   0.975 us    |                memset();
 1)   0.821 us    |                pcpu_chunk_addr();
 1)   0.943 us    |                memset();
 1)   0.896 us    |                mutex_unlock();
 1) + 75.625 us   |              }
 1) + 77.453 us   |            }

!!!! the above are actually called by graph_trace_open() which called by __tracing_open()

== real graph ==:

father_fun()
  child_fun()
  notrace_child_fun()
    grandchild_fun1()
    grandchild_fun2()

===function_graph shows===>

father_fun()
  child_fun()
  grandchild_fun1()
  grandchild_fun2()

When the notrace function calls traceable function, function_graph will
get wrong depth of functions, and show wrong graph.

Is there any method to fix it?

Lai
