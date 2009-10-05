Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbZJEX7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbZJEX7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 19:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbZJEX7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 19:59:53 -0400
Received: from outbound-mail-15.bluehost.com ([69.89.18.115]:45946 "HELO
	outbound-mail-15.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754541AbZJEX7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 19:59:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=KSkgPKAWBTFWvQBx56Axtum8FdW79hTn40hGvzvslJ6SuvGQN2ahXtdjOSNieZEzA5DF8rFIVaEi3WEh6sc4er0KNcULh2yzBzqUPEndP8PEgLDimR200swUuBp26wVh;
Date: Mon, 5 Oct 2009 16:59:07 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Eric Anholt <eric@anholt.net>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.32-rc1: spurious error message from "ACPI button: provide
 lid status functions"
Message-ID: <20091005165907.291b9c6c@jbarnes-g45>
In-Reply-To: <4AC72D09.3040907@tuffmail.co.uk>
References: <4AC72D09.3040907@tuffmail.co.uk>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Oct 2009 11:52:57 +0100
Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:

> ACPI: Waking up from system sleep state S4
> PM: Device PNP0C0D:00 failed to thaw: error 1
> 
> The device appears to be the acpi lid "button".  The error comes from
> calling acpi_lid_send_state():
> 
>     @@ -242,7 +272,12 @@ static int acpi_lid_send_state(struct
>     acpi_device *device)
>          /* input layer checks if event is redundant */
>          input_report_switch(button->input, SW_LID, !state);
>          input_sync(button->input);
>     -    return 0;
>     +
>     +    ret = blocking_notifier_call_chain(&acpi_lid_notifier, state,
>     device);
>     +    if (ret == NOTIFY_DONE)
>     +        ret = blocking_notifier_call_chain(&acpi_lid_notifier,
> state,
>     +                           device);
>     +    return ret;
>      }
> 
> 
> The "error 1" is actually NOTIFY_OK.
> 
>     @include/linux/notify.h:
>     #define NOTIFY_DONE        0x0000        /* Don't care */
>     #define NOTIFY_OK        0x0001        /* Suits me */
>     #define NOTIFY_STOP_MASK    0x8000        /* Don't call further */
>     #define NOTIFY_BAD        (NOTIFY_STOP_MASK|0x0002)
>                             /* Bad/Veto action */
>     /*
>      * Clean way to return from the notifier and stop further calls.
>      */
>     #define NOTIFY_STOP        (NOTIFY_OK|NOTIFY_STOP_MASK)
> 
> 
> Clearly acpi_lid_send_state() should return 0 for NOTIFY_OK.  I guess
> NOTIFY_STOP can be ignored until someone says they need it.
> 
> But I don't understand the NOTIFY_DONE case, so I'm not sure.  I can't
> find any users to reverse engineer it.  IMO it either needs to be
> removed or commented.
> 
> Can you please sort this out, so we don't see this error message on a
> completely successful resume?

Ah yeah, this does look funky.  I'll fix it up.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
