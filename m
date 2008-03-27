Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbYC0QZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbYC0QZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 12:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757188AbYC0QZC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 12:25:02 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:59560 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742AbYC0QZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 12:25:00 -0400
Date: Thu, 27 Mar 2008 11:24:47 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       daniel@hozac.com, lizf@cn.fujitsu.com,
       Pavel Emelyanov <xemul@openvz.org>, Greg KH <greg@kroah.com>,
       Paul Menage <menage@google.com>
Subject: Re: [PATCH 1/1] cgroups: implement device whitelist (v6)
Message-ID: <20080327162447.GA15147@sergelap.austin.ibm.com>
References: <20080326180543.GA27709@sergelap.austin.ibm.com> <20080327020403.5547e43f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327020403.5547e43f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Wed, 26 Mar 2008 13:05:43 -0500 "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> 
> > (This is identical to the version I sent on Mar 19 in response to
> > the comments by Daniel Hokka Zakrisson, which are the last
> > comments I've gotten.)
> > 
> > Implement a cgroup to track and enforce open and mknod restrictions on device
> > files.  A device cgroup associates a device access whitelist with each
> > cgroup.  A whitelist entry has 4 fields.  'type' is a (all), c (char), or
> > b (block).  'all' means it applies to all types and all major and minor
> > numbers.  Major and minor are either an integer or * for all.
> > Access is a composition of r (read), w (write), and m (mknod).
> > 
> > The root device cgroup starts with rwm to 'all'.  A child devcg gets
> > a copy of the parent.  Admins can then remove devices from the
> > whitelist or add new entries.  A child cgroup can never receive a
> > device access which is denied its parent.  However when a device
> > access is removed from a parent it will not also be removed from the
> > child(ren).
> > 
> > An entry is added using devices.allow, and removed using
> > devices.deny.  For instance
> > 
> > 	echo 'c 1:3 mr' > /cgroups/1/devices.allow
> > 
> > allows cgroup 1 to read and mknod the device usually known as
> > /dev/null.  Doing
> > 
> > 	echo a > /cgroups/1/devices.deny
> > 
> > will remove the default 'a *:* mrw' entry.
> > 
> > CAP_SYS_ADMIN is needed to change permissions or move another task
> > to a new cgroup.  A cgroup may not be granted more permissions than
> > the cgroup's parent has.  Any task can move itself between cgroups.
> > This won't be sufficient, but we can decide the best way to
> > adequately restrict movement later.
> 
> The above should be in Documentation/cgroups.txt?
> 
> > +static char *print_whitelist(struct dev_cgroup *devcgroup, int *len)
> > +{
> > +	char *buf, *s, acc[4];
> > +	struct dev_whitelist_item *wh;
> > +	int ret;
> > +	int count = 0;
> > +	char maj[10], min[10];
> > +
> > +	buf = kmalloc(4096, GFP_KERNEL);
> > +	if (!buf)
> > +		return ERR_PTR(-ENOMEM);
> > +	s = buf;
> > +	*s = '\0';
> > +	*len = 0;
> > +
> > +	spin_lock(&devcgroup->lock);
> > +	list_for_each_entry(wh, &devcgroup->whitelist, list) {
> > +		set_access(acc, wh->access);
> > +		set_majmin(maj, 10, wh->major);
> > +		set_majmin(min, 10, wh->minor);
> > +		ret = snprintf(s, 4095-(s-buf), "%c %s:%s %s\n",
> > +			type_to_char(wh->type), maj, min, acc);
> > +		if (s+ret >= buf+4095) {
> > +			kfree(buf);
> > +			buf = ERR_PTR(-ENOMEM);
> > +			break;
> > +		}
> > +		s += ret;
> > +		*len += ret;
> > +		count++;
> > +	}
> > +	spin_unlock(&devcgroup->lock);
> > +
> > +	return buf;
> > +}
> 
> That's rather ugly-looking.  We can't use seq_file here?

I can do that, but then it will probably be cleaner if I split the
file into one for read and one for write.

Paul, did you have any plans of offering some sort of cft->read_seq()
helper?  Having both the cft-> helpers and the subsystem code play
with ->private fields and caching the cgroup isn't very palletable.

thanks,
-serge
