Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbYKZNJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbYKZNJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbYKZNJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:09:14 -0500
Received: from mga14.intel.com ([143.182.124.37]:42347 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884AbYKZNJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:09:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,668,1220252400"; 
   d="scan'208";a="83164306"
Date: Wed, 26 Nov 2008 21:08:48 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] markers: comment usage of
	marker_synchronize_unregister()
Message-ID: <20081126130847.GA20988@localhost>
References: <20081126123652.GA9446@localhost> <20081126124608.GA22504@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126124608.GA22504@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 02:46:08PM +0200, Mathieu Desnoyers wrote:
> * Wu Fengguang (fengguang.wu@intel.com) wrote:
> > Add more comments to marker_synchronize_unregister() in order to
> > reduce the chance of misusing.
> > 
> > Based on comments from Lai Jiangshan <laijs@cn.fujitsu.com>.
> > 
> > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > Signed-off-by: Wu Fengguang <wfg@linux.intel.com>
> > ---
> > 
> > I'm still not sure about the last sentence. Can anyone clarify on
> > this? Thanks!
> > 
> > diff --git a/include/linux/marker.h b/include/linux/marker.h
> > index 889196c..89ce1b8 100644
> > --- a/include/linux/marker.h
> > +++ b/include/linux/marker.h
> > @@ -164,6 +164,12 @@ extern void *marker_get_private_data(const char *name, marker_probe_func *probe,
> >   * marker_synchronize_unregister must be called between the last marker probe
> >   * unregistration and the end of module exit to make sure there is no caller
> >   * executing a probe when it is freed.
> > + *
> > + * It must be called _also_ between unregistration and destruction the data
> > + * that unregistration-ed probes need to make sure there is no caller executing
> > + * a probe when it's data is destroyed.
> 
> it's -> its
> 
> And the way it's written, this last sentence is a bit misleading. One
> might think that the synchronize_unregister has to be called two, when
> in fact it just has to be called once, but it must be called at a moment
> in time between unregister and free of any resource used by the probes,
> including the code which is removed by module unload.
> 
> > + *
> > + * It works reliably only when all probe routines do not sleep and reschedule.
> 
> Per definition, preemption is disabled around marker probe execution, so
> I don't see why we should add this last sentence ?

Thanks, your reminder dismissed my confusion on this last sentence :-)

Updated patch according to your helpful comments.

Thank you,
Fengguang
---
markers: comment usage of marker_synchronize_unregister()

Add more comments to marker_synchronize_unregister() in order to
reduce the chance of misusing.

Based on comments from Lai Jiangshan and Mathieu Desnoyers.

Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Wu Fengguang <wfg@linux.intel.com>
---
diff --git a/include/linux/marker.h b/include/linux/marker.h
index 889196c..32ce4f2 100644
--- a/include/linux/marker.h
+++ b/include/linux/marker.h
@@ -162,8 +162,10 @@ extern void *marker_get_private_data(const char *name, marker_probe_func *probe,
 
 /*
  * marker_synchronize_unregister must be called between the last marker probe
- * unregistration and the end of module exit to make sure there is no caller
- * executing a probe when it is freed.
+ * unregistration and the first one of
+ * - the end of module exit
+ * - the free of any resource used by the probes
+ * to ensure the code and data are all valid for any possibly running probes.
  */
 #define marker_synchronize_unregister() synchronize_sched()
 
