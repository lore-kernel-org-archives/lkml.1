Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbYADOmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbYADOmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 09:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYADOl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 09:41:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36876 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbYADOl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:41:58 -0500
Date: Fri, 4 Jan 2008 15:41:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH x86] [5/16] Replace hard coded reservations in x86-64
	early boot code with dynamic table II
Message-ID: <20080104144140.GA4203@elte.hu>
References: <20080103442.621670000@suse.de> <20080103154218.F294E14DDB@wotan.suse.de> <20080104090052.GE28740@elte.hu> <200801041338.08093.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801041338.08093.ak@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> On Friday 04 January 2008 10:00:52 Ingo Molnar wrote:
> > 
> > * Andi Kleen <ak@suse.de> wrote:
> > 
> > > On x86-64 there are several memory allocations before bootmem. To 
> > > avoid them stomping on each other they used to be all hard coded in 
> > > bad_area(). Replace this with an array that is filled as needed.
> > > 
> > > This cleans up the code considerably and allows to expand its use.
> > 
> > this code introduces a number of style errors that make the code harder 
> > to read and follow. Please fix them.
> 
> I reviewed the code now and I honestly don't see any "style errors" so 
> I don't know how to change it.
> 
> -Andi 

there are 7 style problems in the patch. Checkpatch.pl gives two:

 ERROR: use tabs not spaces
 #92: FILE: arch/x86/kernel/e820_64.c:89:
 + ^I}$

 ERROR: use tabs not spaces
 #135: FILE: arch/x86/kernel/e820_64.c:107:
 + ^I}$

 total: 2 errors, 0 warnings, 308 lines checked

i'm not sure how you manage patches - if you have some 'refresh patch' 
command then you might want to stick a call to scripts/checkpatch.pl in 
there. I have such a check included in my quilt refresh shortcut.

#3:

 +       int i;
 +       struct early_res *r;
 +       for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
 +               r = &early_res[i];

newline needed after the variables.

#4:

  void __init early_res_to_bootmem(void)
  {
          int i;
          for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
          struct early_res *r = &early_res[i];
                  reserve_bootmem_generic(r->start, r->end - r->start);

the variables definition here is totally misaligned.

#5:

+       int changed = 0;
+again:
+       last = addr + size;

newline needed before the 'again:'.

#6:

+               struct early_res *r = &early_res[i];
+               if (last >= r->start && addr < r->end) {

newline needed after the variables.

#7:

+               unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
+               reserve_early(ramdisk_image, ramdisk_end);

newline needed after the variables.

from your other mail:

> [...] Also I didn't realize that white space was more important than 
> seriously cleaner code now.

here's my opinion about this topic:

- style cleanliness is an admittedly secondary concept but it 
  strengthens the most important, primary aspect of any code: 
  readability and maintainability.

- sloppy style is also often a statistical indicator for sloppy quality: 
  code written in rush, not reviewed and not read well enough. I'm not 
  implying anything like that about this patch of yours, but it's a 
  general policy and you'd sure agree that writing 100% clean code is 
  not that much harder than just writing good code.

- cleanup is generally pushed back to patch submitters - this 
  distributes better as it removes load from maintainers (and subsequent 
  patch developers).

- it's also a matter of visual taste. People are more likely to fix and 
  improve clean _looking_ code than messy looking code. It's often the 
  first stepping stone towards reaching structural cleanliness. And 
  frankly, rarely have i seen any genuinely clean code that had a messy 
  style - messy visual output is usually the mirror image of lack of 
  interest or lack of time. (i'd be glad if anyone could point me 
  towards any genuinely clean code within the kernel that nevertheless 
  has messy style.)

So please dont take this personal in any way - you'll see many other 
checkpatch.pl related patch rejections on lkml, from me and from others 
as well. Sloppy style does mount up step by step and results in harder 
to read and harder to fix/maintain code.

White space is not at all more important than seriously cleaner code, 
but 'even more seriously clean code' is more important than just pure 
seriously clean code ;-)

	Ingo
