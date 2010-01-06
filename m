Return-Path: <linux-kernel-owner+w=401wt.eu-S933005Ab0AFX3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005Ab0AFX3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932380Ab0AFX3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:29:44 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56472 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932332Ab0AFX3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:29:43 -0500
Message-ID: <4B451CE2.6080209@us.ibm.com>
Date: Wed, 06 Jan 2010 15:29:38 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ulrich Drepper <drepper@gmail.com>
Subject: Re: [PATCH v2] futex: remove rw parameter from get_futex_key()
References: <20091225083305.AA78.A69D9226@jp.fujitsu.com> <alpine.LSU.2.00.0912301437420.3369@sister.anvils> <20100105162633.45A2.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100105162633.45A2.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

Hi Kosaki,

Some test results below. Things look good, you have my Ack.

> From c3e2dfdff84b9b720e646fd6dd3c38fff293c7e6 Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Tue, 5 Jan 2010 11:33:00 +0900
> Subject: [PATCH] futex: remove rw parameter from get_futex_key()
> 
> Currently, futex have two problem.
> 
> A) current futex doesn't handle private file mappings properly.
> 
> get_futex_key() use PageAnon() to distinguish file and anon. it can
> makes following bad scenario.
> 
>   1) thread-A call futex(private-mapping, FUTEX_WAIT). it makes to
>      sleep on file mapping object.
>   2) thread-B write a variable and it makes cow.
>   3) thread-B call futex(private-mapping, FUTEX_WAKE). it wake up
>      sleeped thread on the anonymous page. (but it's nothing)
> 
> following testcase reproduce this issue.
> 
> actual result)
>        FUTEX_WAIT thread never wake up.
> 
> expect result)
>        FUTEX_WAIT thread wake up by FUTEX_WAKE.
>

<snipped test source>

> 
> B) current futex doesn't handle zero page properly.
> 
> read mode get_user_pages() can return zero page. but current futex code doesn't
> handle it at all. Then, zero page makes infinite loop internally.
> 
> following testcase can reproduce this issue.
> 
> actual result)
> 	FUTEX_WAIT never return and waste cpu time 100%.
> 
> expected result)
> 	FUTEX_WAIT return immediately.
> 

<snipped test source>

> The solution is to use write mode get_user_page() always for page lookup.
> It prevent to lookup both file page of private mappings and zero page.
> 
> performance concern:
> 
> Probaly very little. because glibc always initialize variables for futex
> before to call futex(). It mean glibc user never seen the overhead of this
> patch.
> 
> compatibility concern:
> 
> This patch have few compatibility break. After this patch, FUTEX_WAIT require
> writable access to futex variables (read-only mappings makes EFAULT).
> But practically it's no problem. again glibc always initalize variables for futex
> explicitly. nobody use read-only mappings.
> 
> Reported-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

The tests have been added to futextest. In addition to confirming these 
tests, I compared the performance/futex_wait test results before and 
after this patch and found no significant delta.
	
Threads	2.6.33-rc3	2.6.33-rc3-patched
------------------------------------------
1	42373		42373
2	24938		24450
3	5931		7163
4	4715		4480
5	4593		4227
6	4993		4608
8	4448		5294
10	4778		5149
12	4836		5079
16	4476		3828
24	4188		4314
32	4380		4384
64	4598		4764
128	4429		5102
256	5081		4462
521	4854		4444
1024	4933		4272
------------------------------------------
System: 4xAMD Opteron 270 @ 2GHz
Units: Thousands of iterations per second

Ingo and Thomas, please consider applying this patch. Should this also 
be sent to Stable?

Acked-by: Darren Hart <dvhltc@us.ibm.com>


