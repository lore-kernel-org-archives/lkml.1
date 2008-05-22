Return-Path: <linux-kernel-owner+w=401wt.eu-S933837AbYEVI1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933837AbYEVI1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 04:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755566AbYEVI1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 04:27:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61217 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754143AbYEVI1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 04:27:19 -0400
Message-ID: <48352E07.7050709@cn.fujitsu.com>
Date: Thu, 22 May 2008 16:25:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove unnecessary memmove() in cgroup_path()
References: <48352127.20804@cn.fujitsu.com> <20080522030324.2b650f93.pj@sgi.com>
In-Reply-To: <20080522030324.2b650f93.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Lai wrote:
>> memmove() is unnecessary in cgroup_path(), the following patch will remove it.
> 
> True, I think -- memmove() can be removed as you suggest.
> 
> However, it makes the code a little harder to read, in my opinion,
> because the meaning of the "@buf" parameter passed into cgroup_path()
> is no longer quite the same as the meaning of that same parameter,
> upon return from cgroup_path().
> 
> I have a fairly consistent preference for code clarity, even if it
> means an occassional extra bit of code gets executed, unless we're
> on some code path where the performance gained from the tighter code
> is important.  I don't think that cgroup_path() is on such a path;

Nor do I. cgroup_path() will be executed in 2 places. One is when you
cat /proc/<pid>/cgroup or a few other cgroup-related files in /proc,
one is when run the release agent. So I don't think the patch will
improve performance.

> however I could be wrong on that point.  Did you discover this non-
> essential call to memmove() by code reading, or by observing that
> it was causing some noticeable performance loss for some situation
> that you care about?
> 
> If we did go with this patch as you suggest, then I would like to
> suggest that we elaborate your explanation of what the "@buf"
> parameter to cgroup_path() means.
> 
> Your patch states:
> 
> + * @buf: *buf is the buffer to write the path into, and it was set
> + *       to the start of the path when return
> 
> I would suggest stating instead something like:
> 
>   * @buf: On entry, @buf is a pointer to a pointer to a buffer of
>   *       length @buflen into which the path will be written.  In most
>   *       cases, excepting some trivial cases such as returning "/",
>   *       the path will be written into the -high- end of the buffer,
>   *       and the pointer to which buf points will be updated on
>   *       return from cgroup_path() to point to the beginning of that
>   *       path, somewhere within the original passed in buffer.
> 
> 
> One more minor suggestion ... your patch has:
> -		char *pathbuf;
> +		char *pathbuf, *path;
> 
> and later on it has:
> -	char *buf;
> +	char *buf, *path;
> 
> Could you use the same variable names, when referring to the same
> things, in both places?  It makes the code a little easier to read.
> 
> Overall, however, I am not sure I like this patch, unless you have good
> performance reasons to get rid of that memmove().  The complications to
> what the "@buf" parameter to cgroup_path() means just aren't worth it,
> in my current opinion.
> 

