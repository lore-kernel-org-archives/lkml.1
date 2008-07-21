Return-Path: <linux-kernel-owner+w=401wt.eu-S1760541AbYGUGuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760541AbYGUGuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 02:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbYGUGuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 02:50:06 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:50193 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750825AbYGUGuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 02:50:05 -0400
Message-ID: <416623038.24922@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: jszhang3@mail.ustc.edu.cn
Date: Mon, 21 Jul 2008 14:48:42 +0800
From: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mikael Pettersson <mikpe@it.uu.se>,
       Kristian =?UTF-8?B?SMO4Z3NiZXJn?= <krh@bitplanet.net>
Subject: Re: [PATCH] firewire:queue the right number of data
Message-ID: <20080721144842.0b64f821@debian>
In-Reply-To: <416562490.30709@ustc.edu.cn>
References: <416453059.30160@ustc.edu.cn>
	<416562490.30709@ustc.edu.cn>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on Sun, 20 Jul 2008 16:00:32 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> JiSheng Zhang wrote at LKML:
> > Hi,
> > 
> > There will be 4 padding bytes in struct fw_cdev_event_response on some platforms
> > The member:__u32 data will point to these padding bytes. While queue the
> > response and data in complete_transaction in fw-cdev.c, it will queue like this:
> > |response(excluding padding bytes)|4 padding bytes|4 padding bytes|data. 
> > It queue 4 extra bytes. That is to say it use "&response + sizeof(response)"
> > while other place of kernel and userspace library use "&response + offsetof
> > (typeof(response), data)". So it will lost the last 4 bytes of data.This patch 
> > can fix it while not changing the struct definition.
> > 
> > Sorry for open a new ticket.
> > 
> > Signed-off-by: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
> > 
> > --- old/drivers/firewire/fw-cdev.c
> > +++ new/drivers/firewire/fw-cdev.c
> > @@ -382,9 +382,9 @@
> >  
> >  	response->response.type   = FW_CDEV_EVENT_RESPONSE;
> >  	response->response.rcode  = rcode;
> > -	queue_event(client, &response->event,
> > -		    &response->response, sizeof(response->response),
> > -		    response->response.data, response->response.length);
> > +	queue_event(client, &response->event, &response->response, 
> > +		    sizeof(response->response) + response->response.length,
> > +		    NULL, 0);
> >  }
> >  
> >  static int ioctl_send_request(struct client *client, void *buffer)
> 
> I tested it now on i686, x86-64, and x86-64 with i686 userland, using 
> firecontrol and gscanbus.  As discussed, they got corrupted block read 
> responses on x86-64 and on x86-64 with i686 userland.  The patch fixes this.
> 
> I committed it to linux1394-2.6.git#fixes and intend to send it upstream 
> at the end of the week or so.  Thanks for spotting this bug.
Thanks for committing.
> 
> One point about which I am not sure about yet is what happens if there 
> are multiple events queued up before the client can read() them.  The 
> tests which I did so far involved only a single event queued and 
> dequeued at a time.
IMHO, even there are multiple events queued, it should work OK because 
events are put into event_list rather than a ring buffer, there is no
padding bytes problem between events.
> 
> 
> PS:
> I removed a rule from linux1394-devel's header filters which matched 
> your previous posts.  (Message has priority, but no X-Mailer/User-Agent)
Thanks very much

Regards,
JiSheng
