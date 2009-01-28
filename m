Return-Path: <linux-kernel-owner+w=401wt.eu-S1752457AbZA1TZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbZA1TZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 14:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbZA1TZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 14:25:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318AbZA1TZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 14:25:10 -0500
Date: Wed, 28 Jan 2009 11:24:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Helge Deller <deller@gmx.de>
Cc: bugme-daemon@bugzilla.kernel.org, Frans Pop <elendil@planet.nl>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Matthew Garrett <mjg@redhat.com>, Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 12560] New: crash in hp_wmi_bios_setup (hp-wmi
 driver)
Message-Id: <20090128112431.43a836b1.akpm@linux-foundation.org>
In-Reply-To: <bug-12560-10286@http.bugzilla.kernel.org/>
References: <bug-12560-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 04:54:38 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=12560
> 
>            Summary: crash in hp_wmi_bios_setup (hp-wmi driver)
> ...
> Problem Description:
> 2.6.29-rc2 crashes at bootup when CONFIG_HP_WMI=y (hp-wmi driver)
>
> screenshot of crash is available here:
> http://userweb.kernel.org/~deller/bz_12560/dcp_4175.jpg

You can sort of blame me for that, because I haven't merged
http://userweb.kernel.org/~akpm/mmotm/broken-out/hp-wmi-fix-regressions-caused-by-missing-if-statement.patch
yet.

However, perhaps I was being unconsciously clever here.  Why did it oops???

Look:

(this is the fixed code from -mm):

static int __init hp_wmi_bios_setup(struct platform_device *device)
{
	int err;
	int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);

	err = device_create_file(&device->dev, &dev_attr_display);
	if (err)
		goto add_sysfs_error;
	err = device_create_file(&device->dev, &dev_attr_hddtemp);
	if (err)
		goto add_sysfs_error;
	err = device_create_file(&device->dev, &dev_attr_als);
	if (err)
		goto add_sysfs_error;
	err = device_create_file(&device->dev, &dev_attr_dock);
	if (err)
		goto add_sysfs_error;

	if (wireless & 0x1) {
		wifi_rfkill = rfkill_allocate(&device->dev, RFKILL_TYPE_WLAN);
		wifi_rfkill->name = "hp-wifi";
		wifi_rfkill->state = hp_wmi_wifi_state();
		wifi_rfkill->toggle_radio = hp_wmi_wifi_set;
		wifi_rfkill->user_claim_unsupported = 1;
		err = rfkill_register(wifi_rfkill);
		if (err)
			goto add_sysfs_error;
	}

	if (wireless & 0x2) {
		bluetooth_rfkill = rfkill_allocate(&device->dev,
						   RFKILL_TYPE_BLUETOOTH);
		bluetooth_rfkill->name = "hp-bluetooth";
		bluetooth_rfkill->state = hp_wmi_bluetooth_state();
		bluetooth_rfkill->toggle_radio = hp_wmi_bluetooth_set;
		bluetooth_rfkill->user_claim_unsupported = 1;
		err = rfkill_register(bluetooth_rfkill);
+		if (err)
			goto register_bluetooth_error;
	}

	if (wireless & 0x4) {
		wwan_rfkill = rfkill_allocate(&device->dev, RFKILL_TYPE_WWAN);
		wwan_rfkill->name = "hp-wwan";
		wwan_rfkill->state = hp_wmi_wwan_state();
		wwan_rfkill->toggle_radio = hp_wmi_wwan_set;
		wwan_rfkill->user_claim_unsupported = 1;
		err = rfkill_register(wwan_rfkill);
		if (err)
			goto register_wwan_err;
	}

	return 0;
register_wwan_err:
	rfkill_unregister(bluetooth_rfkill);
register_bluetooth_error:
	rfkill_unregister(wifi_rfkill);
add_sysfs_error:
	cleanup_sysfs(device);
	return err;
}

if local variable `wireless' has a value of 2 and rfkill_register()
fails, the error recovery path will do rfkill_unregister(wifi_rfkill),
but wifi_rfkill was never registered!

So we should do this:

--- a/drivers/platform/x86/hp-wmi.c~hp-wmi-fix-error-path-in-hp_wmi_bios_setup
+++ a/drivers/platform/x86/hp-wmi.c
@@ -458,9 +458,11 @@ static int __init hp_wmi_bios_setup(stru
 
 	return 0;
 register_wwan_err:
-	rfkill_unregister(bluetooth_rfkill);
+	if (bluetooth_rfkill)
+		rfkill_unregister(bluetooth_rfkill);
 register_bluetooth_error:
-	rfkill_unregister(wifi_rfkill);
+	if (wifi_rfkill)
+		rfkill_unregister(wifi_rfkill);
 add_sysfs_error:
 	cleanup_sysfs(device);
 	return err;
_

yes?


<looks at your screenshot>

yup, you hit a BUG().  For some reason there's no indication of this in
the trace (apart from the opcode in the Code: line).  I wonder why the
first line of the BUG handler didn't come out?


