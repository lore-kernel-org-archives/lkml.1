Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbZKJWUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbZKJWUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757486AbZKJWUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:20:43 -0500
Received: from mail.gmx.net ([213.165.64.20]:52088 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757485AbZKJWUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:20:41 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1/MzAoNtS7MGAUOSnfyGCN32j1VWdWmxS2hN8gyU3
	TCV5NZ8ZPLbBhE
Message-ID: <4AF9E73D.4060302@gmx.de>
Date: Tue, 10 Nov 2009 23:20:45 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] Implement prctl(PR_GET_ENDIAN) for all architectures
References: <20091022193533.GA5827@p100.box>	<20091109124618.2aa98630.akpm@linux-foundation.org> <19192.35446.970229.391493@pilspetsen.it.uu.se>
In-Reply-To: <19192.35446.970229.391493@pilspetsen.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2009 10:32 PM, Mikael Pettersson wrote:
> Andrew Morton writes:
>   >  On Thu, 22 Oct 2009 21:35:33 +0200
>   >  Helge Deller<deller@gmx.de>  wrote:
>   >
>   >  >  The PR_GET_ENDIAN and PR_SET_ENDIAN prctl() calls have been implemented
>   >  >  to allow to switch processes at runtime from big-endian to little-endian
>   >  >  mode (and vice versa) on PowerPC processors. Since the other architectures
>   >  >  don't support this feature, they currently will just fail and return -EINVAL.
>   >  >
>   >  >  This patch adds just minimal overhead and implements the PR_GET_ENDIAN
>   >  >  call for all other architectures by returning the native endianess of
>   >  >  the architecture. Furthermore, calling prctl(PR_SET_ENDIAN) with the
>   >  >  native endianess of the architecture will succeed, while trying to
>   >  >  set another (not-supported) endianess, will fail.
>   >  >
>   >  >  The patch can be tested with the following program:
>   >  >
>   >  >  #include<stdio.h>
>   >  >  #include<linux/prctl.h>
>   >  >
>   >  >  int main(int argc, char **argv)
>   >  >  {
>   >  >  	int endian, ret;
>   >  >
>   >  >  	ret = prctl(PR_GET_ENDIAN,&endian);
>   >  >  	if (ret)
>   >  >  		perror("prctl(PR_GET_ENDIAN) not implemented");
>   >  >  	printf("current process/machine is running in %s endian mode (%d)\n",
>   >  >  		endian == PR_ENDIAN_LITTLE ? "little":"big", endian);
>   >  >
>   >  >  	/* setting native endianess should succeed */
>   >  >  	ret = prctl(PR_SET_ENDIAN, endian);
>   >  >  	printf("prctl(PR_SET_ENDIAN,%d) should succeed: %s\n",
>   >  >  		endian, ret == 0 ? "OK":"FAIL");
>   >  >
>   >  >  	/* setting foreign endianess should fail */
>   >  >  	endian = (endian == PR_ENDIAN_LITTLE) ?
>   >  >  		PR_ENDIAN_BIG : PR_ENDIAN_LITTLE;
>   >  >  	ret = prctl(PR_SET_ENDIAN, endian);
>   >  >  	printf("prctl(PR_SET_ENDIAN,%d) should fail: %s\n",
>   >  >  		endian, ret == 0 ? "OK":"FAIL");
>   >  >  }
>   >  >
>   >
>   >  The changelog forgot to provide any reason for making this change to
>   >  the kernel.
>
> Why is PR_GET_ENDIAN needed? Surely user-space can detect the current
> endianess for itself?

PR_GET_ENDIAN/PR_SET_ENDIAN was introduced with:
commit 651d765d0b2c72d33430487c8b6ef64c60cd2134
Author: Anton Blanchard <anton@samba.org>
Date:   Wed Jun 7 16:10:19 2006 +1000

     [PATCH] Add a prctl to change the endianness of a process.

     This new prctl is intended for changing the execution mode of the
     processor, on processors that support both a little-endian mode and a
     big-endian mode.  It is intended for use by programs such as
     instruction set emulators (for example an x86 emulator on PowerPC),
     which may find it convenient to use the processor in an alternate
     endianness mode when executing translated instructions.

     Note that this does not imply the existence of a fully-fledged ABI for
     both endiannesses, or of compatibility code for converting system
     calls done in the non-native endianness mode.  The program is expected
     to arrange for all of its system call arguments to be presented in the
     native endianness.

     Switching between big and little-endian mode will require some care in
     constructing the instruction sequence for the switch.  Generally the
     instructions up to the instruction that invokes the prctl system call
     will have to be in the old endianness, and subsequent instructions
     will have to be in the new endianness.

     Signed-off-by: Anton Blanchard <anton@samba.org>
     Signed-off-by: Paul Mackerras <paulus@samba.org>

> Also, which endianess does this refer to? ARM has had and continues to
> invent bizarre endianess rules, where the endianess of some datum depends
> not only on the endianess flag in a core control register but also the
> functional unit operating on the data and the ARM ISA version. Some of
> these endianess properties are unchangeable, some may be changeable in
> specific implementations.
>
> What about archs that always run in one endianess but support other-endian
> data accesses via special instruction operands? (I believe SPARC falls into
> this category.) PR_SET_ENDIAN on the other-endian value must fail, but what
> does that mean to the program? That it can't do other-endian accesses? No.

Right. I think no one objects on what you are writing here.
  
> I think the very concept of flipping a thread-global endianess mode flag
> is too architecture specific to be treated as a generic thing.

Please read my patch again.
It's not trying to flip any endianess settings in any generic way at all.
For PR_GET_ENDIAN it just returns the real kernels endianess instead of -EINVAL,
and it does not allow you to change the endianess with PR_SET_ENDIAN.

Helge
