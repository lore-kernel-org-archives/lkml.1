Return-Path: <linux-kernel-owner+w=401wt.eu-S1752374AbYJ0Gjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbYJ0Gjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 02:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbYJ0GjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 02:39:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751483AbYJ0GjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 02:39:23 -0400
Date: Sun, 26 Oct 2008 23:39:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Eric Piel <eric.piel@tremplin-utc.net>,
       Yan Burman <burman.yan@gmail.com>, Pau Oliva Fora <pau@eslack.org>
Subject: Re: [PATCH] LIS3LV02Dx Accelerometer driver
Message-Id: <20081026233901.7087e74a.akpm@linux-foundation.org>
In-Reply-To: <20081022154459.GA26291@elf.ucw.cz>
References: <20081022154459.GA26291@elf.ucw.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 17:44:59 +0200 Pavel Machek <pavel@suse.cz> wrote:

> 
> LIS3LV02Dx Accelerometer driver
> 
> This adds a driver to the accelerometer sensor found in several HP
> laptops (under the commercial names of "HP Mobile Data Protection
> System 3D" and "HP 3D driveguard"). It tries to have more or less the
> same interfaces as the hdaps and other accelerometer drivers: in sysfs
> and as a joystick.
> 
> This driver was first written by Yan Burman. Eric Piel has updated it
> and slimed it up (including the removal of an interface to access to
> the free-fall feature of the sensor because it is not reliable enough
> for now). Pavel Machek removed few more features and switched locking
> from semaphore to mutex.
> 
> Several people have contributed to the database of the axes.
> 
> ...
>
> +/* joystick device poll interval in milliseconds */
> +#define MDPS_POLL_INTERVAL 50
>
> ...
>
> +static int lis3lv02d_joystick_kthread(void *data)
> +{
> +	int x, y, z;
> +
> +	while (!kthread_should_stop()) {
> +		lis3lv02d_get_xyz(adev.device->handle, &x, &y, &z);
> +		input_report_abs(adev.idev, ABS_X, x - adev.xcalib);
> +		input_report_abs(adev.idev, ABS_Y, y - adev.ycalib);
> +		input_report_abs(adev.idev, ABS_Z, z - adev.zcalib);
> +
> +		input_sync(adev.idev);
> +
> +		try_to_freeze();
> +		msleep_interruptible(MDPS_POLL_INTERVAL);

You'll have the powertop police on your tail.

Is there no alternative?

> +	}
> +
> +	return 0;
> +}

