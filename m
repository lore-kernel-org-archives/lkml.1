Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbZJMVM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbZJMVM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761355AbZJMVM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:12:28 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:59168 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761354AbZJMVM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:12:26 -0400
From: Thomas Schlichter <thomas.schlichter@web.de>
To: Eric Anholt <eric@anholt.net>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not available
Date: Tue, 13 Oct 2009 23:05:59 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.28.10-modified-ioremap; KDE/4.3.2; i686; ; )
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jan Beulich <jbeulich@novell.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@jbarnes-g45>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Robert Hancock <hancockrwd@gmail.com>
References: <200910122032.52168.thomas.schlichter@web.de> <200910122145.38067.thomas.schlichter@web.de> <1255378684.2063.5.camel@gaiman.anholt.net>
In-Reply-To: <1255378684.2063.5.camel@gaiman.anholt.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200910132306.00089.thomas.schlichter@web.de>
X-Provags-ID: V01U2FsdGVkX19p9PbOFoEYt4VGZnOCW+11jyc5tdumOdim/2pO
	UbwkWa9EVOgR4I4xi0o+S8/yVytjBEEejOLAVEBvyXoULcyKqI
	Qfe/TCwmA5F28hJrN+RQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Anholt wrote:
> On Mon, 2009-10-12 at 21:45 +0200, Thomas Schlichter wrote:
> > Yes, maybe this patch tries to change current behavior too less. Indeed,
> > if setting up MTRR entries it simply behaves as today, and userspace does
> > not see that write combining is not correctly enabled.
> 
> I'm uncomfortable with this patch because it doesn't appear to cover any
> callers of these functions inside of the kernel.  Have you audited them
> to make sure they can handle NULL being returned?

No, I haven't. And to be honest, I think the earlier patch that adds MTRR 
entries should be more safe, as it modifies behavior only slightly.

> Seems like we should install an MTRR instead.  Requiring userland to set
> up the MTRR on the kernel's behalf is backwards.

Exactly.

> With modern drivers we're installing any required MTRRs at module load
> in the kernel, and that's where things should be moving.

I think in general this is not possible, because not for all graphics chips 
there are kernel drivers (required). E.g. for my VIA VX800 based notebook, 
there is no kernel module that should be responsible to set-up the MTRR 
entries. Here it's up to the (userspace) X.org driver. It opens the 
/sys/bus/pci/devices/.../resource0_wc device and mmaps the framebuffer memory. 
With PAT this will set up a write combining memory area, and with my first 
patch this should also happen without PAT with MTRR.

> As long as
> this doesn't interfere with them, I'm OK.  And if some kernel driver is
> failing to install its MTRR, well, let's fix it.

Well, I think the mtrr_add inside mmap should not do any harm...

Kind regards,
  Thomas
