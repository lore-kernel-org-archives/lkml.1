Return-Path: <linux-kernel-owner+w=401wt.eu-S934553AbZGQM4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934553AbZGQM4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 08:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934543AbZGQM4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 08:56:16 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:33931 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934535AbZGQM4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 08:56:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=O18SOhZM9/P98tm9FJkj1tYWocU/wI8Xm4lWc5k5fWLlK8UWUibxIZX7RuTElI3zbc
         iBgtA8TWQ537oNVmXbi4Esfa/zvkE5WXp+t+XUfoVhhes/kDpuxZA9r1jF7G+omEqgbS
         fXUxY0aDsRNIH20MvnLecOvUhldmGuzoKX7ik=
Message-ID: <4A60755F.4030604@gmail.com>
Date: Fri, 17 Jul 2009 14:58:07 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ia32: strncpy does not null terminate string
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With `sizeof(lastcomm) - 1` strncpy() will null terminate the string.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
To test this:

#include <stdio.h>
#include <string.h>

char a[10];
char b[10];

int main()
{
        const char* str = "0123456789012";
        strncpy(a, str, sizeof(a));
        strncpy(b, str, sizeof(b) - 1);
        printf("String a was %s, b was %s\n", a, b);

        return 0;
}

Output:
String a was 0123456789012345678, b was 012345678

diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 085a8c3..b114f57 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -687,7 +687,7 @@ long sys32_vm86_warning(void)
 		compat_printk(KERN_INFO
 			      "%s: vm86 mode not supported on 64 bit kernel\n",
 			      me->comm);
-		strncpy(lastcomm, me->comm, sizeof(lastcomm));
+		strncpy(lastcomm, me->comm, sizeof(lastcomm) - 1);
 	}
 	return -ENOSYS;
 }
