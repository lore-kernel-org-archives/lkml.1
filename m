Return-Path: <linux-kernel-owner+w=401wt.eu-S1761541AbYDPJlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761541AbYDPJlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 05:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756144AbYDPJlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 05:41:13 -0400
Received: from mail2.shareable.org ([80.68.89.115]:54274 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064AbYDPJlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 05:41:12 -0400
Date: Wed, 16 Apr 2008 10:40:57 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Bodo Eggert <7eggert@gmx.de>, Diego Calleja <diegocg@gmail.com>,
       Jan Kara <jack@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
       linux-fsdevel@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Michal Hocko <mhocko@suse.cz>, Meelis Roos <mroos@linux.ee>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080416094057.GB27898@shareable.org>
Mail-Followup-To: Bryan Henderson <hbryan@us.ibm.com>,
	Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
	Bodo Eggert <7eggert@gmx.de>, Diego Calleja <diegocg@gmail.com>,
	Jan Kara <jack@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	Michal Hocko <mhocko@suse.cz>, Meelis Roos <mroos@linux.ee>,
	Pavel Machek <pavel@ucw.cz>
References: <20080415202931.GU7385@csclub.uwaterloo.ca> <OFCA827B78.F987C4A1-ON8825742C.00781E5A-8825742C.0079F2C9@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFCA827B78.F987C4A1-ON8825742C.00781E5A-8825742C.0079F2C9@us.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Henderson wrote:
> The easiest way to imagine a program not doing locking and being useful 
> anyway (as long as the kernel is thread-safe) is to use the same arguments 
> you use for the kernel doing it: there's a higher level user responsible 
> for locking.  The code in question doesn't guarantee that user writes all 
> its stuff to the right place, but at least it guarantees that that user's 
> lack of locking doesn't screw some other user of the file.  It does that 
> by ensuring it never seeks to a place the user doesn't own and that no two 
> separate users ever access the file at the same time.
> 
> I'd even like to accomodate the poor user trying to debug the broken 
> locking in his application.  He sees the file getting corrupted and 
> immediately thinks, "what if my thread serialization isn't working right?" 
>  But he notices that the corruption isn't consistent with that hypothesis. 
>  He knows he was working with only the beginning and the end of the file 
> and the corruption happened in the middle.  So he wastes a week 
> considering other hypotheses, including a kernel bug, until someone points 
> out a paragraph in the lseek() man page that says contrary to all Unix 
> convention, that particular function and system call is not thread-safe, 
> and it doesn't necessarily seek to the place mentioned in its argument.

I think that argument is the strongest yet.  Wasted debugging time due
to totally surprising and hardly justifiable kernel behaviour.  Strace
/ GDB on the application shows a trace which doesn't relate at all to
the unexpected file changes.

There is also POSIX specification:

  http://www.opengroup.org/onlinepubs/000095399/functions/xsh_chap02_09.html

  "All functions defined by this volume of IEEE Std 1003.1-2001 shall
be thread-safe, except that the following functions need not be
thread-safe."

  [List which does not include lseek(), therefore lseek() shall be
  thread-safe.  Same for read() and write().]

Docs for HP-UX and AIX say the same as POSIX about thread-safety.

-- Jamie
