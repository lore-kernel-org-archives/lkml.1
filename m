Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbYFLC0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbYFLC0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 22:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbYFLCZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 22:25:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:28933 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbYFLCZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 22:25:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,627,1204531200"; 
   d="scan'208";a="575609660"
Subject: Re: [RFC] Implement thermal limiting in generic thermal class
From: Zhang Rui <rui.zhang@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080611165804.GB27437@srcf.ucam.org>
References: <20080611100647.GA20013@srcf.ucam.org>
	 <20080611164226.GA27437@srcf.ucam.org>
	 <20080611165804.GB27437@srcf.ucam.org>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 10:25:34 +0800
Message-Id: <1213237534.4867.32.camel@rzhang-dt.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-12 at 00:58 +0800, Matthew Garrett wrote:
> In the absence of an explicitly defined passive cooling zone any
> machine unable to manage its thermal profile through active cooling
> will
> reach its critical shutdown temperature and power off, resulting in
> potential data loss. Add support to the generic thermal class for
> initiating passive cooling at a temperature defaulting to just below
> the
> critical temperature, with this value being overridable by the admin
> via
> sysfs.

this patch introduce two things that are obsolete in ACPI thermal
driver, polling and trip point overriding.
I'm under the impression that they are known to break some laptops for
some reason. Len may have comments on this? :p

I'd say I like the idea which make Linux more robust when overheating IF
and ONLY IF it's okay to use polling.

> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> ---
> 
> I've got bug reports from multiple users with a wide range of hardware
> that can't keep itself sufficiently cool under Linux. Whether this is
> bad hardware design, machines being used outside recommended thermal
> conditions or whatever, failing to do anything about this is resulting
> in data loss (one user is unable to even get through a Fedora install
> without his machine shutting down). There's no evidence that the low
> level of polling used by this patch (one temperature read per zone per
> 10 seconds while the temperature is below the limit point) will
> interfere with any hardware. For all we know, this is how Windows
> implements it...
> 
> This sits on top of the previous two patches that clean up the
> internal
> thermal API.

> +static void thermal_update(struct work_struct *work)
> +{
> +       struct thermal_zone_device *tz;
> +       struct thermal_cooling_device *cdev;
> +       unsigned long temp;
> +       int sleep_time = 10, max_state, state, cpus_throttled = 0;
> +
> +       if (list_empty(&thermal_cdev_list))
> +               goto out;
> +
> +       list_for_each_entry(cdev, &thermal_cdev_list, node)
> +               cdev->throttle = 0;
> +
> +       if (list_empty(&thermal_tz_list))
> +               goto out;
> +
> +       list_for_each_entry(tz, &thermal_tz_list, node) {
> +               if (!tz->force_passive)
> +                       continue;
> +
> +               tz->ops->get_temp(tz, &temp);
> +
> +               /* If the temperature trend is downwards, reduce
> throttling
> +                  in an attempt to end up at a steady state */
> +               if (temp > tz->force_passive_temp) {
> +                       if (((temp - tz->prev_temp) +
> +                            (temp - tz->force_passive_temp)) > 0) {
> +                               if (list_empty(&tz->cooling_devices)
> &&
> +                                   !cpus_throttled) {
> +                                       thermal_throttle_cpus();
> +                                       cpus_throttled = 1;
> +                               } else
> +                                       list_for_each_entry(cdev,
> +
> &tz->cooling_devices,
> +                                                           node)
> +                                               cdev->throttle = 1;
> +                       }
> +               }
> +               tz->prev_temp = temp;
> +
> +               /* Increase polling interval near the cut-off
> temperature */
> +               if (temp > tz->force_passive_temp - 5000)
> +                       sleep_time = 1;
> +       }
> +
> +       list_for_each_entry(cdev, &thermal_cdev_list, node) {
> +               if (!strncmp(cdev->type, "Fan", 3))
> +                       continue;
> +               cdev->ops->get_cur_state(cdev, &state);
> +               if (cdev->throttle) {
> +                       cdev->ops->get_max_state(cdev, &max_state);
> +                       if (++state < max_state)
> +                               cdev->ops->set_cur_state(cdev, state);
> +               } else
> +                       if (state > 0) {
> +                               cdev->ops->set_cur_state(cdev,
> --state);
> +                               sleep_time = 1;
> +                       }
as cdev->throttle is cleared by default, this may affect the cooling
devices in the thermal zones that don't enable passive cooling.

> +       }
> +out:
> +       poll_timer.function = thermal_poll;
> +       poll_timer.expires = round_jiffies(jiffies + sleep_time*HZ);
> +       add_timer(&poll_timer);
> +}
> 
>  /**
>   * thermal_zone_bind_cooling_device - bind a cooling device to a
> thermal zone
> @@ -775,6 +888,7 @@ struct thermal_zone_device
> *thermal_zone_device_register(char *type,
>         struct thermal_cooling_device *pos;
>         int result;
>         int count;
> +       char trip_type[THERMAL_NAME_LENGTH];
> 
>         if (strlen(type) >= THERMAL_NAME_LENGTH)
>                 return ERR_PTR(-EINVAL);
> @@ -803,6 +917,7 @@ struct thermal_zone_device
> *thermal_zone_device_register(char *type,
>         tz->device.class = &thermal_class;
>         tz->devdata = devdata;
>         tz->trips = trips;
> +       tz->force_passive = 1;
>         sprintf(tz->device.bus_id, "thermal_zone%d", tz->id);
>         result = device_register(&tz->device);
>         if (result) {
> @@ -811,6 +926,12 @@ struct thermal_zone_device
> *thermal_zone_device_register(char *type,
>                 return ERR_PTR(result);
>         }
> 
> +       for (count = 0; count < trips; count++) {
> +               tz->ops->get_trip_type(tz, count, trip_type);
> +               if (!strcmp(trip_type, "passive"))
> +                       tz->force_passive = 0;
> +       }
> +
Hmm, I don't think we should enable the force_passive by default.
IMO, we should just create "passive" attribute for thermal zones without
a passive trip point, and enable it until user set a valid value.

thanks,
rui



