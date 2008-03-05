Return-Path: <linux-kernel-owner+w=401wt.eu-S1761527AbYCEQ4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527AbYCEQ4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbYCEQ4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:56:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:21153 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761302AbYCEQ4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:56:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FvDsvX+Q68SWGZ35y1LAVB48FETqAaHQEz1208yFxeTbuzQxBA6uzPvtTraCVhmzTXlPGcA3mHRrqr09GgPCw0JlQm7ABnsXc3box5FDQwKlFXHbZkhSaI1zFxhfjKGfgMTipBZnUUqQD6k0GzYa8s085BF/UiNfr+0KUTk9NGI=
Message-ID: <6dc9ffc80803050856l1f69d262he3115fffa0df5fbe@mail.gmail.com>
Date: Wed, 5 Mar 2008 08:56:11 -0800
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "Aurelien Jarno" <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: Linux doesn't follow x86/x86-64 ABI wrt direction flag
In-Reply-To: <20080305153020.GA24631@volta.aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080305153020.GA24631@volta.aurel32.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

According to i386 psABI,

---
The direction flag must be set "forward" direction before entry and
upon exit from
a function.
---

So, asm statement should make sure that the direction flag is cleared before
function returns and kernel should make sure that the direction flag is cleared
when calling a signal handler.

H.J.
On Wed, Mar 5, 2008 at 7:30 AM, Aurelien Jarno <aurelien@aurel32.net> wrote:
> Hi all,
>
>  Since version 4.3, gcc changed its behaviour concerning the x86/x86-64
>  ABI and the direction flag, that is it now assumes that the direction
>  flag is cleared at the entry of a function and it doesn't clear once
>  more if needed.
>
>  This causes some problems with the Linux kernel which does not clear
>  the direction flag when entering a signal handler. The small code below
>  (for x86-64) demonstrates that.
>
>  If the signal handler is using code that need the direction flag cleared
>  (for example bzero() or memset()), the code is incorrectly executed.
>
>  I guess this has to be fixed on the kernel side, but also gcc-4.3 could
>  revert back to the old behaviour, that is clearing the direction flag
>  when entering a routine that touches it until most people are running a
>  fixed kernel.
>
>  Kind regards,
>  Aurelien
>
>  [1] http://gcc.gnu.org/gcc-4.3/changes.html
>
>
>  #include <stdint.h>
>  #include <stdlib.h>
>  #include <stdio.h>
>  #include <signal.h>
>
>  void handler(int signal) {
>         uint64_t rflags;
>
>         asm volatile("pushfq ; popq %0" : "=g" (rflags));
>
>         if (rflags & (1 << 10))
>                 printf("DF = 1\n");
>         else
>                 printf("DF = 0\n");
>  }
>
>  int main() {
>         signal(SIGUSR1, handler);
>
>         while(1)
>         {
>                 asm volatile("std\r\n");
>         }
>
>         return 0;
>  }
>
>  --
>   .''`.  Aurelien Jarno             | GPG: 1024D/F1BCDB73
>   : :' :  Debian developer           | Electrical Engineer
>   `. `'   aurel32@debian.org         | aurelien@aurel32.net
>    `-    people.debian.org/~aurel32 | www.aurel32.net
>
