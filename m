Return-Path: <linux-kernel-owner+w=401wt.eu-S1752656AbYAOIjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbYAOIjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 03:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbYAOIjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 03:39:32 -0500
Received: from hs-out-0708.google.com ([64.233.178.251]:54409 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750801AbYAOIjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 03:39:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wNkdEjqS28cmr680dfOU5GApW4Zw8HuyQlgOGAD5VZh06uAFPHz1bQMCBXRyjyjjUgNCepVBEsdxejVDU+DPvTbwYNCqCR1UtBZEQScL87BFQ833q8aLbmQtur5PYeADkSxodkUDoAbrrGIEiNdb8xv6hONIiT4FNC61HmfH8U0=
Message-ID: <a8e1da0801150038p242c8717k9db373b1beb2404d@mail.gmail.com>
Date: Tue, 15 Jan 2008 16:38:48 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: stefanr@s5r6.in-berlin.de
Subject: Re: [PATCH 2/7] ieee1394 : use class iteration api
Cc: gregkh@suse.de, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080112095008.GB2893@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080112095008.GB2893@darkstar.te-china.tietoenator.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it right for me to put_device after class_find_device at following point?

On Jan 12, 2008 5:50 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> Convert to use the class iteration api.
>
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>
> ---
>  drivers/ieee1394/nodemgr.c |  319 +++++++++++++++++++++++++--------------------
>  1 file changed, 178 insertions(+), 141 deletions(-)
>
> diff -upr linux/drivers/ieee1394/nodemgr.c linux.new/drivers/ieee1394/nodemgr.c
> --- linux/drivers/ieee1394/nodemgr.c    2008-01-12 15:20:27.000000000 +0800
> +++ linux.new/drivers/ieee1394/nodemgr.c        2008-01-12 15:20:27.000000000 +0800
> @@ -727,36 +727,35 @@ static int nodemgr_bus_match(struct devi
>
>  static DEFINE_MUTEX(nodemgr_serialize_remove_uds);
>
> +static int __match_ne(struct device *dev, void *data)
> +{
> +       struct unit_directory *ud;
> +       struct node_entry *ne = (struct node_entry *)data;
> +
> +       ud = container_of(dev, struct unit_directory, unit_dev);
> +       if (ud->ne == ne)
> +               return 1;
> +       return 0;
> +}
> +
>  static void nodemgr_remove_uds(struct node_entry *ne)
>  {
>         struct device *dev;
> -       struct unit_directory *tmp, *ud;
> +       struct unit_directory *ud;
>
> -       /* Iteration over nodemgr_ud_class.devices has to be protected by
> -        * nodemgr_ud_class.sem, but device_unregister() will eventually
> -        * take nodemgr_ud_class.sem too. Therefore pick out one ud at a time,
> -        * release the semaphore, and then unregister the ud. Since this code
> -        * may be called from other contexts besides the knodemgrds, protect the
> -        * gap after release of the semaphore by nodemgr_serialize_remove_uds.
> +       /* Use class_find device to iterate the devices. Since this code
> +        * may be called from other contexts besides the knodemgrds,
> +        * protect it by nodemgr_serialize_remove_uds.
>          */
>         mutex_lock(&nodemgr_serialize_remove_uds);
> -       for (;;) {
> -               ud = NULL;
> -               down(&nodemgr_ud_class.sem);
> -               list_for_each_entry(dev, &nodemgr_ud_class.devices, node) {
> -                       tmp = container_of(dev, struct unit_directory,
> -                                          unit_dev);
> -                       if (tmp->ne == ne) {
> -                               ud = tmp;
> -                               break;
> -                       }
> -               }
> -               up(&nodemgr_ud_class.sem);
> -               if (ud == NULL)
> -                       break;
> -               device_unregister(&ud->unit_dev);
> -               device_unregister(&ud->device);
> +       dev = class_find_device(&nodemgr_ud_class, ne, __match_ne);
> +       if (!dev) {
> +               mutex_unlock(&nodemgr_serialize_remove_uds);
> +               return;
>         }
> +       ud = container_of(dev, struct unit_directory, unit_dev);

============
Here.
============

> +       device_unregister(&ud->unit_dev);
> +       device_unregister(&ud->device);
>         mutex_unlock(&nodemgr_serialize_remove_uds);
>  }
>
> @@ -882,45 +881,64 @@ fail_alloc:
>         return NULL;
>  }
>
> +static int __match_ne_guid(struct device *dev, void *data)
> +{
> +       struct node_entry *ne;
> +       u64 *guid = (u64 *)data;
> +
> +       ne = container_of(dev, struct node_entry, node_dev);
> +       if (ne->guid == *guid)
> +               return 1;
> +       return 0;
> +}
>
>  static struct node_entry *find_entry_by_guid(u64 guid)
>  {
>         struct device *dev;
> -       struct node_entry *ne, *ret_ne = NULL;
> -
> -       down(&nodemgr_ne_class.sem);
> -       list_for_each_entry(dev, &nodemgr_ne_class.devices, node) {
> -               ne = container_of(dev, struct node_entry, node_dev);
> +       struct node_entry *ne;
>
> -               if (ne->guid == guid) {
> -                       ret_ne = ne;
> -                       break;
> -               }
> -       }
> -       up(&nodemgr_ne_class.sem);
> +       dev = class_find_device(&nodemgr_ne_class, &guid, __match_ne_guid);
> +       if (!dev)
> +               return NULL;
> +       ne = container_of(dev, struct node_entry, node_dev);

============
And here
============

>
> -       return ret_ne;
> +       return ne;
>  }
>
> +struct match_nodeid_param {
> +       struct hpsb_host *host;
> +       nodeid_t nodeid;
> +};
> +
> +static int __match_ne_nodeid(struct device *dev, void *data)
> +{
> +       struct node_entry *ne;
> +       struct match_nodeid_param *param = (struct match_nodeid_param *)data;
> +
> +       if (!dev)
> +               return 0;
> +       ne = container_of(dev, struct node_entry, node_dev);
> +       if (ne->host == param->host && ne->nodeid == param->nodeid)
> +               return 1;
> +       return 0;
> +}
>
>  static struct node_entry *find_entry_by_nodeid(struct hpsb_host *host,
>                                                nodeid_t nodeid)
>  {
>         struct device *dev;
> -       struct node_entry *ne, *ret_ne = NULL;
> +       struct node_entry *ne;
> +       struct match_nodeid_param param;
>
> -       down(&nodemgr_ne_class.sem);
> -       list_for_each_entry(dev, &nodemgr_ne_class.devices, node) {
> -               ne = container_of(dev, struct node_entry, node_dev);
> +       param.host = host;
> +       param.nodeid = nodeid;
>
> -               if (ne->host == host && ne->nodeid == nodeid) {
> -                       ret_ne = ne;
> -                       break;
> -               }
> -       }
> -       up(&nodemgr_ne_class.sem);
> +       dev = class_find_device(&nodemgr_ne_class, &param, __match_ne_nodeid);
> +       if (!dev)
> +               return NULL;
> +       ne = container_of(dev, struct node_entry, node_dev);

============
And here
============

>
> -       return ret_ne;
> +       return ne;
>  }
>
>
> @@ -1370,107 +1388,109 @@ static void nodemgr_node_scan(struct hos
>         }
>  }
>
> -
> -static void nodemgr_suspend_ne(struct node_entry *ne)
> +static int __nodemgr_driver_suspend(struct device *dev, void *data)
>  {
> -       struct device *dev;
>         struct unit_directory *ud;
>         struct device_driver *drv;
> +       struct node_entry *ne = (struct node_entry *)data;
>         int error;
>
> -       HPSB_DEBUG("Node suspended: ID:BUS[" NODE_BUS_FMT "]  GUID[%016Lx]",
> -                  NODE_BUS_ARGS(ne->host, ne->nodeid), (unsigned long long)ne->guid);
> +       ud = container_of(dev, struct unit_directory, unit_dev);
> +       if (ud->ne == ne) {
> +               drv = get_driver(ud->device.driver);
> +               if (drv) {
> +                       error = 1; /* release if suspend is not implemented */
> +                       if (drv->suspend) {
> +                               down(&ud->device.sem);
> +                               error = drv->suspend(&ud->device, PMSG_SUSPEND);
> +                               up(&ud->device.sem);
> +                       }
> +                       if (error)
> +                               device_release_driver(&ud->device);
> +                       put_driver(drv);
> +               }
> +       }
>
> -       ne->in_limbo = 1;
> -       WARN_ON(device_create_file(&ne->device, &dev_attr_ne_in_limbo));
> +       return 0;
> +}
>
> -       down(&nodemgr_ud_class.sem);
> -       list_for_each_entry(dev, &nodemgr_ud_class.devices, node) {
> -               ud = container_of(dev, struct unit_directory, unit_dev);
> -               if (ud->ne != ne)
> -                       continue;
> +static int __nodemgr_driver_resume(struct device *dev, void *data)
> +{
> +       struct unit_directory *ud;
> +       struct device_driver *drv;
> +       struct node_entry *ne = (struct node_entry *)data;
>
> +       ud = container_of(dev, struct unit_directory, unit_dev);
> +       if (ud->ne == ne) {
>                 drv = get_driver(ud->device.driver);
> -               if (!drv)
> -                       continue;
> -
> -               error = 1; /* release if suspend is not implemented */
> -               if (drv->suspend) {
> -                       down(&ud->device.sem);
> -                       error = drv->suspend(&ud->device, PMSG_SUSPEND);
> -                       up(&ud->device.sem);
> +               if (drv) {
> +                       if (drv->resume) {
> +                               down(&ud->device.sem);
> +                               drv->resume(&ud->device);
> +                               up(&ud->device.sem);
> +                       }
> +                       put_driver(drv);
>                 }
> -               if (error)
> -                       device_release_driver(&ud->device);
> -               put_driver(drv);
>         }
> -       up(&nodemgr_ud_class.sem);
> -}
>
> +       return 0;
> +}
>
> -static void nodemgr_resume_ne(struct node_entry *ne)
> +static void nodemgr_suspend_ne(struct node_entry *ne)
>  {
> -       struct device *dev;
> -       struct unit_directory *ud;
> -       struct device_driver *drv;
> +       HPSB_DEBUG("Node suspended: ID:BUS[" NODE_BUS_FMT "]  GUID[%016Lx]",
> +                  NODE_BUS_ARGS(ne->host, ne->nodeid),
> +                  (unsigned long long)ne->guid);
>
> -       ne->in_limbo = 0;
> -       device_remove_file(&ne->device, &dev_attr_ne_in_limbo);
> +       ne->in_limbo = 1;
> +       WARN_ON(device_create_file(&ne->device, &dev_attr_ne_in_limbo));
>
> -       down(&nodemgr_ud_class.sem);
> -       list_for_each_entry(dev, &nodemgr_ud_class.devices, node) {
> -               ud = container_of(dev, struct unit_directory, unit_dev);
> -               if (ud->ne != ne)
> -                       continue;
> +       class_for_each_device(&nodemgr_ud_class, ne, __nodemgr_driver_suspend);
> +}
>
> -               drv = get_driver(ud->device.driver);
> -               if (!drv)
> -                       continue;
>
> -               if (drv->resume) {
> -                       down(&ud->device.sem);
> -                       drv->resume(&ud->device);
> -                       up(&ud->device.sem);
> -               }
> -               put_driver(drv);
> -       }
> -       up(&nodemgr_ud_class.sem);
> +static void nodemgr_resume_ne(struct node_entry *ne)
> +{
> +       ne->in_limbo = 0;
> +       device_remove_file(&ne->device, &dev_attr_ne_in_limbo);
>
> +       class_for_each_device(&nodemgr_ud_class, ne, __nodemgr_driver_resume);
>         HPSB_DEBUG("Node resumed: ID:BUS[" NODE_BUS_FMT "]  GUID[%016Lx]",
>                    NODE_BUS_ARGS(ne->host, ne->nodeid), (unsigned long long)ne->guid);
>  }
>
> -
> -static void nodemgr_update_pdrv(struct node_entry *ne)
> +static int __nodemgr_update_pdrv(struct device *dev, void *data)
>  {
> -       struct device *dev;
>         struct unit_directory *ud;
>         struct device_driver *drv;
>         struct hpsb_protocol_driver *pdrv;
> +       struct node_entry *ne = (struct node_entry *)data;
>         int error;
>
> -       down(&nodemgr_ud_class.sem);
> -       list_for_each_entry(dev, &nodemgr_ud_class.devices, node) {
> -               ud = container_of(dev, struct unit_directory, unit_dev);
> -               if (ud->ne != ne)
> -                       continue;
> -
> +       ud = container_of(dev, struct unit_directory, unit_dev);
> +       if (ud->ne == ne) {
>                 drv = get_driver(ud->device.driver);
> -               if (!drv)
> -                       continue;
> -
> -               error = 0;
> -               pdrv = container_of(drv, struct hpsb_protocol_driver, driver);
> -               if (pdrv->update) {
> -                       down(&ud->device.sem);
> -                       error = pdrv->update(ud);
> -                       up(&ud->device.sem);
> +               if (drv) {
> +                       error = 0;
> +                       pdrv = container_of(drv, struct hpsb_protocol_driver,
> +                                           driver);
> +                       if (pdrv->update) {
> +                               down(&ud->device.sem);
> +                               error = pdrv->update(ud);
> +                               up(&ud->device.sem);
> +                       }
> +                       if (error)
> +                               device_release_driver(&ud->device);
> +                       put_driver(drv);
>                 }
> -               if (error)
> -                       device_release_driver(&ud->device);
> -               put_driver(drv);
>         }
> -       up(&nodemgr_ud_class.sem);
> +
> +       return 0;
> +}
> +
> +static void nodemgr_update_pdrv(struct node_entry *ne)
> +{
> +       class_for_each_device(&nodemgr_ud_class, ne, __nodemgr_update_pdrv);
>  }
>
>
> @@ -1529,13 +1549,31 @@ static void nodemgr_probe_ne(struct host
>         put_device(dev);
>  }
>
> +struct probe_param {
> +       struct host_info *hi;
> +       int generation;
> +};
> +
> +static int __nodemgr_node_probe(struct device *dev, void *data)
> +{
> +       struct probe_param *param = (struct probe_param *)data;
> +       struct node_entry *ne;
> +
> +       ne = container_of(dev, struct node_entry, node_dev);
> +       if (!ne->needs_probe)
> +               nodemgr_probe_ne(param->hi, ne, param->generation);
> +       if (ne->needs_probe)
> +               nodemgr_probe_ne(param->hi, ne, param->generation);
> +       return 0;
> +}
>
>  static void nodemgr_node_probe(struct host_info *hi, int generation)
>  {
>         struct hpsb_host *host = hi->host;
> -       struct device *dev;
> -       struct node_entry *ne;
> +       struct probe_param param;
>
> +       param.hi = hi;
> +       param.generation = generation;
>         /* Do some processing of the nodes we've probed. This pulls them
>          * into the sysfs layer if needed, and can result in processing of
>          * unit-directories, or just updating the node and it's
> @@ -1545,19 +1583,7 @@ static void nodemgr_node_probe(struct ho
>          * while probes are time-consuming. (Well, those probes need some
>          * improvement...) */
>
> -       down(&nodemgr_ne_class.sem);
> -       list_for_each_entry(dev, &nodemgr_ne_class.devices, node) {
> -               ne = container_of(dev, struct node_entry, node_dev);
> -               if (!ne->needs_probe)
> -                       nodemgr_probe_ne(hi, ne, generation);
> -       }
> -       list_for_each_entry(dev, &nodemgr_ne_class.devices, node) {
> -               ne = container_of(dev, struct node_entry, node_dev);
> -               if (ne->needs_probe)
> -                       nodemgr_probe_ne(hi, ne, generation);
> -       }
> -       up(&nodemgr_ne_class.sem);
> -
> +       class_for_each_device(&nodemgr_ne_class, &param, __nodemgr_node_probe);
>
>         /* If we had a bus reset while we were scanning the bus, it is
>          * possible that we did not probe all nodes.  In that case, we
> @@ -1757,6 +1783,22 @@ exit:
>         return 0;
>  }
>
> +struct host_iter_param {
> +       void *data;
> +       int (*cb)(struct hpsb_host *, void *);
> +};
> +
> +static int __nodemgr_for_each_host(struct device *dev, void *data)
> +{
> +       struct hpsb_host *host;
> +       struct host_iter_param *hip = (struct host_iter_param *)data;
> +       int error = 0;
> +
> +       host = container_of(dev, struct hpsb_host, host_dev);
> +       error = hip->cb(host, hip->data);
> +
> +       return error;
> +}
>  /**
>   * nodemgr_for_each_host - call a function for each IEEE 1394 host
>   * @data: an address to supply to the callback
> @@ -1771,18 +1813,13 @@ exit:
>   */
>  int nodemgr_for_each_host(void *data, int (*cb)(struct hpsb_host *, void *))
>  {
> -       struct device *dev;
> -       struct hpsb_host *host;
> -       int error = 0;
> -
> -       down(&hpsb_host_class.sem);
> -       list_for_each_entry(dev, &hpsb_host_class.devices, node) {
> -               host = container_of(dev, struct hpsb_host, host_dev);
> +       struct host_iter_param hip;
> +       int error;
>
> -               if ((error = cb(host, data)))
> -                       break;
> -       }
> -       up(&hpsb_host_class.sem);
> +       hip.cb = cb;
> +       hip.data = data;
> +       error = class_for_each_device(&hpsb_host_class, &hip,
> +                                     __nodemgr_for_each_host);
>
>         return error;
>  }
>
