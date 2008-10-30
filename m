Return-Path: <linux-kernel-owner+w=401wt.eu-S1753588AbYJ3GBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbYJ3GBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 02:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbYJ3GBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 02:01:41 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:60840 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752704AbYJ3GBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 02:01:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkwFAETmCElMQWao/2dsb2JhbACBdspxg1E
Date: Thu, 30 Oct 2008 02:01:38 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: sadump@cn.fujitsu.com, kernel-trace-list@redhat.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       "Martin J. Bligh" <mbligh@mbligh.org>, ltt-dev@lists.casi.polymtl.ca,
       systemtap@sources.redhat.com, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ltt-dev] [sadump 04308] Re:  LTTng 0.44 and LTTV 0.11.3
Message-ID: <20081030060138.GA29673@Krystal>
References: <20081024004502.GA21759@Krystal> <49068D2A.9010308@cn.fujitsu.com> <20081029174001.GA30796@Krystal> <49092AEB.2080000@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49092AEB.2080000@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 01:49:45 up 147 days, 10:30,  5 users,  load average: 0.36, 0.51,
	0.45
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> Mathieu Desnoyers wrote:
> > * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> >> Mathieu Desnoyers wrote:
> >>> - I have also vastly simplified locking in the markers and tracepoints
> >>>   by using _only_ the modules mutex. I actually took this mutex out of
> >>>   module.c and created its own file so tracepoints and markers can use
> >>>   it. That should please Lai Jiangshan. Although he may have some work
> >>>   to do to see how his new probes manager might benefit from it.
> >>>
> >>>   See :
> >>>   http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=commitdiff;h=7aea87ac46df7613d68034f5904bc8d575069076
> >>>   and
> >>>   http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=commitdiff;h=5f6814237f7a67650e7b6214d916825e3f8fc1b7
> >>>   http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=commitdiff;h=410ba66a1cbe27a611e1c18c0a53e87b4652a2c9
> >>>
> >> Hi, Mathieu,
> >>
> >> I strongly reject for removing tracepoint_mutex and marker_mutex.
> >>
> >> As an independent subsystem, we should use our own locks. Do not use others.
> >> otherwise coupling will be increased in linux kernel.
> >> I condemn unnecessary coupling.
> >>
> >> Our tracepoint & marker had tied to modules(for traveling all tracepoints
> >> or markers). The best thing is that we do not increase the coupling.
> >>
> >> [PATCH 2/2] tracepoint: introduce *_noupdate APIs.
> >> is helpful for auto-active-tracepoint-mechanism.
> >>
> >> 		Thanx, Lai.
> >>
> > 
> > Hi Lai,
> > 
> > The approach you propose looks interesting. Please see below to make
> > sure we are on the same page.
> > 
> > The problem is that when we want to connect
> > markers/tracepoints/immediate values together, it results in a real
> > locking mess between
> > 
> > modules_mutex
> >   markers_mutex
> >     tracepoints_mutex
> >       imv_mutex
> > 
> > When we want to take care of a marker at module load, we have to insure
> > the following calling scenario is correct :
> > 
> > load_module()
> >   call markers_update_probes_range() (on the module markers)
> >     call tracepoint register (to automatically enable a tracepoint
> >                                when a marker is connected to it)
> >       call tracepoints_update_probe_range (on kernel core and all modules)
> >         call imv_update_range (on kernel core and all modules)
> > 
> > The current locking status of tracepoints vs markers does not currently
> > allow tracepoints_register to be called from the marker update because
> > it would take the modules_mutex twice.
> > 
> > What you propose is something like this :
> > 
> > load_module()
> >   call markers_update_probes_range()
> >     call tracepoint_register_noupdate (to automatically enable a tracepoint
> >                                        when a marker is connected to it)
> >   call tracepoints_update_all() (for core kernel and all modules (*))
> >     name##__imv = (i)
> >   call imv_update_all() (for core kernel and all modules (*))
> > 
> > (*) This is required because registering a tracepoint might have impact
> >     outside of the module in which the marker is located. Same for
> >     changing an immediate value.
> 
> Er, my patch cannot handle updates when load_module().
> 
> > 
> > And on marker_register_probe() :
> >   call markers_update_probes_range()
> >     call tracepoint_register_noupdate
> >   call tracepoints_update_all()
> >     name##__imv = (i)
> >   call imv_update_all()
> > 
> > Which basically uses the same trick I used for immediate values : it
> > separates the "backing data" update (name##_imv = (i)) from the actual
> > update that needs to iterate on the modules.
> > 
> > The only thing we have to be aware of is that it actually couples
> > markers/tracepoints/immediate values much more thightly to keep separate
> > locking for each, because, as the example above shows, the markers have
> > to be aware that they must call tracepoints_update_all and
> > imv_update_all explicitely. On the plus side, it requires much less
> > iterations on the module sections, which is a clear win.
> > 
> > So the expected mutex nesting order is (indent implies "nested in"):
> > 
> > On load_module :
> > 
> > modules_mutex
> >   markers_mutex
> >   tracepoints_mutex
> >   imv_mutex
> > 
> > On marker register :
> > 
> > markers_mutex
> >   tracepoints_mutex
> >   imv_mutex
> > 
> > On tracepoint register :
> > 
> > tracepoints_mutex
> >   imv_mutex
> > 
> > On imv_update :
> > 
> > imv_mutex
> > 
> > So yes, I think your approach is good, although there are some
> > implementation quirks in the patch you submitted. I'll comment by
> > replying to your other post.
> 
> Hmm, right, the patch <<[PATCH 2/2] tracepoint: introduce *_noupdate APIs>>
> is quirks for it separate working into 2 steps.
> 
> currently, markers and tracepoint abuse RCU and use RCU in a very ugly way.
> patches <<[PATCH 1/2] tracepoint: simplify for tracepoint using RCU>>
> and <<[PATCH tip/tracing/markers] new probes manager>> had toll us how ugly they
> are. if you do not remove tracepoints_mutex and markers_mutex, these two
> patches can be applied now. (and if you want to remove mutexs, I will changed
> these two patches a little.)
> 

Yup, markers have a good reason to "abuse" RCU as they do. Tracepoints
inherited from the same behavior as markers, but given they have no
special-case for single probe, they don't have the same requirements
with respect to reaching quiescent states between consecutive
register/unregisters. So your patches are correct.

> --------------------
> 
> Actually, markers and tracepoint are not like immediate-value, we do not need
> update markers and tracepoint on load_module(), we can register_module_notifier()
> and update them when MODULE_STATE_COMING.
> 

Hrm, interesting. And this would happen without modules_mutex held and
solve all our problems, right ? :)

