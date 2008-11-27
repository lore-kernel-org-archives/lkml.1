Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbYK0IA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbYK0IA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 03:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYK0IAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 03:00:08 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:35051 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751939AbYK0IAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 03:00:06 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjEFAFXeLUlMROB9/2dsb2JhbACBbdBjgn0
Date: Thu, 27 Nov 2008 03:00:03 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] markers: comment marker_synchronize_unregister() on
	data dependency
Message-ID: <20081127080003.GB25072@Krystal>
References: <20081126123652.GA9446@localhost> <20081126124608.GA22504@Krystal> <20081126130847.GA20988@localhost> <20081127010553.GA11182@localhost> <492DF67A.8090006@cn.fujitsu.com> <20081127013655.GA11866@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081127013655.GA11866@localhost>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 02:59:27 up 10 days,  8:39,  1 user,  load average: 0.79, 0.40,
	0.31
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Wu Fengguang (fengguang.wu@intel.com) wrote:
> On Thu, Nov 27, 2008 at 03:23:06AM +0200, Lai Jiangshan wrote:
> > Wu Fengguang wrote:
> > > [updated patch to include Documentation/markers.txt changes]
> > > 
> > > Add document and comments on marker_synchronize_unregister(): it
> > > should be called before freeing resources that the probes depend on.
> > > 
> > > Based on comments from Lai Jiangshan and Mathieu Desnoyers.
> > > 
> > > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > > Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > > Signed-off-by: Wu Fengguang <wfg@linux.intel.com>
> > > ---
> > > diff --git a/Documentation/markers.txt b/Documentation/markers.txt
> > > index 089f613..8bf6afe 100644
> > > --- a/Documentation/markers.txt
> > > +++ b/Documentation/markers.txt
> > > @@ -51,11 +51,15 @@ to call) for the specific marker through marker_probe_register() and can be
> > >  activated by calling marker_arm(). Marker deactivation can be done by calling
> > >  marker_disarm() as many times as marker_arm() has been called. Removing a probe
> > >  is done through marker_probe_unregister(); it will disarm the probe.
> > > -marker_synchronize_unregister() must be called before the end of the module exit
> > > -function to make sure there is no caller left using the probe. This, and the
> > > -fact that preemption is disabled around the probe call, make sure that probe
> > > -removal and module unload are safe. See the "Probe example" section below for a
> > > -sample probe module.
> > > +
> > > +marker_synchronize_unregister() must be called before the first occurrence of
> > > +- the end of the module exit function,
> > > +  to make sure there is no caller left using the probe;
> > > +- the free of any resource used by the probes,
> > > +  to make sure the probes wont be accessing destructed data.
> > > +This, and the fact that preemption is disabled around the probe call, make sure
> > > +that probe removal and module unload are safe. See the "Probe example" section
> > > +below for a sample probe module.
> > >  
> > >  The marker mechanism supports inserting multiple instances of the same marker.
> > >  Markers can be put in inline functions, inlined static functions, and
> > > diff --git a/include/linux/marker.h b/include/linux/marker.h
> > > index 889196c..32ce4f2 100644
> > > --- a/include/linux/marker.h
> > > +++ b/include/linux/marker.h
> > > @@ -162,8 +162,10 @@ extern void *marker_get_private_data(const char *name, marker_probe_func *probe,
> > >  
> > >  /*
> > >   * marker_synchronize_unregister must be called between the last marker probe
> > > - * unregistration and the end of module exit to make sure there is no caller
> > > - * executing a probe when it is freed.
> > > + * unregistration and the first one of
> > > + * - the end of module exit function
> > > + * - the free of any resource used by the probes
> > 
> > Does "destruction" contain the meaning of "free" and other destruction behavior?
> 
> Ahh, better to use "invalid data" instead of "destructed data"?
> 
> > It's every good job, thank you.
> > 
> > Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> Thank you,
> Fengguang
> ---
> markers: comment marker_synchronize_unregister() on data dependency
> 
> Add document and comments on marker_synchronize_unregister(): it
> should be called before freeing resources that the probes depend on.
> 
> Based on comments from Lai Jiangshan and Mathieu Desnoyers.
> 
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Wu Fengguang <wfg@linux.intel.com>
> ---
> diff --git a/Documentation/markers.txt b/Documentation/markers.txt
> index 089f613..8bf6afe 100644
> --- a/Documentation/markers.txt
> +++ b/Documentation/markers.txt
> @@ -51,11 +51,15 @@ to call) for the specific marker through marker_probe_register() and can be
>  activated by calling marker_arm(). Marker deactivation can be done by calling
>  marker_disarm() as many times as marker_arm() has been called. Removing a probe
>  is done through marker_probe_unregister(); it will disarm the probe.
> -marker_synchronize_unregister() must be called before the end of the module exit
> -function to make sure there is no caller left using the probe. This, and the
> -fact that preemption is disabled around the probe call, make sure that probe
> -removal and module unload are safe. See the "Probe example" section below for a
> -sample probe module.
> +
> +marker_synchronize_unregister() must be called before the first occurrence of


You should probably say 

".. must be called between probe unregistration and the first occurence
of..."

Mathieu

> +- the end of the module exit function,
> +  to make sure there is no caller left using the probe;
> +- the free of any resource used by the probes,
> +  to make sure the probes wont be accessing invalid data.
> +This, and the fact that preemption is disabled around the probe call, make sure
> +that probe removal and module unload are safe. See the "Probe example" section
> +below for a sample probe module.
>  
>  The marker mechanism supports inserting multiple instances of the same marker.
>  Markers can be put in inline functions, inlined static functions, and
> diff --git a/include/linux/marker.h b/include/linux/marker.h
> index 889196c..32ce4f2 100644
> --- a/include/linux/marker.h
> +++ b/include/linux/marker.h
> @@ -162,8 +162,10 @@ extern void *marker_get_private_data(const char *name, marker_probe_func *probe,
>  
>  /*
>   * marker_synchronize_unregister must be called between the last marker probe
> - * unregistration and the end of module exit to make sure there is no caller
> - * executing a probe when it is freed.
> + * unregistration and the first one of
> + * - the end of module exit function
> + * - the free of any resource used by the probes
> + * to ensure the code and data are valid for any possibly running probes.
>   */
>  #define marker_synchronize_unregister() synchronize_sched()
>  

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
