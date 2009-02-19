Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbZBSOTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbZBSOTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 09:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZBSOTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 09:19:35 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:58952 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbZBSOTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 09:19:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] drm: Only use DRM_IOCTL_UPDATE_DRAW compat wrapper for compat X86.
Date: Thu, 19 Feb 2009 15:19:01 +0100
User-Agent: KMail/1.9.9
Cc: airlied@linux.ie, benh@kernel.crashing.org,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20090218.013521.97380943.davem@davemloft.net>
In-Reply-To: <20090218.013521.97380943.davem@davemloft.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902191519.03399.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+i5z8pxjdZT2UrFEgukVbSePkPItuKifIGcuL
 gM8ADKUivOkHVfObDqJfh2bR9l90/5UNeKF5jy7XacL1bf48P4
 Py4eG9UbjG0FhcX+z7N4w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009, David Miller wrote:
> drm: Only use DRM_IOCTL_UPDATE_DRAW compat wrapper for compat X86.
> 
> Only X86 32-bit uses a different alignment for "unsigned long long"
> than it's 64-bit counterpart.
> 
> Therefore this compat translation is only correct, and only needed,
> when either CONFIG_X86 or CONFIG_IA64.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

The patch is correct AFAICT, but I'd like to point out that the
problem could have been avoided (besides using a non-padded layout)
by using a compat_u64 member in the struct definition instead of
the packed attribute:

typedef struct drm_update_draw32 {
	drm_drawable_t handle;
	unsigned int type;
	unsigned int num;
	compat_u64 data;	/**< Pointer */
} drm_update_draw32_t;

I find that too often __attribute__((packed)) is used on whole
structures where some other much more gentle solution can be
applied. In fact, there are very few files (e.g.
linux/unaligned/packed_struct.h) that look like they want all
of the implied meanings (pack members, drop alignment on whole
structure, access members as unaligned).

A grep for "packed" in compat_ioctl definitions revealed the
same bug as in drm_update_draw32 to be present in
raw32_config_request, and I'm rather sure that there are more
of these.

	Arnd <><
