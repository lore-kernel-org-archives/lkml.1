Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbYLCVRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbYLCVRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 16:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYLCVRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 16:17:34 -0500
Received: from smtp1.stealer.net ([88.198.224.204]:36856 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbYLCVRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 16:17:33 -0500
Date: Wed, 3 Dec 2008 22:17:18 +0100 (CET)
From: Sven Wegener <sven.wegener@stealer.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] misc: Add dell-wmi driver for hotkey control
In-Reply-To: <20081203195644.GC22560@srcf.ucam.org>
Message-ID: <alpine.LNX.2.00.0812032149470.16637@titan.stealer.net>
References: <20081203195644.GC22560@srcf.ucam.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: 0.1
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Wed, 03 Dec 2008 21:17:30 +0000
	Bayes: 0.4585 Tokens: new, 214; hammy, 4; neutral, 5; spammy, 1.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4585]
	*  0.0 DNS_FROM_SECURITYSAGE RBL: Envelope sender in
	*      blackholes.securitysage.com
X-Spam-Signature: b51bce8eff1b40b0fca4d429b581ece76a775b6f
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008, Matthew Garrett wrote:

> Add a WMI driver for Dell laptops. Currently it does nothing but send a
> generic input event when a button with a picture of a battery on it is
> pressed, but maybe other uses will appear over time.

Some general notes below. I have no knowledge of the input layer, so I
can't verify the patch in terms of input layer correctness.

> [...]
> +void dell_wmi_notify(u32 value, void *context)

static

> +{
> +	struct acpi_buffer response = { ACPI_ALLOCATE_BUFFER, NULL };
> +	static struct key_entry *key;
> +	union acpi_object *obj;
> +
> +	wmi_get_event_data(value, &response);
> +
> +	obj = (union acpi_object *)response.pointer;
> +
> +	if (obj && obj->type == ACPI_TYPE_BUFFER) {
> +		int *buffer = (int *)obj->buffer.pointer;
> +		key = dell_wmi_get_entry_by_scancode(buffer[1]);
> +		if (key) {
> +			input_report_key(dell_wmi_input_dev, key->keycode, 1);
> +			input_sync(dell_wmi_input_dev);
> +			input_report_key(dell_wmi_input_dev, key->keycode, 0);
> +			input_sync(dell_wmi_input_dev);
> +		} else
> +			printk(KERN_INFO "dell-wmi: Unknown key %x pressed\n",
> +			       buffer[1]);
> +	}
> +	return;

No need to at the end of a function.

> +}
> +
> +static int __init dell_wmi_input_setup(void)
> +{
> +	struct key_entry *key;
> +	int err;
> +
> +	dell_wmi_input_dev = input_allocate_device();
> +
> +	dell_wmi_input_dev->name = "Dell WMI hotkeys";

Missing check for allocation failure.

> [...]
> +static int __init dell_wmi_init(void)
> +{
> +	int err;
> +
> +	if (wmi_has_guid(DELL_EVENT_GUID)) {
> +		err = wmi_install_notify_handler(DELL_EVENT_GUID,
> +						 dell_wmi_notify, NULL);
> +		if (!err)
> +			dell_wmi_input_setup();

Uhm, what if the notify handler gets called before the device has been set 
up? And looking at the function, the dell_wmi_input_setup() call can fail, 
which means you end up with invalid device handle.

Sven
