Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab0BDHGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 02:06:06 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:58932 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab0BDHGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 02:06:02 -0500
To: Greg KH <gregkh@suse.de>
Cc: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Serge Hallyn <serue@us.ibm.com>
Subject: Re: sysfs_chmod_file() broken in 2.6.33-rc4-git6
References: <20100120131602.12aa48f7@hyperion.delvare>
	<m1ocko6fkx.fsf@fess.ebiederm.org>
	<20100120160008.7d59688b@hyperion.delvare>
	<20100122041913.GC4302@suse.de>
	<20100203091138.1ababf5e@hyperion.delvare>
	<20100203142218.GA27676@suse.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 03 Feb 2010 23:05:50 -0800
In-Reply-To: <20100203142218.GA27676@suse.de> (Greg KH's message of "Wed\, 3 Feb 2010 06\:22\:18 -0800")
Message-ID: <m1mxzplbu9.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Wed, Feb 03, 2010 at 09:11:38AM +0100, Jean Delvare wrote:
>> On Thu, 21 Jan 2010 20:19:13 -0800, Greg KH wrote:
>> > On Wed, Jan 20, 2010 at 04:00:08PM +0100, Jean Delvare wrote:
>> > > On Wed, 20 Jan 2010 06:01:02 -0800, Eric W. Biederman wrote:
>> > > > Does this fix your issue?
>> > > > 
>> > > > Eric
>> > > > 
>> > > > 
>> > > > diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
>> > > > index 220b758..6a06a1d 100644
>> > > > --- a/fs/sysfs/inode.c
>> > > > +++ b/fs/sysfs/inode.c
>> > > > @@ -81,24 +81,23 @@ int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr * iattr)
>> > > >  		if (!sd_attrs)
>> > > >  			return -ENOMEM;
>> > > >  		sd->s_iattr = sd_attrs;
>> > > > -	} else {
>> > > > -		/* attributes were changed at least once in past */
>> > > > -		iattrs = &sd_attrs->ia_iattr;
>> > > > -
>> > > > -		if (ia_valid & ATTR_UID)
>> > > > -			iattrs->ia_uid = iattr->ia_uid;
>> > > > -		if (ia_valid & ATTR_GID)
>> > > > -			iattrs->ia_gid = iattr->ia_gid;
>> > > > -		if (ia_valid & ATTR_ATIME)
>> > > > -			iattrs->ia_atime = iattr->ia_atime;
>> > > > -		if (ia_valid & ATTR_MTIME)
>> > > > -			iattrs->ia_mtime = iattr->ia_mtime;
>> > > > -		if (ia_valid & ATTR_CTIME)
>> > > > -			iattrs->ia_ctime = iattr->ia_ctime;
>> > > > -		if (ia_valid & ATTR_MODE) {
>> > > > -			umode_t mode = iattr->ia_mode;
>> > > > -			iattrs->ia_mode = sd->s_mode = mode;
>> > > > -		}
>> > > > +	}
>> > > > +	/* attributes were changed at least once in past */
>> > > > +	iattrs = &sd_attrs->ia_iattr;
>> > > > +
>> > > > +	if (ia_valid & ATTR_UID)
>> > > > +		iattrs->ia_uid = iattr->ia_uid;
>> > > > +	if (ia_valid & ATTR_GID)
>> > > > +		iattrs->ia_gid = iattr->ia_gid;
>> > > > +	if (ia_valid & ATTR_ATIME)
>> > > > +		iattrs->ia_atime = iattr->ia_atime;
>> > > > +	if (ia_valid & ATTR_MTIME)
>> > > > +		iattrs->ia_mtime = iattr->ia_mtime;
>> > > > +	if (ia_valid & ATTR_CTIME)
>> > > > +		iattrs->ia_ctime = iattr->ia_ctime;
>> > > > +	if (ia_valid & ATTR_MODE) {
>> > > > +		umode_t mode = iattr->ia_mode;
>> > > > +		iattrs->ia_mode = sd->s_mode = mode;
>> > > >  	}
>> > > >  	return 0;
>> > > >  }
>> > > 
>> > > Yes, this fixes my problem. Thanks for the fast fix!
>> > 
>> > Great, Eric, care to resend this so that I can submit it for inclusion?
>> 
>> Ping Eric, the patch is still not in Linus' tree.
>
> Nor mine :)
>
> Eric, care to send it to me?

Apologies for the long delay.  I have been extremely out of it lately.
I am should have a signed off by version sent shortly.  I looked and
this problem also exists in 2.6.32 but hides because in that case we
directly update the vfs inode so sysfs_chmod works until the vfs inode
is evicted.   I will send you a patch for 2.6.32 -stable as well.

Eric
