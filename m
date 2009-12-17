Return-Path: <linux-kernel-owner+w=401wt.eu-S934684AbZLQBQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934684AbZLQBQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934490AbZLQBQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:16:51 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:52151 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933000AbZLQBQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:16:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=edhgR2ERi9JUyIGxHYPqytMtfZOAc3QK967gVYf33h+6MoyQh6m7HVrt3UNJEKkPjx
         2tCRV5NoChTA1HQeuXv3vmLWwKmKjeebO7B/JumurAKXY8t3g67QcpQvGK4vZMD+lt9C
         0s2iGO5DAxPkRQ9HsOGEztH2tRUsTMWNXGWXc=
Subject: Re: [PATCH v10 5/8] Loongson: YeeLoong: add hardware monitoring
 driver
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>
Cc: akpm@linux-foundation.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <d74dbb0ff251bc26556e27c21be3ce7c752776be.1260868626.git.wuzhangjin@gmail.com>
References: <d74dbb0ff251bc26556e27c21be3ce7c752776be.1260868626.git.wuzhangjin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Thu, 17 Dec 2009 09:16:10 +0800
Message-ID: <1261012570.7239.13.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2009-12-15 at 17:24 +0800, Wu Zhangjin wrote:
> From: Wu Zhangjin <wuzhangjin@gmail.com>
> 
> This can be applied between v9 4/8 and v9 6/8.
> 
> Changes from v9 5/8:
> 
> 	o ensure the fan controlling interface is compatible with the
> 	one described in Documentation/hwmon/sysfs-interface
[...]
> +/* hwmon subdriver */
> +
> +#define MIN_FAN_SPEED 0
> +#define MAX_FAN_SPEED 3
> +
> +static int get_fan_pwm_enable(void)
> +{
> +	int level, mode;
> +
> +	level = ec_read(REG_FAN_SPEED_LEVEL);
> +	mode = ec_read(REG_FAN_AUTO_MAN_SWITCH);
> +
> +	if (level == MAX_FAN_SPEED && mode == BIT_FAN_MANUAL)
> +		mode = 0;
> +	else if (mode == BIT_FAN_MANUAL)
> +		mode = 1;
> +	else
> +		mode = 2;
> +
> +	return mode;
> +}
> +
> +static void set_fan_pwm_enable(int mode)
> +{
> +	switch (mode) {
> +	case 0:
> +		/* fullspeed */
> +		ec_write(REG_FAN_AUTO_MAN_SWITCH, BIT_FAN_MANUAL);
> +		ec_write(REG_FAN_SPEED_LEVEL, MAX_FAN_SPEED);
> +		break;
> +	case 1:
> +		ec_write(REG_FAN_AUTO_MAN_SWITCH, BIT_FAN_MANUAL);
> +		break;
> +	case 2:
> +		ec_write(REG_FAN_AUTO_MAN_SWITCH, BIT_FAN_AUTO);
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
[...]
> +
> +static int yeeloong_hwmon_init(void)
> +{
> +	int ret;
> +
> +	yeeloong_hwmon_dev = hwmon_device_register(NULL);
> +	if (IS_ERR(yeeloong_hwmon_dev)) {
> +		pr_err("Fail to register yeeloong hwmon device\n");
> +		yeeloong_hwmon_dev = NULL;
> +		return PTR_ERR(yeeloong_hwmon_dev);
> +	}
> +	ret = sysfs_create_group(&yeeloong_hwmon_dev->kobj,
> +				 &hwmon_attribute_group);
> +	if (ret) {
> +		hwmon_device_unregister(yeeloong_hwmon_dev);
> +		yeeloong_hwmon_dev = NULL;
> +		return ret;
> +	}
> +	/* ensure fan is set to auto mode */
> +	set_fan_pwm_enable(BIT_FAN_AUTO);
> +

We need to change the above line to:

set_fan_pwm_enable(2);

to ensure it is compatible to the hwmon interface too.

Best Regards,
	Wu Zhangjin

