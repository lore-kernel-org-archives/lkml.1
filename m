Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299Ab0BYPT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:19:27 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:64581 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759037Ab0BYPTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:19:25 -0500
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Feb 2010 10:19:25 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=q+ACQvCd7aEwz6YncKRX6k9azzLHSQneaGKrmcnK9Ds0kzNO5NEdjtPv0rN8nkRoSP
         Jqe725coTTymWyTCLqaCuwajLTHm6nyXEiuFcBhnLzMJCVc3OS5gIoubHStCkUn98EAW
         HsZMi6YJKtO6PkZ+gAQ3Dbg2mI9Y0nhv2kXGs=
Message-ID: <4B8693B9.3060102@gmail.com>
Date: Thu, 25 Feb 2010 16:14:01 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: lkml <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Subject: Re: Is kernel optimized with dead store removal?
References: <4B85A49E.6000803@gmail.com> <19334.22971.970220.245930@pilspetsen.it.uu.se>
In-Reply-To: <19334.22971.970220.245930@pilspetsen.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  >  Does this optimization also occur during compilation of the Linux
>  >  kernel?

> Any such dead store removal is up to the compiler and the lifetime
> of the object being clobbered. For 'auto' objects the optimization
> is certainly likely.
> 
> This is only a problem if the memory (a thread stack, say) is recycled
> and leaked uninitialized to user-space, but such bugs are squashed
> fairly quickly upon discovery.

Thanks for comments,

In the sha1_update() case I don't know whether the stack is recycled and
leaked - it may be dependent on the calling function, but isn't it
vulnerable?

I tested this with the snippet below. If compiled with -O1 or -O2 and
ON_STACK defined 1, I can read "Secret" a second time. With ON_STACK
defined 0 I do not.

Roel

---
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define ON_STACK 1

void foo()
{
        char password[] = "secret";
        password[0]='S';
        printf ("Don't show again: %s\n", password);
        memset(password, 0, sizeof(password));
}

void foo2()
{
        char* password = malloc(7);
        strncpy (password, "secret" , 7);
        password[6] = '\0';
        password[0] = 'S';
        printf ("Don't show again: %s\n", password);
        memset(password, 0, 7);
        free(password);

}

int main(int argc, char* argv[])
{

#if ON_STACK == 1
        foo();
#else
        foo2();
#endif
        int i;
        char foo3[] = "hoi";
        printf ("foo1:%s\n", foo3);
        char* bar = &foo3[0];
        for (i = -50; i < 50; i++)
                printf ("%c.", bar[i]);
        printf("\n");
        return 0;
}
