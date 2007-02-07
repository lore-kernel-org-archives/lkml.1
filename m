Return-Path: <linux-kernel-owner+w=401wt.eu-S1030651AbXBGTWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030651AbXBGTWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 14:22:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030652AbXBGTWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 14:22:15 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36328 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030651AbXBGTWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 14:22:14 -0500
Date: Wed, 7 Feb 2007 14:22:13 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Kwatch: kernel watchpoints using CPU debug registers
In-Reply-To: <20070207025008.1B11118005D@magilla.sf.frob.com>
Message-ID: <Pine.LNX.4.44L0.0702071356580.4502-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007, Roland McGrath wrote:

> > So for the sake of argument, let's assume that debug registers can be 
> > assigned with priority values ranging from 0 to 7 (overkill, but who 
> > cares?).  By fiat, ptrace assignments use priority 4.  Then kwatch callers 
> > can request whatever priority they like.  The well-behaved cases you've 
> > been discussing will use priority 0, and the invasive cases can use 
> > priority 7.  (With appropriate symbolic names instead of raw numeric 
> > values, naturally.)
> 
> Sure.  Or make it signed with lower value wins, have ptrace use -1 and the
> average bear use 0 or something especially unobtrusive use >0, and
> something very obtrusive use -many.

I wonder where this convention of using lower numbers to indicate higher 
priorities comes from...  It seems to be quite prevalent even though it's 
obviously backwards.

>  Unless you are really going to pack it
> into a few bits somewhere, I'd make it an arbitrary int rather than a
> special small range; it's just for sort order comparison.  Bottom line, I
> don't really care about the numerology.  Just so "break ptrace", "don't
> break ptrace", and "readily get out of the way on demand" can be expressed.
> We can always fine-tune it later as there are more concrete users.

Okay; I'm not fixated on any particular size.

> > Or maybe that's too complicated.  Perhaps all userspace assignments should 
> > always use the same priority level.  
> 
> No, I want priorities among user-mode watchpoint users too.  ptrace is
> rigid, but newer facilities can coexist with ptrace on the same thread and
> with kwatch, and do fancy new things to fall back when there is debugreg
> allocation pressure.  Future user facilities might be able to do VM tricks
> that are harder to make workable for kernel mode, for example.  

All right.  However this means thread_struct will have to grow in order to
hold each task's debug-register allocations and priorities.  Would that be
acceptable?  (This might be a good reason to keep the number of bits
down.)

Another question: How can a program using the ptrace API ever give up a
debug-register allocation?  Disabling the register isn't sufficient; a
user program should be able to store a watchpoint address in dr1, enable
it in dr7, disable it in dr7, and then re-enable it in the expectation
that the address stored in dr1 hasn't been overwritten.  As far as I can
see, ptrace-type allocations have to be permanent (until the task exits or
execs, or uses some other to-be-determined API to do the de-allocation.)

Alan Stern

