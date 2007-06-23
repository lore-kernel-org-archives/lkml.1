Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbXFWLIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbXFWLIl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 07:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbXFWLIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 07:08:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48823 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709AbXFWLId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 07:08:33 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Yinghai Lu <Yinghai.Lu@sun.com>
Subject: Re: [PATCH] x86-64: disable the GART in shutdown
Date: Sat, 23 Jun 2007 13:08:30 +0200
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200706221219.16243.yinghai.lu@sun.com> <467C6906.6020105@sun.com> <200706221934.59966.yinghai.lu@sun.com>
In-Reply-To: <200706221934.59966.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706231308.30403.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 June 2007 04:34:59 Yinghai Lu wrote:
> [PATCH] x86-64: disable the GART in shutdown
> 
> For K8 system: 4G RAM with memory hole remapping enabled, or more than 4G RAM
> installed. when mem is allocated for GART, it will do the memset for clear.
> and for kexec case, the first kernel already enable that, the memset in second
> kernel will cause the system restart. solution will be:
> in second kernel: disable that at first before we try to allocate mem for it.
> or in the first kernel: do disable that before shutdown.

I thought we agreed it wasn't needed for the kdump case? Or rather
the only way to fix kdump was to reserve or better not use GART. Just disabling
it is not enough because it could be eventually reenabled and any
in flight DMAs could hit innocent memory.

For kexec it would be sufficient to do it in a platform device hook.

Also I'm a little uneasy in doing PCI access that late in reboot.
While there is luckily no bridge involved here it is still risky
after possibly other PCI hardware has been disabled.

So my suggestion would be: 

(1) implement sysfs platform device based shutdown hooks (preferable
before PCI shutdown) 
(2) make sure GART is never enabled in kernels that are all < 4GB (as 
in the kdump kernel). But what to do about AGP? 

-Andi

