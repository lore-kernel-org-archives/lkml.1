Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbYHPXRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbYHPXRS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 19:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbYHPXRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 19:17:07 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:28438 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbYHPXRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 19:17:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=YBndg+qNl+X1/m04v77sF7zcwI3ojcQ+CobkBCJzh3BwT/Mi8K5hHCrasjKAnTJcdw
         Nir/rK6xwrgBBq4ZDMfdxxR03QEdUGWOVR/EsI0I8eitETusaBs0w8wUKJNiLY/OcuJb
         t+VJo6JrUBb+J0F0zXJwC+Dp2YTmiPXSsOUWE=
Message-ID: <82e4877d0808161617k5404f4ectf6d502de5b7fea4c@mail.gmail.com>
Date: Sat, 16 Aug 2008 19:17:05 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: mjg59@srcf.ucam.org
Subject: Re: [PATCH 2/2] Add Dell laptop driver
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg59 <at> srcf.ucam.org> writes:



> diff --git a/drivers/misc/dell-laptop.c b/drivers/misc/dell-laptop.c
> new file mode 100644
> index 0000000..ab09a69
> --- /dev/null
> +++ b/drivers/misc/dell-laptop.c

[Snip]

> +	da_command_address = table->cmdIOAddress;
> +	da_command_code = table->cmdIOCode;
> +
> +	da_tokens = krealloc(da_tokens, (da_num_tokens + tokens) *
> +			     sizeof(struct calling_interface_token),
> +			     GFP_KERNEL);

Isn't a NULL check required here?

> +
> +	memcpy(da_tokens+da_num_tokens, table->tokens,
> +	       sizeof(struct calling_interface_token) * tokens);
> +

> +static struct calling_interface_buffer *dell_send_request(
> +	struct calling_interface_buffer *buffer, int class, int select)
> +{
> +	struct smi_cmd *command = kzalloc(sizeof(struct smi_cmd), GFP_KERNEL);

NULL check - Here too.

> +	command->magic = SMI_CMD_MAGIC;
> +	command->command_address = da_command_address;
> +	command->command_code = da_command_code;
> +	command->ebx = virt_to_phys(buffer);
> +	command->ecx = 0x42534931;
> +

> +
> +static int dell_rfkill_set(int radio, enum rfkill_state state)
> +{
> +	struct calling_interface_buffer *buffer =
> +		kzalloc(sizeof(struct calling_interface_buffer), GFP_KERNEL);

Ditto.

> +	int disable = (state == RFKILL_STATE_UNBLOCKED) ? 0 : 1;
> +	buffer->input[0] = (1 | (radio<<8) | (disable << 16));
> +	dell_send_request(buffer, 17, 11);
> +	kfree(buffer);
> +	return 0;
> +}

> +static int dell_rfkill_get(int bit, enum rfkill_state *state)
> +{
> +	struct calling_interface_buffer *buffer =
> +		kzalloc(sizeof(struct calling_interface_buffer), GFP_KERNEL);

This makes me confident there is code in the kernel that always
succeeds allocations by mjg59.
Just got to find where it's hidden :)


> +static int dell_wifi_get(void *data, enum rfkill_state *state)
> +{
> +	return dell_rfkill_get(17, state);
> +}
> +
> +static int dell_bluetooth_get(void *data, enum rfkill_state *state)
> +{
> +	return dell_rfkill_get(18, state);
> +}
> +
> +static int dell_wwan_get(void *data, enum rfkill_state *state)
> +{
> +	return dell_rfkill_get(19, state);
> +}
> +
> +static void dell_setup_rfkill(void)
> +{
> +	struct calling_interface_buffer *buffer =
> +		kzalloc(sizeof(struct calling_interface_buffer), GFP_KERNEL);

Once more.

> +
> +static int dell_send_intensity(struct backlight_device *bd)
> +{
> +	int intensity = bd->props.brightness;
> +	struct calling_interface_buffer *buffer =
> +		kzalloc(sizeof(struct calling_interface_buffer), GFP_KERNEL);

Stopped counting!

> +
> +	buffer->input[0] = find_token_location(0x7d);
> +	buffer->input[1] = intensity;
> +
> +	if (buffer->input[0] == -1) {
> +		kfree(buffer);
> +		return -ENODEV;
> +	}


> +
> +static int dell_get_intensity(struct backlight_device *bd)
> +{
> +	struct calling_interface_buffer *buffer =
> +		kzalloc(sizeof(struct calling_interface_buffer), GFP_KERNEL);

count_prev++;

> +	if (!dmi_check_system(dell_device_table))
> +		return -ENODEV;
> +
> +	dmi_walk(find_tokens);
> +
> +	if (!da_tokens)
> +		return -ENODEV;
> +
> +	buffer = kzalloc(sizeof(struct calling_interface_buffer), GFP_KERNEL);

One last.

> +	buffer->input[0] = find_token_location(0x7d);
> +
> +	if (buffer->input[0] != -1) {
> +		dell_send_request(buffer, 2, 1);
> +		max_intensity = buffer->output[3];
> +	}
> +


Parag
