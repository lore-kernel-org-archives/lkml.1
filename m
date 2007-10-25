Return-Path: <linux-kernel-owner+w=401wt.eu-S1759520AbXJYSpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520AbXJYSpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbXJYSpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:45:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbXJYSp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:45:29 -0400
Message-ID: <4720E424.7060509@redhat.com>
Date: Thu, 25 Oct 2007 14:44:52 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Rich Paul <socketpair_bug@rich-paul.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: BUG in sys_socketpair
References: <20071025141107.GA19437@dragon.rich-paul.net>
In-Reply-To: <20071025141107.GA19437@dragon.rich-paul.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2007 10:11 AM, Rich Paul wrote:
> In 2.6.23, there seems to be a minor bug in sys_socketpair.  When the
> calls to sock_alloc_fd fail, it aborts the routine, but it returns the
> variable err, which is not set in this case.
> 
> The result is a silent failure if you have too many files open and call
> socketpair.
> 
> Here is a simple UNTESTED patch (not even compiled) which should resolve the
> issue.
> 
> 
> --- net/socket.c.orig   2007-10-25 10:03:56.000000000 -0400
> +++ net/socket.c        2007-10-25 10:04:00.000000000 -0400
> @@ -1245,11 +1245,14 @@
>                 goto out_release_both;
> 
>         fd1 = sock_alloc_fd(&newfile1);
> -       if (unlikely(fd1 < 0))
> +       if (unlikely(fd1 < 0)) {
> +               err=fd1;
>                 goto out_release_both;
> +       }
> 
>         fd2 = sock_alloc_fd(&newfile2);
>         if (unlikely(fd2 < 0)) {
> +               err=fd2;
>                 put_filp(newfile1);
>                 put_unused_fd(fd1);
>                 goto out_release_both;
> 

Should be "err = fd1" (spaces), otherwise looks good.

Original did:

	err = sock_map_fd(sock1);
	if (err < 0)
		goto out_release_both;
	fd1 = err;
