Return-Path: <linux-kernel-owner+w=401wt.eu-S1751825AbZCFFkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbZCFFkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 00:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbZCFFj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 00:39:57 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:25174 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbZCFFj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 00:39:56 -0500
Message-ID: <49B0B785.4010806@oracle.com>
Date: Thu, 05 Mar 2009 21:41:25 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Paul Collins <paul@burly.ondioline.org>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid/apple: add module parameter to swap the Command and
 Option keys
References: <87zlfz8bc1.fsf@burly.wgtn.ondioline.org>
In-Reply-To: <87zlfz8bc1.fsf@burly.wgtn.ondioline.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.49B0B723.00E2:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Collins wrote:
> Apple keyboards have the Command keys (a.k.a. the Apple or "waffle" key)
> in the positions normally occupied on PC keyboards by the Alt/AltGr keys,
> and the Option or Alt keys in the position occupied by the so-called
> Windows keys.  Folks who have been using PC-type computers for too long
> generally have insurmountable muscle memory in this regard.
> 
> This patch adds a module parameter, defaulting to off, that swaps these keys.
> 
> The same effect can also be achieved by changing the console and X
> keymaps, but this approach does not scale.  For example, I don't want to
> have to learn how to reconfigure Wayland's keymaps when the future
> arrives and we all start using it, and there may be applications I don't
> know about that also read keyboard events directly.

Hi,
Where do you suggest that this option be documented?

> Signed-off-by: Paul Collins <paul@ondioline.org>
> ---
>  drivers/hid/hid-apple.c |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
> index 7ed94cf..63e9ee3 100644
> --- a/drivers/hid/hid-apple.c
> +++ b/drivers/hid/hid-apple.c
> @@ -40,6 +40,11 @@ module_param(fnmode, uint, 0644);
>  MODULE_PARM_DESC(fnmode, "Mode of fn key on Apple keyboards (0 = disabled, "
>  		"[1] = fkeyslast, 2 = fkeysfirst)");
>  
> +static unsigned int swapmodifiers = 0;
> +module_param(swapmodifiers, uint, 0644);
> +MODULE_PARM_DESC(fnmode, "Modifiers match labels or positions "
> +		 "([0] = labels, 1 = positions)");
> +
>  struct apple_sc {
>  	unsigned long quirks;
>  	unsigned int fn_on;
> @@ -123,6 +128,14 @@ static struct apple_key_translation apple_iso_keyboard[] = {
>  	{ }
>  };
>  
> +static struct apple_key_translation apple_swap_modifiers[] = {
> +	{ KEY_LEFTALT,	KEY_LEFTMETA },
> +	{ KEY_RIGHTALT,	KEY_RIGHTMETA },
> +	{ KEY_LEFTMETA,	KEY_LEFTALT },
> +	{ KEY_RIGHTMETA, KEY_RIGHTALT },
> +	{ }
> +};
> +
>  static struct apple_key_translation *apple_find_translation(
>  		struct apple_key_translation *table, u16 from)
>  {
> @@ -199,6 +212,14 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
>  		}
>  	}
>  
> +	if (swapmodifiers) {
> +		trans = apple_find_translation(apple_swap_modifiers, usage->code);
> +		if (trans) {
> +			input_event(input, usage->type, trans->to, value);
> +			return 1;
> +		}
> +	}
> +
>  	if (asc->quirks & APPLE_ISO_KEYBOARD) {
>  		trans = apple_find_translation(apple_iso_keyboard, usage->code);
>  		if (trans) {
> 

Thanks,
-- 
~Randy
