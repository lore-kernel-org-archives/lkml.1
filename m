Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbYBNKZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbYBNKZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 05:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbYBNKZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 05:25:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:59163 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbYBNKZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 05:25:29 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates
From: Andi Kleen <andi@firstfloor.org>
References: <20080213155725.GA19523@elte.hu>
Date: Thu, 14 Feb 2008 11:25:27 +0100
In-Reply-To: <20080213155725.GA19523@elte.hu> (Ingo Molnar's message of "Wed\, 13 Feb 2008 16\:57\:25 +0100")
Message-ID: <p73ir0r25t4.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>
> Thomas Gleixner (1):
>       x86: EFI: fix use of unitialized variable and the cache logic

Your honor, I would like to register a differing opinion...

I submitted that fix originally in a different form, but it
got finally stripped down to this. However in my opinion
the full version of the patch is still needed, otherwise
EFI still does the mapping wrong.

Even with this patch EFI still passes in ioremap (on 32bit)  and fixmap (on 64bit)
addresses to cpa which it will mishandle.

On 64bit cpa will still change cache attributes on random low pages and
cause illegal caching attribute aliases on both 32bit and 64bit.

See http://marc.info/?l=linux-kernel&m=120290071713708&w=2 for details.

git-x86#mm made some attempts to also fix this in pageattr.c which
fixed some parts of the problem on 64bit (static_protections should be
ok now),  but not all (alias handling still not good)  

See http://marc.info/?l=linux-kernel&m=120290203315953&w=2
for details

In particular the direct mapping cache alias handling for
ioremap/fixmap (and EFI uses that) is not correct on both 32bit and
64bit. 

Also all ioremaps have this same problem so all uncached mappings are
broken when the direct mapping happens to overlap them (common on
64bit with enough RAM).  Right now when you do a uncached ioremap the
direct mapping will not be changed, which causes illegal
conflicting caching aliasing.

My original patch above avoided that by not calling set_memory_uc()
for the EFI case, but I did not fix the general ioremap case for
other users yet (will send a patch later for this unless someone 
beats me to it)

Note even with ioremap generally fixed the original patch
http://marc.info/?l=linux-kernel&m=120284838904660&w=2
in its full form will be still needed to pass in the correct attribute 
to ioremap in the first place.

I would recommend to either mark EFI CONFIG_BROKEN for now 
or apply the complete patch I posted earlier 
http://marc.info/?l=linux-kernel&m=120284838904660&w=2
or fix it in some other way in pageattr.c as described in
http://marc.info/?l=linux-kernel&m=120290203315953&w=2 
(although that might be intrusive and I don't think such a change
would be a good idea at this stage of the release) 

And a separate patch fixing ioremap_nocache() will be needed too.

-Andi
