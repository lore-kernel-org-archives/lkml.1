Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbYJHDxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbYJHDxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 23:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbYJHDx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 23:53:27 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:48473 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750888AbYJHDx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 23:53:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AowFAI7H60hMQWq+/2dsb2JhbACBcrxRgWo
Date: Tue, 7 Oct 2008 23:53:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] markers: remove 2 exported symbols
Message-ID: <20081008035325.GA31788@Krystal>
References: <48EC199D.40808@cn.fujitsu.com> <20081008024325.GA29227@Krystal> <48EC2377.6020706@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48EC2377.6020706@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:51:02 up 125 days,  8:31,  9 users,  load average: 0.33, 0.30,
	0.29
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> Mathieu Desnoyers wrote:
> > * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> >> __mark_empty_function() and marker_probe_cb_noarg()
> >> should not be seen by outer code. this patch remove them.
> >>
> >> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> >> ---
> >> diff --git a/include/linux/marker.h b/include/linux/marker.h
> >> index 1290653..f4d4d28 100644
> >> --- a/include/linux/marker.h
> >> +++ b/include/linux/marker.h
> >> @@ -132,12 +132,8 @@ static inline void __printf(1, 2) ___mark_check_format(const char *fmt, ...)
> >>  			___mark_check_format(format, ## args);		\
> >>  	} while (0)
> >>  
> >> -extern marker_probe_func __mark_empty_function;
> >> -
> > 
> > Hi Lai,
> > 
> > Hrm ? Have a good look at the macro __trace_mark() in
> > include/linux/marker.h, you'll see that __mark_empty_function is
> > referenced. Have you tested this against code with declared markers ?
> 
> Sorry for this,
> I have markers in my kernel test code.
> I hasn't tested this patch, for I thought it's to simple.
> I used "grep" to find "__mark_empty_function",
> but I missed one line of the results.
> 
> Other problems:
> 1)
> why we need marker_probe_cb_noarg()?
> marker_probe_cb_noarg() has no performance optimization,
> and no additional format check, or other thing?
> 

marker_probe_cb_noarg() does not need to setup the variable arguments,
because the format string explicitly contains the MARK_NOARGS string. So
this is a performance optimization.

> if we remove marker_probe_cb_noarg, we can remove struct marker.call also.
> 
> 2)
> why we use va_list *?
> As I know, sizeof(va_list) = 4 or 8.
> 

It becomes hellish when we want to pass it as parameter to another C
function, because va_list is typedef'd as an array on some
architectures, and the array gets propoted to a pointer type, which is
in turn incompatible with the array. C language mess :-( Not much we can
do about it.

Mathieu

> 
> please ignore this patch.
> 
> Thanks, Lai.
> 
> > 
> >>  extern void marker_probe_cb(const struct marker *mdata,
> >>  	void *call_private, ...);
> >> -extern void marker_probe_cb_noarg(const struct marker *mdata,
> >> -	void *call_private, ...);
> > 
> > This second change is correct. marker_probe_cb is referenced by
> > __trace_mark(), but not marker_probe_cb_noarg, which is only connected
> > when non-empty format string is found by the registration function in
> > marker.c.
> > 
> >>  
> >>  /*
> >>   * Connect a probe to a marker.
> >> diff --git a/kernel/marker.c b/kernel/marker.c
> >> index 7d1faec..4440a09 100644
> >> --- a/kernel/marker.c
> >> +++ b/kernel/marker.c
> >> @@ -81,11 +81,10 @@ static struct hlist_head marker_table[MARKER_TABLE_SIZE];
> >>   * though the function pointer change and the marker enabling are two distinct
> >>   * operations that modifies the execution flow of preemptible code.
> >>   */
> >> -void __mark_empty_function(void *probe_private, void *call_private,
> >> +static void __mark_empty_function(void *probe_private, void *call_private,
> >>  	const char *fmt, va_list *args)
> >>  {
> >>  }
> >> -EXPORT_SYMBOL_GPL(__mark_empty_function);
> >>  
> > 
> > Same as comment above.
> > 
> >>  /*
> >>   * marker_probe_cb Callback that prepares the variable argument list for probes.
> >> @@ -157,7 +156,7 @@ EXPORT_SYMBOL_GPL(marker_probe_cb);
> >>   *
> >>   * Should be connected to markers "MARK_NOARGS".
> >>   */
> >> -void marker_probe_cb_noarg(const struct marker *mdata, void *call_private, ...)
> >> +static void marker_probe_cb_noarg(const struct marker *mdata, void *call_private, ...)
> >>  {
> >>  	va_list args;	/* not initialized */
> >>  	char ptype;
> >> @@ -197,7 +196,6 @@ void marker_probe_cb_noarg(const struct marker *mdata, void *call_private, ...)
> >>  	}
> >>  	preempt_enable();
> >>  }
> >> -EXPORT_SYMBOL_GPL(marker_probe_cb_noarg);
> >>  
> > 
> > This one is ok.
> > 
> > So overall, if you could check why you have not hit any problem when
> > removing __mark_empty_function, that would be great. The only reason I
> > see is that you had no markers in your kernel test code.
> > 
> > Mathieu
> > 
> >>  static void free_old_closure(struct rcu_head *head)
> >>  {
> >>
> >>
> >>
> > 
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
