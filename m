Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbYGRMHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbYGRMHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbYGRMHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:07:22 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:60861 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753029AbYGRMHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:07:21 -0400
Message-ID: <416382875.30185@ustc.edu.cn>
X-WebMAIL-MUA: [211.86.158.24]
From: "JiSheng Zhang" <jszhang3@mail.ustc.edu.cn>
To: stefanr@s5r6.in-berlin.de
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       krh@redhat.com
Date: Fri, 18 Jul 2008 20:07:55 +0800
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
> There would be a problem if one of the two used "&response +
> sizeof(response)" instead.  Does this happen anywhere?  If so, then
> these places need to be fixed, not the struct definition.
yes, complete_transaction in fw-cdev.c, it queues the response and data.

how about adding __attribute__((packed)) to the two struct definition? It will not
break abi compatibility.

Thanks in advance,
JiSheng


--- old/include/linux/firewire-cdev.h	2008-07-18 16:34:01.181794046 +0800
+++ new/include/linux/firewire-cdev.h	2008-07-18 19:39:16.389293987 +0800
@@ -93,7 +93,7 @@ struct fw_cdev_event_response {
 	__u32 rcode;
 	__u32 length;
 	__u32 data[0];
-};
+} __attribute__((packed));
 
 /**
  * struct fw_cdev_event_request - Sent on incoming request to an address region
@@ -144,7 +144,7 @@ struct fw_cdev_event_iso_interrupt {
 	__u32 cycle;
 	__u32 header_length;
 	__u32 header[0];
-};
+} __attribute__((packed));
 
 /**
  * union fw_cdev_event - Convenience union of fw_cdev_event_ types


