Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbYCLHHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbYCLHHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 03:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbYCLHGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 03:06:55 -0400
Received: from hs-out-0708.google.com ([64.233.178.246]:8379 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYCLHGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 03:06:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=D35yPNArwclc79ONbfEy7pJXZwhZXYQs8xsHNPWFh93BvLik+a6ezHnLut8VS1ruwhe/xbm+IIuyIicME2tox0sVizCon2VYv6VDhIdOWgFAwplMQNqhEK5poBtHQ5wU2MEENabgK0xI9XFOK/P4MKay1YtJbBvUtLkFD1P+uUc=
Message-ID: <97a0a9ac0803120006k30a0ef7dq7b67518bca384b03@mail.gmail.com>
Date: Wed, 12 Mar 2008 01:06:53 -0600
From: "Gordon Farquharson" <gordonfarquharson@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: physmap and "request_module: runaway loop modprobe net-pf-1"
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
In-Reply-To: <20080311225926.6515e18c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <97a0a9ac0803112235l157706adoa84b131549a46049@mail.gmail.com>
	 <20080311225926.6515e18c.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew

On Tue, Mar 11, 2008 at 11:59 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 11 Mar 2008 23:35:28 -0600 "Gordon Farquharson" <gordonfarquharson@gmail.com> wrote:

>  > Alternatively, if selecting CONFIG_MTD_PARTITIONS and not selecting
>  > both CONFIG_MTD_REDBOOT_PARTS and CONFIG_CMDLINE_PARTS, or selecting
>  > CONFIG_MTD_PARTITIONS and not selecting CONFIG_CMDLINE_PARTS and
>  > selecting CONFIG_MTD_REDBOOT_PARTS as a module, are valid
>  > configurations, it seems that parse_mtd_partitions() must be called
>  > only after af_unix_init() has been called. Is this possible?
>
>  Probably.
>
>  We can specify the order in which these things are called at compile-time.
>  See these, from include/linux/init.h:
>
>  #define core_initcall(fn)               __define_initcall("1",fn,1)
>  #define postcore_initcall(fn)           __define_initcall("2",fn,2)
>  #define arch_initcall(fn)               __define_initcall("3",fn,3)
>  #define subsys_initcall(fn)             __define_initcall("4",fn,4)
>  #define fs_initcall(fn)                 __define_initcall("5",fn,5)
>  #define rootfs_initcall(fn)             __define_initcall("rootfs",fn,rootfs)
>  #define device_initcall(fn)             __define_initcall("6",fn,6)
>  #define late_initcall(fn)               __define_initcall("7",fn,7)
>
>  Now, af_unix_init() uses module_init(), which is really __initcall(), which
>  is really device_initcall() (ug, don't ask).
>
>  So you can do what you're sugesting here by locating the caller/callers of
>  parse_mtd_partitions() and marking them late_initcall().

Thanks very much for the explanation.

It looks like there could be up to 38 distinct callers of
parse_mtd_partitions(), and I expect that one would need to test all
of the various platforms on which these calls occur to ensure that
there were no regressions introduced by the change, so this option
scares me a little.

$ grep parse_mtd_partitions -r * | wc -l
38

>  I'd suggest that you make your own decision as to what is the best fix, then
>  send a patch.  Please cc me on it and I'll make sure that it gets
>  appropriately handled.  This may take a bit of time, as the MTD patch
>  backlog is rather large at present.

I'll see how the MTD guys respond today, and then submit a patch
later. I like option 1, but they may have a good reason for needing to
compile a parser as a module, or they may propose a completely
different solution. Right now, there is only one defconfig that has
CONFIG_REDBOOT_MTD_PARTS=m:

arch/mips/configs/mtx1_defconfig:CONFIG_MTD_REDBOOT_PARTS=m

Thanks very much for the input.

Gordon

-- 
Gordon Farquharson
GnuPG Key ID: 32D6D676
