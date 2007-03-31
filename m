Return-Path: <linux-kernel-owner+w=401wt.eu-S933535AbXCaDAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535AbXCaDAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 23:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933544AbXCaDAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 23:00:46 -0400
Received: from gw.goop.org ([64.81.55.164]:56692 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933535AbXCaDAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 23:00:46 -0400
Message-ID: <460DCED9.7050509@goop.org>
Date: Fri, 30 Mar 2007 20:00:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 4/6] Convert PDA into the percpu section
References: <20070331020042.003398870@goop.org>	<20070331020055.075978807@goop.org> <200703310435.59298.ak@suse.de>
In-Reply-To: <200703310435.59298.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Saturday 31 March 2007 04:00, Jeremy Fitzhardinge wrote:
>   
>> Currently x86 (similar to x84-64) has a special per-cpu structure
>> called "i386_pda" which can be easily and efficiently referenced via
>> the %fs register.  An ELF section is more flexible than a structure,
>> allowing any piece of code to use this area.  Indeed, such a section
>> already exists: the per-cpu area.
>>     
>
> Hmm, I'm a little reluctant. This moves i386 more away from x86-64
> again. If we ever merge them it would mean more work. Do you really need it?

It cleans things up a fair bit:

   1. At initialization, it doesn't require %fs to be loaded before
      being able to use per-cpu variables, since you can use percpu with
      %fs set to a plain 0-based 4G segment; you can defer
      initialization until SMP bringup (which is never on a UP kernel).
      PDA requires %fs to be specially set up to point to an initial
      PDA, which includes setting up a gdt entry, generally before C
      code is run.  For paravirtualized boot, this setup needs to be
      replicated by each hypervisor startup sequence; without the PDA,
      it becomes a non-issue (especially since hypervisors typically
      start up with %fs as a flat segment anyway).  Overall, both UP and
      SMP boot is simpler and less fragile.
   2. Adding things to the pda requires changing <asm/pda.h>, which
      often means including extra headers to allow added definitions. 
      Since pda.h is used to implement things like "current" and
      "smp_processor_id", it gets included everywhere.  Any header
      included in <asm/pda.h> effectively gets included everywhere in
      the kernel.  Also, it turns pda.h into a concentrated nest of
      patch conflicts.  percpu requires no central modifications to add
      a new percpu variable.
   3. There's no disadvantage to using a percpu at all, especially if
      you can use the x86_*_percpu functions which allow direct access
      to the variable via %fs.  If one construct will do, why have two? 
      Removing the pda removes quite a bit of unnecessary code.
   4. I think, ultimately, it would be better to migrate x86_64 away
      from using the pda to all percpu too, though this has some tricky
      bits for now.

Certainly, not having this patch at this stage will require me to rework
quite a few of the later patches.  I was going to put off sending out
this patch until later, but reworking everything to work both with pda
and percpu was so fragile and tricky-bug-prone that I decided to push it
early and save myself a lot of work.

    J
