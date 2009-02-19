Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbZBSBqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbZBSBqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 20:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbZBSBqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 20:46:45 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:56441 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbZBSBqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 20:46:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HnFo1vmDBXPxBwQ/cabVD0zRNpSXdhW7yQ26plHpG1/jRd0OXTKFEipzpQKhmB0g1b
         Nja/cpmVKa8FUdtsFiqvLCMNb0jXrsyJmY+o4bmM4U5qgEJ2K4Dw4SWlhu+UMnD0JaYu
         lE9kv9Hlei7572HYEINB/FF8heUACsQ5St89s=
Date: Thu, 19 Feb 2009 02:46:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net, fche@redhat.com,
       compudj@krystal.dyndns.org
Subject: Re: [PATCH] new irq tracer
Message-ID: <20090219014638.GA5785@nowhere>
References: <20090218195328.GA3112@redhat.com> <1234991725.4799.1.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234991725.4799.1.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 10:15:25PM +0100, Peter Zijlstra wrote:
> On Wed, 2009-02-18 at 14:53 -0500, Jason Baron wrote:
> > hi,
> > 
> > Using a copule of tracepoints i've implemented an 'irq tracer' which has
> > the following column format:
> > 
> > [time][irq][action][handled][cpu][length]
> > 
> > for example on my system:
> > 
> > [ 1038.927248381]     28     eth0      1        3     0.000002745
> > [ 1038.927544688]     28     eth0      1        3     0.000002520
> > [ 1038.927593609]     28     eth0      1        3     0.000002509
> > [ 1038.974087675]     29     ahci      1        1     0.000013135
> > [ 1038.974288475]     29     ahci      1        1     0.000005542
> > [ 1038.974414324]     29     ahci      1        1     0.000007953
> > 
> > I think this patch is useful in understanding irq system behavior, and
> > for tracking down irq driver handlers that are firing too often or
> > spending too much time handling an irq. This approach could be extended
> > to the timer irq and for softirqs...
> 
> The function graph tracer can already do this, it has a special section
> to recognize irq entry function, and already measures time spend.


Right, except that it doesn't trace the irq number, action and the return value,
though the latter will be handled one day (probably soon).
 

> I guess with Steve's new triggers (probes or whatever they ended up
> being called) you could limit it to just IRQ entry points.


We already could trace only irq function call tree through set_graph_function:
echo smp_apic_timer_interrupt > set_graph_function
echo do_IRQ >> set_graph_function

But you will see the whole call graph:

  321.913057 |   1)               |      do_IRQ() {
  321.913058 |   1)   0.571 us    |        exit_idle();
  321.913059 |   1)               |        irq_enter() {
  321.913059 |   1)   0.548 us    |          rcu_irq_enter();
  321.913060 |   1)   0.533 us    |          idle_cpu();
  321.913064 |   1)   2.696 us    |        }
  321.913065 |   1)               |        handle_irq() {
  321.913065 |   1)   0.533 us    |          irq_to_desc();
  321.913067 |   1)               |          handle_edge_irq() {
  321.913067 |   1)   0.653 us    |            _spin_lock();
  321.913068 |   1)               |            ack_apic_edge() {
  321.913069 |   1)   0.533 us    |              irq_to_desc();
  321.913070 |   1)               |              move_native_irq() {
  321.913070 |   1)   0.525 us    |                irq_to_desc();
  321.913072 |   1)   1.577 us    |              }
  321.913072 |   1)   0.563 us    |              native_apic_mem_write();
  321.913073 |   1)   4.813 us    |            }
  321.913074 |   1)   0.601 us    |            _spin_unlock();
  321.913075 |   1)               |            handle_IRQ_event() {
  321.913075 |   1)               |              timer_interrupt() {
  321.913076 |   1)               |                tick_handle_oneshot_broadcast() {
  321.913077 |   1)   0.631 us    |                  _spin_lock();
  321.913078 |   1)               |                  ktime_get() {
  321.913078 |   1)               |                    ktime_get_ts() {
  321.913079 |   1)               |                      getnstimeofday() {
  321.913079 |   1)   1.735 us    |                        read_hpet();
  321.913082 |   1)   2.854 us    |                      }
  321.913082 |   1)   0.534 us    |                      set_normalized_timespec();
  321.913083 |   1)   4.963 us    |                    }
  321.913084 |   1)   6.015 us    |                  }
  321.913084 |   1)               |                  tick_do_broadcast() {
  321.913085 |   1)               |                    lapic_timer_broadcast() {
  321.913086 |   1)   0.624 us    |                      flat_send_IPI_mask();
  321.913087 |   1)   1.697 us    |                    }
  321.913087 |   1)   2.944 us    |                  }
  321.913088 |   1)   0.585 us    |                  _spin_unlock();
  321.913089 |   1) + 12.892 us   |                }
  321.913089 |   1) + 14.079 us   |              }
  321.913090 |   1) + 15.176 us   |            }
  321.913091 |   1)   0.540 us    |            note_interrupt();
  321.913092 |   1)   0.653 us    |            _spin_lock();
  321.913093 |   1)   0.586 us    |            _spin_unlock();
  321.913094 |   1) + 27.354 us   |          }
  321.913094 |   1) + 29.547 us   |        }
  321.913095 |   1)               |        irq_exit() {
  321.913096 |   1)   0.526 us    |          rcu_irq_exit();
  321.913097 |   1)   0.526 us    |          idle_cpu();
  321.913098 |   1)   2.674 us    |        }
  321.913098 |   1) + 41.096 us   |      }
  321.913098 |   1)   <========== |

Or you can only trace do_IRQ and smp_apic_timer_interrupt alone without tracing their
call tree:

echo smp_apic_timer_interrupt > set_ftrace_filter
echo do_IRQ >> set_ftrace_filter

