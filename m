Return-Path: <linux-kernel-owner+w=401wt.eu-S965604AbXBTDNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965604AbXBTDNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 22:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965627AbXBTDNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 22:13:43 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:33227 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965604AbXBTDNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 22:13:42 -0500
X-Greylist: delayed 1556 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Feb 2007 22:13:42 EST
Message-ID: <45DA6150.7060704@vandrovec.name>
Date: Mon, 19 Feb 2007 18:47:44 -0800
From: Petr Vandrovec <petr@vandrovec.name>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20061219 Iceape/1.0.7 (Debian-1.0.7-3)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: NCPFS and brittle connections
References: <459D1794.2060009@drzeus.cx> <459D38DA.4030803@vc.cvut.cz> <459D55E3.4000905@drzeus.cx> <459E01B2.50309@vc.cvut.cz> <45B77AE4.2010605@drzeus.cx> <45B79C35.2090302@vc.cvut.cz> <45B7D750.1040501@drzeus.cx> <45B868D5.9070409@vc.cvut.cz> <45B8845E.8070008@drzeus.cx> <45C57695.7000707@vc.cvut.cz> <45C61540.7000008@drzeus.cx> <45C6A99C.5030607@vc.cvut.cz> <45D97DF0.9070306@drzeus.cx>
In-Reply-To: <45D97DF0.9070306@drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Feb 2007 02:47:45.0675 (UTC) FILETIME=[7FF39DB0:01C75499]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> Sorry this took so long but I got occupied with other things and this
> had to move down the pile a bit.
> 
> New patch which uses dedicated buffers for the currently active packet.
> Also adds a new state RQ_ABANDONED which basically means "the caller no
> longer cares about this request so the pointers are no longer valid". It
> is used to determine if the global receive buffer should be copied to
> the provided one upon completion.

Hello,
   it would be nice if these two copies (request->txbuf, and 
rxbuf->reply) could be eliminated, but I see no easy way how to do that...

> commit 166fb223f9507431fb97820549e3e41980987445
> Author: Pierre Ossman <ossman@cendio.se>
> Date:   Mon Feb 19 11:34:43 2007 +0100
> 
>     ncpfs: make sure server connection survives a kill
>     
>     Use internal buffers instead of the ones supplied by the caller
>     so that a caller can be interrupted without having to abort the
>     entire ncp connection.
>     
>     Signed-off-by: Pierre Ossman <ossman@cendio.se>

Acked-by: Petr Vandrovec <petr@vandrovec.name>
(modulo one thing below)

> diff --git a/include/linux/ncp_fs_sb.h b/include/linux/ncp_fs_sb.h
> index a503052..d5e7ffc 100644
> --- a/include/linux/ncp_fs_sb.h
> +++ b/include/linux/ncp_fs_sb.h
> @@ -50,6 +50,8 @@ struct ncp_server {
>  	int packet_size;
>  	unsigned char *packet;	/* Here we prepare requests and
>  				   receive replies */
> +	unsigned char *txbuf;	/* Storage for current requres */

Looks like a typo?  requres => request ?

> +	unsigned char *rxbuf;	/* Storage for reply to current request */
>  
>  	int lock;		/* To prevent mismatch in protocols. */
>  	struct mutex mutex;

								Petr
