Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbZKCX7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbZKCX7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbZKCX7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:59:44 -0500
Received: from vena.lwn.net ([206.168.112.25]:55353 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045AbZKCX7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:59:43 -0500
Date: Tue, 3 Nov 2009 16:59:47 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linus-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
       eparis@redhat.com
Subject: Re: [PATCH 10/10] send events using read
Message-ID: <20091103165947.35bd78d7@bike.lwn.net>
In-Reply-To: <20091031184819.17244.55795.stgit@paris.rdu.redhat.com>
References: <20091031184721.17244.16465.stgit@paris.rdu.redhat.com>
	<20091031184819.17244.55795.stgit@paris.rdu.redhat.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Eric,

This is not a full review, but I did notice a problem as I was trying to
figure out the new API...

> +static ssize_t fanotify_read(struct file *file, char __user *buf,
> +			     size_t count, loff_t *pos)
> +{
> +	struct fsnotify_group *group;
> +	struct fsnotify_event *kevent;
> +	char __user *start;
> +	int ret;
> +	DEFINE_WAIT(wait);
> +
> +	start = buf;
> +	group = file->private_data;
> +
> +	pr_debug("%s: group=%p\n", __func__, group);
> +
> +	while (1) {
> +		prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
> +
> +		mutex_lock(&group->notification_mutex);
> +		kevent = get_one_event(group, count);
> +		mutex_unlock(&group->notification_mutex);

prepare_to_wait(), among other things, sets the task state.  But then you
go into various sleeping calls (mutex_lock(), for starters); that will undo
what prepare_to_wait has done.  You'll be back in TASK_RUNNING at this
point, so you'll never sleep.

I've not looked at the code well enough to know how to fix it.  My guess is
that the sleeping on event availability should be done in get_one_event(),
or in a small wrapper which goes immediately around it.

> +
> +		if (kevent) {
> +			ret = PTR_ERR(kevent);
> +			if (IS_ERR(kevent))
> +				break;
> +			ret = copy_event_to_user(group, kevent, buf);
> +			fsnotify_put_event(kevent);
> +			if (ret < 0)
> +				break;
> +			buf += ret;
> +			count -= ret;
> +			continue;
> +		}
> +
> +		ret = -EAGAIN;
> +		if (file->f_flags & O_NONBLOCK)
> +			break;
> +		ret = -EINTR;
> +		if (signal_pending(current))
> +			break;
> +
> +		if (start != buf)
> +			break;

Alternatively, maybe you could do this here?

	        prepare_to_wait(...);
		if (fsnotify_notify_queue_is_empty(group))
			schedule()
> +
> +		schedule();

You also need finish_wait() here, not outside the loop.

> +	}
> +
> +	finish_wait(&group->notification_waitq, &wait);
> +	if (start != buf && ret != -EFAULT)
> +		ret = buf - start;
> +	return ret;
> +}

jon
