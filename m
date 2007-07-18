Return-Path: <linux-kernel-owner+w=401wt.eu-S1753588AbXGRE0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbXGRE0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 00:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbXGRE0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 00:26:08 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:56712 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbXGRE0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 00:26:06 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Wed, 18 Jul 2007 10:19:29 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Uwe Kleine-Konig <ukleinek@informatik.uni-freiburg.de>,
       Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] UP: smp_call_function_single() must warn on irqs_disabled()
In-Reply-To: <Pine.LNX.4.64.0707180934580.31117@cselinux1.cse.iitk.ac.in>
Message-ID: <Pine.LNX.4.64.0707181016380.32074@cselinux1.cse.iitk.ac.in>
References: <20070717232446.GA20140@lala> <20070717235400.GQ21668@ftp.linux.org.uk>
 <Pine.LNX.4.64.0707180934580.31117@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007, Satyam Sharma wrote:

> On Wed, 18 Jul 2007, Al Viro wrote:
> 
> > On Wed, Jul 18, 2007 at 01:24:46AM +0200, Uwe Kleine-Konig wrote:
> > > [...]
> > > a52b1752c07 introduces usage of the WARN_ON macro in <linux/smp.h>, but
> > > doesn't pull in <linux/kernel.h>.  (<asm/bug.h> is not enough, at least
> > > for arm, because WARN_ON uses printk there.)
> > > 
> > > The obvious options are:
> > > 
> > > 1) include <linux/kernel.h> in <linux/smp.h>, maybe conditioned by !SMP
> > > 2) include <linux/kernel.h> in all includers of <linux/smp.h>
> > > 3) remove the WARN_ONs introduced by a52b1752c07.
> > > [...]
> > 
> > 4) turn the sucker into macro
> 
> 
> I think that warning is incorrect anyway ... and I'm to blame
> for that. What happened is that I had earlier (month or two back,
> _before_ the recent change in smp_call_function_single() semantics)
> submitted a patch that put an unconditional WARN_ON(1) in this
> function for UP -- in those days, both the smp_call_function*
> variants were illegal on the current CPU itself.
> ( http://lkml.org/lkml/2007/6/7/262 )
> 
> Then recently, Andi / Avi proposed the new semantics for
> smp_call_function_single() to allow it to just execute the given
> function on current CPU as well -- smp_call_function() semantics
> were left unchanged, so as not to break stuff like smp_send_stop().
> 
> I think I got confused and recommended the (cpuid != 0) warning,
> but I don't really think it is necessary with new semantics --
> sorry about this, Avi.
> 
> OTOH, the function _should_ include a WARN_ON, but for a different
> condition -- irqs_disabled(), as explained in changelog below.

But on third thoughts, we shouldn't be executing that function locally
for UP if cpuid != 0 anyway, so my earlier suggestion wasn't really
erroneous ... perhaps *both* those warnings are required (well, the
irqs_disabled() one definitely is, at least).
