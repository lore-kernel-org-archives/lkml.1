Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab0BVRhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 12:37:13 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:39694 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab0BVRhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 12:37:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=vgyYBTY9FHx7R1N+oFOgKkNS8aSrLofR3PBTPaxDP0D/aPSLReaN3l00kMZNm6Nypu
         MrafJtREyi2dMVpRcxdtt8XymE0h9aXOWiNnvqEMsyCsdEDvjyvscZeemf6xQ/UgDqn0
         WmWQyPAU5x61IXkC2UxD5f/BDrUDdP+XB8HK4=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] vfs: notify_changes() error handling
References: <1266608845-13212-1-git-send-email-dmonakhov@openvz.org>
	<20100222103516.GA5131@atrey.karlin.mff.cuni.cz>
	<20100222111510.GT9738@laptop> <87eikdo0st.fsf@openvz.org>
	<20100222145639.GW9738@laptop>
Date: Mon, 22 Feb 2010 20:37:02 +0300
In-Reply-To: <20100222145639.GW9738@laptop> (Nick Piggin's message of "Tue, 23
	Feb 2010 01:56:39 +1100")
Message-ID: <873a0t2mv5.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:

> On Mon, Feb 22, 2010 at 04:30:26PM +0300, Dmitry Monakhov wrote:
>> Nick Piggin <npiggin@suse.de> writes:
>> 
>> > On Mon, Feb 22, 2010 at 11:35:17AM +0100, Jan Kara wrote:
>> >> > After this notify_change() perform all necessary checks inside
>> >> > inode_change_ok() and simply call nofail version of vmtruncate().
>> >>   Actually, there are more problems than these in the truncate path.  Some
>> >> filesystems can decide to fail truncate only in their .truncate method but that
>> >> is called only after i_size is set which is too late.  Nick Piggin has a patch
>> >> set which was addressing this problem and should be basically a superset of
>> >> your changes. But I'm not sure whether the patch series is available somewhere
>> >> or what it's current status. Nick?
>> >
>> > I think Al is happy with it in principle, I changed it as he suggested.
>> > Maybe it was put on hold for other reasons. Anyway, here is the core
>> > patch again. It now is basically just adding more helpers, so it's not
>> > so intrusive.
>> >
>> > Al, what are your thoughts on merging? It doesn't appear to conflict
>> > with the -vfs tree.
>> >
>> > Dmitry, this doesn't solve your quota problem, but they obviously clash
>> > rather heavily. Do you see any problems with the way my patch goes?
>> In fact i dont tried to solve quota issue. I just want to understand
>> why error paths in my code becomes so huge and why they so differ
>> from existing code, now i do understand why :)
>
> Oh, but you attempted it (partially?) by moving the inode size
> check into inode_change_ok().
>
>> As soon as i understand this patch add changes only for core part.
>> And later other filesystems will handle the rest.
>
> Yes. Most of them we have converted to the new sequence in
> subsequent patches. From that point it should be easier to improve
> error handling.
>
>> I am agree with it, vmtruncate is nightmare.
>> But imho also we have to solve generic inode attr check/set issue
>> fs_XXX_setattr()
>> {
>> ...
>>    ret = inode_size_ok(inode, attr)
>>    if (ret)
>>         goto bad;
>>    if(private_fs_update_on_disk_data(new_size))
>>         goto bad;
>>    if(simple_setsize(inode,new_size)) {
>>      /* We still can get in to this because RLIMIT_FSIZE may be
>>       * changed after inode_size_ok();
>>       * So we have to roll back all fs-speciffic data which may be 
>>       * paintfull or impossible
>>       */
>>       ret = private_fs_update_on_disk_data(old_size)
>>       BUG_ON(ret)
>>     }
>> }
>> So my purpose is:
>> 1) to move inode_size_ok check in to inode_change_ok()
>> 2) Introduce simple_setsize_nocheck() which just do it's work
>>    after all checks was already done.
>>    And call simple_setsize_nocheck() inside fsXXX_setattr instead
>>    of simple_setsize().
>> 
>> Patch prepared agains yours "truncate: introduce new sequence"
>  
> Hmm, I wonder if it would be safer to rename the function if
> changing behaviour like this so it loudly breaks external modules.
>
Yeah. Since your patch is mandatory as a start point. And i'm trying
to solve slightly  different issue. Which result in core patch pending.
Let it goes in to vfs tree as is. Later i'll convert all fsXXX_setattr()
to sane attribute checks logic.
ACK from me.

