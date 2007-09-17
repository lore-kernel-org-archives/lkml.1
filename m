Return-Path: <linux-kernel-owner+w=401wt.eu-S1757087AbXIQTPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbXIQTPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 15:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbXIQTP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 15:15:29 -0400
Received: from gw.goop.org ([64.81.55.164]:35114 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbXIQTP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 15:15:28 -0400
Message-ID: <46EED250.5080207@goop.org>
Date: Mon, 17 Sep 2007 12:15:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "Nakajima, Jun" <jun.nakajima@intel.com>
CC: Anthony Liguori <aliguori@us.ibm.com>, kvm-devel@lists.sourceforge.net,
       Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure
References: <11897991353793-git-send-email-aliguori@us.ibm.com><46EAF4C6.8090903@goop.org> <46EAF6FC.80207@codemonkey.ws><46EAFBA0.4020503@goop.org> <46EB0136.6080105@codemonkey.ws><46EB02BA.6030909@goop.org> <46EB0657.40603@codemonkey.ws> <97D612E30E1F88419025B06CB4CF1BE10379EBF9@scsmsx412.amr.corp.intel.com> <46EB1285.5050807@goop.org> <97D612E30E1F88419025B06CB4CF1BE10379ED0A@scsmsx412.amr.corp.intel.com> <46EB2716.1070908@goop.org> <97D612E30E1F88419025B06CB4CF1BE10379ED4C@scsmsx412.amr.corp.intel.com> <46EB6556.5020506@goop.org> <97D612E30E1F88419025B06CB4CF1BE10379EDA0@scsmsx412.amr.corp.intel.com> <46EC233B.5010209@us.ibm.com> <97D612E30E1F88419025B06CB4CF1BE1037F83EC@scsmsx412.amr.corp.intel.com>
In-Reply-To: <97D612E30E1F88419025B06CB4CF1BE1037F83EC@scsmsx412.amr.corp.intel.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nakajima, Jun wrote:
> Using CPUID.0x4000000N (N > 2) does not prevent Xen from doing that,
> either. If you use 0x40001000, 1) you need to say the leaves from
> 0x40000000 through 0x40001000 are all valid, OR 2) you create/fork a
> new/odd leaf (with 0x1000 offset) repeating the detection redundantly. 
>   

I don't see a particular problem with that.  If the whole 0x4xxxxxxx
range is reserved for hypervisor use, and existing hypervisors are
already using 0x400000xx in hypervisor-specific ways, then it makes
sense to start the generic stuff at 0x40001xxx (or some other offset). 
But without a few more implementations of the "generic" interface its
all a bit moot (ie, where's your code? ;).

> Again, 0x40000000 is not Xen specific. If the leaf 0x40000000 is used
> for any guest to detect any hypervisor, that would be compelling
> benefit. For future Xen-specific features, it's safe for Xen to use
> other bigger leaves (like 0x40001000) because the guest starts looking
> at them after detection of Xen. 
>
> Likewise if KVM paravirtualization interface (as kind of "open source
> paravirtualization interface") is detected in the generic areas (not in
> vender-specific), any guest can check the features available without
> knowing which hypervisor uses which CPUID for that. 
>   

This just seems a bit grotty.  You're relying on the fact that you can
overlay Xen's current use of 0x4000000x for the generic interface by
freezing Xen's current use of 40000000-2.  0x40000000 becomes a more or
less useless hypervisor-identification signature (useless because you
need to assume that leaves 4000000x, x>2 implement the generic interface
anyway, where x=1,2 are reserved for Xen (=hypervisor-specific) uses).

In other words, what mechanism can a guest use to explicitly identify
the existence of the generic interface?  There needs to be a signature
for that somewhere.

    J
