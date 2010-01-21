Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080Ab0AUQal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab0AUQal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662Ab0AUQak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:30:40 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41968 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab0AUQaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:30:39 -0500
Date: Thu, 21 Jan 2010 17:30:48 +0100
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@elte.hu, tglx@linutronix.de, andreas.herrmann3@amd.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86, cacheinfo: Fix disabling of L3 cache indexes
Message-ID: <20100121163048.GB10321@aftab>
References: <1263899279-30739-1-git-send-email-bp@amd64.org>
 <1263899279-30739-2-git-send-email-bp@amd64.org>
 <4B578C0E.5090709@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B578C0E.5090709@zytor.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 03:04:46PM -0800, H. Peter Anvin wrote:
> On 01/19/2010 03:07 AM, Borislav Petkov wrote:
> >  
> > +static void __wbinvd(void *dummy)
> > +{
> > +	asm volatile("wbinvd" : : : "memory");
> > +}
> > +
> 
> [...]
> 
> > +	smp_call_function_single(cpu, __wbinvd, NULL, 1);
> 
> I really don't like this combination.
> 
> First of all, it's an asm version of an instruction we already have
> macros for.  This should probably just be wbinvd(), or *possibly*
> native_wbinvd(), although that would have to be justified -- especially
> since the preexisting code used wbinvd().

The preexisting code using wbinvd is a bug since wbinvd has to happen on
a core which contains the L3 cache whose indices(!) we disable.

But yeah, a wbinvd smp version is a bit problematic since
smp_call_function_* expects a function pointer which has a void *
argument but native_wbinvd() has no args. By the way, there's a similar
thing in <drivers/char/agp/intel-agp.c::do_wbinvd()>

> Second, it's pretty obvious that the only reason for this function at
> all is to provide a wrapper that can be passed to smp_call_function*().
>  It would be a lot cleaner to have a small function wbinvd_on_cpu(cpu)
> as a wrapper for the higher-order functionality.

Done, see my next patch series.

-- 
Regards/Gruss,
Boris.

-
Advanced Micro Devices, Inc.
Operating Systems Research Center
