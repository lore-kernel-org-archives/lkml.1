Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbYJNDM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbYJNDM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 23:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755738AbYJNDMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 23:12:50 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:48529 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723AbYJNDMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 23:12:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qVO24SiSmP5CAeBk01UrrtvECVzeGZg5+CpVNf5gDUeBhdQgplQVz/M8ixpMIfZTbJ
         nIr5DkTF9XupkOerBRsOq2kA193gZg9eGux/Ntmkr0mypWGY+ehawXv3i4jwjt1x8MyD
         MQTt/2E135pOsvQoybMGz2EzyLxjZJZR61ETM=
Date: Mon, 13 Oct 2008 23:12:44 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add KD_X console mode to avoid keyboard passthrough
Message-ID: <20081014031244.GE8594@anvil.corenet.prv>
References: <20081012174710.GA5206@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081012174710.GA5206@srcf.ucam.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On Sun, Oct 12, 2008 at 06:47:10PM +0100, Matthew Garrett wrote:
> When using the evdev input driver, X currently claims the devices 
> exclusively in order to prevent characters leaking through to the 
> underlying VT. This has the downside that other consumers of input 
> events no longer receive the keys - rfkill and mouseemu no longer work 
> in the kernel, and hal is unable to pass through input events. Removing 
> the exclusive access results in events being passed through to the 
> underlying VT, which may result in leaking sensitive information.
> 
> This patch adds an extra KD_X mode. It's semantically identical to 
> KD_GRAPHICS, except that keyboard events are no longer sent to the 
> console device. This allows X to avoid exclusive access without breaking 
> any applications which depend upon the existing KD_GRAPHICS semantics.
> 

Is this really needed? The current X does not leak anything onto its VT
and the new one should not have either, unless they forget to switch
virtual console into raw mode. Plus, if you make everything work with
KD_GRAPHICS you don't have to have new kernel.

> 
> diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
> index 7b3a212..b0b8285 100644
> --- a/drivers/char/keyboard.c
> +++ b/drivers/char/keyboard.c
> @@ -1298,6 +1298,10 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
>  static void kbd_event(struct input_handle *handle, unsigned int event_type,
>  		      unsigned int event_code, int value)
>  {
> +	struct vc_data *vc = vc_cons[fg_console].d;
> +
> +	if (vc->vc_mode == KD_X)
> +		return;

This surely kills SysRq handling.

>  	if (event_type == EV_MSC && event_code == MSC_RAW && HW_RAW(handle->dev))
>  		kbd_rawcode(value);
>  	if (event_type == EV_KEY)
-- 
Dmitry
