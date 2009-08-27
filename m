Return-Path: <linux-kernel-owner+w=401wt.eu-S1752270AbZH0MIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbZH0MIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbZH0MIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:08:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbZH0MIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:08:50 -0400
Subject: Re: [PATCH] inotify:  Ensure we alwasy write the terminating NULL.
From: Eric Paris <eparis@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <m1iqg9k17v.fsf_-_@fess.ebiederm.org>
References: <m1skffj64t.fsf@fess.ebiederm.org>
	 <1251299483.2308.32.camel@dhcp231-106.rdu.redhat.com>
	 <m1iqg9k17v.fsf_-_@fess.ebiederm.org>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 07:57:41 -0400
Message-Id: <1251374261.2280.18.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-27 at 03:20 -0700, Eric W. Biederman wrote:
> Before the rewrite copy_event_to_user always wrote a terqminating '\0'
> byte to user space after the filename.  Since the rewrite that
> terminating byte was skipped if your filename is exactly a multiple of
> event_size.  Ouch!

All of my testing code was carefully using the len field rather than
counting on it being nul terminated.  You are clearly right, it's
supposed to be nul terminated.

> So add one byte to name_size before we round up and use clear_user to
> set userspace to zero like /dev/zero does instead of copying the
> strange nul_inotify_event.

I already did this in linux-next but haven't passed it to Linus since
although stupid it's right and works.  I guess I'll pass it along rolled
up in your patch now.

>   I can't quite convince myself len_to_zero
> will never exceed 16 and even if it doesn't clear_user should be more
> efficient and a more accurate reflection of what the code is trying to
> do.

len_to_zero has to be <= sizeof(struct inotify_event) since it's defined
as:
        size_t event_size = sizeof(struct inotify_event);
        name_len = roundup(event->name_len, event_size);
        unsigned int len_to_zero = name_len - event->name_len;

So name_len can never be more than 'event_size' larger than
event->name_len.  Then len_to_zero could never be > 16.

Adding to my tree now.

-Eric

> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> ---
>  fs/notify/inotify/inotify_user.c |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
> index f30d9bb..90ae8ad 100644
> --- a/fs/notify/inotify/inotify_user.c
> +++ b/fs/notify/inotify/inotify_user.c
> @@ -47,9 +47,6 @@
>  
>  static struct vfsmount *inotify_mnt __read_mostly;
>  
> -/* this just sits here and wastes global memory.  used to just pad userspace messages with zeros */
> -static struct inotify_event nul_inotify_event;
> -
>  /* these are configurable via /proc/sys/fs/inotify/ */
>  static int inotify_max_user_instances __read_mostly;
>  static int inotify_max_queued_events __read_mostly;
> @@ -199,8 +196,10 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
>  		inotify_free_event_priv(fsn_priv);
>  	}
>  
> -	/* round up event->name_len so it is a multiple of event_size */
> -	name_len = roundup(event->name_len, event_size);
> +	/* round up event->name_len so it is a multiple of event_size
> +	 * plus an extra byte for the terminating '\0'.
> +	 */
> +	name_len = roundup(event->name_len + 1, event_size);
>  	inotify_event.len = name_len;
>  
>  	inotify_event.mask = inotify_mask_to_arg(event->mask);
> @@ -224,8 +223,8 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
>  			return -EFAULT;
>  		buf += event->name_len;
>  
> -		/* fill userspace with 0's from nul_inotify_event */
> -		if (copy_to_user(buf, &nul_inotify_event, len_to_zero))
> +		/* fill userspace with 0's */
> +		if (clear_user(buf, len_to_zero))
>  			return -EFAULT;
>  		buf += len_to_zero;
>  		event_size += name_len;


