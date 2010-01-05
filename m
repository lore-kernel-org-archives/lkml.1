Return-Path: <linux-kernel-owner+w=401wt.eu-S1751977Ab0AEGJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab0AEGJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 01:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789Ab0AEGJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 01:09:48 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:46165 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab0AEGJr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 01:09:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CcY1cTO0jm8TMCAggSurpVu85ltCgG4cLJ7t4IehkAM2q4zb5wCIRC345pWx62ytsF
         M4+tPcdYGZCmlILdoID/P75ULUHLWin2c6qKbynYDf8iQNcR2+jWLJxT8IJX7xKzgH3S
         CfkUXK1kxrfmyfZP+iAGE2NPlIuOZF/8i5HUs=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1001042038110.3630@localhost.localdomain>
References: <20100104182429.833180340@chello.nl>
	 <20100104182813.753545361@chello.nl>
	 <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com>
	 <28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com>
	 <alpine.LFD.2.00.1001042038110.3630@localhost.localdomain>
Date: Tue, 5 Jan 2010 15:09:47 +0900
Message-ID: <28c262361001042209k7241dd38l3d51d230e7b68a5@mail.gmail.com>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
From: Minchan Kim <minchan.kim@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus.

On Tue, Jan 5, 2010 at 1:48 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Tue, 5 Jan 2010, Minchan Kim wrote:
>>
>> Isn't it protected by get_file and iget?
>
> When the vma is mapped, yes.
>
>> Am I miss something?
>
> remove_vma() will have done a
>
>        fput(vma->vm_file);
>
> and other house-keeping (removing the executable info, doing
> vm_ops->close() etc).
>
> And that is _not_ done delayed by RCU, and as outlined in my previous
> email I think that if the code really _does_ delay it, then munmap() (and
> exit) need to wait for the RCU callbacks to have been done, because
> otherwise the file may end up being busy "asynchronously" in ways that
> break existing semantics.
>
> Just as an example: imagine a script that does "fork()+execve()" on a
> temporary file, and then after waiting for it all to finish with wait4()
> does some re-write of the file. It currently works. But what if the
> open-for-writing gets ETXTBUSY because the file is still marked as being
> VM_DENYWRITE, and RCU hasn't done all the callbacks?
>
> Or if you do the i_writecount handling synchronously (which is likely fine
> - it really is just for ETXTBUSY handling, and I don't think speculative
> page faults matter), what about a shutdown sequence (or whatever) that
> wants to unmount the filesystem, but the file is still open - as it has to
> be - because the actual close is delayed by RCU.
>
> So the patch-series as-is is fundamentally buggy - and trying to fix it
> seems painful.
>
> I'm also not entirely clear on how the race with page table tear-down vs
> page-fault got handled, but I didn't read the whole patch-series very
> carefully. I skimmed through it and got rather nervous about it all. It
> doesn't seem too large, but it _does_ seem rather cavalier about all the
> object lifetimes.
>
>                Linus
>

Thanks for careful explanation, Linus.

My humble opinion is following as.

Couldn't we synchronize rcu in that cases(munmap, exit and so on)?
It can delay munap and exit but it would be better than handling them by more
complicated things, I think. And both cases aren't often cases so we
can achieve advantage than disadvantage?


-- 
Kind regards,
Minchan Kim
