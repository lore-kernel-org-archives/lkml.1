Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbZKJWEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbZKJWEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757284AbZKJWEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:04:20 -0500
Received: from mail.gmx.net ([213.165.64.20]:33476 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756938AbZKJWET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:04:19 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1/8UZEFspP8taUMdMT+TyzsZuEtSdmlP1qUfagwkU
	Vub2XFEW6Fwo8C
Message-ID: <4AF9E366.50901@gmx.de>
Date: Tue, 10 Nov 2009 23:04:22 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] Implement prctl(PR_GET_ENDIAN) for all architectures
References: <20091022193533.GA5827@p100.box> <20091109124618.2aa98630.akpm@linux-foundation.org>
In-Reply-To: <20091109124618.2aa98630.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2009 09:46 PM, Andrew Morton wrote:
> On Thu, 22 Oct 2009 21:35:33 +0200
> Helge Deller<deller@gmx.de>  wrote:
>
>> The PR_GET_ENDIAN and PR_SET_ENDIAN prctl() calls have been implemented
>> to allow to switch processes at runtime from big-endian to little-endian
>> mode (and vice versa) on PowerPC processors. Since the other architectures
>> don't support this feature, they currently will just fail and return -EINVAL.
>>
>> This patch adds just minimal overhead and implements the PR_GET_ENDIAN
>> call for all other architectures by returning the native endianess of
>> the architecture. Furthermore, calling prctl(PR_SET_ENDIAN) with the
>> native endianess of the architecture will succeed, while trying to
>> set another (not-supported) endianess, will fail.
>>
>> The patch can be tested with the following program:
>>
>> #include<stdio.h>
>> #include<linux/prctl.h>
>>
>> int main(int argc, char **argv)
>> {
>> 	int endian, ret;
>>
>> 	ret = prctl(PR_GET_ENDIAN,&endian);
>> 	if (ret)
>> 		perror("prctl(PR_GET_ENDIAN) not implemented");
>> 	printf("current process/machine is running in %s endian mode (%d)\n",
>> 		endian == PR_ENDIAN_LITTLE ? "little":"big", endian);
>>
>> 	/* setting native endianess should succeed */
>> 	ret = prctl(PR_SET_ENDIAN, endian);
>> 	printf("prctl(PR_SET_ENDIAN,%d) should succeed: %s\n",
>> 		endian, ret == 0 ? "OK":"FAIL");
>>
>> 	/* setting foreign endianess should fail */
>> 	endian = (endian == PR_ENDIAN_LITTLE) ?
>> 		PR_ENDIAN_BIG : PR_ENDIAN_LITTLE;
>> 	ret = prctl(PR_SET_ENDIAN, endian);
>> 	printf("prctl(PR_SET_ENDIAN,%d) should fail: %s\n",
>> 		endian, ret == 0 ? "OK":"FAIL");
>> }
>>
>
> The changelog forgot to provide any reason for making this change to
> the kernel.

The reason - and the patch - is pretty trivial.
The kernel provides an interface (for all architectures) which is  currently
only useable on one single architecture (ppc).
So, either we could just remove the interface alltogether for all architectures
beside ppc, or implement the functionality for all architectures so that they
return at least some kind of useful values back to userspace.
I hope this qualifies for kernel inclusion?

Helge
