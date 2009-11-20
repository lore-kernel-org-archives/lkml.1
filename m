Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbZKTMGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbZKTMGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 07:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbZKTMGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 07:06:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbZKTMG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 07:06:29 -0500
Message-ID: <4B0685B7.4060601@redhat.com>
Date: Fri, 20 Nov 2009 12:04:07 +0000
From: Andrew Haley <aph@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jeff Law <law@redhat.com>, rostedt@goodmis.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Guenther <richard.guenther@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
References: <viy9pk4xossnb6m2v041qu00.1258665258503@email.android.com>   <4B05B7AD.20500@redhat.com> <1258670580.22249.1002.camel@gandalf.stny.rr.com> <4B05DBBF.5000804@redhat.com> <alpine.LFD.2.00.0911200122190.24119@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0911200122190.24119@localhost.localdomain>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:

> While testing various kernel configs we found out that the problem
> comes and goes. Finally I started to compare the gcc command line
> options and after some fiddling it turned out that the following
> minimal deltas change the code generator behaviour:
> 
> Bad:  -march=pentium-mmx                -Wa,-mtune=generic32
> Good: -march=i686        -mtune=generic -Wa,-mtune=generic32
> Good: -march=pentium-mmx -mtune-generic -Wa,-mtune=generic32
> 
> I'm not supposed to understand the logic behind that, right ?

I don't either.  I'm seeing:

timer_stats_update_stats:                                       timer_stats_update_stats:
        pushl   %edi                                          <
        leal    8(%esp), %edi                                 <
        andl    $-16, %esp                                    <
        pushl   -4(%edi)                                      <
        pushl   %ebp                                                    pushl   %ebp
        movl    %esp, %ebp                                              movl    %esp, %ebp
        pushl   %edi                                          |         andl    $-16, %esp
        pushl   %esi                                          |         subl    $112, %esp
        pushl   %ebx                                          |         movl    %ebx, 100(%esp)
        subl    $108, %esp                                    |         movl    %esi, 104(%esp)
                                                              >         movl    %edi, 108(%esp)
        call    mcount                                                  call    mcount

where the only difference is -mtune=generic.  I'm investigating.

Andrew.

