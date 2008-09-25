Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbYIYDDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbYIYDDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 23:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbYIYDD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 23:03:27 -0400
Received: from ns1.suse.de ([195.135.220.2]:33117 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbYIYDD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 23:03:26 -0400
Date: Thu, 25 Sep 2008 05:03:22 +0200
From: Nick Piggin <npiggin@suse.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       John Daiker <daikerjohn@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #11608] 2.6.27-rc6 BUG: unable to handle kernel paging request
Message-ID: <20080925030322.GC4401@wotan.suse.de>
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik> <7lIhZC4hCxE.A.zMG.D0q1IB@albercik> <20080924204655.481478c6@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924204655.481478c6@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 08:46:55PM -0400, Chuck Ebbert wrote:
> On Sun, 21 Sep 2008 20:54:23 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11608
> > Subject		: 2.6.27-rc6 BUG: unable to handle kernel paging request
> > Submitter	: John Daiker <daikerjohn@gmail.com>
> > Date		: 2008-09-16 23:00 (6 days old)
> > References	: http://marc.info/?l=linux-kernel&m=122160611517267&w=4
> > 
> > 
> 
> As I said in the bugzilla entry:
> 
>   Oops: 000b
> 
>   Bit 3 is set -- the processor detected 1's in reserved bits of the page directory.
> 
> That can't be good...

54384.988151] BUG: unable to handle kernel paging request at ffff8800601dd000
[54384.992095] IP: [<ffffffff80375457>] clear_page_c+0x7/0x10
[54384.992095] PGD 202063 PUD 8067 PMD 65d54163 PTE 80002020601dd163
[54384.992095] Oops: 000b [1] SMP DEBUG_PAGEALLOC

I initially suspect PAT (maybe via DEBUG_PAGEALLOC)... but let's see if the
3rd line here is useful.

     xRRRRRRRRRRRRRRRRRRRRRRR|40b|<--MAXPHYS     PHYS-->|...RR.actuwp
PGD:                                         001000000010000001100011

     xRRRRRRRRRRRRRRRRRRRRRRR|40b|<--MAXPHYS     PHYS-->|...RR.actuwp
PUD:                                                 1000000001100111

     xRRRRRRRRRRRRRRRRRRRRRRR|40b|<--MAXPHYS     PHYS-->|...Rs.actuwp
PMD:                                 01100101110101010100000101100011

     xRRRRRRRRRRRRRRRRRRRRRRR|40b|<--MAXPHYS     PHYS-->|...gP.actuwp
PTE: 1000000000000000001000000010000001100000000111011101000101100011
     3210987654321098765432109876543210987654321098765432109876543210

Is this a 36-bit physical address CPU? In which case you have 2 bits in
the pte that are outside "maxphys". Or if it is a 40-bit CPU, then you
have just 1 bit outside maxphys, in which case I'd say it is memory
corruption (maybe a hardware bug, maybe a scribble from elsewhere). So
I'm wrong about PAT.

Interestingly, the PMD also has a 1 set in a reserved bit (page global),
but according to the Intel docs, the CPU doesn't check that bit, so it
is not faulting there.

Does the machine survive memtest? Is the bug reproduceable? If the
answer is no to either of these, I think we can take it off the
regression list. Otherwise, is it possible to track down to a specific
commit?

Thanks,
Nick

