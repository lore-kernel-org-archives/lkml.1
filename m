Return-Path: <linux-kernel-owner+w=401wt.eu-S966241AbYCTARS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966241AbYCTARS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938509AbYCSXfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:35:19 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50604 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764623AbYCSXfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:35:16 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080319115640.GL10722@ZenIV.linux.org.uk> (message from Al Viro
	on Wed, 19 Mar 2008 11:56:40 +0000)
Subject: Re: [patch 5/6] vfs: optimization to /proc/<pid>/mountinfo patch
References: <20080313212641.989467982@szeredi.hu> <20080313212738.474842471@szeredi.hu> <20080319115640.GL10722@ZenIV.linux.org.uk>
Message-Id: <E1Jc1ai-0003rc-RY@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 19 Mar 2008 17:56:40 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Mar 13, 2008 at 10:26:46PM +0100, Miklos Szeredi wrote:
> > +static int prepend(char **buffer, int *buflen, const char *str,
> > +			  int namelen)
> 
> inline, please.

Akpm wrote earlier about this function:
| Both the newly-added inlines in this patch are wrong.  They will result in
| a larger and slower kernel.  This should be very well known by now.

Please fight that out with him :)

> > @@ -1911,10 +1902,9 @@ char *dentry_path(struct dentry *dentry,
> >  
> >  	spin_lock(&dcache_lock);
> >  	prepend(&end, &buflen, "\0", 1);
> > -	if (!IS_ROOT(dentry) && d_unhashed(dentry)) {
> > -		if (prepend(&end, &buflen, "//deleted", 9))
> > +	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
> > +		(prepend(&end, &buflen, " (deleted)", 10) != 0))
> >  			goto Elong;
> 
> That's a bad idea:
> 	* we bloody well might want to use it outside of procfs
> 	* //deleted is _better_; you can't have an empty path component,
> but you can have a pathname ending on " (deleted)".

This was again Andrew's comment (making it look the same as the links
in /proc/PID/fd), but here I have to agree that //deleted is probably
better in this case.

Miklos
