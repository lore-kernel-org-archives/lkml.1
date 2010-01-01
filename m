Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193Ab0AAXLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab0AAXLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 18:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130Ab0AAXLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 18:11:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752054Ab0AAXLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 18:11:33 -0500
Date: Fri, 1 Jan 2010 15:10:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] sysfs: Cache the last sysfs_dirent to improve readdir
 scalability v2
In-Reply-To: <m1y6kh30pi.fsf_-_@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.1001011501340.3630@localhost.localdomain>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain> <20091226094504.GA6214@liondog.tnic> <20091228092712.AA8C.A69D9226@jp.fujitsu.com> <alpine.LFD.2.00.0912301259220.11961@localhost.localdomain> <m11victac1.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.0912301348320.11961@localhost.localdomain> <m1fx6rtu31.fsf@fess.ebiederm.org> <alpine.LFD.2.00.0912311043330.11961@localhost.localdomain> <m11viaexlj.fsf_-_@fess.ebiederm.org> <alpine.LFD.2.00.1001011047580.3630@localhost.localdomain>
 <m1y6kh30pi.fsf_-_@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Jan 2010, Eric W. Biederman wrote:
>  		mutex_unlock(&sysfs_mutex);
> +		ret = filldir(dirent, name, len, filp->f_pos, ino, type);
> +		mutex_lock(&sysfs_mutex);
> +		if (ret < 0)
> +			break;
> +	}
> +	mutex_unlock(&sysfs_mutex);
> +	if ((filp->f_pos > 1) && !pos) { /* EOF */
> +		filp->f_pos = INT_MAX;
> +		filp->private_data = NULL;
>  	}
>  	return 0;

That

	mutex_lock(&sysfs_mutex);
	if (ret < 0)
		break;

looks just silly. We know 'pos' is non-NULL, so the break will effectively 
just be a "mutex_unlock + return 0", and we just did the mutex_lock, so 
why not instead do

	if (ret < 0)
		return 0;
	mutex_lock(&sysfs_mutex);

there?

Not that it really _matters_, but it seems way clearer, no?

But other than that mindless nit, I can't see anything wrong with your 
logic, and it looks ok to me from just reading the patch itself.

So I guess that's an "Ack", although I'd prefer it to get some more 
testing and perhaps go through Greg's tree as sysfs patches usually go.

And by "testing" I mean both the "yes, this second version also breaks the 
lockdep chain and avoids the warning", but also some kind of actual 
testing of /sysfs itself. If there is any.

		Linus
