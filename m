Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbYC0JEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbYC0JEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbYC0JEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:04:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824AbYC0JEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:04:21 -0400
Date: Thu, 27 Mar 2008 02:04:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, daniel@hozac.com, lizf@cn.fujitsu.com,
       Pavel Emelyanov <xemul@openvz.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/1] cgroups: implement device whitelist (v6)
Message-Id: <20080327020403.5547e43f.akpm@linux-foundation.org>
In-Reply-To: <20080326180543.GA27709@sergelap.austin.ibm.com>
References: <20080326180543.GA27709@sergelap.austin.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008 13:05:43 -0500 "Serge E. Hallyn" <serue@us.ibm.com> wrote:

> (This is identical to the version I sent on Mar 19 in response to
> the comments by Daniel Hokka Zakrisson, which are the last
> comments I've gotten.)
> 
> Implement a cgroup to track and enforce open and mknod restrictions on device
> files.  A device cgroup associates a device access whitelist with each
> cgroup.  A whitelist entry has 4 fields.  'type' is a (all), c (char), or
> b (block).  'all' means it applies to all types and all major and minor
> numbers.  Major and minor are either an integer or * for all.
> Access is a composition of r (read), w (write), and m (mknod).
> 
> The root device cgroup starts with rwm to 'all'.  A child devcg gets
> a copy of the parent.  Admins can then remove devices from the
> whitelist or add new entries.  A child cgroup can never receive a
> device access which is denied its parent.  However when a device
> access is removed from a parent it will not also be removed from the
> child(ren).
> 
> An entry is added using devices.allow, and removed using
> devices.deny.  For instance
> 
> 	echo 'c 1:3 mr' > /cgroups/1/devices.allow
> 
> allows cgroup 1 to read and mknod the device usually known as
> /dev/null.  Doing
> 
> 	echo a > /cgroups/1/devices.deny
> 
> will remove the default 'a *:* mrw' entry.
> 
> CAP_SYS_ADMIN is needed to change permissions or move another task
> to a new cgroup.  A cgroup may not be granted more permissions than
> the cgroup's parent has.  Any task can move itself between cgroups.
> This won't be sufficient, but we can decide the best way to
> adequately restrict movement later.

The above should be in Documentation/cgroups.txt?

> +static char *print_whitelist(struct dev_cgroup *devcgroup, int *len)
> +{
> +	char *buf, *s, acc[4];
> +	struct dev_whitelist_item *wh;
> +	int ret;
> +	int count = 0;
> +	char maj[10], min[10];
> +
> +	buf = kmalloc(4096, GFP_KERNEL);
> +	if (!buf)
> +		return ERR_PTR(-ENOMEM);
> +	s = buf;
> +	*s = '\0';
> +	*len = 0;
> +
> +	spin_lock(&devcgroup->lock);
> +	list_for_each_entry(wh, &devcgroup->whitelist, list) {
> +		set_access(acc, wh->access);
> +		set_majmin(maj, 10, wh->major);
> +		set_majmin(min, 10, wh->minor);
> +		ret = snprintf(s, 4095-(s-buf), "%c %s:%s %s\n",
> +			type_to_char(wh->type), maj, min, acc);
> +		if (s+ret >= buf+4095) {
> +			kfree(buf);
> +			buf = ERR_PTR(-ENOMEM);
> +			break;
> +		}
> +		s += ret;
> +		*len += ret;
> +		count++;
> +	}
> +	spin_unlock(&devcgroup->lock);
> +
> +	return buf;
> +}

That's rather ugly-looking.  We can't use seq_file here?


