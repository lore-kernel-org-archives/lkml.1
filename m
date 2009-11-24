Return-Path: <linux-kernel-owner+w=401wt.eu-S932840AbZKXT7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840AbZKXT7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 14:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932814AbZKXT7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 14:59:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51248 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932800AbZKXT7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 14:59:53 -0500
Message-ID: <4B0C3A2F.20703@zytor.com>
Date: Tue, 24 Nov 2009 11:55:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Haley <aph@redhat.com>
CC: Jakub Jelinek <jakub@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H.J. Lu" <hjl.tools@gmail.com>, rostedt@goodmis.org,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Guenther <richard.guenther@gmail.com>, gcc <gcc@gcc.gnu.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL][v2.6.32] tracing/x86: Add check to detect GCC
  messing with mcount prologue
References: <1258694593.22249.1012.camel@gandalf.stny.rr.com> <1258736456.22249.1032.camel@gandalf.stny.rr.com> <4B06EF6F.2050507@redhat.com> <6dc9ffc80911220138y15bfa91agccf5c29f1c30e09a@mail.gmail.com> <4B0972C9.302@redhat.com> <6dc9ffc80911221530t38d83cf6je739743c8d756667@mail.gmail.com> <4B0BF119.4070704@redhat.com> <alpine.LFD.2.00.0911241555170.24119@localhost.localdomain> <20091124150604.GJ22813@hs20-bc2-1.build.redhat.com> <4B0BFC84.7070806@redhat.com> <20091124153634.GK22813@hs20-bc2-1.build.redhat.com> <4B0BFFD0.2080203@redhat.com> <4B0C0C12.7040907@zytor.com> <4B0C13F4.5090106@redhat.com>
In-Reply-To: <4B0C13F4.5090106@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2009 09:12 AM, Andrew Haley wrote:
>>
>> If we're changing gcc anyway, then let's add the option of intercepting
>> the function at the point where the machine state is well-defined by
>> ABI, which is before the function stack frame is set up.
> 
> Hmm.  On the x86 I suppose we could just inject a naked call instruction,
> but not all aeches allow us to call anything before we've saved the return
> address.  Or are you talking x86 only?
> 

For x86, we should use a naked call.

For architectures where that is not possible, we should use a minimal
sequence such that the ABI state at the invocation point is 100% derivable.

On MIPS, for example, we could use a sequence such as:

	mov at, ra
	jal __fentry__

It would be up to __fentry__ to save the value in at and to restore it
back into ra before resuming, meaning that __fentry__ has a nonstandard
calling convention.

	-hpa
