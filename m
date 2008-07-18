Return-Path: <linux-kernel-owner+w=401wt.eu-S1760063AbYGRMbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063AbYGRMbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759671AbYGRMap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:30:45 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34037 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759610AbYGRMap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:30:45 -0400
Message-ID: <416384276.24780@ustc.edu.cn>
X-WebMAIL-MUA: [211.86.158.24]
From: "JiSheng Zhang" <jszhang3@mail.ustc.edu.cn>
To: stefanr@s5r6.in-berlin.de
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       krh@redhat.com
Date: Fri, 18 Jul 2008 20:31:16 +0800
Reply-To: "JiSheng Zhang" <jszhang3@mail.ustc.edu.cn>
X-Priority: 3
Subject: Re: PATCH] firewire: add padding to some struct
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
>From: Stefan Richter <stefanr@s5r6.in-berlin.de>
>Reply-To: 
>To: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
>Subject: Re: PATCH] firewire: add padding to some struct
>Date:Fri, 18 Jul 2008 13:38:25 +0200
>
>JiSheng Zhang wrote:
> > If p is a pointer to struct fw_cdev_event_response), p->data will point to
the
> > padding data rather than the right place, it will cause problem under some
> > platforms. For example, in the function handle_device_event of
libraw1394(ported
> > to juju stack):
> > .....
> > case FW_CDEV_EVENT_RESPONSE:
> >     rc = u64_to_ptr(u->response.closure);
> >     if (rc->data != NULL)
> > 	memcpy(rc->data, u->response.data, rc->length);//here it will lost the last
four
> > bytes
> >     errcode = juju_to_raw1394_errcode(u->response.rcode);
> > .....
> > 
> > Although this problem can be solved by add the offset to the pointer, but the
> > member:__u32 data[0] lost its original meaning.
> 
> I don't understand what the problem is.  As long as both kernel and
> library use "response.data" or "&response + offsetof(typeof(response),
> data)", they will write and read at the correct location.
>
This patch can fix the problem while not changing the struct definition.


Thanks in advance,
JiSheng

--- old/drivers/firewire/fw-cdev.c	2008-07-14 05:51:29.000000000 +0800
+++ new/drivers/firewire/fw-cdev.c	2008-07-18 20:20:45.841328585 +0800
@@ -382,9 +382,9 @@
 
 	response->response.type   = FW_CDEV_EVENT_RESPONSE;
 	response->response.rcode  = rcode;
-	queue_event(client, &response->event,
-		    &response->response, sizeof(response->response),
-		    response->response.data, response->response.length);
+	queue_event(client, &response->event, &response->response, 
+		    sizeof(response->response) + response->response.length,
+		    NULL, 0);
 }
 
 static int ioctl_send_request(struct client *client, void *buffer)


