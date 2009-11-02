Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbZKBNXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbZKBNXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 08:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbZKBNXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 08:23:30 -0500
Received: from ozlabs.org ([203.10.76.45]:55273 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940AbZKBNX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 08:23:29 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] MM: slqb, fix per_cpu access
Date: Mon, 2 Nov 2009 23:53:30 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: npiggin@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>
References: <1257113578-1584-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1257113578-1584-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911022353.30524.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009 08:42:58 am Jiri Slaby wrote:
> We cannot use the same local variable name as the declared per_cpu
> variable since commit "percpu: remove per_cpu__ prefix."
> 
> Otherwise we would see crashes like:
> general protection fault: 0000 [#1] SMP
> last sysfs file:
> CPU 1
> Modules linked in:
> Pid: 1, comm: swapper Tainted: G        W  2.6.32-rc5-mm1_64 #860
> RIP: 0010:[<ffffffff8142ff94>]  [<ffffffff8142ff94>] start_cpu_timer+0x2b/0x87
> ...
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> ---
>  mm/slqb.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/slqb.c b/mm/slqb.c
> index e745d9a..27f5025 100644
> --- a/mm/slqb.c
> +++ b/mm/slqb.c
> @@ -2770,16 +2770,16 @@ static DEFINE_PER_CPU(struct delayed_work, cache_trim_work);
>  
>  static void __cpuinit start_cpu_timer(int cpu)
>  {
> -	struct delayed_work *cache_trim_work = &per_cpu(cache_trim_work, cpu);
> +	struct delayed_work *_cache_trim_work = &per_cpu(cache_trim_work, cpu);
>  
>  	/*
>  	 * When this gets called from do_initcalls via cpucache_init(),
>  	 * init_workqueues() has already run, so keventd will be setup
>  	 * at that time.
>  	 */
> -	if (keventd_up() && cache_trim_work->work.func == NULL) {
> -		INIT_DELAYED_WORK(cache_trim_work, cache_trim_worker);
> -		schedule_delayed_work_on(cpu, cache_trim_work,
> +	if (keventd_up() && _cache_trim_work->work.func == NULL) {
> +		INIT_DELAYED_WORK(_cache_trim_work, cache_trim_worker);
> +		schedule_delayed_work_on(cpu, _cache_trim_work,
>  					__round_jiffies_relative(HZ, cpu));

How about calling the local var "trim"?

This actually makes the code more readable, IMHO.

Thanks,
Rusty.
