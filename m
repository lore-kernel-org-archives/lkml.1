Return-Path: <linux-kernel-owner+w=401wt.eu-S933598AbYBHTlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598AbYBHTlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 14:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750698AbYBHTlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 14:41:36 -0500
Received: from mail.suse.de ([195.135.220.2]:40164 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268AbYBHTlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 14:41:35 -0500
Date: Fri, 8 Feb 2008 11:39:27 -0800
From: Greg KH <gregkh@suse.de>
To: Balaji Rao <balajirrao@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] kobject handling in cpufreq
Message-ID: <20080208193927.GA25989@suse.de>
References: <200802090052.40939.balajirrao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802090052.40939.balajirrao@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 12:52:40AM +0530, Balaji Rao wrote:
> Hi greg,
> 
> I encountered a regression in linux-2.6.git which prevented the system from shutting down. I found that it 
> was 'waiting_for_completion' on kobj_unregister.The same thing happened when I tried to take CPUs offline.
> 
> git-bisect pointed me to this commit :
> 
> commit c10997f6575f476ff38442fa18fd4a0d80345f9d
> Author: Greg Kroah-Hartman <gregkh@suse.de>
> Date:   Thu Dec 20 08:13:05 2007 -0800
> 
>     Kobject: convert drivers/* from kobject_unregister() to kobject_put()
> 
> In the file drivers/cpufreq/cpufreq.c, you have not replaced one occurrence of kobject_unregister with kobject_put. 
> Apparently its because of the kobject_put in the subsequent line.
> 
> @@ -1030,8 +1030,6 @@ static int __cpufreq_remove_dev (struct sys_device * sys_dev)
>  
>         unlock_policy_rwsem_write(cpu);
>  
> -       kobject_unregister(&data->kobj);
> -
>         kobject_put(&data->kobj);
>  
>         /* we need to make sure that the underlying kobj is actually
> 
> Now, this can be fixed by adding another kobject_put. But having two kobject_puts in consequent lines tells us that there 
> should be two references to the kobject at that point. So, I believe that it is safe to remove the kobject_get 
> corresponding to the existing kobject_put to fix this.
> 
> Signed-off-by: Balaji Rao <balajirrao@gmail.com>

This looks correct to me, nice catch.

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
