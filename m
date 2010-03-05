Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab0CEJbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 04:31:53 -0500
Received: from smtp.citrix.com ([66.165.176.89]:22927 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab0CEJbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 04:31:51 -0500
X-IronPort-AV: E=Sophos;i="4.49,586,1262581200"; 
   d="scan'208";a="7452357"
Subject: Re: [PATCH 6/7] xen: Enable PV clocksource for HVM
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Sheng Yang <sheng@linux.intel.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>
In-Reply-To: <201003051054.50535.sheng@linux.intel.com>
References: <1267695416-14988-1-git-send-email-sheng@linux.intel.com>
	 <1267695416-14988-7-git-send-email-sheng@linux.intel.com>
	 <4B8FF0A3.9060305@goop.org>  <201003051054.50535.sheng@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Fri, 5 Mar 2010 09:31:47 +0000
Message-ID: <1267781507.11737.36769.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 02:54 +0000, Sheng Yang wrote:
> On Friday 05 March 2010 01:40:51 Jeremy Fitzhardinge wrote:
> > On 03/04/2010 01:36 AM, Sheng Yang wrote:
> > > And enable it by default in PV extended HVM guest.
> > >
> > > Signed-off-by: Sheng Yang<sheng@linux.intel.com>
> > > ---
> > >   arch/x86/xen/hvmpv.c |   20 ++++++++++++++++++++
> > >   arch/x86/xen/time.c  |    4 +++-
> > >   2 files changed, 23 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/arch/x86/xen/hvmpv.c b/arch/x86/xen/hvmpv.c
> > > index 7a741ed..284e021 100644
> > > --- a/arch/x86/xen/hvmpv.c
> > > +++ b/arch/x86/xen/hvmpv.c
> > > @@ -43,6 +43,7 @@ static void __init xen_hvm_pv_banner(void)
> > >   		pv_info.name);
> > >   	printk(KERN_INFO "Xen version: %d.%d%s\n",
> > >   		version>>  16, version&  0xffff, extra.extraversion);
> > > +	printk(KERN_INFO "PV feature: PV clocksource enabled\n");
> > >   }
> > >
> > >   static int __init xen_para_available(void)
> > > @@ -117,6 +118,22 @@ static void __init init_shared_info(void)
> > >   	per_cpu(xen_vcpu, 0) =&HYPERVISOR_shared_info->vcpu_info[0];
> > >   }
> > >
> > > +extern struct clocksource xen_clocksource;
> > 
> > No externs in .c files.  But aside from that, I'd prefer you export a
> > function from xen/time.c to do the clocksource registration and call it
> > from both places (even if its a one-liner).
> 
> OK
> > 
> > > +
> > > +static void __init init_pv_clocksource(void)
> > > +{
> > > +	if (enable_hvm_pv(HVM_PV_CLOCK))
> > > +		BUG();
> > 
> > BUG is a bit severe.  Will it really never, ever fail?  And if it does,
> > the consequence is hardly serious; we just fall back to emulated devices.
> 
> It shouldn't fail. If we got a hypervisor without these extension, this one 
> won't be called. Because the feature should be detected by CPUID, and the 
> hypervisor would mask the unsupported features. So the guest won't see that 
> bit if it's not supported, and this one wouldn't be involved.

It is still possible that a hypervisor might want to turn on the general
extensions but not the PV clock extensions, and we can't predict what
reasons we might have for doing that in the future. A BUG() is an
awfully big hammer for a failure like this and destroys any hope of
making changes in a forward/backward compatible manner in the future.
Surely it is possible to simply continue with non-PV clock?

Ian.


