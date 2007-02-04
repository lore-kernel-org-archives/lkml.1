Return-Path: <linux-kernel-owner+w=401wt.eu-S1752091AbXBDGA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbXBDGA6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 01:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbXBDGA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 01:00:58 -0500
Received: from mailgw.cvut.cz ([147.32.3.235]:50873 "EHLO mailgw.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbXBDGA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 01:00:57 -0500
Message-ID: <45C57695.7000707@vc.cvut.cz>
Date: Sat, 03 Feb 2007 22:00:53 -0800
From: Petr Vandrovec <vandrove@vc.cvut.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20061219 Iceape/1.0.7 (Debian-1.0.7-3)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: NCPFS and brittle connections
References: <459D1794.2060009@drzeus.cx> <459D38DA.4030803@vc.cvut.cz> <459D55E3.4000905@drzeus.cx> <459E01B2.50309@vc.cvut.cz> <45B77AE4.2010605@drzeus.cx> <45B79C35.2090302@vc.cvut.cz> <45B7D750.1040501@drzeus.cx> <45B868D5.9070409@vc.cvut.cz> <45B8845E.8070008@drzeus.cx>
In-Reply-To: <45B8845E.8070008@drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> Ok... how about this baby instead. I've replaced the stack allocated
> request structure by one allocated with kmalloc() and reference counted
> using an atomic_t. I couldn't see anything else that was associated to
> the process, so I believe this should suffice.
> 
> (This is just a RFC. Once I get an ok from you I'll put together a more
> proper patch mail)
> 
> -       req.tx_type = *(u_int16_t*)server->packet;
> -
> -       result = ncp_add_request(server, &req);
> +       struct ncp_request_reply *req;
> +
> +       req = ncp_alloc_req();
> +       if (!req)
> +               return -ENOMEM;
> +
> +       req->reply_buf = reply_buf;
> +       req->datalen = max_reply_size;
> +       req->tx_iov[1].iov_base = server->packet;
> +       req->tx_iov[1].iov_len = size;
> +       req->tx_iovlen = 1;
> +       req->tx_totallen = size;
> +       req->tx_type = *(u_int16_t*)server->packet;

Problem is with these pointers - reply_buf & server->packet.  Now code 
will just read packet from server->packet, and write result to 
reply_buf, most probably transmiting some random data to network, and 
overwriting innocent memory on receiption...  I believe that you need to 
make copies of server->packet/size for transmission, and some simillar 
solution for receive as well.  As both request & response can be up to 
~66000 bytes.
							Petr