> ---
>  kernel/futex.c |   27 ++++++++++++---------------
>  1 files changed, 12 insertions(+), 15 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 8e3c3ff..d9b3a22 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -203,8 +203,6 @@ static void drop_futex_key_refs(union futex_key *key)
>   * @uaddr:	virtual address of the futex
>   * @fshared:	0 for a PROCESS_PRIVATE futex, 1 for PROCESS_SHARED
>   * @key:	address where result is stored.
> - * @rw:		mapping needs to be read/write (values: VERIFY_READ,
> - * 		VERIFY_WRITE)
>   *
>   * Returns a negative error code or 0
>   * The key words are stored in *key on success.
> @@ -216,7 +214,7 @@ static void drop_futex_key_refs(union futex_key *key)
>   * lock_page() might sleep, the caller should not hold a spinlock.
>   */
>  static int
> -get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
> +get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
>  {
>  	unsigned long address = (unsigned long)uaddr;
>  	struct mm_struct *mm = current->mm;
> @@ -239,7 +237,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
>  	 *        but access_ok() should be faster than find_vma()
>  	 */
>  	if (!fshared) {
> -		if (unlikely(!access_ok(rw, uaddr, sizeof(u32))))
> +		if (unlikely(!access_ok(VERIFY_WRITE, uaddr, sizeof(u32))))
>  			return -EFAULT;
>  		key->private.mm = mm;
>  		key->private.address = address;
> @@ -248,7 +246,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
>  	}
>  
>  again:
> -	err = get_user_pages_fast(address, 1, rw == VERIFY_WRITE, &page);
> +	err = get_user_pages_fast(address, 1, 1, &page);
>  	if (err < 0)
>  		return err;
>  
> @@ -867,7 +865,7 @@ static int futex_wake(u32 __user *uaddr, int fshared, int nr_wake, u32 bitset)
>  	if (!bitset)
>  		return -EINVAL;
>  
> -	ret = get_futex_key(uaddr, fshared, &key, VERIFY_READ);
> +	ret = get_futex_key(uaddr, fshared, &key);
>  	if (unlikely(ret != 0))
>  		goto out;
>  
> @@ -913,10 +911,10 @@ futex_wake_op(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
>  	int ret, op_ret;
>  
>  retry:
> -	ret = get_futex_key(uaddr1, fshared, &key1, VERIFY_READ);
> +	ret = get_futex_key(uaddr1, fshared, &key1);
>  	if (unlikely(ret != 0))
>  		goto out;
> -	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_WRITE);
> +	ret = get_futex_key(uaddr2, fshared, &key2);
>  	if (unlikely(ret != 0))
>  		goto out_put_key1;
>  
> @@ -1175,11 +1173,10 @@ retry:
>  		pi_state = NULL;
>  	}
>  
> -	ret = get_futex_key(uaddr1, fshared, &key1, VERIFY_READ);
> +	ret = get_futex_key(uaddr1, fshared, &key1);
>  	if (unlikely(ret != 0))
>  		goto out;
> -	ret = get_futex_key(uaddr2, fshared, &key2,
> -			    requeue_pi ? VERIFY_WRITE : VERIFY_READ);
> +	ret = get_futex_key(uaddr2, fshared, &key2);
>  	if (unlikely(ret != 0))
>  		goto out_put_key1;
>  
> @@ -1738,7 +1735,7 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, int fshared,
>  	 */
>  retry:
>  	q->key = FUTEX_KEY_INIT;
> -	ret = get_futex_key(uaddr, fshared, &q->key, VERIFY_READ);
> +	ret = get_futex_key(uaddr, fshared, &q->key);
>  	if (unlikely(ret != 0))
>  		return ret;
>  
> @@ -1904,7 +1901,7 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
>  	q.requeue_pi_key = NULL;
>  retry:
>  	q.key = FUTEX_KEY_INIT;
> -	ret = get_futex_key(uaddr, fshared, &q.key, VERIFY_WRITE);
> +	ret = get_futex_key(uaddr, fshared, &q.key);
>  	if (unlikely(ret != 0))
>  		goto out;
>  
> @@ -2023,7 +2020,7 @@ retry:
>  	if ((uval & FUTEX_TID_MASK) != task_pid_vnr(current))
>  		return -EPERM;
>  
> -	ret = get_futex_key(uaddr, fshared, &key, VERIFY_WRITE);
> +	ret = get_futex_key(uaddr, fshared, &key);
>  	if (unlikely(ret != 0))
>  		goto out;
>  
> @@ -2215,7 +2212,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
>  	rt_waiter.task = NULL;
>  
>  	key2 = FUTEX_KEY_INIT;
> -	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_WRITE);
> +	ret = get_futex_key(uaddr2, fshared, &key2);
>  	if (unlikely(ret != 0))
>  		goto out;
>  


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
