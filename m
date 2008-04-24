Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbYDXEBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbYDXEBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 00:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbYDXEBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 00:01:10 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:13351 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbYDXEBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 00:01:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Qn1MKkEH8AX/X0dwNP23EmC+6WTPU5Cn885xoCrste8Sy5gPpnqDh3qrFPQ7zE9ZHQHbQmONUazl+33F/sgMRMds510M/yP0LA3y+JNICxA78mp7Up005qZUTfbyQZYMm3+I46EFEhMX8q6SZBMHmk5yE1ok0gXhG+GE2Hd2Bmw=
Message-ID: <97a0a9ac0804232101i71bfff22o723e2aaa80b09c2f@mail.gmail.com>
Date: Wed, 23 Apr 2008 22:01:07 -0600
From: "Gordon Farquharson" <gordonfarquharson@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: physmap and "request_module: runaway loop modprobe net-pf-1"
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, davem@davemloft.net,
       netdev@vger.kernel.org
In-Reply-To: <1208867831.9212.582.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <97a0a9ac0803112235l157706adoa84b131549a46049@mail.gmail.com>
	 <20080311225926.6515e18c.akpm@linux-foundation.org>
	 <1208867831.9212.582.camel@pmac.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David

On Tue, Apr 22, 2008 at 6:37 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Tue, 2008-03-11 at 22:59 -0700, Andrew Morton wrote:
>
> > Now, af_unix_init() uses module_init(), which is really __initcall(), which
>  > is really device_initcall() (ug, don't ask).
>
>  ... which is really __define_initcall("6", ...);.
>
>
>  > So you can do what you're sugesting here by locating the caller/callers of
>  > parse_mtd_partitions() and marking them late_initcall().
>
>  Better still, just initialise af_unix earlier so that it's there before
>  any normal drivers which happen to call request_module(). Since core
>  network stuff is initialised with subsys_initcall() which is really
>  __define_initcall("4", ...), we can initialise af_unix with
>  fs_initcall() which is really __define_initcall("5", ...).

I tested the patch you sent. It fixes the runaway modprobe messages,
but I get a modprobe error (see below) with the Debian kernel I used
to test the patch because modules.dep does not exist in the initramfs
(should it?). In my kernel config, I did not enable
CONFIG_MTD_CMDLINE_PARTS and I set CONFIG_MTD_REDBOOT_PARTS=m but the
redboot module was not included in the initramfs so it could not be
loaded, hence the messages saying that the parsing schemes are not
available.

[    4.790000] physmap platform flash device: 00080000 at f0000000
[    4.800000] Found: ST M29W400DB
[    4.800000] physmap-flash.0: Found 1 x16 devices at 0x0 in 16-bit bank
[    4.810000] number of JEDEC chips: 1
[    4.810000] cfi_cmdset_0002: Disabling erase-suspend-program due to
code brokenness.
modprobe: FATAL: Could not load
/lib/modules/2.6.25-trunk-iop32x/modules.dep: No such file or
directory

[    4.900000] cmdlinepart partition parsing not available
modprobe: FATAL: Could not load
/lib/modules/2.6.25-trunk-iop32x/modules.dep: No such file or
directory

[    4.970000] RedBoot partition parsing not available

I guess the question is which patch (if either) is more appealing.

Gordon

-- 
Gordon Farquharson
GnuPG Key ID: 32D6D676
