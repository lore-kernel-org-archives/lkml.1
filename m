Return-Path: <linux-kernel-owner+w=401wt.eu-S1759955AbZD2LCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955AbZD2LCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758018AbZD2K7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:59:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:58157 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759416AbZD2K7S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:59:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH 20/30] microblaze_mmu_v1: uaccess MMU update
Date: Wed, 29 Apr 2009 12:58:40 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       john.williams@petalogix.com
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu> <20090428225352.4a54f277.akpm@linux-foundation.org> <49F827F1.8010308@monstr.eu>
In-Reply-To: <49F827F1.8010308@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904291258.40667.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX192rTMpbhqUQZTxJcfoYlHJwKUGGC67cyVDyLu
 a3DittxNJo6RWbIGh0Z6IKhU1Q9mPZ7JKhYhdimQxWoOpE8D5Q
 hZLIRj1I5o/6xcdYWgPQw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 April 2009, Michal Simek wrote:
> Here is that change which remove address space problem.
> 
> #define __clear_user(addr, n)   (memset((__force void *)(addr), 0, (n)), 0)
> 
> Am I right?
> 
> The same mishmash is for memset_fromio/memset_toio and maybe some others which I want to fix too.

This will work, but a better fix would be to define an inline
function that explicitly takes a __user pointer. This would give
you warnings when code accidentally calls __clear_user on a
kernel pointer (this also adds the might_sleep()):

static inline unsigned long __must_check 
__clear_user(void __user *to, unsigned long n)
{
	memset((__force void *)addr, 0, n);
	return 0;
}

static inline unsigned long __must_check 
clear_user(void __user *to, unsigned long n)
{
	might_sleep();
	if (unlikely(!access_ok(VERIFY_WRITE, to, n)))
		return n;

	return __clear_user(to, n);
}

The above is just the nommu variant. For mmu, you need to
have exception handling in __clear_user to take care of the
case where the address is part of the user mapping (access_ok)
but not currently mapped.

	Arnd <><
