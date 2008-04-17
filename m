Return-Path: <linux-kernel-owner+w=401wt.eu-S933798AbYDQRHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933798AbYDQRHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 13:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765914AbYDQRH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 13:07:26 -0400
Received: from outbound-mail-10.bluehost.com ([69.89.17.210]:45387 "HELO
	outbound-mail-10.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1765532AbYDQRHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 13:07:25 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: Mapping PCI BAR through /sys/devices/pci* sets cache-disableandwrite-through
Date: Thu, 17 Apr 2008 10:07:17 -0700
User-Agent: KMail/1.9.9
Cc: "Keith Packard" <keithp@keithp.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
References: <1208367626.5245.5.camel@koto.keithp.com> <1208409631.10327.5.camel@koto.keithp.com> <924EFEDD5F540B4284297C4DC59F3DEEE5D0C7@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEE5D0C7@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804171007.17898.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 216.239.45.19 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 17, 2008 6:14 am Pallipadi, Venkatesh wrote:
> >Jesse Barnes suggested using the fact that the BAR was prefetchable to
> >guess that this region should not be mapped UC. I don't know of any
> >other information available at this API that would help make a better
> >choice; there are no ioctls on /sys files that we could use to
> >manipulate the mapping.
>
> Yes. But, the API being there for some time may mean that there is some
> user who always wants UC behavior with or without PREFETCHABLE flag.
> With PAT changes we thought of ioctl and then settled on new interface.

Yeah, we can't really know.  There *probably* aren't any users here that would 
break, but you never know, and it's best not to change the behavior of an 
existing API...

> >Yeah, we'll do that when it becomes available. Would it make sense in
> >the pre-PAT world to use Jesse's guess?
>
> Yes. Easiest way to do that will be to use UC_MINUS (Just set PCD bit
> and not PWT bit) until PAT changes.
> Ioremap() uses UC_MINUS, it should not have any side effects to other
> users who expect this mapping to be UC without any MTRR setting.

We could probably do that unconditionally though, rather than dependent on the 
prefetchable bit like my patch does.

> >In any case, we'll continue to use the fact that mprotect is
> >also broken
> >to get our WC mapping working (using mprotect PROT_NONE followed by
> >mprotect PROT_READ|PROT_WRITE causes the CD and WT bits to get
> >cleared).
> >We're fortunate in this case that we've found a bug to exploit that
> >gives us the desired behaviour.
>
> Noo.. Now we have one more thing in PAT to do list :-(. To go and plug
> those mprotect APIs to prevent users from doing things like this.

I think it's just a long standing bug...  mprotect really shouldn't be 
clobbering PTE bits regardless of PAT (though with PAT the bug becomes more 
serious).

Jesse
