Return-Path: <linux-kernel-owner+w=401wt.eu-S964843AbXBUEG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964843AbXBUEG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 23:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965113AbXBUEG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 23:06:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964843AbXBUEG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 23:06:56 -0500
Date: Tue, 20 Feb 2007 20:05:26 -0800
From: Greg KH <greg@kroah.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: securityfs_create_dir strange comment
Message-ID: <20070221040526.GA8207@kroah.com>
References: <Pine.LNX.4.61.0702181642060.28890@yvahk01.tjqt.qr> <20070220211849.GA3416@vino.hallyn.com> <20070220222652.GB21696@kroah.com> <Pine.LNX.4.61.0702210042140.7132@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0702210042140.7132@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 12:45:40AM +0100, Jan Engelhardt wrote:
> 
> On Feb 20 2007 14:26, Greg KH wrote:
> >On Tue, Feb 20, 2007 at 03:18:49PM -0600, Serge E. Hallyn wrote:
> >> Quoting Jan Engelhardt (jengelh@linux01.gwdg.de):
> >> > Hello list,
> >> > 
> >> > 
> >> > in security/inode.c, the comment for securityfs_create_dir() reads:
> >> > 
> >> > 	If securityfs is not enabled in the kernel, the value -ENODEV 
> >> > 	will be returned.  It is not wise to check for this value, but 
> >> > 	rather, check for NULL or !NULL instead as to eliminate the need 
> >> > 	for #ifdef in the calling code.
> >> > 
> >> > What is the actual callee that can return NULL - and what should 
> >> > module_init() of a module return when securityfs_create_dir() returns 
> >> > NULL?
> >> 
> >> Hmm, this came from GregKH.  It does seem based on the code that
> >> checking for -ENODEV is necessary, so I don't understand the comment.
> >
> >If securityfs_create_dir() returns NULL, then something bad happened and
> >your code needs to properly recover from it.
> >
> >Other than that, I don't understand the issue here.
> 
> Consider:
> 
> static __init int mymodule_init(void)
> {
>     struct dentry *de;
>     de = securityfs_create_dir("foobar", NULL);
> 
>     /* case 1 */
>     if(IS_ERR(de))
>         return PTR_ERR(de);
> 
>     /* case 2 */
>     if(de == NULL)
>         return WHAT_HERE; /* -EIO? */
> }
> 
> There are two error cases. One: when the function gives us an error code.
> Two: When it returns NULL, without an error code. This looks bogus to me.
> What error is it, when there is no error? - And what should I return to
> modprobe in that case?

Try this instead:
	if (!de)
		return -ENOMEM;
	if ((IS_ERR(de)) && (PTR_ERR(de) != -ENODEV))
		return PTR_ERR(de);
	return 0;

That should cover everything properly, right?

thanks,

greg k-h
