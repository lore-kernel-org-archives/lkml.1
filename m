Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbYLCWzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbYLCWzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 17:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbYLCWzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 17:55:39 -0500
Received: from smtp1.stealer.net ([88.198.224.204]:38438 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbYLCWzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 17:55:38 -0500
Date: Wed, 3 Dec 2008 23:55:22 +0100 (CET)
From: Sven Wegener <sven.wegener@stealer.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: "Brian S. Julin" <bri@abrij.org>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       greg@kroah.com
Subject: Re: [PATCH] misc: Add oqo-wmi driver for model 2 OQO backlight and
 rfkill control
In-Reply-To: <20081203195537.GB22560@srcf.ucam.org>
Message-ID: <alpine.LNX.2.00.0812032232170.16637@titan.stealer.net>
References: <20081127190517.GA25429@srcf.ucam.org> <alpine.LFD.2.00.0811281431320.3204@localhost.localdomain> <Pine.LNX.4.64.0811282215160.17453@sheavy.abrij.org> <20081129045045.GA13866@srcf.ucam.org> <20081203195537.GB22560@srcf.ucam.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -1.0
X-Spam-Bar: -
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Wed, 03 Dec 2008 22:55:36 +0000
	Bayes: 0.0482 Tokens: new, 435; hammy, 12; neutral, 7; spammy, 1.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0482]
	*  0.0 DNS_FROM_SECURITYSAGE RBL: Envelope sender in
	*      blackholes.securitysage.com
X-Spam-Signature: 84cb713e7ddb1d77bb070f629ff85a80fa97ca93
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008, Matthew Garrett wrote:

> oqo-wmi provides a WMI-based interface to backlight and rfkill control on
> model 2 OQO devices. It was originally written by Brian Julin
> (<bri@abrij.org>) - I've ported it to the rfkill layer and tidied it up a
> little.

Some general comments below.

> +/* Some of this code is left like in acer-wmi so we can add the older
> +   Model 01 and any future models more easily, but we should not expect
> +   it to be as complicated as Acer given each model is a leap rather than
> +   a subtle variant on the last, so we aren't using "quirks" perse.  Not
> +   sure if there is any real difference for our purposes between the o2
> +   and e2.
> +*/
> +struct oqo_model {
> +	const char *model;
> +	u16 model_subs;
> +};
> +#define MODEL_SUB_OQO_O2_SMB0 3
> +
> +static struct oqo_model oqo_models[] = {
> +	{
> +	 .model = "Model 2",
> +	 .model_subs = MODEL_SUB_OQO_O2_SMB0,
> +	 },
> +	{}
> +};
> +
> +static struct oqo_model *model;

With "like in acer-wmi" you mean that this whole model stuff currently
serves no purpose? If we don't access the model variable yet, I think it
shouldn't be there.

> +static int dmi_matched(const struct dmi_system_id *dmi)

__init

