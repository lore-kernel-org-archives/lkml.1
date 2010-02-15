Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab0BOUMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 15:12:37 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44181 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140Ab0BOUMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 15:12:35 -0500
Date: Mon, 15 Feb 2010 12:12:33 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Kay Sievers <kay.sievers@suse.de>
Subject: Re: oops in uevent_helper [was: mmotm 2010-01-13-12-17 uploaded]
Message-ID: <20100215201233.GI6750@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <201001132042.o0DKgaSR027272@imap1.linux-foundation.org> <4B50C2FA.4020100@gmail.com> <4B50FC78.9010107@gmail.com> <20100122155237.e93a1c55.akpm@linux-foundation.org> <4B730EE3.4080405@gmail.com> <20100211205745.GA18202@basil.fritz.box> <20100211142513.b1fd6e7a.akpm@linux-foundation.org> <20100212052126.GA21783@one.firstfloor.org> <20100211212708.aa5bec1f.akpm@linux-foundation.org> <20100212170624.GB27303@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100212170624.GB27303@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 12:06:24PM -0500, Neil Horman wrote:
> On Thu, Feb 11, 2010 at 09:27:08PM -0800, Andrew Morton wrote:
> > On Fri, 12 Feb 2010 06:21:26 +0100 Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > > urgh, must I?  That trashes Neil's
> > > > kmod-add-init-function-to-usermodehelper.patch and
> > > > kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
> > > > and probably requires repairing other stuff and sets the testing status
> > > > back to "square one".
> > > > 
> > > > If you have patches queued, please make the time to support them!
> > > 
> > > Ok, understood. I'll try to look into it today.
> > 
> > Ta.  As I mentioned to Neil, if it looks serious then let's shelve it
> > all and revisit for 2.6.35.
> > 
> > > You want incrementals?
> > 
> > If convenient, please.  Otherwise we can drop--and-remerge.
> > 
> > 
> 
> 
> Ok, this fixes the oops Jiri reported for me.  Its been tested by me, but only
> minimally, and my rcu-foo is not the greatest, so through reviews appreciated.
> The patch is incremental against the latest mmotm as of this AM.

A few questions interspersed below...

							Thanx, Paul

> Thanks!
> Neil
> 
> 
> Fix up remaining references to uevent_helper to play nice with Andi's
> uevent_helper/rcu changes.
> 
> Some changes were made recently which modified uevent_helper to be an rcu
> protected pointer, rather than a static char array.  This has led to a few
> missed points in which the sysfs path still assumed that:
> 1) the uevent_helper symbol could still be accessed safely without
> rcu_dereference
> 2) that the sysfs path could copy data to that pointer safely.
> 
> I've fixed this by chaging the sysfs path so that it duplicates the string on
> uevent_helper_store, and freeing it (only if it doesn't point to the
> CONFIG_DEFAULT_UEVENT_HELPER string), in a call_rcu post-quiescent point.  I've
> also fixed up the remaining references to the uevent_helper pointers to use
> rcu_dereference.
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> 
>  kernel/ksysfs.c      |   38 ++++++++++++++++++++++++++++++++++++--
>  lib/kobject_uevent.c |    4 +++-
>  2 files changed, 39 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
> index 21fe3c4..66d1e5b 100644
> --- a/kernel/ksysfs.c
> +++ b/kernel/ksysfs.c
> @@ -37,19 +37,53 @@ KERNEL_ATTR_RO(uevent_seqnum);
>  static ssize_t uevent_helper_show(struct kobject *kobj,
>  				  struct kobj_attribute *attr, char *buf)
>  {
> -	return sprintf(buf, "%s\n", uevent_helper);
> +	return sprintf(buf, "%s\n", rcu_dereference(uevent_helper));
>  }
> +
> +struct uevent_helper_rcu {
> +	char *oldptr;
> +	struct rcu_head rcu;
> +};
> +
> +static void free_old_uevent_ptr(struct rcu_head *list)
> +{
> +	struct uevent_helper_rcu *ptr;
> +	char *dfl = CONFIG_UEVENT_HELPER_PATH;

Given that you kfree() something that might be equal to dfl, I am
hoping that the CONFIG_UEVENT_HELPER_PATH macro expands to something
that kfree() can do something with...

Or did you mean to put a "return;" in the then-clause of the "if"
statement below?

> +	ptr = container_of(list, struct uevent_helper_rcu, rcu);
> +	if (ptr->oldptr && (ptr->oldptr != dfl))
> +		kfree(ptr->oldptr);
> +
> +	kfree(ptr);
> +}
> +
>  static ssize_t uevent_helper_store(struct kobject *kobj,
>  				   struct kobj_attribute *attr,
>  				   const char *buf, size_t count)
>  {
> +	char *kbuf;
> +	struct uevent_helper_rcu *old;
> +
>  	if (count+1 > UEVENT_HELPER_PATH_LEN)
>  		return -ENOENT;
> -	memcpy(uevent_helper, buf, count);
> +	kbuf = kstrndup(buf, UEVENT_HELPER_PATH_LEN, GFP_KERNEL);
> +	if (!kbuf)
> +		return -ENOMEM;
>  	uevent_helper[count] = '\0';
>  	if (count && uevent_helper[count-1] == '\n')
>  		uevent_helper[count-1] = '\0';
> +	old = kmalloc(sizeof(struct uevent_helper_rcu), GFP_KERNEL);
> +	if (!old)
> +		goto out_free;
> +
> +	old->oldptr = rcu_dereference(uevent_helper);
> +	rcu_assign_pointer(uevent_helper, kbuf);

Some lock protects this?  Or does something else prevent multiple
instances of uevent_helper_store() from executing concurrently?

> +	call_rcu(&old->rcu, free_old_uevent_ptr);
> +
>  	return count;
> +
> +out_free:
> +	kfree(kbuf);
> +	return -ENOMEM;
>  }
>  KERNEL_ATTR_RW(uevent_helper);
>  #endif
> diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
> index c2383f3..211f846 100644
> --- a/lib/kobject_uevent.c
> +++ b/lib/kobject_uevent.c
> @@ -126,6 +126,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
>  	struct kset *kset;
>  	const struct kset_uevent_ops *uevent_ops;
>  	u64 seq;
> +	const char *helper;
>  	int i = 0;
>  	int retval = 0;
> 
> @@ -272,7 +273,8 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
>  #endif
> 
>  	/* call uevent_helper, usually only enabled during early boot */
> -	if (uevent_helper[0])
> +	helper = rcu_dereference(uevent_helper);

This is protected by a pre-existing rcu_read_lock() somewhere?

If not, an rcu_read_lock() / rcu_read_unlock() pair is needed that
covers both the rcu_dereference() and any subsequent dereferences of the
pointer returned by rcu_dereference().

> +	if (helper[0])
>  		retval = uevent_call_helper(subsystem, env);
> 
>  exit:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
