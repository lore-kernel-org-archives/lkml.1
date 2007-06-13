Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbXFMPuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbXFMPuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 11:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758268AbXFMPuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 11:50:00 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:14600 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263AbXFMPt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 11:49:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p9g86NGlrb2cAM/sacNLEvSxEZqwSJz7mvmRdaiuZm9FfPnGwwabKBc+rSo3sdFx1CqnRrAXJKM11RMwM059aFA+DcSxnVQtyi98eiRutno5HFDs/R43+fAo40Bcy5E9fDVOXDvpwhUkvc9hU8ByU+6DXcCeYV0xcOExBawg2fg=
Message-ID: <a781481a0706130849u2373983eyeab365a8bc90a4dd@mail.gmail.com>
Date: Wed, 13 Jun 2007 21:19:58 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Keiichi KII" <k-keiichi@bx.jp.nec.com>
Subject: Re: [RFC][PATCH -mm take5 3/7] add interface for netconsole using sysfs
Cc: "Matt Mackall" <mpm@selenic.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <466FC6BB.4040105@bx.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466FC455.5060001@bx.jp.nec.com> <466FC6BB.4040105@bx.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 6/13/07, Keiichi KII <k-keiichi@bx.jp.nec.com> wrote:
> From: Keiichi KII <k-keiichi@bx.jp.nec.com>
>
> This patch contains the following changes.
>
> create a sysfs entry for netconsole in /sys/class/misc.
> This entry has elements related to netconsole as follows.
> You can change configuration of netconsole(writable attributes such as IP
> address, port number and so on) and check current configuration of netconsole.
>
> -+- /sys/class/misc/
>  |-+- netconsole/
>    |-+- port1/
>    | |--- id          [r--r--r--]  unique port id
>    | |--- local_ip    [rw-r--r--]  source IP to use, writable
>    | |--- local_mac   [r--r--r--]  source MAC address
>    | |--- local_port  [rw-r--r--]  source port number for UDP packets, writable
>    | |--- remote_ip   [rw-r--r--]  port number for logging agent, writable
>    | |--- remote_mac  [rw-r--r--]  MAC address for logging agent, writable
>    | ---- remote_port [rw-r--r--]  IP address for logging agent, writable
>    |--- port2/
>    |--- port3/

[...]
> +static int miscdev_configured;

Is this really required? We just return with error if misc_register()
fails during module init time itself, so it's not really useful ever, is it?

> +static ssize_t show_target_attr(struct kobject *kobj,
[...]
> +       if (na->show)
> +               return na->show(nt, buffer);
> +       else
> +               return -EIO;

and

> +static ssize_t store_target_attr(struct kobject *kobj,
[...]
> +       if (na->store)
> +               return na->store(nt, buffer, count);
> +       else
> +               return -EIO;

EIO isn't quite appropriate for the above two cases. EPERM?

> +static int setup_target_sysfs(struct netconsole_target *nt)
> +{
> +       kobject_set_name(&nt->obj, "port%d", nt->id);

Ah, I see, so this is where we use the ->id member.

> @@ -192,7 +386,9 @@ static void cleanup_netconsole(void)
>
>         unregister_console(&netconsole);
>         list_for_each_entry_safe(nt, tmp, &target_list, list)
> -               remove_target(nt);
> +               kobject_unregister(&nt->obj);
> +       if (miscdev_configured)
> +               misc_deregister(&netconsole_miscdev);

Yeah, I suspect we can do away with miscdev_configured here.
We reach this code only if it is known to be true.

> +       if (misc_register(&netconsole_miscdev)) {
> +               printk(KERN_ERR
> +                      "netconsole: failed to register misc device for "
> +                      "name = %s, id = %d\n",
> +                      netconsole_miscdev.name, netconsole_miscdev.minor);
> +               return -EIO;
> +       } else
> +               miscdev_configured = 1;
> +

Please prefer:

err = misc_register(...);
if (err)
        ...
        return err;

That way we avoid the weird EIO and maintain the error code
returned by misc_register().

Satyam
