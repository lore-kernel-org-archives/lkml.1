Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbZDQVX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbZDQVX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbZDQVXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:23:47 -0400
Received: from rtr.ca ([76.10.145.34]:60166 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbZDQVXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:23:46 -0400
Message-ID: <49E8F35E.2060103@rtr.ca>
Date: Fri, 17 Apr 2009 17:23:42 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/5] Block: Discard may need to allocate pages
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com>
In-Reply-To: <1238683047-13588-1-git-send-email-willy@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> From: Matthew Wilcox <matthew@wil.cx>
> 
> SCSI and ATA both need to send data to the device.  In order to do this,
> the BIO must be allocated with room for a page to be added, and the bio
> needs to be passed to the discard prep function.  We also need to free
> the page attached to the BIO before we free it.
> 
> init_request_from_bio() is not currently called from a context which
> forbids sleeping, and to make sure it stays that way (so we don't have
> to use GFP_ATOMIC), add a might_sleep() to it.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
...
> @@ -1118,7 +1120,7 @@ void init_request_from_bio(struct request *req, struct bio *bio)
>  		req->cmd_flags |= REQ_DISCARD;
>  		if (bio_barrier(bio))
>  			req->cmd_flags |= REQ_SOFTBARRIER;
> -		req->q->prepare_discard_fn(req->q, req);
> +		req->q->prepare_discard_fn(req->q, req, bio);
>  	} else if (unlikely(bio_barrier(bio)))
>  		req->cmd_flags |= (REQ_HARDBARRIER | REQ_NOMERGE);
>  
..

Matthew, note that prepare_discardfn() may fail,
and return an error result.  The above code does not
check for this or handle it very well.

Cheers
