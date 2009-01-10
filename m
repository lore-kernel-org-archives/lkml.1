Return-Path: <linux-kernel-owner+w=401wt.eu-S1759915AbZAJAO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915AbZAJAO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 19:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZAJAOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 19:14:48 -0500
Received: from xenotime.net ([72.52.64.118]:34955 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751400AbZAJAOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 19:14:47 -0500
Date: Fri, 9 Jan 2009 16:14:44 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: async: make async a command line option for now
Message-Id: <20090109161444.27139f19.rdunlap@xenotime.net>
In-Reply-To: <200901100002.n0A02qKl010433@hera.kernel.org>
References: <200901100002.n0A02qKl010433@hera.kernel.org>
Organization: YPO4
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2009 00:02:52 GMT Linux Kernel Mailing List wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=cdb80f630be5cbc23d82331f24dc4704f75b64f4
> Commit:     cdb80f630be5cbc23d82331f24dc4704f75b64f4
> Parent:     b32714ba29358a688ef337d5297bf4bdc9f596dc
> Author:     Arjan van de Ven <arjan@linux.intel.com>
> AuthorDate: Fri Jan 9 13:23:45 2009 -0800
> Committer:  Arjan van de Ven <arjan@linux.intel.com>
> CommitDate: Fri Jan 9 13:23:45 2009 -0800
> 
>     async: make async a command line option for now
>     
>     ... and have it default off.
>     This does allow people to work with it for testing.


Is this boot option documented anywhere or did you mean to
keep it hidden to all but inquiring minds?


>     Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  kernel/async.c |   16 ++++++++++++++--
>  1 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/async.c b/kernel/async.c
> index 64cc916..f286e9f 100644
> --- a/kernel/async.c
> +++ b/kernel/async.c
> @@ -65,6 +65,8 @@ static LIST_HEAD(async_pending);
>  static LIST_HEAD(async_running);
>  static DEFINE_SPINLOCK(async_lock);
>  
> +static int async_enabled = 0;
> +
>  struct async_entry {
>  	struct list_head list;
>  	async_cookie_t   cookie;
> @@ -169,7 +171,7 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct l
>  	 * If we're out of memory or if there's too much work
>  	 * pending already, we execute synchronously.
>  	 */
> -	if (!entry || atomic_read(&entry_count) > MAX_WORK) {
> +	if (!async_enabled || !entry || atomic_read(&entry_count) > MAX_WORK) {
>  		kfree(entry);
>  		spin_lock_irqsave(&async_lock, flags);
>  		newcookie = next_cookie++;
> @@ -316,8 +318,18 @@ static int async_manager_thread(void *unused)
>  
>  static int __init async_init(void)
>  {
> -	kthread_run(async_manager_thread, NULL, "async/mgr");
> +	if (async_enabled)
> +		kthread_run(async_manager_thread, NULL, "async/mgr");
>  	return 0;
>  }
>  
> +static int __init setup_async(char *str)
> +{
> +	async_enabled = 1;
> +	return 1;
> +}
> +
> +__setup("fastboot", setup_async);
> +
> +
>  core_initcall(async_init);

---
~Randy
