Return-Path: <linux-kernel-owner+w=401wt.eu-S1760863AbYEQVmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760863AbYEQVmS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 17:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759806AbYEQVl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 17:41:57 -0400
Received: from smtp27.orange.fr ([80.12.242.94]:23635 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759638AbYEQVlz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 17:41:55 -0400
X-ME-UUID: 20080517214153521.7F5D01C00098@mwinf2704.orange.fr
Message-ID: <482F5113.5090703@cosmosbay.com>
Date: Sat, 17 May 2008 23:41:39 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: James Cammarata <jimi@sngx.net>
Cc: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH updated] net: add ability to clear per-interface network
 statistics via procfs
References: <482DA5B6.1020606@sngx.net> <482DB46A.8020103@cosmosbay.com> <482EF192.4070707@sngx.net>
In-Reply-To: <482EF192.4070707@sngx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Cammarata a écrit :
>> 1) Every call to get_proc_net() should be paired with a call to 
>> put_net(), or else you  leak  struct net.
>
> My mistake, I will add this and resubmit.
>
This version has a bug, please check again.
>> 2) I am not sure this is the right way to do this... Did you consider 
>> to extend ethtool instead ?
>
> Yes, I did consider that.  My reasoning for adding it to procfs is 
> that each
> driver defines their own ethtool interface, so it was much simpler to 
> add it here, with a lot less code changes and broader support.
>
Maybe much simpler but looks like a hack...
>
> ---
>
> --- linux-2.6.25.4/net/core/dev.c       2008-05-15 10:00:12.000000000 
> -0500
> +++ linux-2.6.25.4-jcammara/net/core/dev.c      2008-05-17 
> 09:50:22.000000000 -0500
> @@ -2455,2 +2455,80 @@
>
> +/**
> + * proc_net_dev_write - handle writes to /proc/net/dev
> + * @file: not used
> + * @buf: buffer to write
> + * @length: length of buf, at most PAGE_SIZE
> + * @ppos: not used
> + *
> + * Description: this provides a mechanism to clear statistics on a
> + * per-interface basis
> + * "echo 'net clear-stats ifdev' >/proc/net/dev"
> + * with  "ifdev" replaced by the device name you wish to clear.
> + *
> + */
> +static ssize_t proc_net_dev_write(struct file *file, const char 
> __user *buf,
> +                                  size_t length, loff_t *ppos)
> +{
> +        char *buffer, *p;
> +        char devname[IFNAMSIZ];
> +        struct net *net;
> +        struct net_device *dev;
> +        int err;
> +
> +        if (!buf || length > PAGE_SIZE)
> +                return -EINVAL;
> +
> +        buffer = (char *)__get_free_page(GFP_KERNEL);
> +        if (!buffer)
> +                return -ENOMEM;
> +
> +        err = -EFAULT;
> +        if (copy_from_user(buffer, buf, length))
net is not initialized so you will call put_net(garbage) and crash

My suggestion was better, since you dont have to test if (net) ,
just call put_net(net) at the right place (before out: label)
> +                goto out;
> +
> +        err = -EINVAL;
> +        if (length < PAGE_SIZE)
> +                buffer[length] = '\0';
> +        else if (buffer[PAGE_SIZE-1])
> +                goto out;
> +
> +        err = -ENXIO;
> +        net = get_proc_net(file->f_dentry->d_inode);
> +        if (!net)
> +                goto out;
> +
> +        /*
> +         * Usage: echo "net clear-stats ifdev" >/proc/net/dev
> +         * with  "ifdev" replaced by the device name you wish to clear.
> +         */
> +        if (!strncmp("net clear-stats",buffer,15)) {
> +                p = buffer + 16;
> +                if(sscanf(p,"%16s",devname)>0) {
> +                        dev = dev_get_by_name(net,devname);
> +                        if (dev) {
> +                                if (dev->get_stats) {
> +                                        struct net_device_stats *stats =
> +                                               dev->get_stats(dev);
> +                                        memset(stats,0,
> +                                               sizeof(struct 
> net_device_stats));
> +                                }
> +                                dev_put(dev);
> +                        }
> +                }
> +        }
> +
> +        /*
> +         * convert success returns so that we return the
> +         * number of bytes consumed.
> +         */
> +        if (!err)
> +                err = length;
> +
> + out:
> +        if(net)
> +                put_net(net);
> +        free_page((unsigned long)buffer);
> +        return err;
> +}
> +
> static void *softnet_seq_start(struct seq_file *seq, loff_t *pos)
> @@ -2498,2 +2576,3 @@
>        .read    = seq_read,
> +        .write   = proc_net_dev_write,
>        .llseek  = seq_lseek,
>
>




