Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbYGRLPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbYGRLPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbYGRLPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:15:30 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:52738 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751776AbYGRLPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:15:30 -0400
Message-ID: <416379761.08031@ustc.edu.cn>
X-WebMAIL-MUA: [211.86.158.24]
From: "JiSheng Zhang" <jszhang3@mail.ustc.edu.cn>
To: stefanr@s5r6.in-berlin.de
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       krh@redhat.com
Date: Fri, 18 Jul 2008 19:16:00 +0800
Reply-To: "JiSheng Zhang" <jszhang3@mail.ustc.edu.cn>
X-Priority: 3
Subject: Re: PATCH] firewire: add padding to some struct
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
If p is a pointer to struct fw_cdev_event_response), p->data will point to the
padding data rather than the right place, it will cause problem under some
platforms. For example, in the function handle_device_event of libraw1394(ported
to juju stack):
.....
case FW_CDEV_EVENT_RESPONSE:
    rc = u64_to_ptr(u->response.closure);
    if (rc->data != NULL)
	memcpy(rc->data, u->response.data, rc->length);//here it will lost the last four
bytes
    errcode = juju_to_raw1394_errcode(u->response.rcode);
.....

Although this problem can be solved by add the offset to the pointer, but the
member:__u32 data[0] lost its original meaning.

Thanks in advance,
JiSheng
>From: Stefan Richter <stefanr@s5r6.in-berlin.de>
>Reply-To: 
>To: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
>Subject: Re: PATCH] firewire: add padding to some struct
>Date:Fri, 18 Jul 2008 12:49:11 +0200
>
>JiSheng Zhang wrote:
> > struct fw_cdev_event_response and struct fw_cdev_event_iso_interrupt need
padding.
> > Otherwise, offset of the zero length array is not equal to the struct size. It
may
> > cause some strange problems under some platforms such as sparc32. This
> > patch(against 2.6.26) should fix it.
> 
> The best solution to this problem would be to use
> 
> 	offsetof(struct fw_cdev_event_XYZ, data)
> 
> instead of sizeof(struct fw_cdev_event_XYZ) in all the places where the
> offset is required.
> 
> Your proposed solution to add padding...
> 
> > --- old/include/linux/firewire-cdev.h	2008-07-18 16:34:01.181794046 +0800
> > +++ new/include/linux/firewire-cdev.h	2008-07-18 16:35:46.649294275 +0800
> > @@ -92,6 +92,7 @@
> >  	__u32 type;
> >  	__u32 rcode;
>


