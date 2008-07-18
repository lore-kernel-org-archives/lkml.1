Return-Path: <linux-kernel-owner+w=401wt.eu-S1757657AbYGRP2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657AbYGRP2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 11:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbYGRP2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 11:28:25 -0400
Received: from aun.it.uu.se ([130.238.12.36]:51716 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201AbYGRP2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 11:28:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18560.46704.488430.738634@harpo.it.uu.se>
Date: Fri, 18 Jul 2008 17:27:44 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "JiSheng Zhang" <jszhang3@mail.ustc.edu.cn>
Cc: stefanr@s5r6.in-berlin.de, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, krh@redhat.com
Subject: Re: PATCH] firewire: add padding to some struct
In-Reply-To: <416384276.24780@ustc.edu.cn>
References: <416384276.24780@ustc.edu.cn>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

JiSheng Zhang writes:
 > Hi,
 > >From: Stefan Richter <stefanr@s5r6.in-berlin.de>
 > >Reply-To: 
 > >To: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
 > >Subject: Re: PATCH] firewire: add padding to some struct
 > >Date:Fri, 18 Jul 2008 13:38:25 +0200
 > >
 > >JiSheng Zhang wrote:
 > > > If p is a pointer to struct fw_cdev_event_response), p->data will point to
 > the
 > > > padding data rather than the right place, it will cause problem under some

Define "the right place". If p->data[] isn't the place for the data,
then something's seriously wrong with either the producer or the
consumer of that data -- or the data type definition if either is HW.

 > > > platforms. For example, in the function handle_device_event of
 > libraw1394(ported
 > > > to juju stack):
 > > > .....
 > > > case FW_CDEV_EVENT_RESPONSE:
 > > >     rc = u64_to_ptr(u->response.closure);
 > > >     if (rc->data != NULL)
 > > > 	memcpy(rc->data, u->response.data, rc->length);//here it will lost the last
 > four
 > > > bytes
 > > >     errcode = juju_to_raw1394_errcode(u->response.rcode);
 > > > .....
 > > > 
 > > > Although this problem can be solved by add the offset to the pointer, but the
 > > > member:__u32 data[0] lost its original meaning.
 > > 
 > > I don't understand what the problem is.  As long as both kernel and
 > > library use "response.data" or "&response + offsetof(typeof(response),
 > > data)", they will write and read at the correct location.
 > >
 > This patch can fix the problem while not changing the struct definition.
 > 
 > 
 > Thanks in advance,
 > JiSheng
 > 
 > --- old/drivers/firewire/fw-cdev.c	2008-07-14 05:51:29.000000000 +0800
 > +++ new/drivers/firewire/fw-cdev.c	2008-07-18 20:20:45.841328585 +0800
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

Neither of these look correct.
If sizeof(struct ...) != offsetof(struct ..., data) as you claim is possible,
then the old code will copy too much to/from ->response but the correct amount
to/from ->response.data, and the new code will copy too much to/from ->response.data.

That's why C has offsetof():

	queue_event(client, &response->event,
		   &response->response,
		   offsetof(typeof(*response->responce), data), // I don't know the struct name
		   response->response.data, response->response.length);
