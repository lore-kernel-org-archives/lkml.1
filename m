Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbXJ2Hx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbXJ2Hx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 03:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbXJ2HxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 03:53:21 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50592 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbXJ2HxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 03:53:20 -0400
Message-ID: <4725916A.7010505@garzik.org>
Date: Mon, 29 Oct 2007 03:53:14 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Dirk Hohndel <hohndel@linux.intel.com>
CC: Jiri Kosina <jikos@jikos.cz>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] INPUT: fix hidinput_connect ignoring retval from input_register_device
References: <20071029065153.GA9490@bigserver.hohndel.org>
In-Reply-To: <20071029065153.GA9490@bigserver.hohndel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dirk Hohndel wrote:
> [INPUT] hidinput_connect incorrectly ignored return value from input_register_device
> 
> Signed-off-by: Dirk Hohndel <hohndel@linux.intel.com>
> 
> ---
>  drivers/hid/hid-input.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index dd332f2..c8640e7 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -1186,13 +1186,19 @@ int hidinput_connect(struct hid_device *hid)
>  				 * UGCI) cram a lot of unrelated inputs into the
>  				 * same interface. */
>  				hidinput->report = report;
> -				input_register_device(hidinput->input);
> +				if (input_register_device(hidinput->input)) {
> +					input_free_device(hidinput->input);
> +					return -1;
> +				}
>  				hidinput = NULL;
>  			}
>  		}
>  
>  	if (hidinput)
> -		input_register_device(hidinput->input);
> +		if (input_register_device(hidinput->input)) {
> +			input_free_device(hidinput->input);
> +			return -1;
> +		}

You would also want to kfree(hidinput) on failure too.

Thanks for attacking this newly added warning!

	Jeff



