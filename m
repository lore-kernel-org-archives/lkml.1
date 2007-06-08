Return-Path: <linux-kernel-owner+w=401wt.eu-S1030761AbXFHOdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030761AbXFHOdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 10:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969168AbXFHOc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 10:32:58 -0400
Received: from smtp107.sbc.mail.re2.yahoo.com ([68.142.229.98]:40262 "HELO
	smtp107.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S967307AbXFHOc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 10:32:57 -0400
X-YMail-OSG: 1FpTrpIVM1kr23q.ASl9purr7M5Yc4K7N1otlTvBrq3Vf30l3c7p_PLpYP9Avim1mk0DC9mHAMWUYhWLZqCPBvh2dvDu4yRzuzfpaEyy2iTvA5fGZRlG2QPvNz87cdUTZLvhckzqiMOzEg--
Date: Fri, 8 Jun 2007 09:32:50 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Paul Jackson <pj@sgi.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, vatsa@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com,
       rohitseth@google.com, haveblue@us.ibm.com, xemul@sw.ru, dev@sw.ru,
       containers@lists.osdl.org, devel@openvz.org, ebiederm@xmission.com,
       mbligh@google.com, cpw@sgi.com, menage@google.com,
       svaidy@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ckrm-tech] [PATCH 00/10] Containers(V10): Generic Process Containers
Message-ID: <20070608143250.GA7728@vino.hallyn.com>
References: <20070604204131.GB19409@sergelap.austin.ibm.com> <20070604140533.65e25286.pj@sgi.com> <20070606223952.GB5626@sergelap.austin.ibm.com> <20070606154347.a155630b.pj@sgi.com> <20070607000559.GA19529@sergelap.austin.ibm.com> <20070606174609.bfa01446.pj@sgi.com> <20070607180158.GA936@sergelap.austin.ibm.com> <20070607122121.24fe6ff4.pj@sgi.com> <20070607201723.GA17011@sergelap.austin.ibm.com> <20070607150113.f020d8f8.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607150113.f020d8f8.pj@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Jackson (pj@sgi.com):
> > > The set of people using exclusive cpusets is roughly some subset of
> > > those running multiple, cpuset isolated, non-cooperating jobs on big
> > > iron, usually with the aid of a batch scheduler.
> > 
> > Unfortunately I would imagine these users to be very intereseted in
> > providing checkpoint/restart/migrate functionality.
> 
> Yup - such customers are very interested in checkpoint, restart, and
> migrate functionality.
> 
> > Surely if the admin wants to give cpus 5-6 exclusively to /cpusets/set0/set4
> > later, those cpus can just be taken away from set3?
> 
> Yeah - that works, so far as I know (which isn't all that far ..')
> 
> But both:
>  1) that (using whatever cpus are still available) and
>  2) my other idea, of not allowing any cloning of cpusets with
>     exclusive siblings at all,
> 
> looked a little ugly to me.
> 
> For example, such customers as above would not appreciate having their
> checkpoint/restart/migrate fail in any case where there weren't spare
> non-exclusive cpus, which for users of the exclusive flag, is often the
> more common case.
> 
> My rule of thumb when doing ugly stuff is to constrain it as best
> I can -- minimize what it allows.  This led me to prefer (2) above
> over (1) above.
> 
> Perhaps there's a better way to think of this ...  When we clone
> like this for checkpoint/restart/migrate functionality, perhaps
> we are not really starting up a new, separate, competing job that
> should have its resources isolated and separated from the original.

Depends on whether the cpus are allocated to a customer or to a job.

For the most part I would expect any job to be restart either on a
different machine, or at a different time, but of course it doesn't have
to be that way.

> Perhaps instead we are firing up a convenient alter-ego of the
> original job, which will be co-operatively using the same resources
> by default.  If that's the normal case, then it seems wrong to
> force the clone onto disjoint CPUs, or fail for lack thereof.
> 
> So perhaps we should refine the meaning of 'exclusive', from:
>  - no overlapping siblings
> to:
>  - no overlapping siblings other than clones of ones self.

I'm not sure that clones of self will happen often enough to make a
special case for them :)

Anyway the patch I sent is simple enough, and if users end up demanding
the ability to better deal with exclusive cpusets, the patch will be
simple enough to extend by changing cpuset_auto_setup(), so let's
stick with that patch since it's your preference (IIUC).

> Then default to cloning right on the same CPU resources as the
> original, possibly with both original and clone marked exclusive.

Thanks,
-serge
