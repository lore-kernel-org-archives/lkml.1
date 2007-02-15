Return-Path: <linux-kernel-owner+w=401wt.eu-S1751785AbXBOXnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbXBOXnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:43:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbXBOXnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:43:01 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:59209 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751785AbXBOXnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:43:00 -0500
Message-ID: <45D4F003.4030502@vmware.com>
Date: Thu, 15 Feb 2007 15:42:59 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Alan <alan@lxorguk.ukuu.org.uk>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 9/11] Panic delay fix
References: <200702060353.l163rUmj000771@zach-dev.vmware.com> <20070206122729.GC47229@muc.de> <45C8FA2D.6010706@vmware.com> <20070207123552.GD4481@ucw.cz> <1170880572.11736.4.camel@localhost.localdomain> <20070214125216.2befda78@localhost.localdomain> <45D36B49.5090109@vmware.com> <20070215101713.GK26240@elf.ucw.cz>
In-Reply-To: <20070215101713.GK26240@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>
> You know it is ugly. Alan demonstrated it even hurts performance, but
> being ugly is the main problem.
>   

No argument with that.  Well, we're ok with dropping it.  Actually, 
reverting the entire set of udelay changes now seems wise.  The same bug 
that happened with i8042 can happen with any hardware device driven by 
the VM in passthrough mode - potentially USB or IDE CDROM or direct SCSI.

Since that is per-device and not global, a global udelay disable really 
is broken in that case, and recompiling individual C files or modules 
for passthrough vs. non-passthrough is not the answer.

So Rusty, Chris, Jeremy, any objections to killing udelay() and friends 
in paravirt-ops?  It would simplify things a bit.  The only thing we 
lose is a slightly faster boot time in the 100% emulated device case.  
I'm ok with losing that.  Even the PIT fast paths don't use udelay, so I 
don't think we care for runtime performance at all.

Zach
