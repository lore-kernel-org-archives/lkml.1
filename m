Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZCFHx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZCFHx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 02:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbZCFHv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 02:51:59 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:11371 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432AbZCFHv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 02:51:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=U8MGekb9sL41fG3Qp89zLCrjfyDdoik8GOZ6gw+r2R56XAgHW5SXI2voq/S+ccYZAc
         ve2OK8KIlP6wBKrfFQTLP1Bk+yqtMJ9ogRrfIC3VbuzOTQctWFLKI6vIbkwBrx+Vsb3X
         IrFVkWliChtVvL5ZhCcyAZ5lCjFl5bQujZszE=
Date: Fri, 6 Mar 2009 15:52:11 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: um: WARNING: vmlinux: 'memcpy' exported twice. Previous export
	was in vmlinux
Message-ID: <20090306075211.GN22605@hack.private>
References: <49AFC206.9080004@panasas.com> <20090305130610.GA4265@hack.private> <49AFD780.8080500@panasas.com> <20090305160447.GB4265@hack.private> <49B00B83.20400@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49B00B83.20400@panasas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 07:27:31PM +0200, Boaz Harrosh wrote:
>Américo Wang wrote:
>> On Thu, Mar 05, 2009 at 03:45:36PM +0200, Boaz Harrosh wrote:
>>> Américo Wang wrote:
>>>> On Thu, Mar 05, 2009 at 02:13:58PM +0200, Boaz Harrosh wrote:
>>>>> On today's linus v2.6.29-rc7-3-g559595a
>>>>>
>>>>> Doing make ARCH=um defconfig & make ARCH=um
>>>>> give's me:
>>>>>
>>>>> LD vmlinux.o
>>>>> MODPOST vmlinux.o
>>>>> WARNING: vmlinux: 'memcpy' exported twice. Previous export was in vmlinux
>>>>>
>>>>>
>>>>> Sorry if this is a duplicate report
>>>>>
>>>> Weird...
>>>> I tried to compile like what you said, I can't reproduce it.
>>>>
>>>> Which gcc are you using?
>>>>
>>>> Thanks.
>>>>
>>> $ gcc --version
>>> gcc (GCC) 4.3.2 20081105 (Red Hat 4.3.2-7)
>>>
>>> I'm running on an x86_64 Fedora10 system (updated recently)
>>> $ uname -o -s -r -m -p -i
>>> Linux 2.6.27.15-170.2.24.fc10.x86_64 x86_64 x86_64 x86_64 GNU/Linux
>>>
>> 
>> I am using the same thing, but on i386. I still can't reproduce it. :(
>> 
>
>What can I say I just did it again from scratch
>
>$ mkdir .build_um
>$ make ARCH=um KBUILD_OUTPUT=.build_um defconfig
>$ make ARCH=um KBUILD_OUTPUT=.build_um
>
>(I'm using KBUILD_OUTPUT= because O= does not work when also using M= with
> external modules, so it's a habit)
>
>Thanks for your help. I will try to bisect it on Sunday

Hi, Boaz.

I am sorry that I don't have an x86_64 machine to use, but I know
why this happens now. :)

Would you like to try the following patch? Thanks!

-------------->

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/arch/um/os-Linux/user_syms.c b/arch/um/os-Linux/user_syms.c
index 74f49bb..89b48a1 100644
--- a/arch/um/os-Linux/user_syms.c
+++ b/arch/um/os-Linux/user_syms.c
@@ -14,7 +14,6 @@
 #undef memset
 
 extern size_t strlen(const char *);
-extern void *memcpy(void *, const void *, size_t);
 extern void *memmove(void *, const void *, size_t);
 extern void *memset(void *, int, size_t);
 extern int printf(const char *, ...);
@@ -24,7 +23,11 @@ extern int printf(const char *, ...);
 EXPORT_SYMBOL(strstr);
 #endif
 
+#ifndef __x86_64__
+extern void *memcpy(void *, const void *, size_t);
 EXPORT_SYMBOL(memcpy);
+#endif
+
 EXPORT_SYMBOL(memmove);
 EXPORT_SYMBOL(memset);
 EXPORT_SYMBOL(printf);
 
