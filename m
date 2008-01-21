Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbYAUTIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbYAUTIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 14:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYAUTIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 14:08:44 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:55360 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbYAUTIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 14:08:43 -0500
Date: Mon, 21 Jan 2008 20:08:51 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, dipankar@in.ibm.com,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] rcu: fix section mismatch
Message-ID: <20080121190851.GB32403@uranus.ravnborg.org>
References: <20080119115643.43236e70.randy.dunlap@oracle.com> <20080119212549.GD29070@uranus.ravnborg.org> <200801211138.38591.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801211138.38591.rusty@rustcorp.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2008 at 11:38:38AM +1100, Rusty Russell wrote:
> On Sunday 20 January 2008 08:25:49 Sam Ravnborg wrote:
> > On Sat, Jan 19, 2008 at 11:56:43AM -0800, Randy Dunlap wrote:
> > > rcu_online_cpu() should be __cpuinit instead of __devinit.
> >
> > So if we have:
> > CONFIG_HOTPLUG=n
> > CONFIG_HOTPLUG_CPU=y
> >
> > then this is a oops candidate.
> 
> At first glance, this can't happen because all CONFIG_HOTPLUG_CPU depends on 
> CONFIG_HOTPLUG or selects it, for all archs.
> 
> But CONFIG_PM_SLEEP_SMP selects CONFIG_HOTPLUG_CPU, without requiring 
> CONFIG_HOTPLUG: turning on SUSPEND or HIBERNATION does this.
For now it is a bug to select a symbol with dependencies...

If we could say that we always have HOTPLUG when we have HOTPLUG_CPU
that would kill a lot of a lot of Section Mismatch warnings.
But as things stands out we can build a kernel with HOTPLUG_CPU
but without HOTPLUG.

#if defined(CONFIG_HOTPLUG_CPU && !defined(CONFIG_HOTPLUG)
# error illegal configuration - talk to the PM guys
#endif

could do it?
 
> 
> Perhaps it's time to revisit reverse-depends for select?
Or maybe a higer level solution.
select is used for three pruposes:
- to include specific minimalitic functionality as for example done on
  the ARM Kconfig file with success
- to enable general functionality (the HAVE_* way to do it)
- to enable subsystems of different sizes

And it is only when people try to do the latter it blows up.
And they do so to make it easier for people to configure the kernel
but the end result is the opposite.

	Sam
