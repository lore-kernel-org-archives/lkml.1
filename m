Return-Path: <linux-kernel-owner+w=401wt.eu-S1761815AbYBLTje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761815AbYBLTje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbYBLTjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:39:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbYBLTjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:39:24 -0500
Date: Tue, 12 Feb 2008 14:34:51 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] kgdb-light -v10
Message-ID: <20080212193451.GE19619@redhat.com>
References: <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <20080212135027.GA1343@one.firstfloor.org> <20080212152846.GC3078@elte.hu> <alpine.LFD.1.00.0802120829410.2920@woody.linux-foundation.org> <20080212182024.GA4940@one.firstfloor.org> <20080212102010.d88886f3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212102010.d88886f3.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, Feb 12, 2008 at 10:20:10AM -0800, Andrew Morton wrote:
> [...]  Bear in mind that one of the things you do with kgdb is to
> modify kernel memory [...]

Just for completeness, keep in mind that one can already 
do these sorts of things on a batch basis using systemtap:


> int foo;
> 	...
> 	if (foo == 1)
> 		special_stuff();
> 	...
> 
> to trigger a particular behaviour at a particular time.  [...]

If "foo" is a global within a particular compliation unit, any old
function in that CU can be probed to set/get the global.  (Setting
incoming function parameters works too.)

# cat delayed-set.stp
   # set a systemtap script variable based on a /proc control file
   probe procfs("activate").write { setit = $value }
   global setit
   # check the systemtap global in order to set the kernel global
   probe kernel.function("foo_checking_fn") { 
      if (setit=="1") { setit = ""; $foo = 1 }
   }
# stap -g -m ds delayed-set.stp &
# echo 1 > /proc/systemtap/ds/activate


> OT: another thing you can do with kgdb is error-path testing:
> 	foo = kmalloc(...)
> BP->	if (!foo)
> 		recover();
> put a breakpoint on the !foo test and set foo to zero by hand.

# cat setit2.stp
  probe kernel.statement("*@dir/function.c:222") { /*if (desired)*/ $foo = 0 }
# stap -g setit2.stp &


- FChE
