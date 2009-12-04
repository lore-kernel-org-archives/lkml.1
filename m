Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbZLDWjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbZLDWjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZLDWjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:39:15 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42880 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZLDWjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:39:14 -0500
Date: Fri, 4 Dec 2009 23:39:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Cihula, Joseph" <joseph.cihula@intel.com>,
       "Wang, Shane" <shane.wang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>
Subject: Re: [PATCH] intel_txt: add s3 userspace memory integrity
 verification
Message-ID: <20091204223913.GG32314@elf.ucw.cz>
References: <4A9CE0B2.5060608@intel.com>
 <4ABF2B50.6070106@intel.com>
 <20091004185801.GC1378@ucw.cz>
 <037F493892196B458CD3E193E8EBAD4F01F03277DF@pdsmsx502.ccr.corp.intel.com>
 <20091204081933.GE1540@ucw.cz>
 <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD4C5@orsmsx506.amr.corp.intel.com>
 <20091204221553.GD32314@elf.ucw.cz>
 <4B198C18.7040500@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B198C18.7040500@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-12-04 14:24:24, H. Peter Anvin wrote:
> On 12/04/2009 02:15 PM, Pavel Machek wrote:
> >>>
> >>> Are  you sure x86-64 kernel & modules is always below 4GB? I don't
> >>> think so.
> 
> The x86-64 kernel is run where it is loaded by the boot loader.  For
> most boot loaders, that will mean < 4 GB.  This is not the case for
> modules, and they cannot and should not rely on modules inside
> restricted zone.
> 
> This effectively becomes a constraint on whatever boot loader is used to
> load the kernel for it to be compatible with tboot.

Having "security" technology that silently fails with funny bootloader
is pretty bad, I'd say.

Instead of doing this properly (in tboot), Joseph hopes to save some
work by basically splitting kernel into two parts, "trusted" and
"untrusted". But doing that properly would be too much work, so he
just handwaves and hopes for the best.

Unfortunately that

a) does not work (panic, printks)

b) places funny constraints all over the code (documenting them would
be too much work, so we get more handwaving)

c) reduces future flexibility (trusted code can not be over 4GB, it is
silent security hole when it is) 

I'd prefer to see this done properly; tboot should simply verify all
the memory for us. It is separate piece of code, trusted, and can
probably fit itself under 4GB.

If that seems like too much work, then please go all over the code,
and mark all the code that is "trusted" (has to be under 4GB) and
properly document it, so that future modifications will not break that
assumption. Putting all that code into one section should be enough.

(Going into infinite loop is probably enough when memory corruption is
detected; there's no chance you can put printk/panic/neccessary
drivers all into the "trusted" section.)

Aha, and look. Your tboot_gen_mem_integrity is ran on resume, so it is
"trusted". Unfortunately, it calls crypto_alloc_hash, so you need to
audit that, and probably kmalloc it boils down into. I bet kmalloc
touches memory >4GB. And I bet crypto modules can be
... well... modules. That means over 4GB.

This is broken by design, right?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
