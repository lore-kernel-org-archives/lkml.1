Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbYHPDTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbYHPDTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 23:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYHPDTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 23:19:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61212 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbYHPDTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 23:19:08 -0400
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
From: Kay Sievers <kay.sievers@vrfy.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, rusty@rustcorp.com.au
In-Reply-To: <48A64235.2030108@linux.intel.com>
References: <20080814172945.250a27f2.sfr@canb.auug.org.au>
	 <20080814083828.d10e126d.randy.dunlap@oracle.com>
	 <3ae72650808150427q364842ccicf0a0978b30ca98c@mail.gmail.com>
	 <20080815085836.67e420f1.randy.dunlap@oracle.com>
	 <1218854219.3629.30.camel@lgn.site>  <48A64235.2030108@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Date: Sat, 16 Aug 2008 05:19:58 +0200
Message-Id: <1218856798.3629.45.camel@lgn.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX1/5afgW/PQN5F7os22oVNnsNGPfCmS1Oi9fXs5
 o2CWTXEZmJiXMVQPupclrKNB2lF7pBsJtVFiltEwuzcpNPbsFY
 tYTUOoxXSMDHCFIn/v9VMqTd9JjLaSR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-16 at 04:57 +0200, Andi Kleen wrote:
> >> Extract is:
> >>
> >> XXX adding modparam:'acpi.power_nocheck' 34 (ffffffff806a4cf0)
> > ...
> >> XXX adding modparam:'acpi.acpica_version' 45 (ffffffff806a4ea8)
> > 
> > Two different "modules" use the same prefix, which does not work with
> > the current logic, they need to live next to each other in the sequence
> > of options.
> 
> Sequence of options being defined by link order?

Yeah, they are stored in a global array __start___param, and the current
code expects the prefixes to be sorted, so the sysfs directories can be
created for every first new prefix.

> > This adds a new option:
> >   http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=1382827e93799ec07790849e361267993cfe549e
> > ﻿which specifies ﻿MODULE_PARAM_PREFIX="acpi." in:
> >   drivers/acpi/power.c
> > In the same way as:
> >   drivers/acpi/system.c
> > 
> > Seems, two different modules should not declare parameters in different
> > locations, and use the same MODULE_PARAM_PREFIX.
> 
> That seems bogus to me. Assuming we have some code in a module and then split
> it out into two different modules. Or move an option from one file to another.
> Would we need to change the option name then?

They have been module options, not prefixed kernel parameters so far,
and the prefix was just the module name.
So it just strikes back, that acpi uses generic names for the modules,
there would have been no problem if "power" would be called "acpi_power"
and the options would just be ﻿"acpi.acpica_version" and
"acpi_power.nocheck".

But well, there are driver modules just called "option", so acpi is not
that bad. :)

> I think the generic params code should be fixed to handle this.

We could try to look up existing directories to use instead of expecting
that we need to create and own them. I guess, we have the same issue if
we compile the code as a module and load it later, while some other
built-in code or module has already used the same prefix.

Kay

