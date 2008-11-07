Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbYKGApW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbYKGApW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 19:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbYKGApI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 19:45:08 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:43911 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbYKGApG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 19:45:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=faGO4QuhtZL2Cyw6DaHbIHHhj1zZW8iJQI+iN9Z6LHecC/175lYCfLFT5stzUMNwFt
         WrbC+EjcemX6ZdRim5kbH+lmXbwhhabkeyK5wNbdhgbT7rvqD5sQL5CP3dufJduBwKFi
         NFOcL98MzK0hEUSarYMQzC1iSvoE8bY4tO8Hs=
Date: Fri, 7 Nov 2008 03:48:24 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ken Chen <kenchen@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
Message-ID: <20081107004824.GA28780@x200.localdomain>
References: <20081106203520.GD3578@elte.hu> <20081107003021.GA18666@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107003021.GA18666@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 04:30:23PM -0800, Ken Chen wrote:
> On Thu, Nov 6, 2008 at 12:35 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >> +static int proc_pid_stack(struct task_struct *task, char *buffer)
> >> +{
> >> +     for (i = 0; i < trace.nr_entries; i++) {
> >> +             len += sprintf(buffer + len, "[<%p>] %pS\n",
> >> +                             (void *)entries[i], (void
> >> *)entries[i]);
> >
> > hm, this looks like a potential buffer overflow - isnt 'buffer' here
> > only valid up to the next PAGE_SIZE boundary?

So, make trace depth low enough, or even better use seqfiles, if you're
scared by buffer overflows.

> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -130,6 +131,12 @@ struct pid_entry {
>  		{ .proc_show = &proc_##OTYPE } )
>  
>  /*
> + * buffer size used for proc read.  See proc_info_read().
> + * 4K page size but our output routines use some slack for overruns
> + */
> +#define PROC_BLOCK_SIZE	(3*1024)
