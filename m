Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbZFBCel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbZFBCel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 22:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbZFBCee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 22:34:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47282 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492AbZFBCed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 22:34:33 -0400
Date: Mon, 1 Jun 2009 21:40:31 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Move sleeping operations to outside the semaphore.
Message-ID: <20090602024031.GA21564@hallyn.com>
References: <200906020141.n521faqb003256@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906020141.n521faqb003256@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@i-love.sakura.ne.jp):
> TOMOYO is using rw_semaphore for protecting list elements.
> But TOMOYO is doing operations which might sleep inside down_write().
> This patch makes TOMOYO's sleeping operations go outside down_write().
> 
> Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>
> ---
>  security/tomoyo/common.c   |   80 ++++++---------------
>  security/tomoyo/common.h   |    2 
>  security/tomoyo/domain.c   |  107 ++++++++++++++--------------
>  security/tomoyo/file.c     |  133 ++++++++++++++++++-----------------
>  security/tomoyo/realpath.c |  169 ++++++++++++++-------------------------------
>  security/tomoyo/realpath.h |    7 -
>  6 files changed, 205 insertions(+), 293 deletions(-)
> 
> --- security-testing-2.6.git.orig/security/tomoyo/common.c
> +++ security-testing-2.6.git/security/tomoyo/common.c
> @@ -861,26 +861,27 @@ static struct tomoyo_profile *tomoyo_fin
>  								int profile)
>  {
>  	static DEFINE_MUTEX(lock);
> -	struct tomoyo_profile *ptr = NULL;
> -	int i;
> +	struct tomoyo_profile *new_ptr = NULL;
> +	struct tomoyo_profile *ptr;
>  
>  	if (profile >= TOMOYO_MAX_PROFILES)
>  		return NULL;
> +	new_ptr = kmalloc(sizeof(*new_ptr), GFP_KERNEL);
>  	/***** EXCLUSIVE SECTION START *****/
>  	mutex_lock(&lock);
>  	ptr = tomoyo_profile_ptr[profile];
> -	if (ptr)
> -		goto ok;
> -	ptr = tomoyo_alloc_element(sizeof(*ptr));
> -	if (!ptr)
> -		goto ok;
> -	for (i = 0; i < TOMOYO_MAX_CONTROL_INDEX; i++)
> -		ptr->value[i] = tomoyo_control_array[i].current_value;
> -	mb(); /* Avoid out-of-order execution. */
> -	tomoyo_profile_ptr[profile] = ptr;
> - ok:
> +	if (!ptr && tomoyo_memory_ok(new_ptr)) {
> +		int i;
> +		ptr = new_ptr;
> +		new_ptr = NULL;
> +		for (i = 0; i < TOMOYO_MAX_CONTROL_INDEX; i++)
> +			ptr->value[i] = tomoyo_control_array[i].current_value;
> +		mb(); /* Avoid out-of-order execution. */
> +		tomoyo_profile_ptr[profile] = ptr;
> +	}
>  	mutex_unlock(&lock);
>  	/***** EXCLUSIVE SECTION END *****/
> +	kfree(new_ptr);
>  	return ptr;
>  }

Again I feel (no offense) like I'm reading Ada code here...

Focusing just on this one function,

1. the mutex lock belonging to this function really is just protecting
writes to elements of tomoyo_profile_ptr.  It should be defined,
with a descriptive name and comment, next to tomoyo_profile_ptr
at common.c:46.

2. I see no reason for this not to be a fast spinlock at this
point.

3. Once it's a fast checkpoint, you can change the flow a bit
(unless there is good reason not to) to do:

	spin_lock(&profile_lock);
	ptr = tomoyo_profile_ptr[profile];
	spin_unlock(&profile_lock);

	if (ptr)
		return ptr;

	new_ptr = kmalloc(sizeof(*new_ptr), GFP_KERNEL);
	if (!new_ptr)
		return ERR_PTR(-ENOMEM);

	spin_lock(&profile_lock);
	if (!tomoyo_profile_ptr[profile]) {
		/* do your initialization as above */
		ptr = tomoyo_profile_ptr[profile] = new_ptr;
		new_ptr = NULL;
	}
	spin_unlock(&profile_lock);
	kfree(newptr);
	return ptr;

which avoids the kmalloc in the common case.

-serge
