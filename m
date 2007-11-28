Return-Path: <linux-kernel-owner+w=401wt.eu-S1759745AbXK1XHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745AbXK1XHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 18:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbXK1XHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 18:07:08 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:27416 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528AbXK1XHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 18:07:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=jwfNBseQdec7c+b/qOA6mSgGnPAqIP1lgZfbOkOcCYhORYPSznYo1NsbvEOGGEE9Jxloky3QO3uCbENafrbMuY6ZUXLbGUuus/M3jmPFY+vjfpCVXfoXS1vP08xm70zcFokUvJBMtLm8LlsAcDuSWnoiDkxS7bJDCT6ueE0sS+s=
Message-ID: <474DF493.3010903@gmail.com>
Date: Thu, 29 Nov 2007 00:06:59 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       "Andrew G. Morgan" <morgan@kernel.org>
Subject: named + capset = EPERM [Was: 2.6.24-rc3-mm2]
References: <20071128034140.648383f0.akpm@linux-foundation.org>
In-Reply-To: <20071128034140.648383f0.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2007 12:41 PM, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm2/
[...]
> +capabilities-introduce-per-process-capability-bounding-set.patch

A regression against -mm1. This patch breaks bind (9.5.0-18.a7.fc8):
capset(0x19980330, 0,
{CAP_DAC_READ_SEARCH|CAP_SETGID|CAP_SETUID|CAP_NET_BIND_SERVICE|CAP_SYS_CHROOT|CAP_SYS_RESOURCE,
CAP_DAC_READ_SEARCH|CAP_SETGID|CAP_SETUID|CAP_NET_BIND_SERVICE|CAP_SYS_CHROOT|CAP_SYS_RESOURCE,
0}) = -1 EPERM (Operation not permitted)

$ grep SEC .config
CONFIG_SECCOMP=y
# CONFIG_NETWORK_SECMARK is not set
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set

probably this hunk?:
@@ -133,6 +119,12 @@ int cap_capset_check (struct task_struct
                /* incapable of using this inheritable set */
                return -EPERM;
        }
+       if (!!cap_issubset(*inheritable,
+                          cap_combine(target->cap_inheritable,
+                                      current->cap_bset))) {
+               /* no new pI capabilities outside bounding set */
+               return -EPERM;
+       }

        /* verify restrictions on target's new Permitted set */
        if (!cap_issubset (*permitted,


regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
