Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbXDZWJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbXDZWJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 18:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbXDZWJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 18:09:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:62794 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031501AbXDZWJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 18:09:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Fulghum <paulkf@microgate.com>
Subject: Re: compat_ioctl question
Date: Fri, 27 Apr 2007 00:08:58 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1177620717.5060.11.camel@amdx2.microgate.com> <200704262337.56240.arnd@arndb.de> <46312AEE.1000302@microgate.com>
In-Reply-To: <46312AEE.1000302@microgate.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704270008.58811.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19fauQJmTGPUN5YLmgRBAP5DYG6+K9PBIHW1BT
 RZ3sEBycspznyg8ESc/9D0vYjy5Xvb2V3TeXABtvY6E6XUrmXy
 1ThIDSgrU6Dggvj9fm3tw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 April 2007, Paul Fulghum wrote:
> Arnd Bergmann wrote:
> > It depends a lot on what your specific driver does in the ioctl
> > handler, but normally you should define a compat_ioctl() function.
> > What driver are you talking about?
> 
> drivers/char/synclink.c
> drivers/char/synclinkmp.c
> drivers/char/synclink_gt.c
> drivers/char/pcmcia/synclink_cs.c
> 
> All use the same set of ioctl() codes that
> are peculiar to the synclink drivers.

So you are interested in the MGSL_* set of ioctls, right?
AFAICS, they are all compatible, with the exception of
MGSL_IOCGPARAMS and MGSL_IOCSPARAMS.

Fortunately, these two have different ioctl numbers on
64 bit, so you can define a new
 
#define MGSL_IOCSPARAMS32 _IOR(MGSL_MAGIC_IOC,0,struct _MGSL_PARAMS32)
#define MGSL_IOCGPARAMS32 _IOR(MGSL_MAGIC_IOC,1,struct _MGSL_PARAMS32)

and handle both versions in the ioctl function.

> Defining compat_ioctl() seems to be the best way, but
> that will require modifying the base tty code to allow
> the individual tty drivers to register compat_ioctl().

Yes, that would be the right solution. I've started this
some time ago, but never finished it:
http://www.uwsg.iu.edu/hypermail/linux/kernel/0511.0/1732.html

> Currently the tty file ops do not include that and
> tty_io.c does not register a compat_ioctl(), instead
> relying on compat_ioctl.h and compat_ioctl.c

Just adding the hook in tty_io.c should be trivial, please do that.
If you like, you can also move the vt ioctls in order to reduce
the size of fs/compat_ioctl.c.

	Arnd <><
