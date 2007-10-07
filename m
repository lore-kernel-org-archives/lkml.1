Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbXJGAUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbXJGAUl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 20:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbXJGAUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 20:20:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56964 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbXJGAUb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 20:20:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] net/core: split dev_ifsioc() according to locking
Date: Sun, 7 Oct 2007 02:17:08 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20071006204212.GA32177@havoc.gtf.org>
In-Reply-To: <20071006204212.GA32177@havoc.gtf.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710070217.09073.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/i02q2zUvadDc0zIwHlxk6pwLqBqU6yL69TCz
 051EWFq3ErXhHDRjYENPce6ePraXyPbOSG+iIwqkTjhHwmGgvR
 99F2qwze4xKSBJgvFHzqw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 October 2007, Jeff Garzik wrote:
> 
> This always bugged me:  dev_ioctl() called dev_ifsioc() either inside
> read_lock(dev_base_lock) or rtnl_lock(), depending on the ioctl being
> executed.
> 
> This change moves the ioctls executed inside dev_base_lock to a new
> function, dev_ifsioc_locked().  Now the locking context is completely
> clear to the reader.
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

Great idea!

I've been experimenting with a new compat_dev_ioctl() function along
the lines of what I just posted for the blkdev ioctls. For that, it
would be perfect to streamline dev_ioctl further:

* move the dev_load() and locking into dev_ifsioc{,_locked}
* move the copy_to_user step to a single place at the end of dev_ioctl

After that, we could have very simple dev_ioctl and compat_dev_ioctl
functions calling the same dev_ifsioc{,_locked} functions.

	Arnd <><
