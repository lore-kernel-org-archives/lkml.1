Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932Ab0AAS4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab0AAS4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 13:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721Ab0AAS43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 13:56:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696Ab0AAS43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 13:56:29 -0500
Date: Fri, 1 Jan 2010 10:56:15 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] sysfs: Cache the last sysfs_dirent to improve readdir
 scalability
In-Reply-To: <m11viaexlj.fsf_-_@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.1001011047580.3630@localhost.localdomain>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain> <20091226094504.GA6214@liondog.tnic> <20091228092712.AA8C.A69D9226@jp.fujitsu.com> <alpine.LFD.2.00.0912301259220.11961@localhost.localdomain> <m11victac1.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.0912301348320.11961@localhost.localdomain> <m1fx6rtu31.fsf@fess.ebiederm.org> <alpine.LFD.2.00.0912311043330.11961@localhost.localdomain> <m11viaexlj.fsf_-_@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Jan 2010, Eric W. Biederman wrote:
> 
> When sysfs_readdir stops short we now cache the next sysfs_dirent to
> return to user space in filp->private_data.  There is no impact on the
> rest of sysfs by doing this and in the common case it allows us to
> pick up exactly where we left off with no seeking.
> 
> Additionally I drop and regrab the sysfs_mutex around filldir to avoid
> a page fault arbitrarily increasing the hold time on the sysfs_mutex.

Ok, looks mostly sane, but a few things look odd.

>  
> -	if (filp->f_pos == 0) {
> +	if (!pos && filp->f_pos == 0) {
>  		ino = parent_sd->s_ino;
>  		if (filldir(dirent, ".", 1, filp->f_pos, ino, DT_DIR) == 0)
>  			filp->f_pos++;
>  	}
> -	if (filp->f_pos == 1) {
> +	if (!pos && filp->f_pos == 1) {
>  		if (parent_sd->s_parent)
>  			ino = parent_sd->s_parent->s_ino;
>  		else
> @@ -847,29 +879,35 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
>  		if (filldir(dirent, "..", 2, filp->f_pos, ino, DT_DIR) == 0)
>  			filp->f_pos++;
>  	}
> -	if ((filp->f_pos > 1) && (filp->f_pos < INT_MAX)) {
> -		mutex_lock(&sysfs_mutex);
> -
> -		/* Skip the dentries we have already reported */
> -		pos = parent_sd->s_dir.children;
> -		while (pos && (filp->f_pos > pos->s_ino))
> -			pos = pos->s_sibling;
> +	/* EOF? */
> +	if (!pos && filp->f_pos > 2)
> +		return 0;

These are all incorrect in the presense of 'lseek'. You can't do that

	if (!pos && "test filp->f_pos")

thing, because you get all the wrong results for both the case of an lseek 
before doing any readdir (which is undefined behavior, so I guess that's 
technically ok) _and_ for the 'lseek back to zero _after_ doing a readdir' 
case (which is _not_ undefined behavior!

It looks like it might be easy to fix by making a sysfs_llseek() function 
that does something like

	.. sysfs_llseek(..)
	{
		mutex_lock(&sysfs_mutex);
		sysfs_release();
		filp->private_data = NULL;
		mutex_unlock(&sysfs_mutex);

		return generic_file_llseek(..);
	}

or similar.  Except themn you'll need to change the EOF condition testing 
and turn it into a re-validation event. Or maybe do the re-validation in 
sysfs_llseek() itself, rather than just dropping the cached data.

Hmm? I haven't thought it through very deeply, so maybe I'm missing 
something.

		Linus
