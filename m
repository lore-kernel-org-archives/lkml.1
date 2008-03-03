Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbYCDFWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbYCDFWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 00:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbYCDFWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 00:22:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:8343 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbYCDFWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 00:22:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,442,1199692800"; 
   d="scan'208";a="303498076"
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are
	dealocked when cpu is set to offline
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1204556014.3842.13.camel@yangyi-dev.bj.intel.com>
References: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com>
	 <b647ffbd0803030354s268089fo8e5b8f647ada0aae@mail.gmail.com>
	 <20080303115652.GA9257@elte.hu>
	 <b647ffbd0803030402t3a0a9acej75bc92be39db5204@mail.gmail.com>
	 <1204556014.3842.13.camel@yangyi-dev.bj.intel.com>
Content-Type: text/plain
Organization: Intel
Date: Tue, 04 Mar 2008 01:37:35 +0800
Message-Id: <1204565855.3842.22.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-03 at 22:53 +0800, Yi Yang wrote:
> On Mon, 2008-03-03 at 13:02 +0100, Dmitry Adamushko wrote:
> > On 03/03/2008, Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > >  * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> > >
> > >  >                 per_cpu(watchdog_task, hotcpu) = NULL;
> > >  > +               mlseep(1);
> > >
> > >
> > > that wont build very well ...
> > 
> > yeah, I forgot to mention that it's not even compile-tested :-/
> > I re-created it from scratch instead of looking for the original one.
> > 
> > please, this one (again, not compile-tested)
> > 
> > --- softlockup-prev-2.c 2008-03-03 12:38:36.000000000 +0100
> > +++ softlockup.c        2008-03-03 13:00:20.000000000 +0100
> > @@ -294,6 +294,7 @@ cpu_callback(struct notifier_block *nfb,
> >         case CPU_DEAD_FROZEN:
> >                 p = per_cpu(watchdog_task, hotcpu);
> >                 per_cpu(watchdog_task, hotcpu) = NULL;
> > +               msleep(1);
> >                 kthread_stop(p);
> >                 break;
> >  #endif /* CONFIG_HOTPLUG_CPU */
> 
> I don't think it can fix this issue, it only gives one chance to
> scheduler, i think there are another potential and very serious issues
> inside of scheduler or locking or what else we don't know.
> 
> Maybe migration is a doubtful point as Gautham mentioned.

That issue is still there after the above patch is applied.

I found that [watchdog/#] is indeed migrated to other cpu because
migration_call is called before cpu_callback, i think this is the real
root cause very very possibly.

I suggest we can develop a new notifier infrastructure in which one
caller can specify whether it is kthread_stopping a cpu-bind kthread
so that such notifier callbacks can be executed prior to other
callbacks.
> > 

