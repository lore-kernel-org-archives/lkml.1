Return-Path: <linux-kernel-owner+w=401wt.eu-S1759889AbYJIO2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889AbYJIO2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 10:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758910AbYJIO2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 10:28:00 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:50168 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758805AbYJIO2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 10:28:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoYFAOOs7UhMQWq+/2dsb2JhbACBcr09gWpg
Date: Thu, 9 Oct 2008 10:27:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] markers: remove 2 exported symbols
Message-ID: <20081009142758.GE15553@Krystal>
References: <48EC199D.40808@cn.fujitsu.com> <20081008024325.GA29227@Krystal> <48EC2377.6020706@cn.fujitsu.com> <20081008035325.GA31788@Krystal> <48ED6A29.3080903@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48ED6A29.3080903@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:51:38 up 126 days, 18:32,  8 users,  load average: 1.29, 0.81,
	0.61
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> Mathieu Desnoyers wrote:
> > * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> >> Mathieu Desnoyers wrote:
> >>> * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> >>>> __mark_empty_function() and marker_probe_cb_noarg()
> >>>> should not be seen by outer code. this patch remove them.
> >>>>
> >>>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> >>>> ---
> >>>> diff --git a/include/linux/marker.h b/include/linux/marker.h
> >>>> index 1290653..f4d4d28 100644
> >>>> --- a/include/linux/marker.h
> >>>> +++ b/include/linux/marker.h
> >>>> @@ -132,12 +132,8 @@ static inline void __printf(1, 2) ___mark_check_format(const char *fmt, ...)
> >>>>  			___mark_check_format(format, ## args);		\
> >>>>  	} while (0)
> >>>>  
> >>>> -extern marker_probe_func __mark_empty_function;
> >>>> -
> >>> Hi Lai,
> >>>
> >>> Hrm ? Have a good look at the macro __trace_mark() in
> >>> include/linux/marker.h, you'll see that __mark_empty_function is
> >>> referenced. Have you tested this against code with declared markers ?
> >> Sorry for this,
> >> I have markers in my kernel test code.
> >> I hasn't tested this patch, for I thought it's to simple.
> >> I used "grep" to find "__mark_empty_function",
> >> but I missed one line of the results.
> >>
> >> Other problems:
> >> 1)
> >> why we need marker_probe_cb_noarg()?
> >> marker_probe_cb_noarg() has no performance optimization,
> >> and no additional format check, or other thing?
> >>
> > 
> > marker_probe_cb_noarg() does not need to setup the variable arguments,
> > because the format string explicitly contains the MARK_NOARGS string. So
> > this is a performance optimization.
> 
> marker_probe_cb_noarg()/marker_probe_cb() are really critical path,
> but I think saving a "va_start" is not performance optimization.
> "va_start" is just several machine instructions after compiled.
> 
> if marker_probe_cb_noarg() is removed, kernel size will be reduced
> also, and cache missing will be reduced.
> 

I'd like some performance numbers on this. A good way I found to test
this is to run tbench with LTTng connected on the default markers, with
flight recorder tracing on. It's a good macro-benchmark (although I've
seen 100MB/s (over 1900MB/s) difference between -rc6 and -rc7, so it's
easily influenced by kernel changes). The other thing I do is to use the
specialized test modules I created, available at
http://ltt.polymtl.ca/svn/trunk/tests/kernel/. They basically loop doing
the same operation (e.g. calling a marker) so you can see how fast the
operation is in terms of cycles-per-loop. It's always cache-hot however.


> > 
> [...]
> >>
> >> 2)
> >> why we use va_list *?
> >> As I know, sizeof(va_list) = 4 or 8.
> >>
> > 
> > It becomes hellish when we want to pass it as parameter to another C
> > function, because va_list is typedef'd as an array on some
> > architectures, and the array gets propoted to a pointer type, which is
> > in turn incompatible with the array. C language mess :-( Not much we can
> > do about it.
> 
> va_list is platform-dependent, but it's transplantable. So I don't think
> it's a problem.
> 

See my comment in marker.h :

 * @args: variable argument list pointer. Use a pointer to overcome C's
 *        inability to pass this around as a pointer in a portable manner in
 *        the callee otherwise.

It's an information hard to find on the web (cannot find my original
source anymore, it's mainly through forums saying that the
http://c-faq.com/varargs/handoff.html _doesn't_ work), but you'll
understand that promotion of array to pointer when passed to a function
poses problem when you try to pass this array to another function. The
following won't work on architectures where va_list is defined as an
array :

void C(const char *fmt, va_list argp)
{
  ....
}

void B(const char *fmt, va_list argp)
{
  C(fmt, argp);  <--- this won't work, because we try to pass a pointer
                      to a function expecting an array.
}

void A(const char *fmt, ...)
{
  va_list argp;

  argp = va_start(fmt);
  B(fmt, argp);
  va_end(argp);
}

The way to permit it is to pass a pointer to argp instead :

void C(const char *fmt, va_list *argp)
{
  ....
}

void B(const char *fmt, va_list *argp)
{
  C(fmt, argp);
}

void A(const char *fmt, ...)
{
  va_list argp;

  argp = va_start(fmt);
  B(fmt, &argp);
  va_end(argp);
}

Mathieu

> And pass-by-value vs. pass-by-reference:
> marker_probe_cb() don't need see what have been changed with "args"
> by the probes/callbacks.
> 
> So I think pass-by-value is better than pass-by-reference here.
> 
> code piece:
>  typedef void marker_probe_func(void *probe_private, void *call_private,
> -		const char *fmt, va_list *args);
> +		const char *fmt, va_list args);
> 
> marker_probe_cb():
> 		multi = mdata->multi;
> +		va_start(args, call_private);
> 		for (i = 0; multi[i].func; i++) {
> -			va_start(args, call_private);
> 			multi[i].func(multi[i].probe_private, call_private,
> -				mdata->format, &args);
> -			va_end(args);
> +				mdata->format, args);
> 		}
> +		va_end(args);
> 
> 
> The only problem is that API is changed, and we need changed LTTng
> and SYSTEMTAP also.
> 
> 
> 
> > 
> > Mathieu
> > 
> [...]
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
