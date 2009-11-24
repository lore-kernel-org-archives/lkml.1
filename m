Return-Path: <linux-kernel-owner+w=401wt.eu-S934352AbZKXWxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934352AbZKXWxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 17:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934329AbZKXWxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 17:53:41 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:23070 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934328AbZKXWxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 17:53:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dfow5ZjTyUGBMq6365vgZgK4PUUlpGaMoxfZnI6ORTBqbH/Km2zRqVzmLGZ3YKxW1j
         4wBrMqDqAnnCFZPkKRQ5247nN4hC4V5YUTOIv/uj2vuwicjLhQo5vbl08wxNwC/enSn/
         u95jCzu11gYnUgnC3OSozguD+2nsfi1HRxnvw=
Date: Tue, 24 Nov 2009 23:53:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing - fix function graph trace to properly display
	failed entries
Message-ID: <20091124225342.GB5208@nowhere>
References: <1259067458-27143-1-git-send-email-jolsa@redhat.com> <1259082845.22249.1110.camel@gandalf.stny.rr.com> <20091124211423.GE5071@nowhere> <20091124221748.GA5208@nowhere> <1259101602.22249.1122.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259101602.22249.1122.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 05:26:42PM -0500, Steven Rostedt wrote:
> > But it happens with trace_pipe reading.
> 
> Yep, but I think we should be able to handle it without modifying
> trace_seq.



Yeah. I guess now that the bug window is isolated to the
trace_pipe case, the fix will probably (hopefully) be easier.


 
> > 
> > There is another bug. Here is a sample from
> > trace reading:
> > 
> >  0)               |  sys_newfstat() {
> >  0)               |    vfs_fstat() {
> >  0)   1.187 us    |      fget();
> >  0)               |      vfs_getattr() {
> >  0)               |        security_inode_getattr() {
> >  0)   0.608 us    |              }
> >  0)   2.951 us    |            }
> >  0) + 65.349 us   |          }
> >  0)               |          path_put() {
> >  0)   0.608 us    |            dput();
> >  0)   0.548 us    |            mntput_no_expire();
> >  0)   2.748 us    |          }
> >  0) + 74.472 us   |        }
> > 
> > 
> > I think we are loosing some traces here, between security_inode_getattr()
> > and path_put().
> 
> Sure the buffer didn't just wrap there? Is this a trace_pipe output?


No it didn't wrapped, and it's trace output, not trace_pipe.


> Also note, with the reader page of the ring buffer there could also be
> another symptom. Once the writer is off the reader page, it will never
> come back on it (unless a reader swaps where the writer is, but that
> only happens on a lightly filled buffer).
> 
> Thus, even if we freeze recording, when the reader finishes its reader
> page and goes off into the main buffer, there may be a gap between the
> last read and the next (main buffer) due to the writer wrapping it.



You mean the writer could have eaten what we are supposed to read next?
Yeah that could explain the problem.



> If you are using the trace_pipe while the function tracer is on, you
> will probably see this a lot.


That's perhaps the problem. I was tracing while reading (too lazy
to echo 0 > tracing_on)


> > 
> > I'm not sure why. The problem related by Olsa would explain such
> > symptoms, and what olsa reported is a real bug, but only
> > in trace_pipe. There is also something else, probably more
> > related to the fast path.
> 
> Are you looking at this while the function_graph tracer is running? Or
> do you disable tracing (tracing_on = 0)


Yeah it is running.
But I just tried after setting tracing_on to 0 and I found that:


 0)               |          raw_notifier_call_chain() {
 0)               |            tick_notify() {
 0)               |              tick_broadcast_oneshot_control() {
 0)   2.072 us    |                _spin_lock_irqsave();
 0)               |                clockevents_set_mode() {
 0)               |                  lapic_timer_setup() {
 0)   0.976 us    |                    native_apic_mem_read();
 0)   2.223 us    |                    native_apic_mem_write();
 0)   0.946 us    |                    native_apic_mem_write();
 0)   7.959 us    |                  }
 0)   9.844 us    |                }
 0) + 46.074 us   |      }
 0) ! 172.995 us  |    }
 0)   1.178 us    |    menu_reflect();
 0) ! 190.040 us  |  }

The whole trace looks globally reliable but there is this little
corner case. Looks like we are loosing some return entries.

Or that:

 0)               |                clockevents_set_mode() {
 0)               |                  lapic_timer_setup() {
 0)               |                    __setup_APIC_LVTT() {
 0)   0.946 us    |                      native_apic_mem_write();
 0)   0.969 us    |                      native_apic_mem_read();
 0)               |                      native_apic_mem_write() {
 0)   6.487 us    |                    }
 0)   1.096 us    |                    }
 0)   0.946 us    |                    native_apic_mem_write();
 0)   6.781 us    |                  }
 0)   8.657 

This one looks more strange. As if the return trace of
native_apic_mem_write() had a wrong depth.

Sometimes also the depth seems to go too far:

 0)               |    acpi_idle_enter_simple() {
 0)   1.900 us    |                _spin_lock_irqsave();
 0)               |                clockevents_set_mode() {
 0)               |                  lapic_timer_setup() {
 0)               |                    __setup_APIC_LVTT() {
 0)   0.939 us    |                      native_apic_mem_write();
 0)   0.939 us    |                      native_apic_mem_read();
 0)   1.164 us    |                      native_apic_mem_write();
 0)   6.706 us    |                    }
 0)   8.725 us    |                  }
 0) + 10.737 us   |                }
 0)               |        


And to finish, a special gift :-)

 0)               |            tick_notify() {
 0)               |              tick_broadcast_oneshot_control() {
 0)   1.855 us    |                _spin_lock_irqsave();
 0)               |                clockevents_set_mode() {
 0)               |                  lapic_timer_setup() {
 0)               |                    __setup_APIC_LVTT() {
 0)   0.894 us    |                      native_apic_mem_write();
 0)   0.939 us    |                      native_apic_mem_read();
 0)   0.901 us    |                      native_apic_mem_write();
 0)   6.503 us    |                    }
 0)   8.463 us    |                  }
 0)   0.938 us    |                    }
 0)   6.652 us    |                  }
 0)   8.515 us    |                }
 0)   1.637 us    |                _spin_unlock_irqrestore();
 0) + 15.904 us   |              }
 0) + 17.78


I'll try to fix these issues...

