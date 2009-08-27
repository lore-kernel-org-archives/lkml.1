Return-Path: <linux-kernel-owner+w=401wt.eu-S1752926AbZH0QkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbZH0QkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 12:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZH0QkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 12:40:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38609 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbZH0QkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 12:40:13 -0400
Date: Thu, 27 Aug 2009 18:40:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <gregory.haskins@gmail.com>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: FTRACE: regression in 31-rc7
Message-ID: <20090827164007.GA30679@elte.hu>
References: <4A96B55C.10001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A96B55C.10001@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gregory Haskins <gregory.haskins@gmail.com> wrote:

> Hi Steve,
> 
> I just moved from -rc6 to -rc7, and I noticed that the 
> function-graph tracer suddenly stopped working properly: I do not 
> see any output from seeming most things except a handful of 
> interrupt related events.  I currently believe it may be an issue 
> with tracing modules.
> 
> I haven't had a chance to bisect yet, but I did confirm that 
> reverting the -rc7 merge restores the previous tracer behavior.  
> Any help/pointers appreciated.

Works fine here (using -rc7 based -tip):

 11)               |  sys_munmap() {
 11)               |    profile_munmap() {
 11)               |      blocking_notifier_call_chain() {
 11)   0.170 us    |        __blocking_notifier_call_chain();
 11)   0.480 us    |      }
 11)   0.799 us    |    }
 11)               |    down_write() {
 11)   0.146 us    |      _cond_resched();
 11)   0.146 us    |      _spin_lock_irq();
 11)   0.754 us    |    }
 11)               |    do_munmap() {
 11)   0.144 us    |      test_ti_thread_flag();
 11)   0.144 us    |      test_ti_thread_flag();
 11)   0.164 us    |      find_vma();
 11)   0.156 us    |      arch_unmap_area_topdown();
 11)               |      unmap_region() {
 11)               |        lru_add_drain() {
 11)               |          ____pagevec_lru_add() {
 11)   0.153 us    |            _spin_lock_irq();
 11)   0.145 us    |            __inc_zone_state();
 11)               |            __inc_zone_state() {
 11)   0.144 us    |            __inc_zone_state();
 11)   0.146 us    |            __inc_zone_state();
 11)   0.145 us    |            __inc_zone_state();
 11)   0.223 us    |            release_pages();
 11)   2.463 us    |          }
 11)   2.795 us    |        }
 11)               |        unmap_vmas() {
 11)               |          unmap_page_range() {
 11)   0.144 us    |            pgd_none_or_clear_bad();
 11)   0.145 us    |            pud_none_or_clear_bad();
 11)   0.154 us    |            pmd_none_or_clear_bad();
 11)               |            zap_pte_range() {
 11)   0.145 us    |              _spin_lock();
 11)   0.168 us    |              vm_normal_page();
 11)   0.143 us    |              mark_page_accessed();
 11)               |              page_remove_rmap() {
 11)               |                __dec_zone_page_state() {
 11)   0.150 us    |                  __dec_zone_state();
 11)   0.441 us    |                }
 11)   0.748 us    |              }
 11)   0.149 us    |              vm_normal_page();
 11)   0.146 us    |              mark_page_accessed();
 11)               |              page_remove_rmap() {
 11)               |                __dec_zone_page_state() {
 11)   0.148 us    |                  __dec_zone_state();
 11)   0.439 us    |                }
 11)   0.748 us    |              }
 11)   0.144 us    |              vm_normal_page();
 11)   0.148 us    |              mark_page_accessed();
 11)               |              page_remove_rmap() {
 11)               |                __dec_zone_page_state() {
 11)   0.148 us    |                  __dec_zone_state();
 11)   0.438 us    |                }
 11)   0.731 us    |              }
 11)   0.144 us    |              vm_normal_page();
 11)   0.146 us    |              mark_page_accessed();
 11)               |              page_remove_rmap() {
 11)               |                __dec_zone_page_state() {
 11)   0.146 us    |                  __dec_zone_state();
 11)   0.437 us    |                }
 11)   0.733 us    |              }
 11)   0.143 us    |              vm_normal_page();
 11)   0.148 us    |              mark_page_accessed();
 11)               |              page_remove_rmap() {
 11)               |                __dec_zone_page_state() {
 11)   0.147 us    |                  __dec_zone_state();
 11)   0.438 us    |                }
 11)   0.731 us    |              }
 11)   0.144 us    |              vm_normal_page();
 11)   0.146 us    |              mark_page_accessed();
 11)               |              page_remove_rmap() {
 11)               |                __dec_zone_page_state() {
 11)   0.146 us    |                  __dec_zone_state();
 11)   0.436 us    |                }
 11)   0.732 us    |              }
 11)   0.143 us    |              vm_normal_page();
 11)   0.146 us    |              mark_page_accessed();
 11)               |              page_remove_rmap() {
 11)               |                __dec_zone_page_state() {
 11)   0.147 us    |                  __dec_zone_state();
 11)   0.435 us    |                }
 11)   0.751 us    |              }
 11)   0.142 us    |              vm_normal_page();
 11)   0.146 us    |              mark_page_accessed();
 11)               |              page_remove_rmap() {
 11)               |                __dec_zone_page_state() {
 11)   0.146 us    |                  __dec_zone_state();
 11)   0.438 us    |                }
 11)   0.733 us    |              }
 11)   0.143 us    |              vm_normal_page();
 11)   0.145 us    |              mark_page_accessed();
 11)               |              page_remove_rmap() {
 11)               |                __dec_zone_page_state() {
 11)   0.145 us    |                  __dec_zone_state();
 11)   0.434 us    |                }
 11)   0.731 us    |              }
 11) + 14.220 us   |            }
 11) + 15.442 us   |          }
 11) + 15.750 us   |        }
 11)               |        free_pgtables() {

so it would be nice if you sent a config and a precise description 
of what you did to see the weirdness - in case others have trouble 
reproducing it as well.

	Ingo
