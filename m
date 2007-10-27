Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbXJ0MAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbXJ0MAd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 08:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbXJ0MAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 08:00:25 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:50375 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbXJ0MAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 08:00:24 -0400
Date: Sat, 27 Oct 2007 14:00:17 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Roopesh <roopesh@cyberspace.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: MMC: CRC Errors with 2GB cards
Message-ID: <20071027140017.41e9d67f@poseidon.drzeus.cx>
In-Reply-To: <20071019161700.GA19254@grex.cyberspace.org>
References: <20071019161700.GA19254@grex.cyberspace.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roopesh,

I'm terribly sorry I haven't replied sooner. I put your message on my todo list, figuring I could get to it within a day or two, but as you noticed, that didn't quite happen. :/

On Fri, 19 Oct 2007 12:17:00 -0400
Roopesh <roopesh@cyberspace.org> wrote:

>  Hi, 
> 
>  I am seeing a lot of CRC errors happening with CMD25 on a couple 
>  of Transcend 2GB cards (specifiation version 1.1).  However, if 
>  I apply the following patch, I see no errors being reported
> 

Ok, so the card is mishandling the state bits a bit. We should be able to work around that.

> @@ -310,8 +311,8 @@
>  					       req->rq_disk->disk_name, err);
>  					goto cmd_err;
>  				}
> -			} while (!(cmd.resp[0] & R1_READY_FOR_DATA));
> -
> +			} while (!(R1_CURRENT_STATE(cmd.resp[0]) == 4)); 
> +			
>  #if 0

This might trade us one problem for another. Could you try the following:

} while (!(cmd.resp[0] & R1_READY_FOR_DATA) || (R1_CURRENT_STATE(cmd.resp[0]) == 7));

This should also work for cards that mishandle the state field, and if the card jumps to
some odd state for some reason.

> 
>  I am just wondering if I have set of broken cards.  Any pointers 
>  in this regard?
> 

You do. But don't be too alarmed, that is unfortunately the norm. :/

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
