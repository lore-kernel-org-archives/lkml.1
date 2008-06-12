Return-Path: <linux-kernel-owner+w=401wt.eu-S1759814AbYFLBa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814AbYFLBa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 21:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757954AbYFLBaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 21:30:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:65385 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791AbYFLBaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 21:30:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,627,1204531200"; 
   d="scan'208";a="575594437"
Subject: Re: [PATCH] More cleanup of the thermal API
From: Zhang Rui <rui.zhang@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080611164226.GA27437@srcf.ucam.org>
References: <20080611100647.GA20013@srcf.ucam.org>
	 <20080611164226.GA27437@srcf.ucam.org>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 09:29:48 +0800
Message-Id: <1213234188.4867.5.camel@rzhang-dt.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-12 at 00:42 +0800, Matthew Garrett wrote:
> The state management functions in the thermal API also pass strings
> around. Change them to ints and do the conversion at the sysfs point.
just some codingstyle problems. :)

thanks,
rui

> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> ---
> 
> diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
> index 6cf10cb..f3db49e 100644
> --- a/drivers/acpi/fan.c
> +++ b/drivers/acpi/fan.c
> @@ -69,27 +69,30 @@ static struct acpi_driver acpi_fan_driver = {
>  };
> 
>  /* thermal cooling device callbacks */
> -static int fan_get_max_state(struct thermal_cooling_device *cdev,
> char *buf)
> +static int fan_get_max_state(struct thermal_cooling_device *cdev,
> unsigned int
> +                            *state)
>  {
>         /* ACPI fan device only support two states: ON/OFF */
> -       return sprintf(buf, "1\n");
> +       *state = 1;
> +       return 0;
>  }
> 
> -static int fan_get_cur_state(struct thermal_cooling_device *cdev,
> char *buf)
> +static int fan_get_cur_state(struct thermal_cooling_device *cdev,
> unsigned int
> +                            *state)
>  {
>         struct acpi_device *device = cdev->devdata;
> -       int state;
>         int result;
> 
>         if (!device)
>                 return -EINVAL;
> 
> -       result = acpi_bus_get_power(device->handle, &state);
> +       result = acpi_bus_get_power(device->handle, state);
>         if (result)
>                 return result;
> 
> -       return sprintf(buf, "%s\n", state == ACPI_STATE_D3 ? "0" :
> -                        (state == ACPI_STATE_D0 ? "1" : "unknown"));
> +       *state = (*state == ACPI_STATE_D3 ? 0 :
> +                (*state == ACPI_STATE_D0 ? 1 : -1));
> +       return 0;
>  }
> 
>  static int
> diff --git a/drivers/acpi/processor_thermal.c
> b/drivers/acpi/processor_thermal.c
> index ef34b18..2a3721d 100644
> --- a/drivers/acpi/processor_thermal.c
> +++ b/drivers/acpi/processor_thermal.c
> @@ -374,7 +374,8 @@ static int acpi_processor_max_state(struct
> acpi_processor *pr)
>         return max_state;
>  }
>  static int
> -processor_get_max_state(struct thermal_cooling_device *cdev, char
> *buf)
> +processor_get_max_state(struct thermal_cooling_device *cdev, unsigned
> int
> +                       *state)
>  {
>         struct acpi_device *device = cdev->devdata;
>         struct acpi_processor *pr = acpi_driver_data(device);
> @@ -382,24 +383,24 @@ processor_get_max_state(struct
> thermal_cooling_device *cdev, char *buf)
>         if (!device || !pr)
>                 return -EINVAL;
> 
> -       return sprintf(buf, "%d\n", acpi_processor_max_state(pr));
> +       *state = acpi_processor_max_state(pr);
> +       return 0;
>  }
> 
>  static int
> -processor_get_cur_state(struct thermal_cooling_device *cdev, char
> *buf)
> +processor_get_cur_state(struct thermal_cooling_device *cdev, unsigned
> int
> +                       *cur_state)
>  {
>         struct acpi_device *device = cdev->devdata;
>         struct acpi_processor *pr = acpi_driver_data(device);
> -       int cur_state;
> 
>         if (!device || !pr)
>                 return -EINVAL;
> 
> -       cur_state = cpufreq_get_cur_state(pr->id);
> +       *cur_state = cpufreq_get_cur_state(pr->id);
>         if (pr->flags.throttling)
> -               cur_state += pr->throttling.state;
> -
> -       return sprintf(buf, "%d\n", cur_state);
> +               *cur_state += pr->throttling.state;
> +       return 0;
>  }
> 
>  static int
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index 5e5dda3..d8d7596 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -358,26 +358,30 @@ static struct output_properties
> acpi_output_properties = {
> 
> 
>  /* thermal cooling device callbacks */
> -static int video_get_max_state(struct thermal_cooling_device *cdev,
> char *buf)
> +static int video_get_max_state(struct thermal_cooling_device *cdev,
> unsigned
> +                              int *state)
>  {
>         struct acpi_device *device = cdev->devdata;
>         struct acpi_video_device *video = acpi_driver_data(device);
> 
> -       return sprintf(buf, "%d\n", video->brightness->count - 3);
> +       *state = video->brightness->count - 3;
> +       return 0;
>  }
> 
> -static int video_get_cur_state(struct thermal_cooling_device *cdev,
> char *buf)
> +static int video_get_cur_state(struct thermal_cooling_device *cdev,
> unsigned
> +                              int *state)
>  {
>         struct acpi_device *device = cdev->devdata;
>         struct acpi_video_device *video = acpi_driver_data(device);
>         unsigned long level;
> -       int state;
> +       int offset;
> 
>         acpi_video_device_lcd_get_level_current(video, &level);
> -       for (state = 2; state < video->brightness->count; state++)
> -               if (level == video->brightness->levels[state])
> -                       return sprintf(buf, "%d\n",
> -                                      video->brightness->count -
> state - 1);
> +       for (offset = 2; offset < video->brightness->count; offset++)
> +               if (level == video->brightness->levels[offset]) {
> +                       *state = video->brightness->count - offset -
> 1;
> +                       return 0;
> +               }
> 
>         return -EINVAL;
>  }
> diff --git a/drivers/thermal/thermal_sys.c
> b/drivers/thermal/thermal_sys.c
> index c537a5b..02abaf0 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -249,8 +249,12 @@ thermal_cooling_device_max_state_show(struct
> device *dev,
>                                       struct device_attribute *attr,
> char *buf)
>  {
>         struct thermal_cooling_device *cdev = to_cooling_device(dev);
> +       int state, ret;
> 
> -       return cdev->ops->get_max_state(cdev, buf);
> +       ret = cdev->ops->get_max_state(cdev, &state);
> +       if (ret)
> +               return ret;
> +       return sprintf(buf, "%d\n", state);
>  }
> 
>  static ssize_t
> @@ -258,8 +262,12 @@ thermal_cooling_device_cur_state_show(struct
> device *dev,
>                                       struct device_attribute *attr,
> char *buf)
>  {
>         struct thermal_cooling_device *cdev = to_cooling_device(dev);
> +       int state, ret;
> 
> -       return cdev->ops->get_cur_state(cdev, buf);
> +       ret = cdev->ops->get_cur_state(cdev, &state);
> +       if (ret)
> +               return ret;
> +       return sprintf(buf, "%d\n", state);
>  }
> 
>  static ssize_t
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index 63e6619..5ddbd4f 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -46,8 +46,8 @@ struct thermal_zone_device_ops {
>  };
> 
>  struct thermal_cooling_device_ops {
> -       int (*get_max_state) (struct thermal_cooling_device *, char
> *);
> -       int (*get_cur_state) (struct thermal_cooling_device *, char
> *);
> +       int (*get_max_state) (struct thermal_cooling_device *,
> unsigned int *);
> +       int (*get_cur_state) (struct thermal_cooling_device *,
> unsigned int *);
>         int (*set_cur_state) (struct thermal_cooling_device *,
> unsigned int);
>  };
> 
> --
> Matthew Garrett | mjg59@srcf.ucam.org
> 
> 

