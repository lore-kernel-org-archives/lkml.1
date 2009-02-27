Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbZB0M26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbZB0M26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 07:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbZB0M2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 07:28:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58192 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbZB0M2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 07:28:48 -0500
Message-ID: <49A7DC7E.1040307@redhat.com>
Date: Fri, 27 Feb 2009 13:28:46 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: [BUGFIX] dm-crypt: Fix a bug of async cryption complete function
References: <1235724971.6204.106.camel@yhuang-dev.sh.intel.com> <20090227114103.GB24024@gondor.apana.org.au> <49A7D3E5.5040706@redhat.com> <20090227115638.GA24221@gondor.apana.org.au>
In-Reply-To: <20090227115638.GA24221@gondor.apana.org.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Fri, Feb 27, 2009 at 12:52:05PM +0100, Milan Broz wrote:
>> Herbert Xu wrote:
>>> On Fri, Feb 27, 2009 at 04:56:11PM +0800, Huang Ying wrote:
>>>> @@ -830,7 +838,7 @@ static void kcryptd_async_done(struct cr
>>>>  		return;
>>>>  	}
>>>>  
>>>> -	mempool_free(ablkcipher_request_cast(async_req), cc->req_pool);
>>>> +	mempool_free(dmreq->req, cc->req_pool);
>>> Why do we need all this complexity? Can't just fix it by using
>>> cc->req?
>> No. There can be parallel req allocated, also cc->req can be NULL.
>> (seems that these structs are overcomplicated already:-)
> 
> Fair enough.  However we still shouldn't need to have dmreq->req
> since
> 
> 	dmreq->req == (char *)dmreq - sizeof(dmreq->req)
> 
> In fact just pass the request itself as data and derive dmreq
> from that.

Like this?

struct ablkcipher_request *req = (char *)dmreq - cc->dmreq_start;
mempool_free(req, cc->req_pool);

Yes, this should be enough. Just some nice inline function will be
better for such  pointer game...

So we need add just dmreq->ctx field now.

Milan
--
mbroz@redhat.com


