Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbYDQVIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbYDQVIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 17:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbYDQVIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 17:08:30 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:38472 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYDQVI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 17:08:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=I5hyURGngsMO03DI/QuCxwRFFYAdgHSnKFxfUKerhAApHb/oIWvwIFQJ9Jslk4IXGFaUEN/D+JRairyJxepx15rqkJvENHI0Hz20tl7ZxZp1xF1t9E3mqZxFAtXk5zFWIRSCV48lCChcjr8l7xmh+ZB4RBJ314SlL5iXFQ6W4LQ=
Message-ID: <4807BC41.50406@gmail.com>
Date: Thu, 17 Apr 2008 23:08:17 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: sukadev@us.ibm.com
CC: Andrew Morton <akpm@osdl.org>, serue@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Factor out PTY index allocation
References: <20080416221723.GB7112@us.ibm.com>
In-Reply-To: <20080416221723.GB7112@us.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2008 12:17 AM, sukadev@us.ibm.com wrote:
> We noticed this while working on pts namespaces and believe this might
> be an useful change even as we rework our pts/device namespace approach.
> 
> ---
> 
> From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
> Subject: [PATCH]: Factor out PTY index allocation
> 
> Factor out the code used to allocate/free a pts index into new interfaces,
> devpts_new_index() and devpts_kill_index().  This localizes the external
> data structures used in managing the pts indices.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
> Signed-off-by: Serge Hallyn<serue@us.ibm.com>
> Signed-off-by: Matt Helsley<matthltc@us.ibm.com>
> 
> ---
>  drivers/char/tty_io.c     |   40 ++++++----------------------------------
>  fs/devpts/inode.c         |   42 +++++++++++++++++++++++++++++++++++++++++-
>  include/linux/devpts_fs.h |    4 ++++
>  3 files changed, 51 insertions(+), 35 deletions(-)
[...]
> Index: 2.6.25-rc8-mm2/drivers/char/tty_io.c
> ===================================================================
> --- 2.6.25-rc8-mm2.orig/drivers/char/tty_io.c	2008-04-16 09:51:11.000000000 -0700
> +++ 2.6.25-rc8-mm2/drivers/char/tty_io.c	2008-04-16 09:51:15.000000000 -0700
> @@ -137,9 +136,6 @@ EXPORT_SYMBOL(tty_mutex);
>  
>  #ifdef CONFIG_UNIX98_PTYS
>  extern struct tty_driver *ptm_driver;	/* Unix98 pty masters; for /dev/ptmx */
> -extern int pty_limit;			/* Config limit on Unix98 ptys */
> -static DEFINE_IDR(allocated_ptys);
> -static DEFINE_MUTEX(allocated_ptys_lock);
[...]
> Index: 2.6.25-rc8-mm2/fs/devpts/inode.c
> ===================================================================
> --- 2.6.25-rc8-mm2.orig/fs/devpts/inode.c	2008-02-27 15:17:59.000000000 -0800
> +++ 2.6.25-rc8-mm2/fs/devpts/inode.c	2008-04-16 09:51:15.000000000 -0700
> @@ -26,6 +27,10 @@
>  
>  #define DEVPTS_DEFAULT_MODE 0600
>  
> +extern int pty_limit;			/* Config limit on Unix98 ptys */
> +static DEFINE_IDR(allocated_ptys);
> +static DECLARE_MUTEX(allocated_ptys_lock);

Ugh, why mutex->semaphore conversion?
