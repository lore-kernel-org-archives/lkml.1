Return-Path: <linux-kernel-owner+w=401wt.eu-S1757673AbYGTOBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbYGTOBK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 10:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757030AbYGTOA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 10:00:56 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58959 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923AbYGTOA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 10:00:56 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48834500.2050507@s5r6.in-berlin.de>
Date: Sun, 20 Jul 2008 16:00:32 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.15) Gecko/20080719 SeaMonkey/1.1.10
MIME-Version: 1.0
To: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mikael Pettersson <mikpe@it.uu.se>,
       =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>
Subject: Re: [PATCH] firewire:queue the right number of data
References: <416453059.30160@ustc.edu.cn>
In-Reply-To: <416453059.30160@ustc.edu.cn>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

JiSheng Zhang wrote at LKML:
> Hi,
> 
> There will be 4 padding bytes in struct fw_cdev_event_response on some platforms
> The member:__u32 data will point to these padding bytes. While queue the
> response and data in complete_transaction in fw-cdev.c, it will queue like this:
> |response(excluding padding bytes)|4 padding bytes|4 padding bytes|data. 
> It queue 4 extra bytes. That is to say it use "&response + sizeof(response)"
> while other place of kernel and userspace library use "&response + offsetof
> (typeof(response), data)". So it will lost the last 4 bytes of data.This patch 
> can fix it while not changing the struct definition.
> 
> Sorry for open a new ticket.
> 
> Signed-off-by: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
> 
> --- old/drivers/firewire/fw-cdev.c
> +++ new/drivers/firewire/fw-cdev.c
> @@ -382,9 +382,9 @@
>  
>  	response->response.type   = FW_CDEV_EVENT_RESPONSE;
>  	response->response.rcode  = rcode;
> -	queue_event(client, &response->event,
> -		    &response->response, sizeof(response->response),
> -		    response->response.data, response->response.length);
> +	queue_event(client, &response->event, &response->response, 
> +		    sizeof(response->response) + response->response.length,
> +		    NULL, 0);
>  }
>  
>  static int ioctl_send_request(struct client *client, void *buffer)

I tested it now on i686, x86-64, and x86-64 with i686 userland, using 
firecontrol and gscanbus.  As discussed, they got corrupted block read 
responses on x86-64 and on x86-64 with i686 userland.  The patch fixes this.

I committed it to linux1394-2.6.git#fixes and intend to send it upstream 
at the end of the week or so.  Thanks for spotting this bug.

One point about which I am not sure about yet is what happens if there 
are multiple events queued up before the client can read() them.  The 
tests which I did so far involved only a single event queued and 
dequeued at a time.


PS:
I removed a rule from linux1394-devel's header filters which matched 
your previous posts.  (Message has priority, but no X-Mailer/User-Agent)
-- 
Stefan Richter
-=====-==--- -=== =-=--
http://arcgraph.de/sr/
