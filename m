Return-Path: <linux-kernel-owner+w=401wt.eu-S933254AbYDOWMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254AbYDOWMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 18:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbYDOWMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 18:12:09 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59787 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298AbYDOWMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 18:12:07 -0400
In-Reply-To: <20080415202931.GU7385@csclub.uwaterloo.ca>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Bodo Eggert <7eggert@gmx.de>, Diego Calleja <diegocg@gmail.com>,
       Jan Kara <jack@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
       linux-fsdevel@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Michal Hocko <mhocko@suse.cz>, Meelis Roos <mroos@linux.ee>,
       Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Subject: Re: file offset corruption on 32-bit machines?
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFCA827B78.F987C4A1-ON8825742C.00781E5A-8825742C.0079F2C9@us.ibm.com>
From: Bryan Henderson <hbryan@us.ibm.com>
Date: Tue, 15 Apr 2008 15:11:54 -0700
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.0.1|February 07, 2008) at
 04/15/2008 18:12:03,
	Serialize complete at 04/15/2008 18:12:03
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well it would take seriously hard work to make a program that would work
> correctly if it was atomic and would break if it isn't.  Certainly a
> normal program that just tries to seek and read/write should never have
> any issue.

I can easily imagine such a program.  I think you aren't exercising enough 
imagination about the kinds of requirements a program might be 
implementing.

That lack of imagination (in all of us) is the reason we shouldn't 
tolerate something working not as designed or not as expected just because 
we went through every possible use scenario and it didn't matter in any of 
them.  Just focus on the layer in question.

The easiest way to imagine a program not doing locking and being useful 
anyway (as long as the kernel is thread-safe) is to use the same arguments 
you use for the kernel doing it: there's a higher level user responsible 
for locking.  The code in question doesn't guarantee that user writes all 
its stuff to the right place, but at least it guarantees that that user's 
lack of locking doesn't screw some other user of the file.  It does that 
by ensuring it never seeks to a place the user doesn't own and that no two 
separate users ever access the file at the same time.

I'd even like to accomodate the poor user trying to debug the broken 
locking in his application.  He sees the file getting corrupted and 
immediately thinks, "what if my thread serialization isn't working right?" 
 But he notices that the corruption isn't consistent with that hypothesis. 
 He knows he was working with only the beginning and the end of the file 
and the corruption happened in the middle.  So he wastes a week 
considering other hypotheses, including a kernel bug, until someone points 
out a paragraph in the lseek() man page that says contrary to all Unix 
convention, that particular function and system call is not thread-safe, 
and it doesn't necessarily seek to the place mentioned in its argument.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems

