Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbZDWRbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbZDWRbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 13:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756700AbZDWRbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 13:31:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44514 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567AbZDWRbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 13:31:36 -0400
Message-ID: <49F0A5E7.6080309@redhat.com>
Date: Thu, 23 Apr 2009 13:31:19 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 2/3] crypto: handle ccm dec test vectors expected to	fail
 verification
References: <200904091434.59639.jarod@redhat.com> <200904150835.38818.jarod@redhat.com> <200904150935.15947.jarod@redhat.com> <200904150936.43919.jarod@redhat.com> <20090420062543.GA1135@gondor.apana.org.au>
In-Reply-To: <20090420062543.GA1135@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2009 02:25 AM, Herbert Xu wrote:
> On Wed, Apr 15, 2009 at 09:36:43AM -0400, Jarod Wilson wrote:
>> Add infrastructure to tcrypt to support handling ccm decryption test
>> vectors that are expected to fail verification.
>>
>> Signed-off-by: Jarod Wilson<jarod@redhat.com>
>>
>> ---
>>   crypto/testmgr.c |   32 ++++++++++++++++++++++++++++++++
>>   crypto/testmgr.h |    1 +
>>   2 files changed, 33 insertions(+), 0 deletions(-)
>>
>> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
>> index a8bdcb3..92f4df0 100644
>> --- a/crypto/testmgr.c
>> +++ b/crypto/testmgr.c
>> @@ -373,6 +373,16 @@ static int test_aead(struct crypto_aead *tfm, int enc,
>>
>>   			switch (ret) {
>>   			case 0:
>> +				if (template[i].novrfy) {
>> +					/* verification was supposed to fail */
>> +					printk(KERN_ERR "alg: aead: %s failed "
>> +					       "on test %d for %s: ret was 0, "
>> +					       "expected -EBADMSG\n",
>> +					       e, j, algo);
>> +					/* so really, we got a bad message */
>> +					ret = -EBADMSG;
>> +					goto out;
>> +				}
>>   				break;
>>   			case -EINPROGRESS:
>>   			case -EBUSY:
>> @@ -382,6 +392,10 @@ static int test_aead(struct crypto_aead *tfm, int enc,
>>   					INIT_COMPLETION(result.completion);
>>   					break;
>>   				}
>> +			case -EBADMSG:
>> +				if (template[i].novrfy)
>> +					/* verification failure was expected */
>> +					goto next_aead_vector;
>>   				/* fall through */
>
> How about just doing continue instead of having this goto?

Gah. Yeah, that makes sense. Relic of having some additional debug goo 
in there, where I wanted feedback from every loop of the test...

-- 
Jarod Wilson
jarod@redhat.com

