Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbYJ2RpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbYJ2RpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 13:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbYJ2RpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 13:45:06 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:47471 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753963AbYJ2RpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 13:45:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArUEAAQ8CElMQWao/2dsb2JhbACBdswng1E
Date: Wed, 29 Oct 2008 13:40:01 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: ltt-dev@lists.casi.polymtl.ca, "Martin J. Bligh" <mbligh@mbligh.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, kernel-trace-list@redhat.com,
       linux-kernel@vger.kernel.org, systemtap@sources.redhat.com
Subject: Re: [ltt-dev] LTTng 0.44 and LTTV 0.11.3
Message-ID: <20081029174001.GA30796@Krystal>
References: <20081024004502.GA21759@Krystal> <49068D2A.9010308@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49068D2A.9010308@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:07:37 up 146 days, 20:48,  8 users,  load average: 0.50, 0.57,
	0.57
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> Mathieu Desnoyers wrote:
> > - I have also vastly simplified locking in the markers and tracepoints
> >   by using _only_ the modules mutex. I actually took this mutex out of
> >   module.c and created its own file so tracepoints and markers can use
> >   it. That should please Lai Jiangshan. Although he may have some work
> >   to do to see how his new probes manager might benefit from it.
> > 
> >   See :
> >   http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=commitdiff;h=7aea87ac46df7613d68034f5904bc8d575069076
> >   and
> >   http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=commitdiff;h=5f6814237f7a67650e7b6214d916825e3f8fc1b7
> >   http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=commitdiff;h=410ba66a1cbe27a611e1c18c0a53e87b4652a2c9
> > 
> 
> Hi, Mathieu,
> 
> I strongly reject for removing tracepoint_mutex and marker_mutex.
> 
> As an independent subsystem, we should use our own locks. Do not use others.
> otherwise coupling will be increased in linux kernel.
> I condemn unnecessary coupling.
> 
> Our tracepoint & marker had tied to modules(for traveling all tracepoints
> or markers). The best thing is that we do not increase the coupling.
> 
> [PATCH 2/2] tracepoint: introduce *_noupdate APIs.
> is helpful for auto-active-tracepoint-mechanism.
> 
> 		Thanx, Lai.
> 

Hi Lai,

The approach you propose looks interesting. Please see below to make
sure we are on the same page.

The problem is that when we want to connect
markers/tracepoints/immediate values together, it results in a real
locking mess between

modules_mutex
  markers_mutex
    tracepoints_mutex
      imv_mutex

When we want to take care of a marker at module load, we have to insure
the following calling scenario is correct :

load_module()
  call markers_update_probes_range() (on the module markers)
    call tracepoint register (to automatically enable a tracepoint
                               when a marker is connected to it)
      call tracepoints_update_probe_range (on kernel core and all modules)
        call imv_update_range (on kernel core and all modules)

The current locking status of tracepoints vs markers does not currently
allow tracepoints_register to be called from the marker update because
it would take the modules_mutex twice.

What you propose is something like this :

load_module()
  call markers_update_probes_range()
    call tracepoint_register_noupdate (to automatically enable a tracepoint
                                       when a marker is connected to it)
  call tracepoints_update_all() (for core kernel and all modules (*))
    name##__imv = (i)
  call imv_update_all() (for core kernel and all modules (*))

(*) This is required because registering a tracepoint might have impact
    outside of the module in which the marker is located. Same for
    changing an immediate value.

And on marker_register_probe() :
  call markers_update_probes_range()
    call tracepoint_register_noupdate
  call tracepoints_update_all()
    name##__imv = (i)
  call imv_update_all()

Which basically uses the same trick I used for immediate values : it
separates the "backing data" update (name##_imv = (i)) from the actual
update that needs to iterate on the modules.

The only thing we have to be aware of is that it actually couples
markers/tracepoints/immediate values much more thightly to keep separate
locking for each, because, as the example above shows, the markers have
to be aware that they must call tracepoints_update_all and
imv_update_all explicitely. On the plus side, it requires much less
iterations on the module sections, which is a clear win.

So the expected mutex nesting order is (indent implies "nested in"):

On load_module :

modules_mutex
  markers_mutex
  tracepoints_mutex
  imv_mutex

On marker register :

markers_mutex
  tracepoints_mutex
  imv_mutex

On tracepoint register :

tracepoints_mutex
  imv_mutex

On imv_update :

imv_mutex

So yes, I think your approach is good, although there are some
implementation quirks in the patch you submitted. I'll comment by
replying to your other post.

Thanks,

Mathieu


> > So hopefully everyone will be happy with this new release. :)
> > 
> > Mathieu
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
