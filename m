Return-Path: <linux-kernel-owner+w=401wt.eu-S932699AbXCTMuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699AbXCTMuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 08:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933312AbXCTMuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 08:50:11 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:8732 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933177AbXCTMuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 08:50:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WIxi4O7ES0OqdvgDaNN2tvOpamu2dpHYQwdgAk+NV2BKGX2hvqJx7skgh5sj2lLAt4cHtk/0OBsHQglX/6G3BebaccAxCBKh7v0Bwj7iOz2zD49lPOg6ie49sX1XQLFuQS5fGR+/lsLXnE4so2cL7msERaaRkomzn8KLjKtGl4A=
Message-ID: <b6fcc0a0703200550p441bb01fkfebb4102ef8e57d@mail.gmail.com>
Date: Tue, 20 Mar 2007 14:50:07 +0200
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Keiichi KII" <k-keiichi@bx.jp.nec.com>
Subject: Re: [RFC][PATCH -mm take3 6/6][resend] add ioctls for adding/removing target
Cc: mpm@selenic.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <45FFD4C1.7000103@bx.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45FFCF31.3040000@bx.jp.nec.com> <45FFD4C1.7000103@bx.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/20/07, Keiichi KII <k-keiichi@bx.jp.nec.com> wrote:
> We add ioctls for adding/removing target.
> If we use NETCONSOLE_ADD_TARGET ioctl,
> we can dynamically add netconsole target.
> If we use NETCONSOLE_REMOVE_TARGET ioctl,
> we can dynamically remoe netconsole target.
>
> We attach a sample program for ioctl.

> +static int netconsole_ioctl(struct inode *inode, struct file *file,
> +			    unsigned int cmd, unsigned long arg)
> +{
> +	int id, count;
> +	char config[256];
> +	char *cur;
> +	struct netconsole_request req;
> +	struct netconsole_target *nt, *tmp;
> +	void __user *argp = (void __user *)arg;
> +
> +	switch (cmd) {
> +	case NETCON_ADD_TARGET:
> +		printk(KERN_INFO "netconsole: cmd=NETCON_ADD_TARGET\n");
> +		if (copy_from_user(&req, argp, sizeof(req)))
> +			return -EFAULT;
> +		cur = config;
> +		count = sprintf(cur, "%d@", req.local_port);
> +		cur += count;
> +		if (req.local_ip)
> +			count = sprintf(cur, "%d.%d.%d.%d/",
> +					NIPQUAD(req.local_ip));
> +		else
> +			count = sprintf(cur, "/");
> +		cur += count;
> +		count = sprintf(cur, "%s,", req.netdev_name);
> +		cur += count;
> +		count = sprintf(cur, "%d@", req.remote_port);
> +		cur += count;
> +		count = sprintf(cur, "%d.%d.%d.%d/",
> +				NIPQUAD(req.remote_ip));
> +		cur += count;
> +		count = sprintf(cur, "%02x:%02x:%02x:%02x:%02x:%02x",
> +				req.remote_mac[0], req.remote_mac[1],
> +				req.remote_mac[2], req.remote_mac[3],
> +				req.remote_mac[4], req.remote_mac[5]);
> +		printk(KERN_INFO "count = %d config=[%s]\n", count, config);
> +		if (add_target(config))
> +			return -EINVAL;
> +		break;
> +	case NETCON_REMOVE_TARGET:
> +		printk(KERN_INFO "netconsole: cmd=NETCON_REMOVE_TARGET\n");
> +		if (copy_from_user(&id, argp, sizeof(int)))
> +			return -EFAULT;
> +		printk(KERN_INFO "netconsole: id=%d\n", id);
> +		list_for_each_entry_safe(nt, tmp, &target_list, list) {
> +			if (nt->id == id) {
> +				kobject_unregister(&nt->obj);
> +				break;
> +			}
> +		}
> +		break;
> +	default:
> +		return -ENOTTY;
> +	}
> +
> +	return 0;
> +}

If you go with misc device, then implement ->write method so you, say,
do

     echo "add [same format as with module parameter]" >/dev/netconsole

and avoid all that additional programs and ioctls.
