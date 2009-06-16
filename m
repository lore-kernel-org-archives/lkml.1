Return-Path: <linux-kernel-owner+w=401wt.eu-S1761369AbZFPTUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761369AbZFPTUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756408AbZFPTUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:20:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38142 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755736AbZFPTUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:20:34 -0400
Message-ID: <4A37F098.2060208@redhat.com>
Date: Tue, 16 Jun 2009 22:20:56 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
       Rik van Riel <riel@redhat.com>, nickpiggin@yahoo.com.au
Subject: Re: running get_user_pages() from kernel thread
References: <4A37DEE7.1000208@redhat.com> <20090616181325.GC23969@random.random> <Pine.LNX.4.64.0906161930050.24878@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0906161930050.24878@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Tue, 16 Jun 2009, Andrea Arcangeli wrote:
>   
>> On Tue, Jun 16, 2009 at 09:05:27PM +0300, Izik Eidus wrote:
>>     
>>> So the question is: is this thing is by desgin? (that kernel thread cant 
>>> call get_user_pages???), should i use something like switch_mm()??
>>>       
>> I think switch_mm trick should be used for page faults, but gup
>> shouldn't require it because it gets the 'mm' as parameter and the
>> current->mm has to be irrelevant. current->mm is only relevant for
>> gup-fast (obviously :). So I think the only bit that needs fixing is
>> grab_swap_token to not run if current->mm is null.
>>     
>
> Looks like Izik and I hit the same problem (otherwise running well):
> I too decided we needn't do more than avoid the issue in grab_swap_token.
> (I've a feeling someone has hit this issue before with some other thread,
> though I've no idea which - does RHEL include a patch like this perhaps?).
>
> [PATCH] mm: grab_swap_token back out if no mm
>
> If a kthread happens to use get_user_pages() on an mm (as KSM does),
> there's a chance that it will end up trying to read in a swap page,
> and oops in grab_swap_token() because the kthread has no mm:
> nothing clever, just avoid that case.
>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
>
>  mm/thrash.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> --- 2.6.30-mm1/mm/thrash.c	2007-07-09 00:32:17.000000000 +0100
> +++ linux/mm/thrash.c	2009-06-15 19:44:53.000000000 +0100
> @@ -30,6 +30,9 @@ void grab_swap_token(void)
>  {
>  	int current_interval;
>  
> +	if (!current->mm)	/* kthread doing get_user_pages on an mm */
> +		return;
> +
>  	global_faults++;
>  
>  	current_interval = global_faults - current->mm->faultstamp;
>   
Good, This solve another issue that you probably dont hit beacuse you 
work with the madvise version:
the .release call back of the file_operations strcture will call to:
ksm_sma_release() that will call to remove_slot_from_hash_and_tree() 
that will do the silly break_cow() call (even that the prcoesses just 
die!!!)
Now beacuse that exit_mm() will set tsk->mm = NULL before the .release 
will get called, we will trigger this path even without the kernel 
thread context.
(I prepred patch that just avoid the break_cow() from the .release 
context, but it isnt needed with this patch)

(You shouldnt have that specific problem in the madvise() version 
beacuse we dont have this .release callback anymore, but we still do 
there useless break_cow() calls, considering the fact that the process 
just die, this break_cow() calls should be made only when the user ask 
specifically to stop merging pages i guess...,
I will send patch that will make it work more logical on top of your 
patches as soon as you send something)

Thanks.
