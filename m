Return-Path: <linux-kernel-owner+w=401wt.eu-S1755106AbYGTGVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbYGTGVz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 02:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbYGTGVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 02:21:47 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:60874 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751295AbYGTGVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 02:21:47 -0400
Message-ID: <416534939.07236@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: jszhang3@mail.ustc.edu.cn
Date: Sun, 20 Jul 2008 14:20:27 +0800
From: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, krh@redhat.com
Subject: Re: PATCH] firewire: add padding to some struct
Message-ID: <20080720142027.772e5d03@debian>
In-Reply-To: <416463624.22263@ustc.edu.cn>
References: <416384276.24780@ustc.edu.cn>
	<416443505.10974@ustc.edu.cn>
	<416453387.04151@ustc.edu.cn>
	<416463624.22263@ustc.edu.cn>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul 2008 12:32:35 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> JiSheng Zhang wrote:
> > On Fri, 18 Jul 2008 17:27:44 +0200
> > Mikael Pettersson <mikpe@it.uu.se> wrote:
> >> JiSheng Zhang writes:
> >>  > --- old/drivers/firewire/fw-cdev.c	2008-07-14 05:51:29.000000000 +0800
> >>  > +++ new/drivers/firewire/fw-cdev.c	2008-07-18 20:20:45.841328585 +0800
> >>  > @@ -382,9 +382,9 @@
> >>  >  
> >>  >  	response->response.type   = FW_CDEV_EVENT_RESPONSE;
> >>  >  	response->response.rcode  = rcode;
> >>  > -	queue_event(client, &response->event,
> >>  > -		    &response->response, sizeof(response->response),
> >>  > -		    response->response.data, response->response.length);
> >>  > +	queue_event(client, &response->event, &response->response, 
> >>  > +		    sizeof(response->response) + response->response.length,
> >>  > +		    NULL, 0);
> >>  >  }
> >>
> >> Neither of these look correct.
> >> If sizeof(struct ...) != offsetof(struct ..., data) as you claim is possible,
> >> then the old code will copy too much to/from ->response but the correct amount
> >> to/from ->response.data, and the new code will copy too much to/from ->response.data.
> > 
> > The old code will copy 4 extra bytes totally on some platforms, the new code
> > is correct. The old one queue like this:
> > struct ...(excluding the padding bytes)|4 padding bytes|4 padding bytes|data
> > 
> >> That's why C has offsetof():
> >>
> >> 	queue_event(client, &response->event,
> >> 		   &response->response,
> >> 		   offsetof(typeof(*response->responce), data), // I don't know the struct name
> >> 		   response->response.data, response->response.length);
> 
> sizeof(struct ...) != offsetof(struct ..., data) happens for example on 
> x86-64.
> 
> This is what I get with the current firewire drivers in a block read 
> response from firecontrol on i686:
> 
> 	Command: r . 0 0xfffff0000400 20
> 	reading from node 0, bus 1023, offset 0XFFFFF0000400 20 bytes
> 	read succeeded. Data follows (hex):
> 	04 04 04 8F
> 	31 33 39 34
> 	F0 00 A2 22
> 	00 10 DC 56
> 	00 FE D2 D4
> 	Ack code: complete
> 
> And the same on x86-64:
> 
> 	Command: r . 0 0xfffff0000400 20
> 	reading from node 0, bus 1023, offset 0XFFFFF0000400 20 bytes
> 	read succeeded. Data follows (hex):
> 	04 04 04 8F
this is the 4 extra padding bytes
> 	04 04 04 8F
> 	31 33 39 34
> 	F0 00 A2 22
> 	00 10 DC 56
here lost the last 4 bytes of data
> 	Ack code: complete
> 
> 	Command: r . 0 0xfffff0000400 24
> 	reading from node 0, bus 1023, offset 0XFFFFF0000400 20 bytes
> 	read succeeded. Data follows (hex):
> 	04 04 04 8F
> 	04 04 04 8F
> 	31 33 39 34
> 	F0 00 A2 22
> 	00 10 DC 56
> 	00 FE D2 D4
> 	Ack code: complete
> 
> I used libraw1394 from Dan's git repo.  Gscanbus shows exactly the same 
> results.  So, x86-64 and all other architectures where struct 
> fw_cdev_event* are aligned on u64 boundaries are currently seriously 
> broken... but nobody noticed it before.  The only breakage which I saw 
the read_topology_map in the testlibraw of libraw1394(with support to juju)
will show similar breakage. 
> (and is obviously the result of this bug) is that gscanbus shows a wrong 
> bus topology on x86-64 but the correct one on i686.  The damage from 
> this bug is limited though because
>    - most applications send requests which get responses with 0 or 4
>      bytes payload,
I think so.
>    - no application (which can run on both old and new stack without
>      change) uses address range mappings, i.e. get incoming requests.
> 
> I'll look further into your proposed fix.
Thanks

Regards,
JiSheng
