Return-Path: <linux-kernel-owner+w=401wt.eu-S934021AbXCTQMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934021AbXCTQMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934024AbXCTQMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:12:05 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:23427 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934023AbXCTQMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:12:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Mkid9c4JFccRZXYv22tAat3glr7sFQp5/sfCMrkMNSMv3NTjLZmb0KVA6A3BHllQFF2lVMbL0cY/lPsh2fg5GmBUbgXUH+xTKkcSAwDnVZPtKMx2EPLM6AT7li6fwk0u63wg3i4j2MrUsGs8fpur557mSKqUtwwsadS0AHVxQrg=
Message-ID: <75b57c110703200912t3fe623c6g8cd163bef8c3b7bb@mail.gmail.com>
Date: Tue, 20 Mar 2007 12:12:00 -0400
From: "Gerb Stralko" <gerb.stralko@gmail.com>
To: "Nicolas Boichat" <nicolas@boichat.ch>
Subject: Re: [RFC][PATCH] Apple SMC driver (hardware monitoring and control)
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org, rlove@rlove.org,
       linux-kernel@hansmi.ch
In-Reply-To: <45F7C083.7090504@boichat.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45F7C083.7090504@boichat.ch>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +/* data port used by apple SMC */
> +#define APPLESMC_DATA_PORT     0x300
> +/* command/status port used by apple SMC */
> +#define APPLESMC_CMD_PORT      0x304
> +
> +#define APPLESMC_NR_PORTS      5 /* 0x300-0x304 */
> +
> +#define APPLESMC_STATUS_MASK   0x0f
> +#define APPLESMC_READ_CMD      0x10
> +#define APPLESMC_WRITE_CMD     0x11
> +
> +#define LIGHT_SENSOR_LEFT_KEY  "ALV0" //r-o length 6
> +#define LIGHT_SENSOR_RIGHT_KEY "ALV1" //r-o length 6
> +#define BACKLIGHT_KEY          "LKSB" //w-o
> +
> +#define CLAMSHELL_KEY          "MSLD" //r-o length 1 (unused)
> +
> +#define MOTION_SENSOR_X_KEY    "MO_X" //r-o length 2
> +#define MOTION_SENSOR_Y_KEY    "MO_Y" //r-o length 2
> +#define MOTION_SENSOR_Z_KEY    "MO_Z" //r-o length 2
> +#define MOTION_SENSOR_KEY      "MOCN" //r/w length 2
> +
> +#define FANS_COUNT             "FNum" //r-o length 1
> +#define FANS_MANUAL            "FS! " //r-w length 2
> +#define FAN_ACTUAL_SPEED       "F0Ac" //r-o length 2
> +#define FAN_MIN_SPEED          "F0Mn" //r-o length 2
> +#define FAN_MAX_SPEED          "F0Mx" //r-o length 2
> +#define FAN_SAFE_SPEED         "F0Sf" //r-o length 2
> +#define FAN_TARGET_SPEED       "F0Tg" //r-w length 2
> +
> +/* Temperature sensors keys. First set for Macbook(Pro), second for Macmini */
> +static const char* temperature_sensors_sets[][8] = {
> +       { "TB0T", "TC0D", "TC0P", "Th0H", "Ts0P", "Th1H", "Ts1P", NULL },
> +       { "TC0D", "TC0P", NULL }
> +};
> +
> +#define INIT_TIMEOUT_MSECS     5000    /* wait up to 5s for device init ... */
> +#define INIT_WAIT_MSECS                50      /* ... in 50ms increments */
> +
> +#define APPLESMC_POLL_PERIOD   (HZ/20) /* poll for input every 1/20s */
> +#define APPLESMC_INPUT_FUZZ    4       /* input event threshold */
> +#define APPLESMC_INPUT_FLAT    4
> +
> +#define SENSOR_X 0
> +#define SENSOR_Y 1
> +#define SENSOR_Z 2
> +
> +/* Structure to be passed to DMI_MATCH function */
> +struct dmi_match_data {
> +/* Indicates whether this computer has an accelerometer. */
> +       int accelerometer;
> +/* Indicates whether this computer has light sensors and keyboard backlight. */
> +       int light;
> +/* Indicates which temperature sensors set to use. */
> +       int temperature_set;
> +};
> +
> +static int debug = 0;
> +static struct platform_device *pdev;
> +static s16 rest_x;
> +static s16 rest_y;
> +static struct timer_list applesmc_timer;
> +static struct input_dev *applesmc_idev;
> +
> +/* Indicates whether this computer has an accelerometer. */
> +static unsigned int applesmc_accelerometer = 0;
> +
> +/* Indicates whether this computer has light sensors and keyboard backlight. */
> +static unsigned int applesmc_light = 0;
> +
> +/* Indicates which temperature sensors set to use. */
> +static unsigned int applesmc_temperature_set = 0;
> +

Is it possible to put some of this in a header file?  I think it may
make the driver look alittle nicer and IMO easier to read.  If this is
a problem or not just plain _stupid_ then just ignore me.  I'm not
trying to be nit picky, i just think this is a *great* driver and I'm
excited to use it, but the cleaner it is the more manageable it will
be in the future.

-Jerry
