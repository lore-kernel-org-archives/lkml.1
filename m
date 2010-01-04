Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329Ab0ADIdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab0ADIdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 03:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203Ab0ADIdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 03:33:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44495 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab0ADIdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 03:33:08 -0500
Date: Mon, 4 Jan 2010 09:31:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: 640E9920 <640e9920@gmail.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [RFC] PM_QOS api update to use handles 1/5
Message-ID: <20100104083127.GA1450@ucw.cz>
References: <20091130010953.GA4732@mgross-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130010953.GA4732@mgross-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-11-29 17:09:53, 640E9920 wrote:
> I'm using this crazy email address because I have problems getting to
> linux.intel.com from home, and my work at intel has changed a bit.
> 
> This is the first in a 5 part series that attempts to update PM_QOS to
> use handles instead of named strings in its kernel api.  It seams that
> some folks are using pm_qos on hot paths and the overhead of the list
> walks and string compares is a problem.
> 
> Most of the changes came from aili@codeaurora.org, and I spent some time
> cleaning up the API.
> 
> Also, I couldn't resist myself in renaming the API's a bit give the fact
> that the signatures changed enough that I had to touch all the pm_qos
> users anyway.  I changed *requirement* to *request* in keeping with the
> way PM_QOS really only does best effort.  I've felt "requirement" is too
> strong a word for the way it works.

Looks good on quick scan. Moving away from strings is certainly good.

> @@ -384,15 +363,14 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
>  		size_t count, loff_t *f_pos)
>  {
>  	s32 value;
> -	int pm_qos_class;
> +	struct pm_qos_request_list *pm_qos_req;
>  
> -	pm_qos_class = (long)filp->private_data;
>  	if (count != sizeof(s32))
>  		return -EINVAL;
>  	if (copy_from_user(&value, buf, sizeof(s32)))
>  		return -EFAULT;
> -	sprintf(name, "process_%d", current->pid);
> -	pm_qos_update_requirement(pm_qos_class, name, value);
> +	pm_qos_req = (struct pm_qos_request_list *)filp->private_data;
> +	pm_qos_update_request(pm_qos_req, value);
>  
>  	return  sizeof(s32);
>  }

Umm.. passing binary numbers like that... is not exactly good
interface. Think endianness issues  when writing to it from high-level
language.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
