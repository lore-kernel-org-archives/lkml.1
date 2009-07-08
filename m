Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbZGHASf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbZGHASf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 20:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758000AbZGHAS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 20:18:27 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:63857 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962AbZGHAS0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 20:18:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RHq6H89rLSqKSsTU9lOZW0uNRlBDk6KhycQqcOkt19CSKA/Tbq5KlcvKMa1HJrJ40g
         KnRgS7D3+IyOSR+CJX+csz+95TjQc875huwmaUAP8OS9l7FDddySVRtRgXM0VOLJuIhr
         TupQ994owxZzDJuwtznVHbf+D9t0GIJaqYghA=
MIME-Version: 1.0
In-Reply-To: <1246979820.9451.71.camel@pc1117.cambridge.arm.com>
References: <1246979820.9451.71.camel@pc1117.cambridge.arm.com>
Date: Wed, 8 Jul 2009 08:18:25 +0800
Message-ID: <d82e647a0907071718l79e9eab8s67ae3a972003cf8d@mail.gmail.com>
Subject: Re: Possible memory leak in request_firmware()
From: Ming Lei <tom.leiming@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/7 Catalin Marinas <catalin.marinas@arm.com>:
> Hi,
>
> I get a couple kmemleak reports like below which I think happen on the
> failure path (-ENOENT) of a request_firmware() call:
>
> unreferenced object 0xc355fdb0 (size 256):
>  comm "NetworkManager", pid 2606, jiffies 4294902882
>  backtrace:
>    [<c01e0c3a>] create_object+0xfa/0x250
>    [<c01e1e7d>] kmemleak_alloc+0x5d/0x70
>    [<c01dac1b>] kmem_cache_alloc+0x14b/0x190
>    [<c03a0c4c>] _request_firmware+0x11c/0x530
>    [<c03a1102>] request_firmware+0x12/0x20
>    [<f95f6591>] iwl_mac_start+0xa1/0x850 [iwlagn]
>    [<f8fb08c1>] ieee80211_open+0x2e1/0x860 [mac80211]
>    [<c048459a>] dev_open+0xba/0x100
>    [<c0483ab9>] dev_change_flags+0x139/0x1d0
>    [<c048d392>] do_setlink+0x282/0x410
>    [<c048ea81>] rtnl_setlink+0xf1/0x130
>    [<c048e285>] rtnetlink_rcv_msg+0x165/0x200
>    [<c049fac6>] netlink_rcv_skb+0x76/0xa0
>    [<c048e10e>] rtnetlink_rcv+0x1e/0x30
>    [<c049f7fb>] netlink_unicast+0x23b/0x250
>    [<c04a02db>] netlink_sendmsg+0x1db/0x2d0
>
> The f_dev in _request_firmware() is allocated via the fw_setup_device()
> and fw_register_device() calls and its class set to firmware_class (the
> class release function is fw_dev_release).
>
> Commit 6acf70f078ca replaced the kfree(dev) in fw_dev_release() with a
> put_device() call but my understanding is that the release function is
> called via put_device -> kobject_put -> kref_put -> koject_release etc.
> and it should call kfree since it's the last to see this device
> structure alive.
>
> Because of that, the _request_firmware() function on its -ENOENT error
> path only calls device_unregister(f_dev) which would eventually call
> fw_dev_release() but there is no kfree (the subsequent put_device call
> would just make the kref negative).
>
> The patch below may fix the problem but it's only later tonight that I
> can test it and confirm:
>
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index ddeb819..12e6e64 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -357,7 +357,7 @@ static void fw_dev_release(struct device *dev)
>        kfree(fw_priv->pages);
>        kfree(fw_priv->fw_id);
>        kfree(fw_priv);
> -       put_device(dev);
> +       kfree(dev);

Ackd-by: Ming Lei <tom.leiming@gmail.com>

Thanks.

>
>        module_put(THIS_MODULE);
>  }
> @@ -407,14 +407,13 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
>        retval = device_register(f_dev);
>        if (retval) {
>                dev_err(device, "%s: device_register failed\n", __func__);
> +               kfree(fw_priv->fw_id);
>                put_device(f_dev);
> -               goto error_kfree_fw_id;
> +               return retval;
>        }
>        *dev_p = f_dev;
>        return 0;
>
> -error_kfree_fw_id:
> -       kfree(fw_priv->fw_id);
>  error_kfree:
>        kfree(f_dev);
>        kfree(fw_priv);
>
>
> --
> Catalin
>
>



-- 
Lei Ming
