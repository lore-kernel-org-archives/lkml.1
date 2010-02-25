Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933Ab0BYRHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:07:17 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:40840 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932865Ab0BYRHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:07:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Ow59iVR+dBtX9hEd7xV4gFeWhCnRDPkd8fgOv1jXGc/8HUgUwbioHLvK0ryoUYegm0
         NFLozn+n09KG9qGbLYpsSefQthFwnMlXfvCuwYOqaG6O4pojYyuoF4vQLSiGdgEn42S2
         zjKG4+xfOgEu2eLmPweg2mVhzOErAR4tdTuq8=
MIME-Version: 1.0
In-Reply-To: <25e057c01002250833n1e13391drfcc806df369c5a55@mail.gmail.com>
References: <4B8692E3.9030509@gmail.com> <19334.40337.651079.440912@pilspetsen.it.uu.se> 
	<84144f021002250816o2c2cef0fke484c7e43256dba4@mail.gmail.com> 
	<25e057c01002250833n1e13391drfcc806df369c5a55@mail.gmail.com>
From: roel kluin <roel.kluin@gmail.com>
Date: Thu, 25 Feb 2010 18:06:51 +0100
Message-ID: <25e057c01002250906x6267a3b6xe661abfa12f913cb@mail.gmail.com>
Subject: Re: [PATCH] sha: prevent removal of memset as dead store in 
	sha1_update()
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 5:33 PM, roel kluin <roel.kluin@gmail.com> wrote:
> On Thu, Feb 25, 2010 at 5:16 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>> On Thu, Feb 25, 2010 at 5:56 PM, Mikael Pettersson <mikpe@it.uu.se> wrote:
>>> I fear that the only portable (across compiler versions) and safe
>>> solution is to invoke an assembly-coded dummy function with prototype
>>>
>>>        void use(void *p);
>>>
>>> and rewrite the code above as
>>>
>>>        {
>>>                u32 temp[...];
>>>                ...
>>>                memset(temp, 0, sizeof temp);
>>>                use(temp);
>>>        }
>>>
>>> This forces the compiler to consider the buffer live after the
>>> memset, so the memset cannot be eliminated.
>>
>> So is there some "do not optimize" GCC magic that we could use for a
>> memzero_secret() helper function?
>>
>>                        Pekka
>>
>
>        *(volatile char *)p = *(volatile char *)p;
>
> appears to work when called after the memset:

Or similar to suggested here:

https://www.securecoding.cert.org/confluence/display/cplusplus/MSC06-CPP.+Be+aware+of+compiler+optimization+when+dealing+with+sensitive+data

This memzero_secret() appears to work:

void *memzero_secret(void *v, size_t n) {
        volatile unsigned char *p = v;
        while (n--)
                *p++ = 0;

        return v;
}
---
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void *memzero_secret(void *v, size_t n) {
	volatile unsigned char *p = v;
	while (n--)
		*p++ = 0;

	return v;
}

void foo()
{
	char password[] = "secret";
	password[0]='S';
	printf ("Don't show again: %s\n", password);
	memzero_secret(password, sizeof(password));
	//memset(password, 0, sizeof(password));
}

int main(int argc, char* argv[])
{
	foo();
	int i;
	char foo3[] = "";
	char* bar = &foo3[0];
	for (i = -50; i < 50; i++)
		printf ("%c.", bar[i]);
	printf("\n");
	return 0;
}
