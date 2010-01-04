Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865Ab0ADDGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab0ADDGP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 22:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116Ab0ADDGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 22:06:13 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:49020 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab0ADDGM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 22:06:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mSbXu4oBioHqWysenclItqIjKPLaf7OgJBsh9FHusAM9fCVfsQsZUQuMqpoAavSLsD
         oe7kpD77A3Ia2AZYoNKydcTxBLPw9I2sZX9KLBuY7VvkXuwKKUfHWcrD6liIfMV1LxSW
         IDpfsB2I2tGecCo2wfDHIG0+RMAX2hy6cCJgw=
MIME-Version: 1.0
In-Reply-To: <4B398ECD.1080506@kernel.org>
References: <4B347AEE.6030705@kernel.org> <20091228094707.GH24690@elte.hu>
	 <4B398ECD.1080506@kernel.org>
Date: Sun, 3 Jan 2010 19:06:11 -0800
Message-ID: <4807377b1001031906s6b1ee576jc021da2642bb4147@mail.gmail.com>
Subject: Re: [PATCH -v2] x86: increase NR_IRQS and nr_irqs
From: Jesse Brandeburg <jesse.brandeburg@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDEV list <netdev@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 28, 2009 at 9:08 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> have a system with lots of igb and ixgbe, when iov/vf are enabled for
> them, we hit the limit of 3064.
>
> when system have 20 pcie installed, and one card have 2 functions, and one
> function need 64 msi-x,
>  may need 20 * 2 * 64 = 2560 for msi-x
> but if iov and vf are enabled
>  may need 20 * 2 * 64 * 3 = 7680 for msi-x
> assume system with 5 ioapic, nr_irqs_gsi will be 120.
> NR_CPUS = 512, and nr_cpu_ids = 128
> will have NR_IRQS = 256 + 512 * 64 = 33024
> will have nr_irqs = 120 + 8 * 128 + 120 * 64 = 8824
>
> when SPARSE_IRQ is not set, there is no increase with data
> when NR_CPUS=128, and SPARSE_IRQ is set
>   text            data     bss            dec           hex    filename
> 21837444        4216564 12480736        38534744        24bfe58 vmlinux.before
> 21837442        4216580 12480736        38534758        24bfe66 vmlinux.after
> when NR_CPUS=4096, and SPARSE_IRQ is set
>   text            data     bss            dec           hex    filename
> 21878619        5610244 13415392        40904255        270263f vmlinux.before
> 21878617        5610244 13415392        40904253        270263d vmlinux.after
>
> -v2: update comments to address Ingo's concern
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

I'm not sure this is the best plan, but may be okay for now.  What
happens when all of your slots have 6 port 82599 ixgbe adapters in
them?  They are being made[1], as well as quad port 82576 igb
adapters, however I'm not fully sure of the SRIOV support of the
bridges being used on those adapters.

Is it on the table to (re-)design this subsystem to be a little more
dynamic?  There are probably examples in ppc64 or ia64 directories.
Every time you suggest a limit I can find a case where it won't be
enough.

[1] http://www.hotlavasystems.com/products_10gbe.html
