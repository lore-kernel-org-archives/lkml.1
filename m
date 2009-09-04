Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbZIDOax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbZIDOax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 10:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756847AbZIDOav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 10:30:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943AbZIDOau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 10:30:50 -0400
Date: Fri, 4 Sep 2009 16:26:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@linux-foundation.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 8/8] FS: proc, make limits writable
Message-ID: <20090904142645.GA10535@redhat.com>
References: <20090903174106.GC27161@redhat.com> <1252008524-5376-8-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252008524-5376-8-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03, Jiri Slaby wrote:
>
> Allow writing strings such as
> Max core file size=0:unlimited
> to /proc/<pid>/limits to change limits.

Can't review the parsing in limits_write() because I don't have enough
"C" skills, but otherwise the whole series looks correct to me.






One small nit, just to suggest the further 9/8 cleanup,

> +static const struct file_operations proc_pid_limits_operations = {
> +	.read		= proc_info_read,
> +	.write		= limits_write,
> +};

I think it makes sense to tweak proc_pid_limits() a little bit (and
rename it), so that we can do

	.read = limits_read,
	.write = limits_write

Then,

> @@ -2501,7 +2571,9 @@ static const struct pid_entry tgid_base_stuff[] = {
> +	NOD("limits",	  S_IFREG|S_IRUSR|S_IWUSR, NULL,
> +			&proc_pid_limits_operations,
> +			{ .proc_read = proc_pid_limits }),

We could use

	REG("limits", S_IRUSR|S_IWUSR, &proc_pid_limits_operations),

instead, this looks a bit cleaner to me.

But as I said, we can do this later.


And another minor nit (just in case you will re-submit this series for
some reason). Perhaps the changelog in 6/8 should mention that we do
not do any security checks when tsk != current (without selinux). We
assume that either the caller is sys_setrlimit(), or the caller should
verify it has rights to change the limits: in case of limits_write()
we rely on ->mode = S_IRUSR|S_IWUSR.

Oleg.

