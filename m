Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbZF2Lvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbZF2Lvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 07:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbZF2Lvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 07:51:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:22361 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbZF2Lvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 07:51:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,309,1243839600"; 
   d="scan'208";a="703395304"
Subject: Re: [PATCH v2] enable x2APIC without interrupt remapping under KVM
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Gleb Natapov <gleb@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>
In-Reply-To: <20090629112531.GA20289@redhat.com>
References: <20090629100837.GW20289@redhat.com>
	 <1246272416.27006.10632.camel@localhost.localdomain>
	 <20090629112531.GA20289@redhat.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 29 Jun 2009 04:48:44 -0700
Message-Id: <1246276124.27006.10646.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-29 at 04:25 -0700, Gleb Natapov wrote:
> I left interrupt masking in enable_IR_x2apic() because interrupt should
> be masked during transition to x2apic mode, so it can't be moved to
> enable_IR(). I moved io-apic into enable_IR() because the state of
> io-apic depend on whether IR was enabled or not, so I left it close to
> IR enabling logic.

This can be based on the outcome of enable_IR().

>  Also io-apic masking can fail, but we still want to
> enable x2apic on KVM if possible, and moving io-apic masking to
> enable_IR_x2apic() will complicate the logic.

io-apic masking can fail because of memory allocation failures, right?
If we want a simple solution, we can skip both x2apic and IR. This is
not going to be common scenario anyhow. If we really hit this, we will
worry about more things than x2apic :)

> 
> > Can we keep it together so that it will be easy to read and understand
> > that we first do the interrupt subsystem mask, try enabling IR and
> > x2apic and  unmask the interrupt subsystem.
> > 
> For io-apic this is not 100% symmetric. We mask io-apic, enable IR and
> if this succeeds we do not unmask io-apic.

Correct. Can we do the same, otherwise we might have a situation (under
kvm atleast) where io-apic will be active while we will be changing the
cpu mode. Just trying to be defensive as these might lead to hard to
debug corner case conditions.

thanks,
suresh