> [Quick Quiz 1] why imv_update_all() must called on load_module()?
> load_module() will setup parameters, the routine of setuping parameters
> will use immediate-value.
> 
> sys_init_module:
>   load_module
>     setup parameters
>   blocking_notifier_call_chain(MODULE_STATE_COMING)
>   mod->init();
> 
> the markers and tracepoint in "setup parameters" will not be actived by this 
> approach, it's OK for it's a trace tool.
> 

that's fine with me.

> PS and OT: why not introduce module_param_imv?
> a little like this:
> #define module_param_imv(name, type, perm)				\
> 	module_param_named(name, name##__imv, type, perm)
> and update them in MODULE_STATE_COMING.
> 
> most module param are readonly after initialized.
> 

Yup, this sounds like a very good idea.

Actually, I'm wondering if we could simply put the marker, tracepoint
and immediate values update code in MODULE_STATE_COMING notifiers rather
than in load_module() ?

> ----------------------------
> if you do not like <<[PATCH 2/2] tracepoint: introduce *_noupdate APIs>>,
> here is the second way:
> introduce these five APIs in module.c
> module_iter_start()   - require module_mutex and return first module
> module_iter_next()
> module_iter_stop()    - release module_mutex
> __module_iter_start() - do not require module_mutex
> __module_iter_stop()
> 
> When we have fixed the mutex mess, code changed by this approach are
> the least. and we can implement robust tracepoint_iter, marker_iter
> by using these APIs.
> 

Hrm, finally I think I've got to like the _noupdate APIs, especially if
we can use MODULE_STATE_COMING notifiers outside of modules_mutex
section after module load.

> ------------------------------
> 
> I strongly reject for removing tracepoint_mutex and marker_mutex.
> you will pay for it when markers and tracepoint become powerful
> after you remove tracepoint_mutex and marker_mutex. and the
> modules guys will condemn you for bring coupling for modules.
> 

Agreed. If we can manage to keep them separate, let's do it.

Thanks,

Mathieu

> 	Thanx, Lai.
> 
> > 
> > Thanks,
> > 
> > Mathieu
> > 
> > 
> >>> So hopefully everyone will be happy with this new release. :)
> >>>
> >>> Mathieu
> >>>
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >>
> > 
> 
> 
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
