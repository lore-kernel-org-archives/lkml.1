Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbZJ0QQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbZJ0QQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 12:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755947AbZJ0QQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 12:16:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755892AbZJ0QQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 12:16:49 -0400
Subject: Re: [PATCH] [RFC][Patch x86-tip] add notifier before kdump
From: Lon Hohberger <lhh@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jin Dongming <jin.dongming@np.css.fujitsu.com>,
       LKLM <linux-kernel@vger.kernel.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Neil Horman <nhorman@redhat.com>
In-Reply-To: <20091027150725.GD10513@redhat.com>
References: <4AE6B1CC.6040603@np.css.fujitsu.com>
	 <20091027150725.GD10513@redhat.com>
Content-Type: text/plain
Organization: Red Hat
Date: Tue, 27 Oct 2009 12:16:48 -0400
Message-Id: <1256660208.15137.102.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 11:07 -0400, Vivek Goyal wrote:
> > 
> > In our PC-cluster, there are two nodes working together, one is running
> > and the other one is on standby mode. When the running one is going
> > on panic, we hope the works listed as following would be done:
> >     1. Before the running kernel is going on panic, the node on standby
> >        mode should be notified firstly.
> >     2. After the notified work is done, the panic kernel startup on the
> >        second kernel to get kdump.
> > But the current kernel could not do them all.
> > 

Ok, I'll admit at being naive as to how panicking kernels operate.

I do not understand how this could be safe from a cluster fencing
perspective.  Effectively, you're allowing a "bad" kernel to continue to
do "something", when you should be allowing it to do "nothing".

This panicking kernel does "something" and the cluster presumably
initiates recovery /before/ the kdump kernel boots... i.e. with the old,
panicking kernel still present.

Shouldn't you at least wait until the kdump kernel boots before telling
a cluster that it is safe to begin recovery?

> > This patch is not tested on SH and Power PC.
> > 
> 
> I guess this might be 3rd or 4th attempt to get this kind of
> infrastructure in kernel.
> 
> In the past exporting this kind of hook to modules has been rejected
> becuase of concerns that modules might be doing too much in side a 
> crashed kernel and that can hang up the system completely and we can't
> even capture the dump.

Right.
 - the hook can fail
 - the hook could potentially be a poorly written one which tries to
access shared storage

Surely, booting the kdump kernel/env. might fail too - but it's no worse
than the notification hook failing.  In both cases, you eventually time
out and fence off (or "STONITH") the failed node

I suspect doing things in a crashing kernel is more likely to fail than
doing things in a kdump-booted kernel...

> In the past two ways have been proposed to handle this situation.
> 
> - Handle it in second kernel. Especially in initrd. Put right
>   script/binary/tools and configuration in kdump initrd at the time of
>   configuration and once second kernel boots, initrd will first send the
>   kdump message out to other node(s). This can be helpful for fencing
>   scenario also.

I think this is safer and more predictable: once the second kernel
boots, the panicked kernel is not in control any more.  I suspect there
is a much higher degree of certainty around what the new kdump kernel
will do than what will happen in the panicked kernel with an added
'crashing' hook.

Waiting for kdump to boot is an unfortunate delay.  However, the trade
off, I think, is more predictable, ordered failure recovery and
potentially less risk to data on shared storage (depending on what the
notify hook does).

-- Lon

