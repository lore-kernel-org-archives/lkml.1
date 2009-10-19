Return-Path: <linux-kernel-owner+w=401wt.eu-S932103AbZJSOFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbZJSOFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbZJSOFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:05:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbZJSOFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:05:02 -0400
Message-ID: <4ADC71C4.3020805@redhat.com>
Date: Mon, 19 Oct 2009 10:03:48 -0400
From: Jarod Wilson <jarod@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10.5; en-US; rv:1.9.1.4pre) Gecko/20090915 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Felipe Contreras <felipe.contreras@gmail.com>,
       linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 3/7] crypto: testmgr: fix warning
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com> <1255906474-25091-4-git-send-email-felipe.contreras@gmail.com> <alpine.LSU.2.00.0910191551030.8582@wotan.suse.de> <4ADC707E.2040802@redhat.com>
In-Reply-To: <4ADC707E.2040802@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/09 9:58 AM, Jarod Wilson wrote:
> On 10/19/09 9:52 AM, Jiri Kosina wrote:
>> On Mon, 19 Oct 2009, Felipe Contreras wrote:
>>
>>> crypto/testmgr.c: In function ?test_cprng?:
>>> crypto/testmgr.c:1204: warning: ?err? may be used uninitialized in
>>> this function
>>>
>>> Signed-off-by: Felipe Contreras<felipe.contreras@gmail.com>
>>> ---
>>> crypto/testmgr.c | 2 +-
>>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
>>> index 6d5b746..1f2357b 100644
>>> --- a/crypto/testmgr.c
>>> +++ b/crypto/testmgr.c
>>> @@ -1201,7 +1201,7 @@ static int test_cprng(struct crypto_rng *tfm,
>>> struct cprng_testvec *template,
>>> unsigned int tcount)
>>> {
>>> const char *algo = crypto_tfm_alg_driver_name(crypto_rng_tfm(tfm));
>>> - int err, i, j, seedsize;
>>> + int err = 0, i, j, seedsize;
>>> u8 *seed;
>>> char result[32];
>>
>> As it is not obvious to me immediately why/whether tcount couldn't be
>> zero
>> (which would cause uninitialized use of 'err'), I am not merging this
>> through trivial tree. Herbert?
>
> I believe I'm the guilty party who wrote the code in question.
> Initializing err to 0 isn't correct. tcount should always be at least 1,
> if its 0, test_cprng has been called with invalid parameters. I believe
> err would best be initialized to -EINVAL, lest the caller think they
> were successful.

...and I need to re-read said code more carefully. tcount is 
desc->suite.cprng.count, which is ANSI_CPRNG_AES_TEST_VECTORS, which is 
#define'd to 6, and is the count of how many cprng test vectors there 
are. If someone changes that to 0, then I guess a retval of 0 would 
actually be correct, since no tests failed...

So yeah, I rescind my claim that initializing err to 0 is incorrect, I 
think that's just fine.

-- 
Jarod Wilson
jarod@redhat.com
