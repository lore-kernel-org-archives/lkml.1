Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbZG1D2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbZG1D2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 23:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZG1D2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 23:28:30 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:46745 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbZG1D2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 23:28:30 -0400
MIME-Version: 1.0
In-Reply-To: <20090728011943.589176cb@lxorguk.ukuu.org.uk>
References: <1248132223.2654.278.camel@localhost> <alpine.LRH.2.00.0907211258110.32400@tundra.namei.org> 
	<1248187482.19456.90.camel@moss-lions.epoch.ncsc.mil> <alpine.LRH.2.00.0907221953190.15799@tundra.namei.org> 
	<20090728011943.589176cb@lxorguk.ukuu.org.uk>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Mon, 27 Jul 2009 23:28:09 -0400
Message-ID: <f73f7ab80907272028y3b9451b4s4997308b6d9ec79a@mail.gmail.com>
Subject: Re: mmap_min_addr and your local LSM (ok, just SELinux)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Morris <jmorris@namei.org>, James Carter <jwcart2@tycho.nsa.gov>,
       Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       Stephen Smalley <sds@tycho.nsa.gov>, spender@grsecurity.net,
       Daniel J Walsh <dwalsh@redhat.com>, cl@linux-foundation.org,
       Arjan van de Ven <arjan@infradead.org>, kees@outflux.net,
       Chad Sellers <csellers@tresys.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 20:19, Alan Cox<alan@lxorguk.ukuu.org.uk> wrote:
> A dumb question perhaps, but while addling my brain over the tty layer I
> was wondering if for the specific case of jump through NULL (which seems
> to be the most common but by no means only problem case that gets
> exploited) is there any reason we can't set a default breakpoint for
> executing 0 and fix that up as a trap in the kernel ?
>
> Even user code that needs zero page mapped such as BIOS hackery doesn't
> actually jump through zero often if ever, and would be a userspace not a
> kernel space trap source so could be fixed up.
>
> Just a random "I've been staring at code too long today" thought ?

Alternatively, since such emulation code is almost certainly not
performance sensitive, perhaps it's possible to go the kmemcheck-style
route?  We could probably "allow" userspace mappings of pages below
mmap_min_addr for unprivileged processes by trapping and
single-stepping the appropriate memory access instructions.

Every time anything tries to access that memory it would trigger a
fault; if the code is in kernel space we BUG() and dump a nastygram to
dmesg.  For anything else, we either temporarily map the page and
single-step or simply emulate the instruction.  Sure, it might be slow
as hell... but the unprivileged use-cases seem to be few and
far-between.

Cheers,
Kyle Moffett
