Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbXFXSJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbXFXSJx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 14:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbXFXSJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 14:09:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:55567 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbXFXSJo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 14:09:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Date: Sun, 24 Jun 2007 20:07:10 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk> <20070624174732.GZ21478@ftp.linux.org.uk>
In-Reply-To: <20070624174732.GZ21478@ftp.linux.org.uk>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706242007.10585.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18zFm+PW2xgeVOJR1VnpRAq6OVNSfCguy6y/tD
 /ZQNvi/PWRosZv76wHlEg+o4xv0VAS2hxI/MV8X4RavFKBaDqu
 P9nezw8uKT5nCcfVCn+qg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 June 2007, Al Viro wrote:
> but the latter...  Probably ought to be
> #define _IOC_TYPECHECK(t) \
>         (sizeof(t) + BUILD_BUG_ON_ZERO(sizeof(t) == sizeof(t[1]) && \
>           sizeof(t) < (1 << _IOC_SIZEBITS)))
> 
> Objections?  The only reason that doesn't break gcc to hell and back is
> that gcc has unfixed bugs in that area.  It certainly is not a valid C
> or even a remotely sane one.

Yes, looks good. I originally came up with _IOC_TYPECHECK before we had
the generic BUILD_BUG_ON(). 

One minor issue though:
While BUILD_BUG_ON and a few other macros in linux/kernel.h are currently
exported to user space, I would think that they should really be hidden
in #ifdef __KERNEL__, which means that we also need something like

#ifdef __KERNEL__
#define _IOC_TYPECHECK(t) \
        (sizeof(t) + BUILD_BUG_ON_ZERO(sizeof(t) == sizeof(t[1]) && \
          sizeof(t) < (1 << _IOC_SIZEBITS)))
#else
#define _IOC_TYPECHECK(t) sizeof(t)
#endif

	Arnd <><
