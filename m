Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbZEAJfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbZEAJfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 05:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbZEAJf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 05:35:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:50824 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbZEAJf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 05:35:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH 17/27] add generic lib/checksum.c
Date: Fri, 1 May 2009 11:35:14 +0200
User-Agent: KMail/1.9.9
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
References: <cover.1241105648.git.arnd@arndb.de> <cda5746ab12cf9d6bcb7803a3667c92250a29784.1241105648.git.arnd@arndb.de> <20090501092027.GA29366@flint.arm.linux.org.uk>
In-Reply-To: <20090501092027.GA29366@flint.arm.linux.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905011135.15137.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Cdq1kNdjFzqN7cU/wn1L9Du86jzmynbKw9w7
 53eUaobpo3z4b5TsaTLMg9Acqvm2qu+SCFiAzaJwAFXJPmUnmx
 t36SuPBPLNmF1D+C83wbA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 May 2009, Russell King wrote:
> Since when has 'memcpy' been valid from user addresses?

It's an artifact from the microblaze code, I found it after
submitting the patches when running sparse over it (yes, I
know I should do these things in a different order).

The s390 version seems to get this right, so I'll use this:

static inline __wsum
csum_partial_copy_from_user(const void __user *src, void *dst,
                                          int len, __wsum sum,
                                          int *err_ptr)
{
	int missing;

	missing = copy_from_user(dst, src, len);
	if (missing) {
		memset(dst + len - missing, 0, missing);
		*err_ptr = -EFAULT;
	}

	return csum_partial(dst, len, sum);
}

On microblaze, the old code was only correct for NOMMU.

Thanks,

	Arnd <><
