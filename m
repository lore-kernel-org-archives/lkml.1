Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbYK0Bhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbYK0Bhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 20:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYK0BhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 20:37:23 -0500
Received: from mga03.intel.com ([143.182.124.21]:34189 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbYK0BhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 20:37:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,671,1220252400"; 
   d="scan'208";a="83492192"
Date: Thu, 27 Nov 2008 09:36:55 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] markers: comment marker_synchronize_unregister() on
	data dependency
Message-ID: <20081127013655.GA11866@localhost>
References: <20081126123652.GA9446@localhost> <20081126124608.GA22504@Krystal> <20081126130847.GA20988@localhost> <20081127010553.GA11182@localhost> <492DF67A.8090006@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492DF67A.8090006@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 03:23:06AM +0200, Lai Jiangshan wrote:
> Wu Fengguang wrote:
> > [updated patch to include Documentation/markers.txt changes]
> > 
> > Add document and comments on marker_synchronize_unregister(): it
> > should be called before freeing resources that the probes depend on.
> > 
> > Based on comments from Lai Jiangshan and Mathieu Desnoyers.
> > 
> > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > Signed-off-by: Wu Fengguang <wfg@linux.intel.com>
> > ---
> > diff --git a/Documentation/markers.txt b/Documentation/markers.txt
> > index 089f613..8bf6afe 100644
> > --- a/Documentation/markers.txt
> > +++ b/Documentation/markers.txt
> > @@ -51,11 +51,15 @@ to call) for the specific marker through marker_probe_register() and can be
> >  activated by calling marker_arm(). Marker deactivation can be done by calling
> >  marker_disarm() as many times as marker_arm() has been called. Removing a probe
> >  is done through marker_probe_unregister(); it will disarm the probe.
> > -marker_synchronize_unregister() must be called before the end of the module exit
> > -function to make sure there is no caller left using the probe. This, and the
> > -fact that preemption is disabled around the probe call, make sure that probe
> > -removal and module unload are safe. See the "Probe example" section below for a
> > -sample probe module.
> > +
> > +marker_synchronize_unregister() must be called before the first occurrence of
> > +- the end of the module exit function,
> > +  to make sure there is no caller left using the probe;
> > +- the free of any resource used by the probes,
> > +  to make sure the probes wont be accessing destructed data.
> > +This, and the fact that preemption is disabled around the probe call, make sure
> > +that probe removal and module unload are safe. See the "Probe example" section
> > +below for a sample probe module.
> >  
> >  The marker mechanism supports inserting multiple instances of the same marker.
> >  Markers can be put in inline functions, inlined static functions, and
> > diff --git a/include/linux/marker.h b/include/linux/marker.h
> > index 889196c..32ce4f2 100644
> > --- a/include/linux/marker.h
> > +++ b/include/linux/marker.h
> > @@ -162,8 +162,10 @@ extern void *marker_get_private_data(const char *name, marker_probe_func *probe,
> >  
> >  /*
> >   * marker_synchronize_unregister must be called between the last marker probe
> > - * unregistration and the end of module exit to make sure there is no caller
> > - * executing a probe when it is freed.
> > + * unregistration and the first one of
> > + * - the end of module exit function
> > + * - the free of any resource used by the probes
> 
> Does "destruction" contain the meaning of "free" and other destruction behavior?

Ahh, better to use "invalid data" instead of "destructed data"?

> It's every good job, thank you.
> 
> Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Thank you,
Fengguang
---
markers: comment marker_synchronize_unregister() on data dependency

Add document and comments on marker_synchronize_unregister(): it
should be called before freeing resources that the probes depend on.

Based on comments from Lai Jiangshan and Mathieu Desnoyers.

Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Wu Fengguang <wfg@linux.intel.com>
---
diff --git a/Documentation/markers.txt b/Documentation/markers.txt
index 089f613..8bf6afe 100644
--- a/Documentation/markers.txt
+++ b/Documentation/markers.txt
@@ -51,11 +51,15 @@ to call) for the specific marker through marker_probe_register() and can be
 activated by calling marker_arm(). Marker deactivation can be done by calling
 marker_disarm() as many times as marker_arm() has been called. Removing a probe
 is done through marker_probe_unregister(); it will disarm the probe.
-marker_synchronize_unregister() must be called before the end of the module exit
-function to make sure there is no caller left using the probe. This, and the
-fact that preemption is disabled around the probe call, make sure that probe
-removal and module unload are safe. See the "Probe example" section below for a
-sample probe module.
+
+marker_synchronize_unregister() must be called before the first occurrence of
+- the end of the module exit function,
+  to make sure there is no caller left using the probe;
+- the free of any resource used by the probes,
+  to make sure the probes wont be accessing invalid data.
+This, and the fact that preemption is disabled around the probe call, make sure
+that probe removal and module unload are safe. See the "Probe example" section
+below for a sample probe module.
 
 The marker mechanism supports inserting multiple instances of the same marker.
 Markers can be put in inline functions, inlined static functions, and
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
+ * - the end of module exit function
+ * - the free of any resource used by the probes
+ * to ensure the code and data are valid for any possibly running probes.
  */
 #define marker_synchronize_unregister() synchronize_sched()
 