> +{
> +	model = dmi->driver_data;
> +	/*
> +	 * Detect which ACPI-WMI interface we're using.
> +	 */
> +	if (wmi_has_guid(OQO_O2_AMW0_GUID))
> +		interface = &AMW0_interface;
> +
> +	return 0;
> +}
> +
> +static struct dmi_system_id oqo_dmis[] = {

__initdata

And i think const is also possible.

> +static acpi_status oqo_read_kine(int *good, s16 *x, s16 *y, s16 *z,
> +				 u16 *lumin)
> +{
> +	u8 hiregs[4] = { OQO_O2_SMB0_ACCEL_XHI,
> +		OQO_O2_SMB0_ACCEL_YHI,
> +		OQO_O2_SMB0_ACCEL_ZHI,
> +		OQO_O2_SMB0_LUMIN_HI
> +	};
> +	u8 loregs[4] = { OQO_O2_SMB0_ACCEL_XLO,
> +		OQO_O2_SMB0_ACCEL_YLO,
> +		OQO_O2_SMB0_ACCEL_ZLO,
> +		OQO_O2_SMB0_LUMIN_LO
> +	};
> +
> +	short ax[4] = { ABS_X, ABS_Y, ABS_Z, ABS_MISC };

Uhm, I think these three variables could be static and const.

> +	*x = (u16) res[0];
> +	*y = (u16) res[1];
> +	*z = (u16) res[2];
> +	*lumin = (u16) res[3];
> +	return status;

This return could be dropped, just let it fall-through.

> +leave:
> +	return status;
> +}



> +static int __devinit oqo_kine_init(void)
> +{
> +	int err;
> +
> +	oqo_kine = input_allocate_device();
> +	if (!oqo_kine)
> +		return -ENOMEM;
> +
> +	oqo_kine->name = "OQO embedded accelerometer";
> +	oqo_kine->phys = "platform:oqo-wmi:kine";
> +	oqo_kine->id.bustype = 0;
> +	oqo_kine->id.vendor = 0;
> +	oqo_kine->id.product = 2;
> +	oqo_kine->id.version = 0;
> +	oqo_kine->evbit[0] = BIT_MASK(EV_ABS);
> +	set_bit(ABS_X, oqo_kine->absbit);
> +	set_bit(ABS_Y, oqo_kine->absbit);
> +	set_bit(ABS_Z, oqo_kine->absbit);
> +	set_bit(ABS_MISC, oqo_kine->absbit);
> +	oqo_kine->absmin[ABS_X] =
> +	    oqo_kine->absmin[ABS_Y] =
> +	    oqo_kine->absmin[ABS_Z] = oqo_kine->absmin[ABS_MISC] = -32768;
> +	oqo_kine->absmax[ABS_X] =
> +	    oqo_kine->absmax[ABS_Y] =
> +	    oqo_kine->absmax[ABS_Z] = oqo_kine->absmax[ABS_MISC] = 32767;
> +
> +	memcpy(oqo_kine->dev.bus_id, "kine", 4);
> +
> +	oqo_kine_polled = input_allocate_polled_device();
> +	if (!oqo_kine_polled) {
> +		err = -ENOMEM;
> +		goto bail0;
> +	}
> +
> +	oqo_kine_polled->poll = oqo_kine_poll;
> +	oqo_kine_polled->poll_interval = 250;
> +	oqo_kine_polled->input = oqo_kine;

input_allocate_polled_device() allocates ->input for us, you must remove
the input_allocate_device() above and shift the code around.

> +static void __devexit oqo_kine_fini(void)
> +{
> +	smwrite_u8(OQO_O2_SMB0_ACCEL_POLL_ITVL, orig.kine_itvl);
> +	input_unregister_polled_device(oqo_kine_polled);
> +	input_free_polled_device(oqo_kine_polled);

Uhm, I wonder if this is the right order. First unregister and then do
the smwrite_u8() to prevent the device from reverting our write?

> +static int __devinit oqo_platform_probe(struct platform_device *device)
> +{
> +	int err;
> +	int i;
> +	char *troubleok = "trouble, but continuing.\n";

This variable seems needless, just append the message to the printk()
calls.

> +
> +	memset(oqo_sn, 0, OQO_O2_SMB0_SERIAL_LEN + 1);
> +	for (i = 0; i < OQO_O2_SMB0_SERIAL_LEN; i++) {
> +		err = oqo_smbus_getb(OQO_O2_SMB0_SERIAL_START + i, oqo_sn + i);
> +		if (err) {
> +			printk(OQO_ERR "Serial number check failed.\n");
> +			return err;
> +		}
> +	}
> +	printk(OQO_INFO "Found OQO with serial number %s.\n", oqo_sn);
> +
> +	err = oqo_backlight_init(&device->dev);
> +	if (err)
> +		printk(OQO_ERR "Backlight init %s", troubleok);
> +
> +	err = oqo_rfkill_init(&device->dev);
> +	if (err)
> +		printk(OQO_ERR "RFKill init %s", troubleok);
> +
> +	/* LID does not work at all yet, and this may be taken
> +	   care of by ACPI.
> +	 */
> +	orig.lid_wakes = smread_u8(OQO_O2_SMB0_LID_WAKES_ADDR);
> +	orig.lid_wakes &= OQO_O2_SMB0_LID_WAKES_MASK;
> +	orig.lid_wakes = curr.lid_wakes = !!orig.lid_wakes;
> +	if (orig.lid_wakes < 0) {
> +		printk(OQO_ERR "Wake on LID event %s", troubleok);
> +	} else {
> +		printk(OQO_INFO "Wake on LID is %s.\n",
> +		       (orig.lid_wakes ? "on" : "off"));
> +	}
> +
> +	err = oqo_kine_init();
> +	return err;

Uhm, if oqo_kine_init() fails, does our caller take care of
unregistering the backlight and rfkill devices?

> +}
> +
> +static int oqo_platform_remove(struct platform_device *device)
> +{
> +	oqo_backlight_fini();
> +	oqo_rfkill_fini();
> +	oqo_kine_fini();

These three functions are marked __devexit, I suspect this will cause
section mismatches.

> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +
> +static int oqo_platform_suspend(struct platform_device *dev, pm_message_t state)
> +{
> +	if (!interface)
> +		return -ENOMEM;

Interface should be always set once the module has been loaded
successfully.

> +
> +	/* This sticks during boot so do not turn it entirely off */
> +	if (oqo_backlight_device) {
> +		curr.bl_bright = read_brightness(oqo_backlight_device);
> +		smwrite_s16(OQO_O2_SMB0_BL_HI, OQO_O2_SMB0_BL_LO, 256);
> +	}
> +	return 0;
> +}
> +
> +static int oqo_platform_resume(struct platform_device *device)
> +{
> +	if (!interface)
> +		return -ENOMEM;

Likewise.

> +
> +	if (oqo_backlight_device) {
> +		smwrite_s16(OQO_O2_SMB0_BL_HI,
> +			    OQO_O2_SMB0_BL_LO, curr.bl_bright);
> +	}
> +
> +	return 0;
> +}

> +	err = platform_device_add(oqo_platform_device);
> +	if (err) {
> +		printk(OQO_ERR "platform_device_add gave %d.\n", err);
> +		platform_device_put(oqo_platform_device);
> +		goto bail1;

Why not add a bail2 and move platform_device_put() there?

> +	}
> +
> +	return 0;
> +
> +bail1:
> +	platform_driver_unregister(&oqo_platform_driver);
> +bail0:
> +	return err;
> +}
> +
> +static void __exit oqo_wmi_fini(void)
> +{
> +	platform_device_del(oqo_platform_device);
> +	platform_driver_unregister(&oqo_platform_driver);
> +
> +	return;
> +}

Needless return at end of function.

Sven
