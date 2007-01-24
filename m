Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbXAXRty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbXAXRty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 12:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbXAXRtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 12:49:53 -0500
Received: from mailgw.cvut.cz ([147.32.3.235]:52502 "EHLO mailgw.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbXAXRtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 12:49:52 -0500
Message-ID: <45B79C35.2090302@vc.cvut.cz>
Date: Wed, 24 Jan 2007 09:49:41 -0800
From: Petr Vandrovec <vandrove@vc.cvut.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20061219 Iceape/1.0.7 (Debian-1.0.7-2)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: NCPFS and brittle connections
References: <459D1794.2060009@drzeus.cx> <459D38DA.4030803@vc.cvut.cz> <459D55E3.4000905@drzeus.cx> <459E01B2.50309@vc.cvut.cz> <45B77AE4.2010605@drzeus.cx>
In-Reply-To: <45B77AE4.2010605@drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> Sorry this took some time, I've been busy with other things.
> 
> Petr Vandrovec wrote:
>> Unfortunately NCP does not run on top of TCP stream, but on top of
>> IPX/UDP, and so dropping reply is not sufficient - you must continue
>> resending request (so you must buffer it somewhere...) until you get
>> result from server - after you receive answer from server, you can
>> finally throw away both request & reply, and move on.
>>
> 
> I don't quite understand why you need to resend. I did the following and
> it seems to work fine with UDP:

Hello,
   create test scenario where first transmit of NCP request is lost by 
network, and before resend you kill this process.  So it stops 
resending, but local sequence count is already incremented.  Then when 
next process tries to access ncpfs, server will ignore its requests as 
it expects packet with sequence X, while packet with sequence X+1 arrived.

And unfortunately it is not possible to simple not increment sequence 
number unless you get reply - when server receives two packets with same 
sequence number, it simple resends answer it gave to first request, 
without looking at request's body at all.  So in this case server would 
answer, but would gave you bogus answer.

So only solution (as far as I can tell) is to keep retrying request 
until you get answer - only in this case you can be sure that client and 
server state machines are in same state - your solution will work if 
packet is never lost.  But as we talk about UDP and real networks, this 
assumption is not safe.
								Petr

> 
> diff --git a/fs/ncpfs/sock.c b/fs/ncpfs/sock.c
> index e496d8b..5159bae 100644
> --- a/fs/ncpfs/sock.c
> +++ b/fs/ncpfs/sock.c
> @@ -151,6 +153,8 @@ static inline int get_conn_number(struct
> ncp_reply_header *rp)
>         return rp->conn_low | (rp->conn_high << 8);
>  }
>  
> +static void __ncp_next_request(struct ncp_server *server);
> +
>  static inline void __ncp_abort_request(struct ncp_server *server,
> struct ncp_request_reply *req, int err)
>  {
>         /* If req is done, we got signal, but we also received answer... */
> @@ -163,7 +167,10 @@ static inline void __ncp_abort_request(struct
> ncp_server *server, struct ncp_req
>                         ncp_finish_request(req, err);
>                         break;
>                 case RQ_INPROGRESS:
> -                       __abort_ncp_connection(server, req, err);
> +                       printk(KERN_INFO "ncpfs: Killing running
> request!\n");
> +                       ncp_finish_request(req, err);
> +                       __ncp_next_request(server);
> +//                     __abort_ncp_connection(server, req, err);
>                         break;
>         }
>  }
> @@ -754,7 +761,8 @@ static int ncp_do_request(struct ncp_server *server,
> int size,
>         if (result < 0) {
>                 /* There was a problem with I/O, so the connections is
>                  * no longer usable. */
> -               ncp_invalidate_conn(server);
> +               printk(KERN_INFO "ncpfs: Invalidating connection!\n");
> +//             ncp_invalidate_conn(server);
>         }
>         return result;
>  }
> 
> I'm not particularly proud of the second chunk though. Ideas on how to
> handle when we actually get a transmission problem and not just getting
> killed by a signal?
> 
> Rgds
> 


