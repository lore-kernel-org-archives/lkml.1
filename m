Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbXDTENA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbXDTENA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 00:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754423AbXDTEM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 00:12:59 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754412AbXDTEM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 00:12:57 -0400
Date: Thu, 19 Apr 2007 21:12:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Keiichi KII <k-keiichi@bx.jp.nec.com>
Cc: mpm@selenic.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC][PATCH -mm take4 4/6] using symlink for the net_device
Message-Id: <20070419211239.6f22ee2c.akpm@linux-foundation.org>
In-Reply-To: <46260AE2.9080107@bx.jp.nec.com>
References: <462605DC.2080804@bx.jp.nec.com>
	<46260AE2.9080107@bx.jp.nec.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007 21:11:14 +0900 Keiichi KII <k-keiichi@bx.jp.nec.com> wrote:

> From: Keiichi KII <k-keiichi@bx.jp.nec.com>
> 
> We use symbolic link for net_device.

As Stephen said, please fully document the new interfaces in netconsole.txt.

Please also cc netdev@vger.kernel.org on all networking-related patches.

> +static char *make_netdev_class_name(char *netdev_name);
> +static int netconsole_event(struct notifier_block *this, unsigned long event,
> +			    void *ptr);

Please try order things in a way which minimises the number of
forward-declarations, as long as such ordering doesn't make the code
illogical (it usually doesn't).

>  static int miscdev_configured;
>  
> @@ -274,12 +277,77 @@ static struct miscdevice netconsole_misc
>  	.name = "netconsole",
>  };
>  
> +static struct notifier_block netconsole_notifier = {
> +	.notifier_call = netconsole_event,
> +};
> +
>  static int setup_target_sysfs(struct netconsole_target *nt)
>  {
> +	int retval = 0;
> +	char *name;
> +
>  	kobject_set_name(&nt->obj, "port%d", nt->id);
>  	nt->obj.parent = &netconsole_miscdev.this_device->kobj;
>  	nt->obj.ktype = &target_ktype;
> -	return kobject_register(&nt->obj);
> +	retval = kobject_register(&nt->obj);
> +	name = make_netdev_class_name(nt->np.dev_name);
> +	if (IS_ERR(name))
> +		return PTR_ERR(name);
> +	retval = sysfs_create_link(&nt->obj, &nt->np.dev->dev.kobj, name);
> +	kfree(name);
> +
> +	return retval;
> +}
> +
> +static char *make_netdev_class_name(char *netdev_name)
> +{
> +	int size;
> +	char *name;
> +	char *netdev_class_prefix = "net:";
> +
> +	size = strlen(netdev_class_prefix) + strlen(netdev_name) + 1;
> +	name = kmalloc(size, GFP_KERNEL);
> +	if (!name) {
> +		printk(KERN_ERR "netconsole: kmalloc() failed!\n");
> +		return ERR_PTR(-ENOMEM);
> +	}
> +	strcpy(name, netdev_class_prefix);
> +	strcat(name, netdev_name);
> +
> +	return name;
> +}

I think this whole function can be replaced by one call to kasprintf()

> +static int netconsole_event(struct notifier_block *this, unsigned long event,
> +			    void *ptr)
> +{
> +	int error = 0;
> +	char *old_link_name = NULL, *new_link_name = NULL;
> +	struct netconsole_target *nt;
> +	struct net_device *dev = ptr;
> +
> +	if (event == NETDEV_CHANGENAME) {
> +		spin_lock(&target_list_lock);
> +		list_for_each_entry(nt, &target_list, list) {
> +			if (nt->np.dev != dev)
> +				continue;
> +			new_link_name = make_netdev_class_name(dev->name);
> +			old_link_name =
> +				make_netdev_class_name(nt->np.dev_name);

The error return from make_netdev_class_name() is being ignored here.

> +			sysfs_remove_link(&nt->obj, old_link_name);
> +			error = sysfs_create_link(&nt->obj,
> +						  &nt->np.dev->dev.kobj,
> +						  new_link_name);
> +			if (error)
> +				printk(KERN_ERR "can't create link: %s\n",
> +				       new_link_name);
> +			strcpy(nt->np.dev_name, dev->name);
> +			kfree(new_link_name);
> +			kfree(old_link_name);
> +		}
> +		spin_unlock(&target_list_lock);
> +	}
> +
> +	return NOTIFY_DONE;
>  }

